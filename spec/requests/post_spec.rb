require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:headers) { valid_headers }
  
  describe "POST /api/v1/posts" do
    before { post '/api/v1/posts', headers: headers }
    let(:valid_attributes) { { body: "New post" } }
    
    context "when the request is valid" do
      before do
        post "/api/v1/posts", params: { post: valid_attributes }
      end
      
      it "creates a post" do
        expect(response).to have_http_status(201)
        expect(json).to eq("New post")
      end
    end
    
    context "when the request is invalid" do
      before do
        post "/api/v1/posts", params: { post: { body: nil } }
      end
      
      it "returns a validation error message" do
        expect(response).to have_http_status(422)
        expect(json["errors"]["body"]).to include("can't be blank")
      end
    end
  end
  
  describe 'GET /api/v1/posts' do
    before { get '/api/v1/posts', headers: headers }
    
    let!(:posts) { create(:post, 10, user: user) }
    let(:post_id) { posts.first.id }

    it 'returns posts' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/v1/posts/:id' do
    before { get "/api/v1/posts/#{post_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the post' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(post_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:post_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("Couldn't find post")
      end
    end
  end

   describe "PATCH /api/v1/posts/:id" do
    before { patch '/api/v1/posts', headers: headers }

    context "when the request is valid" do
      before do
        patch "/api/v1/posts/#{post.id}", params: { post: { body: "Updated the status." } }
      end

      it "updates the post" do
        expect(response).to have_http_status(200)
        expect(json).to eq("Updated the status")
      end
    end

    context "when the request is invalid" do
      before do
        patch "/api/v1/posts/#{post.id}", params: { post: { title: nil } }
      end

      it "returns a validation error message" do
        expect(response).to have_http_status(422)
        expect(json["errors"]["body"]).to include("can't be blank")
      end
    end
  end

   describe "DELETE /api/v1/posts/:id" do
    before { get '/api/v1/posts', headers: headers } 

    context "when the request is valid" do
      before do
        delete "/api/v1/posts/#{post.id}"
      end

      it "deletes the post" do
        expect(response).to have_http_status(204)
        expect(Post.find_by(id: post.id)).to be_nil
      end
    end
  end
end 

def valid_headers
  {
    "Authorization" => "Bearer #{user.token}",
    "Content-Type" => "application/json"
  }
end

def token_generator(user)
  JsonWebToken.encode(user)
end

def json
  JSON.parse(response.body)
end
