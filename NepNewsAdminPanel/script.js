// State Management
let state = {
    users: [],
    articles: [],
    ads: [],
    logs: []
};

// Theme Management
function toggleTheme() {
    const html = document.documentElement;
    const currentTheme = html.getAttribute('data-theme');
    const newTheme = currentTheme === 'light' ? 'dark' : 'light';
    html.setAttribute('data-theme', newTheme);
    
    // Update theme toggle icon
    const themeToggle = document.querySelector('.theme-toggle i');
    themeToggle.className = newTheme === 'light' ? 'fas fa-moon' : 'fas fa-sun';
    
    // Save theme preference
    localStorage.setItem('theme', newTheme);
}

// Initialize theme from localStorage
function initializeTheme() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.documentElement.setAttribute('data-theme', savedTheme);
    
    // Set initial theme toggle icon
    const themeToggle = document.querySelector('.theme-toggle i');
    themeToggle.className = savedTheme === 'light' ? 'fas fa-moon' : 'fas fa-sun';
}

// Navigation
function navigate(section, event) {
    // Remove active class from all nav links
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
    });

    // Add active class to clicked nav link (only if event is provided)
    if (event && event.currentTarget) {
        event.currentTarget.classList.add('active');
    } else {
        // Optionally, set the active class based on section
        document.querySelectorAll('.nav-link').forEach(link => {
            if (link.getAttribute('onclick') && link.getAttribute('onclick').includes(section)) {
                link.classList.add('active');
            }
        });
    }

    // Load content based on section
    const content = document.getElementById('content');
    content.innerHTML = ''; // Clear existing content

    switch(section) {
        case 'dashboard':
            loadDashboard();
            break;
        case 'users':
            loadUsers();
            break;
        case 'articles':
            loadArticles();
            break;
        case 'ads':
            loadAds();
            break;
        case 'logs':
            loadLogs();
            break;
    }
}

// Dashboard
function loadDashboard() {
    const content = document.getElementById('content');
    
        content.innerHTML = `
        <h2>Dashboard Overview</h2>
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Users</h3>
                <div class="stat-value">${state.users.length}</div>
                <div class="stat-trend trend-up">
                    <i class="fas fa-arrow-up"></i> 12% vs last month
                </div>
            </div>
            <div class="stat-card">
                <h3>Articles Published</h3>
                <div class="stat-value">${state.articles.length}</div>
                <div class="stat-trend trend-up">
                    <i class="fas fa-arrow-up"></i> 5% vs last month
                </div>
            </div>
            <div class="stat-card">
                <h3>Active Ads</h3>
                <div class="stat-value">${state.ads.length}</div>
                <div class="stat-trend trend-down">
                    <i class="fas fa-arrow-down"></i> 2% vs last month
                </div>
            </div>
            <div class="stat-card">
                <h3>Total Revenue</h3>
                <div class="stat-value">$12,345</div>
                <div class="stat-trend trend-up">
                    <i class="fas fa-arrow-up"></i> 8% vs last month
                </div>
            </div>
        </div>
        <div class="chart-container">
            <canvas id="trafficChart"></canvas>
            </div>
        `;

    initializeTrafficChart();
}

function initializeTrafficChart() {
    const ctx = document.getElementById('trafficChart');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [{
                label: 'User Traffic',
                data: [12000, 19000, 15000, 25000, 22000, 30000],
                borderColor: '#0984e3',
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top',
                }
            }
        }
    });
}

// API Functions
async function fetchUsers() {
    try {
        const response = await fetch(`${config.API_URL}/users`, {
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('token')}`
            }
        });
        const data = await response.json();
        state.users = data;
        return data;
    } catch (error) {
        console.error('Error fetching users:', error);
        return [];
    }
}

async function fetchArticles() {
    try {
        const response = await fetch(`${config.API_URL}/articles`, {
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('token')}`
            }
        });
        const data = await response.json();
        state.articles = data;
        return data;
    } catch (error) {
        console.error('Error fetching articles:', error);
        return [];
    }
}

