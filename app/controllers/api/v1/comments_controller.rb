class Api::V1::CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_with_jwt_token
  before_action :set_post
  respond_to :json

  def create
    @comment = @post.comments.new(comment_params.merge(user: current_api_v1_user))
      if @comment.save
        render json: @comment, status: :ok
      else
        render json: {errors: @comment.errors, message: "Comment could not be created"},  status: :unprocessable_entity
      end

  end

  def destroy
    if params[:id].blank?
      render json: { error: 'Comment ID is required' }, status: :unprocessable_entity
      return
    end
    @comment = Comment.find(params[:id])
    if @comment.destroy()
      render json: {message: "domment has been deleted"}, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_post
    @post = Post.find_by(id: params[:post_id])
    if @post.nil?
      render json: { error: 'Post not found' }, status: :not_found
    end
  end

  def authenticate_with_jwt_token
    token = request.headers['Authorization']&.split(' ')&.last
    if token.present?
      begin
        decoded_token = Warden::JWTAuth::TokenDecoder.new.call(token)
        Rails.logger.info "Decoded Token: #{decoded_token}"
        user_id = decoded_token['sub']
        @current_user = User.find(user_id)
      rescue JWT::DecodeError => e
        Rails.logger.error "JWT Decode Error: #{e.message}"
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    else
      Rails.logger.error "Token missing or invalid"
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_api_v1_user
    @current_user
  end
end 


