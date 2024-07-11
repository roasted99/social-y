class PagesController < ApplicationController
  def sign_up
    render 'sign_up'
  end

  def sign_in
    render 'sign_in'
    # redirect_to '/' if current_api_v1_user?
  end

  def index
    render 'index'
  end

  def profile
    render 'profile'
  end

  def post
    render 'post'
  end

  private

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