async function fetchAds() {
    try {
        const response = await fetch(`${config.API_URL}/ads`, {
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('token')}`
            }
        });
        const data = await response.json();
        state.ads = data;
        return data;
    } catch (error) {
        console.error('Error fetching ads:', error);
        return [];
    }
}

// Users Management
async function loadUsers() {
    const content = document.getElementById('content');
    
    // Show loading state
    content.innerHTML = '<div class="loading">Loading users...</div>';
    
    // Fetch users from API
    await fetchUsers();
    
    content.innerHTML = `
        <div class="content-header">
            <h2>User Management</h2>
            <button class="btn btn-primary" onclick="showAddUserModal()">
                <i class="fas fa-plus"></i> Add User
            </button>
        </div>
        <table class="data-table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                ${state.users.map((user) => `
                    <tr>
                        <td>${user.name}</td>
                        <td>${user.email}</td>
                        <td>${user.role}</td>
                        <td>
                            <div class="action-buttons-vertical">
                                <button class="btn btn-edit" onclick="editUser('${user._id}')">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <button class="btn btn-delete" onclick="deleteUser('${user._id}')">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </div>
                        </td>
                    </tr>
                `).join('')}
            </tbody>
        </table>
    `;
}

function showAddUserModal() {
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    
    modalBody.innerHTML = `
        <h3>Add New User</h3>
        <form id="addUserForm">
            <div class="form-group">
                <label>Name</label>
                <input type="text" class="form-control" name="name" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" class="form-control" name="email" required>
            </div>
            <div class="form-group">
                <label>Role</label>
                <select class="form-control" name="role" required>
                    <option value="Editor">Editor</option>
                    <option value="Author">Author</option>
                    <option value="Ads Manager">Ads Manager</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Add User</button>
        </form>
    `;

    modal.style.display = 'block';
    
    document.getElementById('addUserForm').onsubmit = (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        addUser({
            name: formData.get('name'),
            email: formData.get('email'),
            role: formData.get('role')
        });
        modal.style.display = 'none';
    };
}

async function addUser(user) {
    try {
        const response = await fetch(`${config.API_URL}/users`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${localStorage.getItem('token')}`
            },
            body: JSON.stringify(user)
        });
        
        if (response.ok) {
            await fetchUsers(); // Refresh the users list
            hideModal();
            logAction(`Added new user: ${user.name}`);
        } else {
            throw new Error('Failed to add user');
        }
    } catch (error) {
        console.error('Error adding user:', error);
        alert('Failed to add user. Please try again.');
    }
}

function editUser(userId) {
    showModal(`
        <h3>Edit User</h3>
        <form id="editUserForm">
            <div class="form-group">
                <label>Name</label>
                <input type="text" class="form-control" name="name" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" class="form-control" name="email" required>
            </div>
            <div class="form-group">
                <label>Role</label>
                <select class="form-control" name="role" required>
                    <option value="Editor">Editor</option>
                    <option value="Author">Author</option>
                    <option value="Ads Manager">Ads Manager</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Save Changes</button>
        </form>
    `);

    document.getElementById('editUserForm').onsubmit = (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        state.users[index] = {
            name: formData.get('name'),
            email: formData.get('email'),
            role: formData.get('role')
        };
        localStorage.setItem('users', JSON.stringify(state.users));
        logAction(`Edited user: ${formData.get('name')}`);
        hideModal();
        loadUsers();
    };
}

async function deleteUser(userId) {
    if (!confirm('Are you sure you want to delete this user?')) return;
    
    try {
        const response = await fetch(`${config.API_URL}/users/${userId}`, {
            method: 'DELETE',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('token')}`
            }
        });
        
        if (response.ok) {
            await fetchUsers(); // Refresh the users list
            logAction('Deleted a user');
        } else {
            throw new Error('Failed to delete user');
        }
    } catch (error) {
        console.error('Error deleting user:', error);
        alert('Failed to delete user. Please try again.');
    }
}

// Logs
function loadLogs() {
    const content = document.getElementById('content');
    
    content.innerHTML = `
        <h2>System Logs</h2>
        <div class="logs-container">
            ${state.logs.map(log => `
                <div class="log-entry">
                    <span class="log-time">${new Date(log.timestamp).toLocaleString()}</span>
                    <span class="log-action">${log.action}</span>
                </div>
            `).join('')}
            </div>
        `;
}

function logAction(action) {
    const log = {
        action,
        timestamp: new Date().toISOString()
    };
    state.logs.unshift(log);
    localStorage.setItem('logs', JSON.stringify(state.logs));
}

// Modal Utilities
function showModal(content) {
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    modalBody.innerHTML = content;
    modal.style.display = 'block';
}

function hideModal() {
    document.getElementById('modal').style.display = 'none';
}

