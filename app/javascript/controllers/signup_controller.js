import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="signup"
export default class extends Controller {
  static targets = ["username", "password", "email", "confirmPassword"]
  connect() {
  }

  async submit(event) {
    event.preventDefault()
    // const form = event.target
    const formData = { 
      user: { 
        username: this.usernameTarget.value,
        email: this.emailTarget.value,
        password: this.passwordTarget.value,
        password_confirmation: this.confirmPasswordTarget.value                    
    } 
  }
    
    const response = await fetch('/api/v1/signup', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(formData)
    })

      const data = await response.json()
      localStorage.setItem('token', data.token)
      localStorage.setItem('user', JSON.stringify(data.user))
      window.location.href = '/'

      const errorData = await response.json()
      console.error('Sign up failed', errorData)
    
  }

  redirectToLogin() {
    window.location.href = '/login'
  }

}
