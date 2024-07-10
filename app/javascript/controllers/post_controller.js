import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="post"
export default class extends Controller {
  static targets = ["postContainer", "commentForm", "commentContainer", "editBody", "editContainer", "postBody", "postContainer"]

  connect() {
    console.log("from post stimulus")
    this.postId = this.getPostIdFromUrl();
    this.fetchPostDetails()
  }

  getPostIdFromUrl() {
    const url = window.location.pathname;
    const id = url.split('/').pop();
    return id;
  }

  async fetchPostDetails() {
    const token = localStorage.getItem('token')
    if (!token) {
      window.location.href = '/login'
      return
    }

   try { 
    const response = await fetch(`/api/v1/posts/${this.postId}`, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })
      const post = await response.json()
      this.renderPostDetails(post)
    } catch(error) {
      console.error('Failed to fetch post details')
      console.log(error)
    }
    
  }

  renderPostDetails(post) {
    this.postContainerTarget.innerHTML = this.postTemplate(post)

    if (post.comments.length > 0) {
      post.comments.forEach(comment => {
      this.commentContainerTarget.insertAdjacentHTML('beforeend', this.commentTemplate(comment))
    })}
  }

  postTemplate(post) {
    return `
      <div class="flex flex-col p-4 border rounded-lg w-full max-w-xl bg-white shadow-md mx-auto">
       
          <div class="flex items-center mb-4">
            <span class="font-bold">${post.user.username}</span>
          </div>
    
       
          <div data-post-target="postContainer">
           <div class="mb-4 text-gray-800" data-post-target="postBody">
           ${post.body}
           </div>

          <button class="text-blue-500" data-action="click->post#editPost">Edit</button>
          <button class="text-red-500" data-action="click->post#deletePost">Delete</button>
        </div>

          <div style="display: none;" id="editContainer" data-post-target="editContainer">
            <textarea data-post-target="editBody" class="w-full border border-sky-300 rounded-lg p-2 resize-none focus:outline-none focus:ring-2 focus:ring-sky-500" rows="2" ></textarea>
            <button data-action="click->post#submitEdit" class="text-blue-500">Submit</button>
            <button data-action="click->post#cancelEdit" class="text-red-500">Cancel</button>
           </div>

      </div>
    `
  }

  commentTemplate(comment) {
    return `
      <div class="flex items-start mb-2" id=comment${comment.id}>
        <div class="flex-1">
          <div class="bg-gray-100 p-2 rounded-lg">
            <span class="font-bold"></span>
              <p class="text-gray-800">${comment.body}</p>
              <button class="text-red-500" data-action="click->post#deleteComment" data-comment-id=${comment.id}>Delete</button>
          </div>
        </div>
          
       
      </div>
    `
  }


  async submitComment(event) {
    event.preventDefault()
    const token = localStorage.getItem('token')
    if (!token) {
      window.location.href = '/login'
      return
    }

    const formData = new FormData(this.commentFormTarget)
    const data = Object.fromEntries(formData.entries())

    // const postId = this.element.dataset.postId
    const response = await fetch(`/api/v1/posts/${this.postId}/comments`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    })

    if (response.ok) {
      const newComment = await response.json()
      this.commentContainerTarget.insertAdjacentHTML('beforeend', this.commentTemplate(newComment))
      this.commentFormTarget.reset()
    } else {
      console.error('Failed to submit comment')
    }
  }

  async deletePost(event) {
    const token = localStorage.getItem('token')
    if (!token) {
      window.location.href = '/login'
      return
    }

    // const postId = this.element.dataset.postId
    const response = await fetch(`/api/v1/posts/${this.postId}`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })

    if (response.ok) {
      window.location.href = '/'
    } else {
      console.error('Failed to delete post')
    }
  }

  editPost() {
    const body = this.postBodyTarget.textContent;
    this.editBodyTarget.value = body;
    // this.postContainerTarget.style.display = 'none';
    // this.editContainerTarget.style.display = 'block';
    document.getElementById('editContainer').style.display = 'block'
    // this.editContainerTarget.classList.remove = 'hidden';
  }

  submitEdit() {
    const token = localStorage.getItem('token')
    if (!token) {
      window.location.href = '/login'
      return
    }

    const updatedBody = this.editBodyTarget.value;

    fetch(`/api/v1/posts/${this.postId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify({
        post: {
          body: updatedBody
        }
      })
    })
      .then(response => response.json())
      .then(data => {
        this.postBodyTarget.textContent = data.body;
        this.postContainerTarget.style.display = 'block';
        this.editContainerTarget.style.display = 'none';
      })
      .catch(error => {
        console.error('Error updating post:', error);
      });
  }

  cancelEdit() {
    this.postContainerTarget.style.display = 'block';
    this.editContainerTarget.style.display = 'none';
  }


  async deleteComment(event) {
    const token = localStorage.getItem('token')
    if (!token) {
      window.location.href = '/login'
      return
    }

    // const postId = this.element.dataset.postId
    const commentId = event.currentTarget.dataset.commentId
    const response = await fetch(`/api/v1/posts/${this.postId}/comments/${commentId}`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })

    if (response.ok) {
      document.getElementById(`comment${commentId}`).remove()
      window.location.href = `/post/${this.postId}`
    } else {
      console.error('Failed to delete post')
    }
  }

  async logout(event) {
    localStorage.removeItem('token')
    localStorage.removeItem('user')

     window.location.href = `/login`
  }
}