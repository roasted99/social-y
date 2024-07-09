require 'rails_helper'

RSpec.describe "Comments API", type: :request do
  
    let(:user) { FactoryBot.create(:user) }
    let(:postData) { FactoryBot.create(:post, user: user) }
    let(:headers) { valid_headers }
    let(:post_id) { postData.id }
    let(:valid_attributes) { { body: "This is a comment." } }
    let(:invalid_attributes) { { body: nil } }
  
    describe "POST /api/v1/posts/:post_id/comments" do
      context "when the request is valid" do
        before { post "/api/v1/posts/#{post_id}/comments", params: valid_attributes.to_json , headers: headers }
  
        it "creates a comment" do
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)["body"]).to eq("This is a comment.")
        end
      end
  
      context "when the request is invalid" do
        before { post "/api/v1/posts/#{post_id}/comments", params: invalid_attributes.to_json , headers: headers }
  
        it "returns a validation error message" do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)["errors"]).not_to be_empty
        end
      end
    end
   
    describe "DELETE /api/v1/posts/:post_id/comments/:id" do
      let!(:comment) { FactoryBot.create(:comment, post: postData, user: user) }
  
      it "deletes the comment" do
        expect {
          delete "/api/v1/posts/#{post_id}/comments/#{comment.id}", headers: headers
        }.to change(Comment, :count).by(-1)
        expect(response).to have_http_status(200)
      end
    end
  
end

def valid_headers
  {
    "Authorization" => "Bearer #{token_generator(user)}",
    "Content-Type" => "application/json"
  }
end

def token_generator(user)
  Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
end

def json
  JSON.parse(response.body)
end


