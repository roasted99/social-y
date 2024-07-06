module Api 
  module V1
    class PostsController < 
      before_action :authenticated_user!
      respond_to  :jon
      def index
        @post = Post.new 
        @posts = Post.all.order(updated_at: :asc)

        response_with @posts
      end

      def create
        @post = Post.new(post_params)
      
        respond_to do |format|
          if @post.save
            @posts = Post.all.order(updated_at: :asc)
            format.json { render :json => @posts }
          else
            format.json { render :json => @post.errors.full_messages } 
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
  end
end 
end
