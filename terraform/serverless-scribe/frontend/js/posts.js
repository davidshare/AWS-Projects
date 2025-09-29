// Posts management for both public and admin views
class PostsManager {
  constructor(isAdmin = false) {
    this.isAdmin = isAdmin;
    this.currentPage = 1;
    this.postsPerPage = isAdmin ? 10 : 9;
    this.totalPosts = 0;
    this.totalPages = 0;
  }

  async loadPosts(page = 1) {
    this.currentPage = page;

    try {
      const response = await Utils.apiCall(
        `/posts?page=${page}&limit=${this.postsPerPage}`
      );

      // Handle both array response (current) and object response with metadata (future)
      if (Array.isArray(response)) {
        // Current API returns just the posts array
        this.displayPosts(response);
        this.totalPosts = response.length; // This is just for current page, not total
        this.totalPages = Math.ceil(this.totalPosts / this.postsPerPage);
      } else if (response.posts && response.metadata) {
        // Future API could return posts + metadata
        this.displayPosts(response.posts);
        this.totalPosts = response.metadata.totalPosts || response.posts.length;
        this.totalPages =
          response.metadata.totalPages ||
          Math.ceil(this.totalPosts / this.postsPerPage);
      } else {
        // Fallback
        this.displayPosts(response);
        this.totalPosts = response.length;
        this.totalPages = Math.ceil(this.totalPosts / this.postsPerPage);
      }

      this.updatePagination();
    } catch (error) {
      const container = this.isAdmin
        ? document.querySelector("#posts-table tbody")
        : document.getElementById("post-grid");

      if (container) {
        container.innerHTML = `<div class="error">Error loading posts: ${error.message}</div>`;
      }
      Utils.showMessage("Failed to load posts: " + error.message, "error");
    }
  }

  displayPosts(posts) {
    const container = this.isAdmin
      ? document.querySelector("#posts-table tbody")
      : document.getElementById("post-grid");

    if (!container) return;

    if (!posts || posts.length === 0) {
      container.innerHTML = this.isAdmin
        ? '<tr><td colspan="4">No posts found</td></tr>'
        : '<div class="no-posts">No posts found. Check back later!</div>';
      return;
    }

    if (this.isAdmin) {
      container.innerHTML = posts
        .map(
          (post) => `
      <tr>
        <td>${Utils.escapeHtml(post.title)}</td>
        <td>${Utils.escapeHtml(post.author)}</td>
        <td>${Utils.formatDate(post.publish_date)}</td>
        <td>
          <button data-action="edit" data-post-id="${
            post.post_id
          }">Edit</button>
          <button data-action="delete" data-post-id="${
            post.post_id
          }" class="danger">Delete</button>
        </td>
      </tr>
    `
        )
        .join("");
    } else {
      container.innerHTML = posts
        .map(
          (post) => `
                <div class="post-card" onclick="viewPost('${post.slug}')">
                    <h3>${Utils.escapeHtml(post.title)}</h3>
                    <p class="author">By ${Utils.escapeHtml(post.author)}</p>
                    <p class="date">${Utils.formatDate(post.publish_date)}</p>
                    <p class="excerpt">${Utils.escapeHtml(
                      post.content.substring(0, 100)
                    )}...</p>
                </div>
            `
        )
        .join("");
    }
  }

  updatePagination() {
    if (this.isAdmin) {
      const pageInfo = document.getElementById("posts-page-info");
      const prevBtn = document.querySelector(".pagination button:first-child");
      const nextBtn = document.querySelector(".pagination button:last-child");

      if (pageInfo) {
        pageInfo.textContent = `Page ${this.currentPage}${
          this.totalPages > 0 ? ` of ${this.totalPages}` : ""
        }`;
      }
      if (prevBtn) prevBtn.disabled = this.currentPage <= 1;
      if (nextBtn) nextBtn.disabled = this.currentPage >= this.totalPages;
    } else {
      const pageInfo = document.getElementById("page-info");
      const prevBtn = document.getElementById("prev-btn");
      const nextBtn = document.getElementById("next-btn");

      if (pageInfo) {
        pageInfo.textContent = `Page ${this.currentPage}${
          this.totalPages > 0 ? ` of ${this.totalPages}` : ""
        }`;
      }
      if (prevBtn) prevBtn.disabled = this.currentPage <= 1;
      if (nextBtn) nextBtn.disabled = this.currentPage >= this.totalPages;
    }
  }

  nextPage() {
    if (this.currentPage < this.totalPages) {
      this.loadPosts(this.currentPage + 1);
    }
  }

  prevPage() {
    if (this.currentPage > 1) {
      this.loadPosts(this.currentPage - 1);
    }
  }

  async createPost(title, content) {
    try {
      if (!authManager.isLoggedIn()) {
        Utils.showMessage("Please log in to create posts", "error");
        return false;
      }

      await Utils.apiCall("/posts", {
        method: "POST",
        headers: authManager.getAuthHeaders(),
        body: JSON.stringify({title, content}),
      });

      Utils.showMessage("Post created successfully!", "success");
      this.loadPosts(this.currentPage); // Reload current page
      return true;
    } catch (error) {
      Utils.showMessage("Failed to create post: " + error.message, "error");
      return false;
    }
  }

  async editPost(postId) {
    // Implementation for editing posts
    Utils.showMessage("Edit functionality not implemented yet", "info");
  }

  async deletePost(postId) {
    if (!confirm("Are you sure you want to delete this post?")) {
      return;
    }

    try {
      await Utils.apiCall(`/posts/${postId}`, {
        method: "DELETE",
        headers: authManager.getAuthHeaders(),
      });

      Utils.showMessage("Post deleted successfully!", "success");
      this.loadPosts(this.currentPage); // Reload current page
    } catch (error) {
      Utils.showMessage("Failed to delete post: " + error.message, "error");
    }
  }

  // Optional: Method to count S3 posts (if we implement this)
  async countPostsFromS3() {
    try {
      // This would require a new API endpoint that counts S3 objects
      const response = await Utils.apiCall("/posts/count");
      return response.count || 0;
    } catch (error) {
      console.error("Failed to count posts from S3:", error);
      return 0;
    }
  }
}

// Global function for public post viewing
function viewPost(slug) {
  window.location.href = `/posts/${slug}.html`;
}
