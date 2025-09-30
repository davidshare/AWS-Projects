// Comments functionality for individual post pages
class CommentsManager {
  constructor() {
    this.apiBase = API_BASE; // Use the constant from config.js
    this.postId = window.postId;
    if (!this.postId) {
      console.error("Post ID not found in window.postId");
      return;
    }
    this.init();
  }

  init() {
    this.loadComments();
    this.setupEventListeners();
  }

  setupEventListeners() {
    const commentForm = document.getElementById("comment-form");
    if (commentForm) {
      commentForm.addEventListener("submit", (e) =>
        this.handleCommentSubmit(e)
      );
    } else {
      console.error("Comment form not found!");
    }
  }

  async loadComments() {
    try {
      const commentsList = document.getElementById("comments-list");
      if (!commentsList) {
        console.error("Comments list element not found");
        return;
      }

      commentsList.innerHTML = '<div class="loading">Loading comments...</div>';

      const url = `${this.apiBase}/comments/${this.postId}`;

      const response = await fetch(url);

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${await response.text()}`);
      }

      const comments = await response.json();
      this.displayComments(comments);
    } catch (error) {
      console.error("Error loading comments:", error);
      this.showError("Failed to load comments: " + error.message);
    }
  }

  displayComments(comments) {
    const commentsList = document.getElementById("comments-list");
    if (!commentsList) return;

    if (!comments || comments.length === 0) {
      commentsList.innerHTML =
        '<div class="no-comments">No comments yet. Be the first to comment!</div>';
      return;
    }

    commentsList.innerHTML = comments
      .map(
        (comment) => `
            <div class="comment">
                <div class="comment-author">${this.escapeHtml(
                  comment.author
                )}</div>
                <div class="comment-date">${this.formatDate(
                  comment.timestamp
                )}</div>
                <div class="comment-text">${this.escapeHtml(comment.text)}</div>
            </div>
        `
      )
      .join("");
  }

  async handleCommentSubmit(event) {
    event.preventDefault();

    const authorInput = document.getElementById("author");
    const commentInput = document.getElementById("comment");

    if (!authorInput || !commentInput) {
      console.error("Form inputs not found");
      return;
    }

    const author = authorInput.value.trim();
    const text = commentInput.value.trim();

    if (!author || !text) {
      this.showError("Please fill in both name and comment fields");
      return;
    }

    try {
      const url = `${this.apiBase}/comments`;
      const payload = {
        post_id: this.postId,
        author: author,
        text: text,
      };


      const response = await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      });


      if (!response.ok) {
        const errorText = await response.text();
        console.error("Server error:", errorText);
        throw new Error(errorText || "Failed to submit comment");
      }

      const result = await response.json();

      // Clear form
      authorInput.value = "";
      commentInput.value = "";

      // Reload comments
      this.loadComments();

      // Show success message
      this.showSuccess("Comment submitted successfully!");
    } catch (error) {
      console.error("Error submitting comment:", error);
      this.showError("Failed to submit comment: " + error.message);
    }
  }

  showError(message) {
    this.showMessage(message, "error");
  }

  showSuccess(message) {
    this.showMessage(message, "success");
  }

  showMessage(message, type) {
    // Create or update message element
    let messageEl = document.getElementById("comment-message");
    if (!messageEl) {
      messageEl = document.createElement("div");
      messageEl.id = "comment-message";
      const commentForm = document.getElementById("comment-form");
      if (commentForm) {
        commentForm.parentNode.insertBefore(messageEl, commentForm.nextSibling);
      }
    }

    messageEl.textContent = message;
    messageEl.className = `message ${type}`;
    messageEl.style.display = "block";

    // Auto-hide after 5 seconds
    setTimeout(() => {
      messageEl.style.display = "none";
    }, 5000);
  }

  formatDate(dateString) {
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

  escapeHtml(text) {
    const div = document.createElement("div");
    div.textContent = text;
    return div.innerHTML;
  }
}

// Initialize comments manager when DOM is loaded
document.addEventListener("DOMContentLoaded", function () {

  if (typeof window.postId !== "undefined" && window.postId) {
    window.commentsManager = new CommentsManager();
  } else {
    console.error("Cannot initialize CommentsManager: postId is undefined");
  }
});
