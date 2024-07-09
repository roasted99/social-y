require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:headers) { valid_headers }
  let(:postData) { FactoryBot.create(:post, user: user)}
  let(:post_id) { postData.id }
  
  #post request
  describe "POST /api/v1/posts" do  
    context "when the request is valid" do
      before { post '/api/v1/posts', headers: headers, params: { post: {body: "New post" }}.to_json } 
     
      it "creates a post" do
        expect(response).to have_http_status(200)
        expect(json["body"]).to eq("New post")
      end
    end
    
    context "when the request is invalid" do
      before { post '/api/v1/posts', headers: headers, params: { post: { body => nil }}.to_json } 
      
      it "returns a validation error message" do
        expect(response).to have_http_status(422)
        expect(json["error"]).to match("Body cannot be blank")
      end
    end
  end
  
  #get request
  describe 'GET /api/v1/posts' do
    before do
      FactoryBot.create_list(:post, 5, user: user)
      get '/api/v1/posts', headers: headers
    end
    
    it 'returns posts' do
      expect(json).not_to be_empty
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
      let(:post_id) { 10000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("Post not found")
      end
    end
  end
  
   #patch request
  describe "PATCH /api/v1/posts/:id" do
  
     context "when the request is valid" do
       before { patch "/api/v1/posts/#{post_id}", params: { post: { body: "Updated the status"} }.to_json, headers: headers }
       it "updates the post" do
         expect(response).to have_http_status(200)
         expect(json["body"]).to eq("Updated the status")
       end
     end
    
     context "when the request is invalid" do
       before { patch "/api/v1/posts/#{post_id}", params: { post: { body: nil } }.to_json, headers: headers }
       it "returns a validation error message" do
         expect(response).to have_http_status(422)
         expect(json["error"]).to match("Body cannot be blank")
       end
     end
   end
  
   #delete request  
  describe "DELETE /api/v1/posts/:id" do
     before { delete "/api/v1/posts/#{post_id}", headers: headers } 
  
     context "when the request is valid" do
      
       it "deletes the post" do
         expect(response).to have_http_status(200)
         expect(Post.find_by(id: post_id)).to be_nil
       end
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
