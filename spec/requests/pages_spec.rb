require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /sign_up" do
    it "returns http success" do
      get "/pages/sign_up"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /sign_in" do
    it "returns http success" do
      get "/pages/sign_in"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/pages/index"
      expect(response).to have_http_status(:success)
    end
  end

end
