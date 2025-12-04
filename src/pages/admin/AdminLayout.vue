<template>
  <div class="admin-layout">
    <aside class="admin-sidebar">
      <div class="sidebar-header">
        <h2>Admin Panel</h2>
      </div>
      <nav class="sidebar-nav">
        <router-link to="/admin" class="nav-item" exact-active-class="active">
          <span>📊 Dashboard</span>
        </router-link>
        <router-link to="/admin/projects" class="nav-item" active-class="active">
          <span>🚀 Projects</span>
        </router-link>
        <router-link to="/admin/experiences" class="nav-item" active-class="active">
          <span>💼 Experiences</span>
        </router-link>
        <router-link to="/admin/contacts" class="nav-item" active-class="active">
          <span>✉️ Contacts</span>
        </router-link>
        <router-link to="/" class="nav-item">
          <span>← Back to Site</span>
        </router-link>
      </nav>
    </aside>
    
    <main class="admin-content">
      <router-view />
    </main>
  </div>
</template>

<style scoped>
.admin-layout {
  display: flex;
  min-height: 100vh;
}

.admin-sidebar {
  width: 280px;
  background: rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(20px);
  border-right: 1px solid rgba(255, 255, 255, 0.1);
  padding: 2rem 0;
  position: fixed;
  height: 100vh;
  overflow-y: auto;
}

.sidebar-header {
  padding: 0 1.5rem 2rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  margin-bottom: 1rem;
}

.sidebar-header h2 {
  color: white;
  font-size: 1.5rem;
  font-weight: 600;
  margin: 0;
}

.sidebar-nav {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  padding: 0 1rem;
}

.nav-item {
  display: flex;
  align-items: center;
  padding: 0.875rem 1rem;
  color: rgba(255, 255, 255, 0.7);
  text-decoration: none;
  border-radius: 12px;
  transition: all 0.3s ease;
  font-weight: 500;
}

.nav-item:hover {
  background: rgba(255, 255, 255, 0.05);
  color: white;
}

.nav-item.active {
  background: rgba(99, 102, 241, 0.2);
  color: white;
  border: 1px solid rgba(99, 102, 241, 0.3);
}

.admin-content {
  flex: 1;
  margin-left: 280px;
  padding: 2rem;
}

@media (max-width: 1024px) {
  .admin-sidebar {
    position: static;
    width: 100%;
    height: auto;
  }
  
  .admin-content {
    margin-left: 0;
  }
  
  .admin-layout {
    flex-direction: column;
  }
}
</style>
