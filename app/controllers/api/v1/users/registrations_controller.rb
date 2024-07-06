# frozen_string_literal: true
# module Api
  # module V1
    class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
      # before_action :configure_sign_up_params, only: [:create]
      # before_action :configure_account_update_params, only: [:update]
      skip_before_action :verify_authenticity_token

      # GET /resource/sign_up
      # def new
      #   super
      # end

      # POST /resource
      def create
        logger.debug "Params: #{params.inspect}"
        build_resource(sign_up_params)
          
        resource.save
        if resource.persisted?
          token = generate_jwt_token(resource)
          render json: {
            status: { status: 200, message: "Signed up sucessfully."},
            data: resource,
            token: token
          }, status: :ok
        else
          render json: {
            status: {code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
          }, status: :unprocessable_entity
        end
        
        logger.debug "Resource errors: #{resource.errors.full_messages}" unless resource.persisted?
          
        # render_resource(resource)
      end

      # GET /resource/edit
      # def edit
      #   super
      # end

      # PUT /resource
      # def update
      #   super
      # end

      # DELETE /resource
      # def destroy
      #   super
      # end

      # GET /resource/cancel
      # Forces the session data which is usually expired after sign
      # in to be expired now. This is useful if the user wants to
      # cancel oauth signing in/up in the middle of the process,
      # removing all OAuth session data.
      # def cancel
      #   super
      # end

      # protected

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_sign_up_params
      #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
      # end

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_account_update_params
      #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
      # end

      # The path used after sign up.
      # def after_sign_up_path_for(resource)
      #   super(resource)
      # end

      # The path used after sign up for inactive accounts.
      # def after_inactive_sign_up_path_for(resource)
      #   super(resource)
      # end
      respond_to :json
      private

      def sign_up_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
      end

      def render_resource(resource)
        if resource.persisted?
          render json: resource, status: :created
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def generate_jwt_token(resource)
          Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
        end

    end
  # end
# end  