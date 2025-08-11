class PartnerDashboard {
    constructor() {
        this.currentClient = null;
        this.selectedPartnerId = null;
        this.partners = [];
        this.clients = [];
        this.init();
    }

    async init() {
        await this.loadPartners();
        this.setupEventListeners();
    }

    setupEventListeners() {
        // Partner selection
        document.getElementById('partnerSelect').addEventListener('change', (e) => {
            this.selectPartner(e.target.value);
        });

        // Add client button
        document.getElementById('addClientBtn').addEventListener('click', () => this.showClientModal());

        // Modal close buttons
        document.querySelectorAll('.modal-close, #cancelClientBtn').forEach(btn => {
            btn.addEventListener('click', () => this.closeClientModal());
        });

        // Form submission
        document.getElementById('clientForm').addEventListener('submit', (e) => this.handleClientSubmit(e));

        // Search functionality
        document.getElementById('searchInput').addEventListener('input', (e) => this.filterClients(e.target.value));

        // Close modal on outside click
        document.getElementById('clientModal').addEventListener('click', (e) => {
            if (e.target.id === 'clientModal') {
                this.closeClientModal();
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
                this.populatePartnerSelect();
            } else {
                this.showError('Failed to load partners: ' + data.error);
            }
        } catch (error) {
            console.error('Error loading partners:', error);
            this.showError('Network error while loading partners');
        } finally {
            this.showLoading(false);
        }
    }

    populatePartnerSelect() {
        const select = document.getElementById('partnerSelect');
        select.innerHTML = '<option value="">Select Partner...</option>';
        
        this.partners.forEach(partner => {
            const option = document.createElement('option');
            option.value = partner.id;
            option.textContent = partner.name;
            select.appendChild(option);
        });
    }

    async selectPartner(partnerId) {
        this.selectedPartnerId = partnerId ? parseInt(partnerId) : null;
        
        const addClientBtn = document.getElementById('addClientBtn');
        const partnerInfo = document.getElementById('partnerInfo');
        
        if (!this.selectedPartnerId) {
            addClientBtn.disabled = true;
            partnerInfo.classList.add('hidden');
            this.showEmptyState();
            return;
        }

        // Enable add client button
        addClientBtn.disabled = false;

        // Show partner info
        const partner = this.partners.find(p => p.id === this.selectedPartnerId);
        if (partner) {
            document.getElementById('selectedPartnerName').textContent = partner.name;
            document.getElementById('selectedPartnerDescription').textContent = partner.description || 'No description available';
            partnerInfo.classList.remove('hidden');
        }

        // Load clients for this partner
        await this.loadClients();
    }

    async loadClients() {
        if (!this.selectedPartnerId) return;

        try {
            this.showLoading(true);
            const response = await fetch(`/api/clients?partner_id=${this.selectedPartnerId}`);
            const data = await response.json();
            
            if (data.success) {
                this.clients = data.clients;
                this.renderClients();
                this.updateStats();
            } else {
                this.showError('Failed to load clients: ' + data.error);
            }
        } catch (error) {
            console.error('Error loading clients:', error);
            this.showError('Network error while loading clients');
        } finally {
            this.showLoading(false);
        }
    }

    renderClients(clientsToRender = this.clients) {
        const grid = document.getElementById('clientsGrid');
        const emptyState = document.getElementById('emptyState');
        const noClientsState = document.getElementById('noClientsState');

        // Hide all states first
        grid.style.display = 'none';
        emptyState.style.display = 'none';
        noClientsState.style.display = 'none';

        if (!this.selectedPartnerId) {
            emptyState.style.display = 'block';
            return;
        }

        if (clientsToRender.length === 0) {
            noClientsState.style.display = 'block';
            return;
        }

        grid.style.display = 'grid';
        grid.innerHTML = clientsToRender.map(client => this.createClientCard(client)).join('');

        // Add event listeners to action buttons
        clientsToRender.forEach(client => {
            document.getElementById(`edit-${client.id}`).addEventListener('click', () => this.editClient(client));
            document.getElementById(`delete-${client.id}`).addEventListener('click', () => this.deleteClient(client));
        });
    }

    createClientCard(client) {
        const sizeLabels = {
            'Small': 'Small (1-50)',
            'Medium': 'Medium (51-500)',
            'Large': 'Large (501-5000)',
            'Enterprise': 'Enterprise (5000+)'
        };

        return `
            <div class="bg-white rounded-xl border border-gray-200 p-6 hover:shadow-lg transition-all duration-200">
                <div class="flex items-start justify-between mb-4">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 bg-primary-50 rounded-lg flex items-center justify-center">
                            <i class="fas fa-building text-primary-500 text-lg"></i>
                        </div>
                        <div>
                            <h3 class="font-semibold text-gray-900 text-lg">${this.escapeHtml(client.name)}</h3>
                            <p class="text-sm text-gray-500 font-mono">CID ${client.id}</p>
                        </div>
                    </div>
                    <div class="flex items-center gap-1">
                        <button id="edit-${client.id}" class="p-2 text-gray-400 hover:text-primary-500 hover:bg-primary-50 rounded-md transition-all" title="Edit Client">
                            <i class="fas fa-edit text-sm"></i>
                        </button>
                        <button id="delete-${client.id}" class="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-md transition-all" title="Delete Client">
                            <i class="fas fa-trash text-sm"></i>
                        </button>
                    </div>
                </div>

                <div class="mb-4 space-y-2">
                    ${client.industry ? `
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i class="fas fa-industry text-xs text-gray-400"></i>
                            <span>${this.escapeHtml(client.industry)}</span>
                        </div>
                    ` : ''}
                    ${client.size ? `
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i class="fas fa-users text-xs text-gray-400"></i>
                            <span>${sizeLabels[client.size] || client.size}</span>
                        </div>
                    ` : ''}
                    ${client.contact_email ? `
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i class="fas fa-envelope text-xs text-gray-400"></i>
                            <span>${this.escapeHtml(client.contact_email)}</span>
                        </div>
                    ` : ''}
                    ${client.contact_phone ? `
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i class="fas fa-phone text-xs text-gray-400"></i>
                            <span>${this.escapeHtml(client.contact_phone)}</span>
                        </div>
                    ` : ''}
                </div>

                ${client.address ? `
                    <div class="mb-4">
                        <div class="flex items-start gap-2 text-sm text-gray-600">
                            <i class="fas fa-map-marker-alt text-xs text-gray-400 mt-0.5"></i>
                            <span class="leading-relaxed">${this.escapeHtml(client.address)}</span>
                        </div>
                    </div>
                ` : ''}

                <div class="flex items-center justify-between pt-4 border-t border-gray-100">
                    <div class="flex items-center gap-2">
                        <span class="text-xs text-gray-500">Part of ${this.escapeHtml(client.partner_name)}</span>
                    </div>
                    <div class="text-xs text-gray-500">
                        Added ${new Date(client.created_at).toLocaleDateString()}
                    </div>
                </div>
            </div>
        `;
    }

    showClientModal(client = null) {
        this.currentClient = client;
        const modal = document.getElementById('clientModal');
        const form = document.getElementById('clientForm');
        const title = document.getElementById('clientModalTitle');
        const badge = document.getElementById('clientIdBadge');
        const clientId = document.getElementById('displayClientId');

        // Reset form
        form.reset();

        if (client) {
            // Edit mode
            title.textContent = 'Edit Client';
            badge.classList.remove('hidden');
            clientId.textContent = client.id;
            
            // Populate form
            document.getElementById('clientName').value = client.name || '';
            document.getElementById('clientIndustry').value = client.industry || '';
            document.getElementById('clientSize').value = client.size || 'Medium';
            document.getElementById('clientEmail').value = client.contact_email || '';
            document.getElementById('clientPhone').value = client.contact_phone || '';
            document.getElementById('clientAddress').value = client.address || '';
        } else {
            // Add mode
            title.textContent = 'Add Client';
            badge.classList.add('hidden');
        }

        modal.classList.remove('hidden');
        document.getElementById('clientName').focus();
    }

    closeClientModal() {
        document.getElementById('clientModal').classList.add('hidden');
        this.currentClient = null;
    }

    async handleClientSubmit(e) {
        e.preventDefault();
        
        const formData = new FormData(e.target);
        const clientData = {
            client_partner_id: this.selectedPartnerId,
            name: formData.get('name'),
            industry: formData.get('industry'),
            size: formData.get('size'),
            contact_email: formData.get('contact_email'),
            contact_phone: formData.get('contact_phone'),
            address: formData.get('address')
        };

        try {
            this.showLoading(true);
            
            let response;
            if (this.currentClient) {
                // Update existing client
                delete clientData.client_partner_id; // Don't update partner relationship
                response = await fetch(`/api/clients/${this.currentClient.id}`, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(clientData)
                });
            } else {
                // Create new client
                response = await fetch('/api/clients', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(clientData)
                });
            }

            const result = await response.json();
            
            if (result.success) {
                this.showSuccess(this.currentClient ? 'Client updated successfully!' : 'Client created successfully!');
                this.closeClientModal();
                await this.loadClients(); // Reload to show changes
            } else {
                this.showError('Failed to save client: ' + result.error);
            }
        } catch (error) {
            console.error('Error saving client:', error);
            this.showError('Network error while saving client');
        } finally {
            this.showLoading(false);
        }
    }

    async editClient(client) {
        this.showClientModal(client);
    }

    async deleteClient(client) {
        if (!confirm(`Are you sure you want to delete "${client.name}"? This will also delete all associated surveys.`)) {
            return;
        }

        try {
            this.showLoading(true);
            
            const response = await fetch(`/api/clients/${client.id}`, {
                method: 'DELETE'
            });

            const result = await response.json();
            
            if (result.success) {
                this.showSuccess('Client deleted successfully!');
                await this.loadClients(); // Reload to show changes
            } else {
                this.showError('Failed to delete client: ' + result.error);
            }
        } catch (error) {
            console.error('Error deleting client:', error);
            this.showError('Network error while deleting client');
        } finally {
            this.showLoading(false);
        }
    }

    filterClients(searchTerm) {
        const filtered = this.clients.filter(client => 
            client.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
            (client.industry && client.industry.toLowerCase().includes(searchTerm.toLowerCase())) ||
            (client.contact_email && client.contact_email.toLowerCase().includes(searchTerm.toLowerCase()))
        );
        this.renderClients(filtered);
    }

    updateStats() {
        const totalClients = this.clients.length;
        document.getElementById('totalClients').textContent = totalClients;
        
        // TODO: Load actual survey count for these clients
        document.getElementById('totalSurveys').textContent = '0';
    }

    showEmptyState() {
        const grid = document.getElementById('clientsGrid');
        const emptyState = document.getElementById('emptyState');
        const noClientsState = document.getElementById('noClientsState');

        grid.style.display = 'none';
        emptyState.style.display = 'block';
        noClientsState.style.display = 'none';
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

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Initialize the dashboard when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.partnerDashboard = new PartnerDashboard();
});