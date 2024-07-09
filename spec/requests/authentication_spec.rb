require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:valid_credentials) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }.to_json
  end
  let(:invalid_credentials) do
    {
      user: {
        email: user.email,
        password: 'wrongpassword'
      }
    }.to_json
  end

  describe 'POST /api/v1/login' do
    context 'when request is valid' do
      before { post '/api/v1/login', params: valid_credentials, headers: headers }

      it 'returns a token' do
        expect(json['token']).not_to be_nil
      end

      it 'returns a 200 status code' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when request is invalid' do
      before { post '/api/v1/login', params: invalid_credentials, headers: headers }

      it 'returns a failure message' do
        expect(json['error']).to match("Invalid email or password.")
      end

      it 'returns a 401 status code' do
        expect(response).to have_http_status(401)
      end
    end
  end
end

def json
  JSON.parse(response.body)
end
