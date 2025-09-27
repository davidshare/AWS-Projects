// Comments functionality for individual post pages
class CommentsManager {
  constructor() {
    this.apiBase = window.apiBase || `${window.location.origin}/prod`;
    this.postId = window.postId;
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
    }
  }

  async loadComments() {
    try {
      const commentsList = document.getElementById("comments-list");
      if (!commentsList) return;

      commentsList.innerHTML = '<div class="loading">Loading comments...</div>';

      const response = await fetch(`${this.apiBase}/comments/${this.postId}`);
      if (!response.ok) {
        throw new Error("Failed to load comments");
      }

      const comments = await response.json();
      this.displayComments(comments);
    } catch (error) {
      console.error("Error loading comments:", error);
      this.showError("Failed to load comments");
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

    const author = authorInput.value.trim();
    const text = commentInput.value.trim();

    if (!author || !text) {
      alert("Please fill in both name and comment fields");
      return;
    }

    try {
      const response = await fetch(`${this.apiBase}/comments`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          post_id: this.postId,
          author: author,
          text: text,
        }),
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || "Failed to submit comment");
      }

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
  if (typeof window.postId !== "undefined") {
    window.commentsManager = new CommentsManager();
  }
});
