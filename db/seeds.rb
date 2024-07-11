# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

require 'factory_bot_rails'
require 'faker'

# Clear existing data
Comment.destroy_all
Post.destroy_all
User.destroy_all

# Seed data
NUM_USERS = 10
POSTS_PER_USER = 5
COMMENTS_PER_POST = 3

custom_user = User.create!(
  username: 'johnjohn',
  email: 'test@example.com',
  password: 'password123'
)

# Create users
users = FactoryBot.create_list(:user, NUM_USERS)

# Create posts and comments for each user
users.each do |user|
  posts = FactoryBot.create_list(:post, POSTS_PER_USER, user: user)
  
  posts.each do |post|
    FactoryBot.create_list(:comment, COMMENTS_PER_POST, user: user, post: post)
  end
end

puts "Seeded #{NUM_USERS} users, each with #{POSTS_PER_USER} posts and #{COMMENTS_PER_POST} comments per post."
