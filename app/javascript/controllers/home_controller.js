import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home"
export default class extends Controller {
  static targets = ["postsContainer", "form"]


  connect() {
    this.fetchPosts()
  }

  async fetchPosts() {
    console.log("I am at post controller")
    const token = localStorage.getItem('token')
    if (!token) {
      window.location.href = '/login'
      return
    }

    const response = await fetch('/api/v1/posts', {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })

    if (response.ok) {
      const posts = await response.json()
      this.renderPosts(posts)
    } else {
      console.error('Failed to fetch posts')
    }
  }

  renderPosts(posts) {
    this.postsContainerTarget.innerHTML = posts.map(post => this.postTemplate(post)).join('')
  }

  postTemplate(post) {
    return `
      <div class="flex flex-col p-4 border rounded-lg w-full max-w-xl bg-white shadow-md mx-auto mt-4 hover:border-cyan-300" data-action="click->home#redirectToPost" data-post-id="${post.id}" style="cursor: pointer">
        <!-- Tweet Header -->
        <div class="flex items-center mb-2">
          <span class="font-bold">${post.user.username}</span>
        </div>
        
        <div class="mb-4 text-gray-800">
          ${post.body}
        </div>   

        <div class="flex items-center space-x-4">
          <button class="flex items-center text-blue-500 hover:text-blue-600" data-action="click->home#redirectToPost" data-post-id="${post.id}">
            <svg class="w-5 h-5 mr-1" fill="none" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16h6m2 4H7a2 2 0 01-2-2V7a2 2 0 012-2h10a2 2 0 012 2v11a2 2 0 01-2 2z" />
            </svg>
            <span>Comment</span>
          </button>
        </div>
      </div>
    `
  }


  redirectToPost(event) {
    const postId = event.currentTarget.dataset.postId
    window.location.href = `/post/${postId}`
  }

  async submit(event) {
    event.preventDefault()
    const token = localStorage.getItem('token')
    if (!token) {
      window.location.href = '/login'
      return
    }

    const formData = new FormData(this.formTarget)
    const data = Object.fromEntries(formData.entries())

    try {
      const response = await fetch('/api/v1/posts', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    })
 
      const newPost = await response.json()
      this.postsContainerTarget.insertAdjacentHTML('afterbegin', this.postTemplate(newPost))
      this.formTarget.reset()
      
    } catch(error) {
      console.error(error)
    }
  }

  async logout(event) {
    localStorage.removeItem('token')
    localStorage.removeItem('user')

     window.location.href = `/login`
  }

}