// Authentication Functions
async function login(email, password) {
    try {
        const response = await fetch(`${config.API_URL}/auth/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ email, password })
        });

        const data = await response.json();
        
        if (response.ok) {
            // Store the token in localStorage
            localStorage.setItem('token', data.token);
            // Store user info if needed
            localStorage.setItem('user', JSON.stringify(data.user));
            // Show admin panel
            showAdminPanel();
            navigate('dashboard');
            return true;
        } else {
            throw new Error(data.message || 'Login failed');
        }
    } catch (error) {
        console.error('Login error:', error);
        alert(error.message || 'Login failed. Please try again.');
        return false;
    }
}

function logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    showLoginPage();
}

function showLoginPage() {
    const content = document.getElementById('content');
    content.innerHTML = `
        <div class="login-container">
            <h2>Admin Login</h2>
            <form id="loginForm" onsubmit="handleLogin(event)">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <button type="submit" class="btn btn-primary">Login</button>
            </form>
        </div>
    `;
}

async function handleLogin(event) {
    event.preventDefault();
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    
    const success = await login(email, password);
    if (success) {
        // Login successful, the login function will handle showing the admin panel
    }
}

function showAdminPanel() {
    document.getElementById('login-container').style.display = 'none';
    document.getElementById('admin-panel').style.display = 'flex';
}

// Check authentication status on page load
function checkAuth() {
    const token = localStorage.getItem('token');
    if (token) {
        showAdminPanel();
        navigate('dashboard');
    } else {
        showLoginPage();
    }
}

// Initialize the app
document.addEventListener('DOMContentLoaded', () => {
    checkAuth();
    initializeTheme();
    loadDashboard(); // Load dashboard by default

    // Modal close button
    const closeModalBtn = document.querySelector('.close-modal');
    if (closeModalBtn) {
        closeModalBtn.onclick = () => {
            document.getElementById('modal').style.display = 'none';
        };
    }

    // Click outside modal to close
    window.onclick = (event) => {
        const modal = document.getElementById('modal');
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    };

    // Mobile menu toggle
    document.getElementById('mobile-toggle').onclick = () => {
        document.querySelector('.sidebar').classList.toggle('active');
    };

    // Search Bar Toggle for Mobile
    document.querySelector('.search-bar i').addEventListener('click', function() {
        if (window.innerWidth <= 768) {
            document.querySelector('.search-bar').classList.toggle('active');
        }
    });

    // Close mobile menu when clicking outside
    document.addEventListener('click', function(event) {
        const sidebar = document.querySelector('.sidebar');
        const mobileToggle = document.getElementById('mobile-toggle');
        
        if (window.innerWidth <= 768 && 
            !sidebar.contains(event.target) && 
            !mobileToggle.contains(event.target)) {
            sidebar.classList.remove('active');
        }
    });
});

// Articles Management
function loadArticles() {
    const content = document.getElementById('content');
    
    content.innerHTML = `
        <div class="content-header">
            <h2>Article Management</h2>
            <button class="btn btn-primary" onclick="showAddArticleModal()">
                <i class="fas fa-plus"></i> Create New Article
            </button>
        </div>
        <div class="articles-grid">
            ${state.articles.map((article, index) => `
                <div class="article-card">
                    <div class="article-image">
                        <img src="${article.image || 'https://via.placeholder.com/300x200'}" alt="${article.title}">
                        <span class="article-category">${article.category}</span>
                        <span class="article-status ${article.status.toLowerCase()}">${article.status}</span>
                    </div>
                    <div class="article-content">
                        <h3 class="article-title">${article.title}</h3>
                        <p class="article-excerpt">${article.content?.substring(0, 150)}...</p>
                        <div class="article-metadata">
                            <span><i class="far fa-calendar"></i> ${new Date(article.date).toLocaleDateString()}</span>
                            <span><i class="far fa-eye"></i> ${Math.floor(Math.random() * 1000)} views</span>
                        </div>
                        <div class="article-actions">
                            <button class="btn btn-edit" onclick="editArticle(${index})">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button class="btn btn-delete" onclick="deleteArticle(${index})">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                            <button class="btn btn-preview" onclick="previewArticle(${index})">
                                <i class="fas fa-eye"></i> Preview
                            </button>
                        </div>
                    </div>
                </div>
            `).join('')}
        </div>
    `;
}

function showAddArticleModal() {
    showModal(`
        <h3>Add New Article</h3>
        <form id="addArticleForm">
            <div class="form-group">
                <label>Title</label>
                <input type="text" class="form-control" name="title" required>
            </div>
            <div class="form-group">
                <label>Category</label>
                <select class="form-control" name="category" required>
                    <option value="News">News</option>
                    <option value="Technology">Technology</option>
                    <option value="Sports">Sports</option>
                    <option value="Entertainment">Entertainment</option>
                </select>
            </div>
            <div class="form-group">
                <label>Content</label>
                <textarea class="form-control" name="content" rows="4" required></textarea>
            </div>
            <div class="form-group">
                <label>Status</label>
                <select class="form-control" name="status" required>
                    <option value="Draft">Draft</option>
                    <option value="Published">Published</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Add Article</button>
        </form>
    `);

    document.getElementById('addArticleForm').onsubmit = (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        addArticle({
            title: formData.get('title'),
            category: formData.get('category'),
            content: formData.get('content'),
            status: formData.get('status'),
            date: new Date().toISOString()
        });
        hideModal();
    };
}

function addArticle(article) {
    state.articles.push(article);
    localStorage.setItem('articles', JSON.stringify(state.articles));
    logAction(`Added article: ${article.title}`);
    loadArticles();
}

function editArticle(index) {
    const article = state.articles[index];
    showModal(`
        <h3>Edit Article</h3>
        <form id="editArticleForm">
            <div class="form-group">
                <label>Title</label>
                <input type="text" class="form-control" name="title" value="${article.title}" required>
            </div>
            <div class="form-group">
                <label>Category</label>
                <select class="form-control" name="category" required>
                    <option value="News" ${article.category === 'News' ? 'selected' : ''}>News</option>
                    <option value="Technology" ${article.category === 'Technology' ? 'selected' : ''}>Technology</option>
                    <option value="Sports" ${article.category === 'Sports' ? 'selected' : ''}>Sports</option>
                    <option value="Entertainment" ${article.category === 'Entertainment' ? 'selected' : ''}>Entertainment</option>
                </select>
            </div>
            <div class="form-group">
                <label>Content</label>
                <textarea class="form-control" name="content" rows="4" required>${article.content}</textarea>
            </div>
            <div class="form-group">
                <label>Status</label>
                <select class="form-control" name="status" required>
                    <option value="Draft" ${article.status === 'Draft' ? 'selected' : ''}>Draft</option>
                    <option value="Published" ${article.status === 'Published' ? 'selected' : ''}>Published</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Save Changes</button>
        </form>
    `);

    document.getElementById('editArticleForm').onsubmit = (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        state.articles[index] = {
            ...article,
            title: formData.get('title'),
            category: formData.get('category'),
            content: formData.get('content'),
            status: formData.get('status')
        };
        localStorage.setItem('articles', JSON.stringify(state.articles));
        logAction(`Edited article: ${formData.get('title')}`);
        hideModal();
        loadArticles();
    };
}

function deleteArticle(index) {
    if (confirm('Are you sure you want to delete this article?')) {
        const article = state.articles[index];
        state.articles.splice(index, 1);
        localStorage.setItem('articles', JSON.stringify(state.articles));
        logAction(`Deleted article: ${article.title}`);
        loadArticles();
    }
}

// Advertisements Management
function loadAds() {
    const content = document.getElementById('content');
    
    content.innerHTML = `
        <div class="content-header">
            <h2>Advertisement Management</h2>
            <button class="btn btn-primary" onclick="showAddAdModal()">
                <i class="fas fa-plus"></i> Create New Campaign
            </button>
        </div>
        <div class="ads-grid">
            ${state.ads.map((ad, index) => `
                <div class="ad-card">
                    <div class="ad-header">
                        <div class="ad-status ${ad.status.toLowerCase()}">
                            <i class="fas fa-circle"></i> ${ad.status}
                        </div>
                        <div class="ad-client">
                            <img src="${ad.clientLogo || 'https://via.placeholder.com/40'}" alt="${ad.client}" class="client-logo">
                            <span>${ad.client}</span>
                        </div>
                    </div>
                    <div class="ad-preview">
                        <img src="${ad.image || 'https://via.placeholder.com/300x200'}" alt="${ad.title}">
                    </div>
                    <div class="ad-content">
                        <h3 class="ad-title">${ad.title}</h3>
                        <div class="ad-metrics">
                            <div class="metric">
                                <i class="fas fa-eye"></i>
                                <span>${Math.floor(Math.random() * 10000)}</span>
                                <label>Views</label>
                            </div>
                            <div class="metric">
                                <i class="fas fa-mouse-pointer"></i>
                                <span>${Math.floor(Math.random() * 1000)}</span>
                                <label>Clicks</label>
                            </div>
                            <div class="metric">
                                <i class="fas fa-percentage"></i>
                                <span>${(Math.random() * 5).toFixed(2)}%</span>
                                <label>CTR</label>
                            </div>
                        </div>
                        <div class="ad-timeline">
                            <div class="date-range">
                                <span><i class="far fa-calendar-alt"></i> ${new Date(ad.startDate).toLocaleDateString()} - ${new Date(ad.endDate).toLocaleDateString()}</span>
                            </div>
                            <div class="progress-bar">
                                <div class="progress" style="width: ${calculateProgress(ad.startDate, ad.endDate)}%"></div>
                            </div>
                        </div>
                        <div class="ad-actions">
                            <button class="btn btn-edit" onclick="editAd(${index})">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button class="btn btn-delete" onclick="deleteAd(${index})">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                            <button class="btn btn-stats" onclick="showAdStats(${index})">
                                <i class="fas fa-chart-line"></i> Stats
                            </button>
                        </div>
                    </div>
                </div>
            `).join('')}
        </div>
    `;
}

function showAddAdModal() {
    showModal(`
        <h3>Add New Advertisement</h3>
        <form id="addAdForm">
            <div class="form-group">
                <label>Title</label>
                <input type="text" class="form-control" name="title" required>
            </div>
            <div class="form-group">
                <label>Client</label>
                <input type="text" class="form-control" name="client" required>
            </div>
            <div class="form-group">
                <label>Status</label>
                <select class="form-control" name="status" required>
                    <option value="Active">Active</option>
                    <option value="Pending">Pending</option>
                    <option value="Expired">Expired</option>
                </select>
            </div>
            <div class="form-group">
                <label>Start Date</label>
                <input type="date" class="form-control" name="startDate" required>
            </div>
            <div class="form-group">
                <label>End Date</label>
                <input type="date" class="form-control" name="endDate" required>
            </div>
            <button type="submit" class="btn btn-primary">Add Advertisement</button>
        </form>
    `);

    document.getElementById('addAdForm').onsubmit = (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        addAd({
            title: formData.get('title'),
            client: formData.get('client'),
            status: formData.get('status'),
            startDate: formData.get('startDate'),
            endDate: formData.get('endDate')
        });
        hideModal();
    };
}

function addAd(ad) {
    state.ads.push(ad);
    localStorage.setItem('ads', JSON.stringify(state.ads));
    logAction(`Added advertisement: ${ad.title}`);
    loadAds();
}

function editAd(index) {
    const ad = state.ads[index];
    showModal(`
        <h3>Edit Advertisement</h3>
        <form id="editAdForm">
            <div class="form-group">
                <label>Title</label>
                <input type="text" class="form-control" name="title" value="${ad.title}" required>
            </div>
            <div class="form-group">
                <label>Client</label>
                <input type="text" class="form-control" name="client" value="${ad.client}" required>
            </div>
            <div class="form-group">
                <label>Status</label>
                <select class="form-control" name="status" required>
                    <option value="Active" ${ad.status === 'Active' ? 'selected' : ''}>Active</option>
                    <option value="Pending" ${ad.status === 'Pending' ? 'selected' : ''}>Pending</option>
                    <option value="Expired" ${ad.status === 'Expired' ? 'selected' : ''}>Expired</option>
                </select>
            </div>
            <div class="form-group">
                <label>Start Date</label>
                <input type="date" class="form-control" name="startDate" value="${ad.startDate}" required>
            </div>
            <div class="form-group">
                <label>End Date</label>
                <input type="date" class="form-control" name="endDate" value="${ad.endDate}" required>
            </div>
            <button type="submit" class="btn btn-primary">Save Changes</button>
        </form>
    `);

    document.getElementById('editAdForm').onsubmit = (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        state.ads[index] = {
            title: formData.get('title'),
            client: formData.get('client'),
            status: formData.get('status'),
            startDate: formData.get('startDate'),
            endDate: formData.get('endDate')
        };
        localStorage.setItem('ads', JSON.stringify(state.ads));
        logAction(`Edited advertisement: ${formData.get('title')}`);
        hideModal();
    loadAds();
    };
}

function deleteAd(index) {
    if (confirm('Are you sure you want to delete this advertisement?')) {
        const ad = state.ads[index];
        state.ads.splice(index, 1);
        localStorage.setItem('ads', JSON.stringify(state.ads));
        logAction(`Deleted advertisement: ${ad.title}`);
    loadAds();
    }
}

// Helper function for ad progress calculation
function calculateProgress(startDate, endDate) {
    const start = new Date(startDate).getTime();
    const end = new Date(endDate).getTime();
    const now = new Date().getTime();
    const progress = ((now - start) / (end - start)) * 100;
    return Math.min(Math.max(progress, 0), 100);
}

// Add this to your existing script.js
function setActiveNavLink(page) {
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('onclick').includes(page)) {
            link.classList.add('active');
        }
    });
}

// Add hover effect for menu items
document.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('mouseenter', () => {
        link.style.transform = 'translateX(5px)';
    });
    link.addEventListener('mouseleave', () => {
        link.style.transform = 'translateX(0)';
    });
});
