module Api 
  module V1
    class PostsController < ApplicationController
      # Rails.logger.debug(request.headers)
      # before_action :log_request_headers
      before_action :authenticate_with_jwt_token
      respond_to  :json
      skip_before_action :verify_authenticity_token
      
      def index
        # @post = Post.new 
        @posts = Post.all.order(updated_at: :asc)

        respond_with @posts
      end

      def create
        Rails.logger.error("Params recieved: #{post_params}")
        @post = current_api_v1_user.posts.new(post_params)
      
        respond_to do |format|
          if @post.save
            @posts = Post.all.order(updated_at: :asc)
            format.json { render :json => @posts }
          else
            format.json { render :json => {message: "can't be blank", error: @post.errors.full_messages }, status => :unprocessable_entity}
          end 
        end
      end

      before_action :set_post, only: [:edit, :destroy]

      def destroy
        if params[:id].blank?
          render json: { error: 'Post ID is required' }, status: :unprocessable_entity
          return
        end
        if @post.destroy(post_params)
          render json: @post, status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def edit
        if params[:id].blank?
          render json: { error: 'Post ID is required' }, status: :unprocessable_entity
          return
        end

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
        @post = Post.find(params[:id])
        if @post
          render json: @post, status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      private

      def post_params
        params.require(:post).permit(:body)
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
