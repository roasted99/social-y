class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include Devise::Controllers::Helpers
  include Devise::JWT::RevocationStrategies::Null
end
