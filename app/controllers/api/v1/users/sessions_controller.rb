# frozen_string_literal: true
# module Api
  # module V1
  class Api::V1::Users::SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]
    skip_before_action :verify_authenticity_token
    respond_to :json
    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create

     

      user = User.find_by(email: login_params[:email])

      Rails.logger.debug(user)

      if user && user.valid_password?(login_params[:password])
        token = generate_jwt_token(user)
        render :json => {user: user, token: token}, status: :ok
      else
        Rails.logger.error("Authentication failed: Invalid email or password")
        render :json => { error: 'Invalid email or password.' }, status: :unauthorized
      end
       
      # render json: { error: 'An error occurred while trying to log in' }, status: :internal_server_error
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
