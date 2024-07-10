import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="login"
export default class extends Controller {
  static targets = ["form", "email", "password"]
  connect() {
    console.log('I am from login stimulus')
  }

  async submit(event) {
    event.preventDefault()
    const form = event.target
    const formData = { user: { email: this.emailTarget.value, password: this.passwordTarget.value}}
    
    try {
      const response = await fetch('/api/v1/login', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(formData)
    })
      if(response.status == 401) alert("username or password is incorrect")
      const data = await response.json()

      localStorage.setItem('token', data.token)
      localStorage.setItem('user', JSON.stringify(data.user))
      window.location.href = '/'
 

    } catch(error) {
      const errorData = error
      console.error('Login failed', errorData)
    }
   
  }

  redirectToSignup() {
    window.location.href = '/signup'
  }
}
