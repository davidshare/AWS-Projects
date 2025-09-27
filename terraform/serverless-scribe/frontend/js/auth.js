// Authentication management
class AuthManager {
  constructor() {
    this.token = localStorage.getItem("auth_token");
    this.userInfo = this.getUserInfoFromToken();
  }

  getUserInfoFromToken() {
    if (!this.token) return null;

    try {
      const payload = JSON.parse(atob(this.token.split(".")[1]));
      return {
        username: payload["cognito:username"],
        groups: payload["cognito:groups"] || [],
        email: payload.email,
      };
    } catch (error) {
      console.error("Invalid token:", error);
      this.logout();
      return null;
    }
  }

  isLoggedIn() {
    return !!this.userInfo;
  }

  isAdmin() {
    return this.userInfo && this.userInfo.groups.includes("Admins");
  }

  async login(username, password) {
    try {
      const data = await Utils.apiCall("/auth/login", {
        method: "POST",
        body: JSON.stringify({
          client_id: CLIENT_ID,
          username: username,
          password: password,
        }),
      });

      this.token = data.id_token;
      localStorage.setItem("auth_token", this.token);
      this.userInfo = this.getUserInfoFromToken();

      Utils.showMessage("Login successful!", "success");
      return true;
    } catch (error) {
      Utils.showMessage("Login failed: " + error.message, "error");
      return false;
    }
  }

  logout() {
    this.token = null;
    this.userInfo = null;
    localStorage.removeItem("auth_token");
    window.location.reload();
  }

  getAuthHeaders() {
    return this.token ? {Authorization: `Bearer ${this.token}`} : {};
  }
}

// Global auth instance
window.authManager = new AuthManager();
