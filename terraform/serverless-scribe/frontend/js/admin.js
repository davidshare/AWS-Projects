// Admin-specific functionality
class AdminManager {
  constructor() {
    this.postsManager = new PostsManager(true);
    this.setupEventListeners();
    this.setupEventDelegation();
  }

  setupEventDelegation() {
    const postsTable = document.getElementById("posts-table");
    if (postsTable) {
      // Remove any existing event listeners
      postsTable.removeEventListener("click", this.handleTableClick);

      // Add new event listener
      this.handleTableClick = this.handleTableClick.bind(this);
      postsTable.addEventListener("click", this.handleTableClick);
      console.log("Event delegation setup for posts table");
    }
  }

  setupEventListeners() {
    // Post form
    const postForm = document.getElementById("post-form");
    if (postForm) {
      postForm.addEventListener("submit", (e) => this.handlePostSubmit(e));
    }

    // User form
    const userForm = document.getElementById("user-form");
    if (userForm) {
      userForm.addEventListener("submit", (e) => this.handleUserSubmit(e));
    }
  }

  async handlePostSubmit(event) {
    event.preventDefault();

    const title = document.getElementById("post-title").value;
    const content = document.getElementById("post-content").value;

    if (!title || !content) {
      Utils.showMessage("Please fill in all fields", "error");
      return;
    }

    const success = await this.postsManager.createPost(title, content);
    if (success) {
      document.getElementById("post-form").reset();
    }
  }

  async handleUserSubmit(event) {
    event.preventDefault();

    if (!authManager.isAdmin()) {
      Utils.showMessage("Admin access required", "error");
      return;
    }

    const username = document.getElementById("new-username").value;
    const email = document.getElementById("new-email").value;
    const group = document.getElementById("user-group").value;

    if (!username || !email) {
      Utils.showMessage("Please fill in all required fields", "error");
      return;
    }

    try {
      await Utils.apiCall("/users", {
        method: "POST",
        headers: authManager.getAuthHeaders(),
        body: JSON.stringify({username, email, group}),
      });

      Utils.showMessage("User created successfully!", "success");
      document.getElementById("user-form").reset();
    } catch (error) {
      Utils.showMessage("Failed to create user: " + error.message, "error");
    }
  }

  loadAdminContent() {
    if (authManager.isLoggedIn()) {
      // Show admin content
      document.getElementById("login-form").style.display = "none";
      document.getElementById("admin-panel").style.display = "block";
      document.getElementById("admin-content").style.display = "block";

      // Show user management if admin
      if (authManager.isAdmin()) {
        document.getElementById("user-management").style.display = "block";
      }

      // Load posts
      this.postsManager.loadPosts(1);

      // Update username display
      const usernameEl = document.getElementById("admin-username");
      if (usernameEl) {
        usernameEl.textContent = authManager.userInfo.username;
      }
    }
  }
}
