// Posts management for both public and admin views
class PostsManager {
  constructor(isAdmin = false) {
    this.isAdmin = isAdmin;
    this.currentPage = 1;
    this.postsPerPage = isAdmin ? 10 : 9;
  }

  async loadPosts(page = 1) {
    this.currentPage = page;

    try {
      const posts = await Utils.apiCall(
        `/posts?page=${page}&limit=${this.postsPerPage}`
      );
      this.displayPosts(posts);
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
                        <button onclick="postsManager.editPost('${
                          post.post_id
                        }')">Edit</button>
                        <button onclick="postsManager.deletePost('${
                          post.post_id
                        }')" class="danger">Delete</button>
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

  // ... rest of the PostsManager class remains the same ...
}

// Global function for public post viewing
function viewPost(slug) {
  window.location.href = `/posts/${slug}.html`;
}
