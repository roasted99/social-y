# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/api/*', 
      headers: %w(Authorization),
      expose: %(Authorization), 
      methods: [:get, :post, :patch, :put]
  end
end