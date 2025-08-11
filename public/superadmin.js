class SuperAdminDashboard {
    constructor() {
        this.currentPartner = null;
        this.partners = [];
        this.currentUser = null;
        this.init();
    }

    async init() {
        await this.checkAuthentication();
    }

    async checkAuthentication() {
        try {
            const response = await fetch('/api/auth/status');
            const data = await response.json();
            
            if (!data.authenticated) {
                window.location.href = '/login.html';
                return;
            }
            
            // Get user details
            const userResponse = await fetch('/api/auth/user');
            const userData = await userResponse.json();
            
            if (userData.success) {
                this.currentUser = userData.user;
                
                // Check if user has superadmin role
                if (this.currentUser.role !== 'superadmin') {
                    this.showError('Access denied. SuperAdmin privileges required.');
                    setTimeout(() => window.location.href = '/', 2000);
                    return;
                }
                
                this.updateUIForUser();
                await this.loadPartners();
                this.setupEventListeners();
                this.updateStats();
            }
        } catch (error) {
            console.error('Authentication check failed:', error);
            window.location.href = '/login.html';
        }
    }

    updateUIForUser() {
        if (!this.currentUser) return;

        // Add user info and logout button to header
        const header = document.querySelector('header .flex-1');
        if (header) {
            const userInfo = document.createElement('div');
            userInfo.className = 'flex items-center gap-4 mt-2';
            userInfo.innerHTML = `
                <div class="flex items-center gap-2 text-sm text-gray-600">
                    <i class="fas fa-user text-xs"></i>
                    <span>Welcome, ${this.escapeHtml(this.currentUser.name)}</span>
                    <span class="px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded-full font-medium">SuperAdmin</span>
                </div>
                <button onclick="superAdmin.logout()" class="flex items-center gap-2 px-3 py-1 text-sm text-gray-600 hover:text-gray-800 hover:bg-gray-100 rounded-md transition-all">
                    <i class="fas fa-sign-out-alt text-xs"></i>
                    <span>Logout</span>
                </button>
            `;
            header.appendChild(userInfo);
        }
    }

    setupEventListeners() {
        // Add partner button
        document.getElementById('addPartnerBtn').addEventListener('click', () => this.showPartnerModal());

        // Modal close buttons
        document.querySelectorAll('.modal-close, #cancelPartnerBtn').forEach(btn => {
            btn.addEventListener('click', () => this.closePartnerModal());
        });

        // Form submission
        document.getElementById('partnerForm').addEventListener('submit', (e) => this.handlePartnerSubmit(e));

        // Search functionality
        document.getElementById('searchInput').addEventListener('input', (e) => this.filterPartners(e.target.value));

        // Close modal on outside click
        document.getElementById('partnerModal').addEventListener('click', (e) => {
            if (e.target.id === 'partnerModal') {
                this.closePartnerModal();
            }
        });
    }

    async loadPartners() {
        try {
            this.showLoading(true);
            const response = await fetch('/api/client-partners');
            const data = await response.json();
            
            if (data.success) {
                this.partners = data.client_partners;
                this.renderPartners();
            } else {
                this.showError('Failed to load client partners: ' + data.error);
            }
        } catch (error) {
            console.error('Error loading partners:', error);
            this.showError('Network error while loading client partners');
        } finally {
            this.showLoading(false);
        }
    }

    renderPartners(partnersToRender = this.partners) {
        const grid = document.getElementById('partnersGrid');
        const emptyState = document.getElementById('emptyState');

        if (partnersToRender.length === 0) {
            grid.style.display = 'none';
            emptyState.style.display = 'block';
            return;
        }

        grid.style.display = 'grid';
        emptyState.style.display = 'none';

        grid.innerHTML = partnersToRender.map(partner => this.createPartnerCard(partner)).join('');

        // Add event listeners to action buttons
        partnersToRender.forEach(partner => {
            document.getElementById(`edit-${partner.id}`).addEventListener('click', () => this.editPartner(partner));
            document.getElementById(`delete-${partner.id}`).addEventListener('click', () => this.deletePartner(partner));
        });
    }

    createPartnerCard(partner) {
        const clientText = partner.client_count === 1 ? 'client' : 'clients';
        
        return `
            <div class="bg-white rounded-xl border border-gray-200 p-6 hover:shadow-lg transition-all duration-200">
                <div class="flex items-start justify-between mb-4">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 bg-primary-50 rounded-lg flex items-center justify-center">
                            <i class="fas fa-building text-primary-500 text-lg"></i>
                        </div>
                        <div>
                            <h3 class="font-semibold text-gray-900 text-lg">${this.escapeHtml(partner.name)}</h3>
                            <p class="text-sm text-gray-500 font-mono">PID ${partner.id}</p>
                        </div>
                    </div>
                    <div class="flex items-center gap-1">
                        <button id="edit-${partner.id}" class="p-2 text-gray-400 hover:text-primary-500 hover:bg-primary-50 rounded-md transition-all" title="Edit Partner">
                            <i class="fas fa-edit text-sm"></i>
                        </button>
                        <button id="delete-${partner.id}" class="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-md transition-all" title="Delete Partner">
                            <i class="fas fa-trash text-sm"></i>
                        </button>
                    </div>
                </div>

                <div class="mb-4">
                    <p class="text-gray-600 text-sm leading-relaxed">
                        ${partner.description ? this.escapeHtml(partner.description) : 'No description provided'}
                    </p>
                </div>

                <div class="space-y-2 mb-4">
                    ${partner.contact_email ? `
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i class="fas fa-envelope text-xs text-gray-400"></i>
                            <span>${this.escapeHtml(partner.contact_email)}</span>
                        </div>
                    ` : ''}
                    ${partner.contact_phone ? `
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i class="fas fa-phone text-xs text-gray-400"></i>
                            <span>${this.escapeHtml(partner.contact_phone)}</span>
                        </div>
                    ` : ''}
                </div>

                <div class="flex items-center justify-between pt-4 border-t border-gray-100">
                    <div class="flex items-center gap-2">
                        <div class="text-2xl font-bold text-primary-500">${partner.client_count}</div>
                        <div class="text-sm text-gray-600">${clientText}</div>
                    </div>
                    <div class="text-xs text-gray-500">
                        Added ${new Date(partner.created_at).toLocaleDateString()}
                    </div>
                </div>
            </div>
        `;
    }

    showPartnerModal(partner = null) {
        this.currentPartner = partner;
        const modal = document.getElementById('partnerModal');
        const form = document.getElementById('partnerForm');
        const title = document.getElementById('partnerModalTitle');
        const badge = document.getElementById('partnerIdBadge');
        const partnerId = document.getElementById('displayPartnerId');

        // Reset form
        form.reset();

        if (partner) {
            // Edit mode
            title.textContent = 'Edit Client Partner';
            badge.classList.remove('hidden');
            partnerId.textContent = partner.id;
            
            // Populate form
            document.getElementById('partnerName').value = partner.name || '';
            document.getElementById('partnerDescription').value = partner.description || '';
            document.getElementById('partnerEmail').value = partner.contact_email || '';
            document.getElementById('partnerPhone').value = partner.contact_phone || '';
        } else {
            // Add mode
            title.textContent = 'Add Client Partner';
            badge.classList.add('hidden');
        }

        modal.classList.remove('hidden');
        document.getElementById('partnerName').focus();
    }

    closePartnerModal() {
        document.getElementById('partnerModal').classList.add('hidden');
        this.currentPartner = null;
    }

    async handlePartnerSubmit(e) {
        e.preventDefault();
        
        const formData = new FormData(e.target);
        const partnerData = {
            name: formData.get('name'),
            description: formData.get('description'),
            contact_email: formData.get('contact_email'),
            contact_phone: formData.get('contact_phone')
        };

        try {
            this.showLoading(true);
            
            let response;
            if (this.currentPartner) {
                // Update existing partner
                response = await fetch(`/api/client-partners/${this.currentPartner.id}`, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(partnerData)
                });
            } else {
                // Create new partner
                response = await fetch('/api/client-partners', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(partnerData)
                });
            }

            const result = await response.json();
            
            if (result.success) {
                this.showSuccess(this.currentPartner ? 'Partner updated successfully!' : 'Partner created successfully!');
                this.closePartnerModal();
                await this.loadPartners(); // Reload to show changes
            } else {
                this.showError('Failed to save partner: ' + result.error);
            }
        } catch (error) {
            console.error('Error saving partner:', error);
            this.showError('Network error while saving partner');
        } finally {
            this.showLoading(false);
        }
    }

    async editPartner(partner) {
        this.showPartnerModal(partner);
    }

    async deletePartner(partner) {
        if (!confirm(`Are you sure you want to delete "${partner.name}"? This will also delete all associated clients and surveys.`)) {
            return;
        }

        try {
            this.showLoading(true);
            
            const response = await fetch(`/api/client-partners/${partner.id}`, {
                method: 'DELETE'
            });

            const result = await response.json();
            
            if (result.success) {
                this.showSuccess('Partner deleted successfully!');
                await this.loadPartners(); // Reload to show changes
            } else {
                this.showError('Failed to delete partner: ' + result.error);
            }
        } catch (error) {
            console.error('Error deleting partner:', error);
            this.showError('Network error while deleting partner');
        } finally {
            this.showLoading(false);
        }
    }

    filterPartners(searchTerm) {
        const filtered = this.partners.filter(partner => 
            partner.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
            (partner.description && partner.description.toLowerCase().includes(searchTerm.toLowerCase())) ||
            (partner.contact_email && partner.contact_email.toLowerCase().includes(searchTerm.toLowerCase()))
        );
        this.renderPartners(filtered);
    }

    updateStats() {
        const totalPartners = this.partners.length;
        const totalClients = this.partners.reduce((sum, partner) => sum + (partner.client_count || 0), 0);
        
        document.getElementById('totalPartners').textContent = totalPartners;
        document.getElementById('totalClients').textContent = totalClients;
    }

    showLoading(show) {
        const loading = document.getElementById('loading');
        if (show) {
            loading.classList.remove('hidden');
        } else {
            loading.classList.add('hidden');
        }
    }

    showSuccess(message) {
        // Simple success notification - you can enhance this
        const notification = document.createElement('div');
        notification.className = 'fixed top-4 right-4 bg-green-500 text-white px-6 py-3 rounded-md shadow-lg z-50';
        notification.innerHTML = `
            <div class="flex items-center gap-2">
                <i class="fas fa-check-circle"></i>
                <span>${message}</span>
            </div>
        `;
        
        document.body.appendChild(notification);
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }

    showError(message) {
        // Simple error notification - you can enhance this
        const notification = document.createElement('div');
        notification.className = 'fixed top-4 right-4 bg-red-500 text-white px-6 py-3 rounded-md shadow-lg z-50';
        notification.innerHTML = `
            <div class="flex items-center gap-2">
                <i class="fas fa-exclamation-circle"></i>
                <span>${message}</span>
            </div>
        `;
        
        document.body.appendChild(notification);
        setTimeout(() => {
            notification.remove();
        }, 5000);
    }

    async logout() {
        try {
            const response = await fetch('/api/auth/logout', {
                method: 'POST'
            });
            
            if (response.ok) {
                window.location.href = '/login.html';
            }
        } catch (error) {
            console.error('Logout failed:', error);
            // Force redirect anyway
            window.location.href = '/login.html';
        }
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Initialize the dashboard when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.superAdmin = new SuperAdminDashboard();
});