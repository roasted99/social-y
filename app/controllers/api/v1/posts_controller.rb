module Api 
  module V1
    class PostsController < ApplicationController
      # Rails.logger.debug(request.headers)
      # before_action :log_request_headers
      skip_before_action :verify_authenticity_token
      before_action :authenticate_with_jwt_token
      before_action :set_post, only: [:update, :destroy, :show]
      before_action :validate_post_params, only: [:create, :update]
      respond_to  :json
      
      def index
        # @post = Post.new 
        @posts = Post.all.order(updated_at: :desc)
        render :json => @posts, status: :ok
      end

      def create
        Rails.logger.error("Params recieved: #{post_params}")
        @post = current_api_v1_user.posts.new(post_params)

          if @post.save
            render :json => @post, status: :ok
          else
            render :json => {message: "can't be blank", error: @post.errors.full_messages }, status => :unprocessable_entity
          end 
        
      end


      def destroy
        if params[:id].blank?
          render json: { error: 'Post ID is required' }, status: :unprocessable_entity
          return
        end
        @post = Post.find(params[:id])
        if @post.destroy()
          render json: {message: "post has been deleted"}, status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def update
        if params[:id].blank?
          render json: { error: 'Post ID is required' }, status: :unprocessable_entity
          return
        end
        @post = Post.find(params[:id])
        if @post.update(post_params)
          render json: @post, status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def show
        if params[:id].blank?
          render json: { error: 'Post ID is required' }, status: :unprocessable_entity
          return
        end
        @post = Post.find_by(id: params[:id])
        if @post
          render json: @post.to_json(include: :comments), status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      private

      def post_params
        params.require(:post).permit(:body)
      end

      def validate_post_params
        if post_params[:body].blank? || post_params[:body] == nil
          render json: { error: 'Body cannot be blank' }, status: :unprocessable_entity
        end
      end

      def set_post
        @post = Post.find_by(id: params[:id])
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
  end 
end
