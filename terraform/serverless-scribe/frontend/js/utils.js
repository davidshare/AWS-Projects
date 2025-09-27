// Utility functions used across the application
class Utils {
  static escapeHtml(text) {
    if (!text) return "";
    const div = document.createElement("div");
    div.textContent = text;
    return div.innerHTML;
  }

  static formatDate(dateString) {
    if (!dateString) return "Unknown date";
    const date = new Date(dateString);
    return (
      date.toLocaleDateString() +
      " at " +
      date.toLocaleTimeString([], {
        hour: "2-digit",
        minute: "2-digit",
      })
    );
  }

  static showMessage(message, type = "info") {
    // Create message container if it doesn't exist
    let container = document.getElementById("global-message-container");
    if (!container) {
      container = document.createElement("div");
      container.id = "global-message-container";
      container.style.cssText = `
                position: fixed; top: 20px; right: 20px; z-index: 1000;
                padding: 10px; max-width: 300px;
            `;
      document.body.appendChild(container);
    }

    const messageEl = document.createElement("div");
    const bgColor =
      type === "error" ? "#dc3545" : type === "success" ? "#28a745" : "#17a2b8";

    messageEl.style.cssText = `
            background: ${bgColor}; color: white; padding: 15px; 
            border-radius: 5px; margin-bottom: 10px; word-wrap: break-word;
        `;
    messageEl.textContent = message;

    container.appendChild(messageEl);

    // Auto-remove after 5 seconds
    setTimeout(() => {
      if (messageEl.parentNode) {
        messageEl.parentNode.removeChild(messageEl);
      }
    }, 5000);
  }

  static async apiCall(endpoint, options = {}) {
    try {
      const fullUrl = endpoint.startsWith("http")
        ? endpoint
        : `${API_BASE}${endpoint}`;
      const response = await fetch(fullUrl, {
        headers: {
          "Content-Type": "application/json",
          ...options.headers,
        },
        ...options,
      });

      if (!response.ok) {
        const errorText = await response.text();
        let errorMessage = `HTTP ${response.status}`;

        try {
          const errorData = JSON.parse(errorText);
          errorMessage = errorData.error || errorMessage;
        } catch {
          errorMessage = errorText || errorMessage;
        }

        throw new Error(errorMessage);
      }

      return await response.json();
    } catch (error) {
      console.error("API call failed:", error);
      throw error;
    }
  }
}
