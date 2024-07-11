# SocialY
This project is a small social media application built with Ruby on Rails. It includes functionality for users to sign up, log in, create posts, and comment on posts. The frontend is handled using Rails views with Stimulus and Importmap, providing a dynamic and responsive user interface.The backend provides a RESTful API with versioning, and authentication is managed using JWT.

### Features

- **User Registration and Authentication**
  - Users can sign up with their username, email, and password.
  - Users can log in using their email and password.
  - Authentication is handled using JSON Web Tokens (JWT).

- **Posts**
  - Authenticated users can create new posts.
  - Users can view posts created by others.
  - Users can edit and delete posts.

- **Comments**
  - Authenticated users can comment on posts.
  - Users can view comments on any post.
  - Users can delete comments.

## Setup Instructions
 ### Prerequisites
  	- Ruby (version 3.0.0 or later)
	- Rails (version 7.0 or later) 
	- PostgreSQL 
  - #### Clone the Repository
 

   ```
 git clone https://github.com/roasted99/social-y.git 
 cd social-y
```

   - #### Install Dependencies
    bundle install

   - #### DB setup
	   Check `config/database.yml` for db env setup.

    rails db:create
    rails db:migrate

(Optional) Seed the database with initial data:

    rails db:seed

   - #### Run the application

    rails s
OR

    ./bin/dev

   - #### Run test
	  Testing is run with RSpec gem.
   

    bundle exec rspec
   - #### Views
	 Go to http://localhost:3000/ for login.
	 Use below credential to login if you run `rails db:seed`.
	 

    test@example.com
    password123
   ### Api endpoints
   #### Authentication
- #### Login
	 - Endpoint: `POST /api/v1/login`

**Request**
		   

    { 
    "user":  { 	
	    "email": "test@example.com", 
	 "password": "password123" 
	}
     }
	
**Response**

    {
	"user": {
		"id": 37,
		"email": "test@example.com",
		"created_at": "2024-07-11T03:26:42.330Z",
		"updated_at": "2024-07-11T03:26:42.330Z",
		"username": "johnjohn"
		},
	"token":"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNyIsInNjcCI6InVzZXIiLCJhdWQiOm51..."
    }
- ### SignUp
	 - Endpoint:`POST /api/v1/signup`

**Request**
		   

    {
    "user":  { 	
	    	"username": "sky_brother",
	   	"email": "skybro@gmail.com", 
		"password": "password123" ,
		"password_confirmation: "password123"
	    }
	}
	
**Response**

    {
	"user": {
		"id": 38,
		"username": "sky_brother",
		"email": "skybro@gmail.com",
		"created_at": "2024-07-11T03:26:42.330Z",
		"updated_at": "2024-07-11T03:26:42.330Z",
		"username": "sky_brother"
		},
	"token":"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNyIsInNjcCI6InVzZXIiLCJhdWQiOm51bGwsImlhdCI6MTc..."
	}

- ### Post
	- #### Create post
	-   Endpoint: `POST /api/v1/posts`
	- Headers: ``headers: {
				'Authorization':  `Bearer ${token}`,
				'Accept':  'application/json',
				'Content-Type':  'application/json'
			}
	``

**Request**
		   

    { "body": "This is a test post"}
	
**Response**

    {
	"id": 61,
	"body": "This is a test post",
	"created_at": "2024-07-11T04:51:00.664Z",
	"updated_at": "2024-07-11T04:51:00.664Z",
	"user": {
		"id": 37,
		"username": "johnjohn"
	},
	"comments": []
	}
- ### Get all post
	-   Endpoint: `GET /api/v1/posts`
	- Headers: ``headers: {
				'Authorization':  `Bearer ${token}`,
				'Accept':  'application/json',
				'Content-Type':  'application/json'
			}
	``
	
**Response**

    [
	{
	"id": 61,
	"body": "This is a test post",
	"created_at": "2024-07-11T04:51:00.664Z",
	"updated_at": "2024-07-11T04:51:00.664Z",
	"user": {
		"id": 37,
		"username": "johnjohn"
		}
	},...
    ]
		
- ### Update post
	-   Endpoint: `PATCH /api/v1/posts/:id`
	- Headers: ``headers: {
				'Authorization':  `Bearer ${token}`,
				'Accept':  'application/json',
				'Content-Type':  'application/json'
			}
	``

**Request**
		   

    { "body": "This is an update post"}
	
**Response**

    {
	"id": 61,
	"body": "This is a update post",
	"created_at": "2024-07-11T04:57:00.664Z",
	"updated_at": "2024-07-11T04:57:00.664Z",
	}
	
	
- ### Delete post
	-   Endpoint: `POST /api/v1/posts/:id`
	- Headers ``headers: {
				'Authorization':  `Bearer ${token}`,
				'Accept':  'application/json',
				'Content-Type':  'application/json'
			}
	``
	
**Response**

    { "message":  "post has been deleted" }

- ### Create comment
	-   **Endpoint:** `POST /api/v1/posts/postId/comments`
	- **Headers** ``headers: {
				'Authorization':  `Bearer ${token}`,
				'Accept':  'application/json',
				'Content-Type':  'application/json'
			}
	``

**Request**
		   
    { "body": "This is a comment" }
	
**Response**

    {
	"id": 113,
	"body": "This is a comment",
	"created_at": "2024-07-11T04:51:00.664Z",
	"updated_at": "2024-07-11T04:51:00.664Z",
	}
- ### Delete comment
	-   Endpoint: `POST /api/v1/posts/postId/comments/commentId`
	- Headers ``headers: {
				'Authorization':  `Bearer ${token}`,
				'Accept':  'application/json',
				'Content-Type':  'application/json'
			}
	``
	
**Response**

    { "message":  "comment has been deleted" }
