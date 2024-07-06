# frozen_string_literal: true
# module Api
  # module V1
    class Api::V1::Users::SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]
    respond_to :json
    skip_before_action :verify_authenticity_token
    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      # Rails.logger.debug("Params received: #{params.inspect}")
      # self.resource = warden.authenticate!(auth_options)
      # Rails.logger.debug("Authenticated resource: #{resource.inspect}")
      # sign_in(resource_name, resource)
      # token = generate_jwt_token(resource)
      # self.resource = warden.authenticate!(auth_options.merge(scope: resource_name, recall: "#{controller_path}#failure"))
      # if resource
      #   sign_in(resource_name, resource)
      #   token = generate_jwt_token(resource)
      #     else
      #       render json: { error: 'Invalid email or password' }, status: :unauthorized
      #     end
      Rails.logger.debug("Params received: #{login_params.inspect}")

          user = User.find_by(email: login_params[:email])

          if user && user.valid_password?(login_params[:password])
            token = generate_jwt_token(user)
            render json: { message: 'Logged in successfully', data: resource, token: token }, status: :ok
          else
            Rails.logger.error("Authentication failed: Invalid email or password")
            render json: { error: 'Invalid email or password' }, status: :unauthorized
          end
        rescue => e
          # Rails.logger.error("Authentication error: #{e.message}")
          # Rails.logger.error(e.backtrace.join("\n"))
          render json: { error: 'An error occurred while trying to log in' }, status: :internal_server_error
    end

    # DELETE /resource/sign_out
    def destroy
      if current_user
          render json: {
            status: 200,
            message: "Logged out successfully"
          }, status: :ok
        else
          render json: {
            status: 401,
            message: "Couldn't find an active session."
          }, status: :unauthorized
        end
    end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

      private

       def login_params
          params.require(:user).permit(:email, :password)
        end

      def generate_jwt_token(resource)
          Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
      end
    end
  # end
# end
