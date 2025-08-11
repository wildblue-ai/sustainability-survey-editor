class ClientDashboard {
    constructor() {
        this.currentVendor = null;
        this.selectedClientId = null;
        this.clients = [];
        this.vendors = [];
        this.init();
    }

    async init() {
        await this.loadClients();
        this.setupEventListeners();
    }

    setupEventListeners() {
        // Client selection
        document.getElementById('clientSelect').addEventListener('change', (e) => {
            this.selectClient(e.target.value);
        });

        // Add vendor button
        document.getElementById('addVendorBtn').addEventListener('click', () => this.showVendorModal());

        // Modal close buttons
        document.querySelectorAll('.modal-close, #cancelVendorBtn').forEach(btn => {
            btn.addEventListener('click', () => this.closeVendorModal());
        });

        // Form submission
        document.getElementById('vendorForm').addEventListener('submit', (e) => this.handleVendorSubmit(e));

        // Search functionality
        document.getElementById('searchInput').addEventListener('input', (e) => this.filterVendors(e.target.value));

        // Close modal on outside click
        document.getElementById('vendorModal').addEventListener('click', (e) => {
            if (e.target.id === 'vendorModal') {
                this.closeVendorModal();
            }
        });
    }

    async loadClients() {
        try {
            this.showLoading(true);
            const response = await fetch('/api/clients');
            const data = await response.json();
            
            if (data.success) {
                this.clients = data.clients;
                this.populateClientSelect();
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

    populateClientSelect() {
        const select = document.getElementById('clientSelect');
        select.innerHTML = '<option value="">Select Client...</option>';
        
        this.clients.forEach(client => {
            const option = document.createElement('option');
            option.value = client.id;
            option.textContent = `${client.name} (${client.partner_name})`;
            select.appendChild(option);
        });
    }

    async selectClient(clientId) {
        this.selectedClientId = clientId ? parseInt(clientId) : null;
        
        const addVendorBtn = document.getElementById('addVendorBtn');
        const clientInfo = document.getElementById('clientInfo');
        
        if (!this.selectedClientId) {
            addVendorBtn.disabled = true;
            clientInfo.classList.add('hidden');
            this.showEmptyState();
            return;
        }

        // Enable add vendor button
        addVendorBtn.disabled = false;

        // Show client info
        const client = this.clients.find(c => c.id === this.selectedClientId);
        if (client) {
            document.getElementById('selectedClientName').textContent = client.name;
            document.getElementById('selectedClientIndustry').textContent = client.industry || 'Not specified';
            document.getElementById('selectedClientSize').textContent = client.size || 'Not specified';
            document.getElementById('selectedClientPartner').textContent = client.partner_name;
            clientInfo.classList.remove('hidden');
        }

        // Load vendors (all vendors for now, later we can add client-vendor relationships)
        await this.loadVendors();
    }

    async loadVendors() {
        try {
            this.showLoading(true);
            const response = await fetch('/api/vendors');
            const data = await response.json();
            
            if (data.success) {
                this.vendors = data.vendors;
                this.renderVendors();
                this.updateStats();
            } else {
                this.showError('Failed to load vendors: ' + data.error);
            }
        } catch (error) {
            console.error('Error loading vendors:', error);
            this.showError('Network error while loading vendors');
        } finally {
            this.showLoading(false);
        }
    }

    renderVendors(vendorsToRender = this.vendors) {
        const grid = document.getElementById('vendorsGrid');
        const emptyState = document.getElementById('emptyState');
        const noVendorsState = document.getElementById('noVendorsState');

        // Hide all states first
        grid.style.display = 'none';
        emptyState.style.display = 'none';
        noVendorsState.style.display = 'none';

        if (!this.selectedClientId) {
            emptyState.style.display = 'block';
            return;
        }

        if (vendorsToRender.length === 0) {
            noVendorsState.style.display = 'block';
            return;
        }

        grid.style.display = 'grid';
        grid.innerHTML = vendorsToRender.map(vendor => this.createVendorCard(vendor)).join('');

        // Add event listeners to action buttons
        vendorsToRender.forEach(vendor => {
            document.getElementById(`edit-${vendor.id}`).addEventListener('click', () => this.editVendor(vendor));
            document.getElementById(`delete-${vendor.id}`).addEventListener('click', () => this.deleteVendor(vendor));
            document.getElementById(`survey-${vendor.id}`).addEventListener('click', () => this.createSurvey(vendor));
        });
    }

    createVendorCard(vendor) {
        const surveyText = vendor.survey_count === 1 ? 'survey' : 'surveys';

        return `
            <div class="bg-white rounded-xl border border-gray-200 p-6 hover:shadow-lg transition-all duration-200">
                <div class="flex items-start justify-between mb-4">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 bg-primary-50 rounded-lg flex items-center justify-center">
                            <i class="fas fa-truck text-primary-500 text-lg"></i>
                        </div>
                        <div>
                            <h3 class="font-semibold text-gray-900 text-lg">${this.escapeHtml(vendor.name)}</h3>
                            <p class="text-sm text-gray-500 font-mono">VID ${vendor.id}</p>
                        </div>
                    </div>
                    <div class="flex items-center gap-1">
                        <button id="survey-${vendor.id}" class="p-2 text-gray-400 hover:text-green-500 hover:bg-green-50 rounded-md transition-all" title="Create Survey">
                            <i class="fas fa-clipboard-check text-sm"></i>
                        </button>
                        <button id="edit-${vendor.id}" class="p-2 text-gray-400 hover:text-primary-500 hover:bg-primary-50 rounded-md transition-all" title="Edit Vendor">
                            <i class="fas fa-edit text-sm"></i>
                        </button>
                        <button id="delete-${vendor.id}" class="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-md transition-all" title="Delete Vendor">
                            <i class="fas fa-trash text-sm"></i>
                        </button>
                    </div>
                </div>

                <div class="mb-4 space-y-2">
                    ${vendor.industry ? `
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i class="fas fa-industry text-xs text-gray-400"></i>
                            <span>${this.escapeHtml(vendor.industry)}</span>
                        </div>
                    ` : ''}
                    ${vendor.vendor_type ? `
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i class="fas fa-tag text-xs text-gray-400"></i>
                            <span>${this.escapeHtml(vendor.vendor_type)}</span>
                        </div>
                    ` : ''}
                    ${vendor.contact_email ? `
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i class="fas fa-envelope text-xs text-gray-400"></i>
                            <span>${this.escapeHtml(vendor.contact_email)}</span>
                        </div>
                    ` : ''}
                    ${vendor.contact_phone ? `
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i class="fas fa-phone text-xs text-gray-400"></i>
                            <span>${this.escapeHtml(vendor.contact_phone)}</span>
                        </div>
                    ` : ''}
                </div>

                ${vendor.address ? `
                    <div class="mb-4">
                        <div class="flex items-start gap-2 text-sm text-gray-600">
                            <i class="fas fa-map-marker-alt text-xs text-gray-400 mt-0.5"></i>
                            <span class="leading-relaxed">${this.escapeHtml(vendor.address)}</span>
                        </div>
                    </div>
                ` : ''}

                <div class="flex items-center justify-between pt-4 border-t border-gray-100">
                    <div class="flex items-center gap-2">
                        <div class="text-lg font-semibold text-primary-500">${vendor.survey_count || 0}</div>
                        <div class="text-sm text-gray-600">${surveyText}</div>
                    </div>
                    <div class="text-xs text-gray-500">
                        Added ${new Date(vendor.created_at).toLocaleDateString()}
                    </div>
                </div>
            </div>
        `;
    }

    showVendorModal(vendor = null) {
        this.currentVendor = vendor;
        const modal = document.getElementById('vendorModal');
        const form = document.getElementById('vendorForm');
        const title = document.getElementById('vendorModalTitle');
        const badge = document.getElementById('vendorIdBadge');
        const vendorId = document.getElementById('displayVendorId');

        // Reset form
        form.reset();

        if (vendor) {
            // Edit mode
            title.textContent = 'Edit Vendor';
            badge.classList.remove('hidden');
            vendorId.textContent = vendor.id;
            
            // Populate form
            document.getElementById('vendorName').value = vendor.name || '';
            document.getElementById('vendorIndustry').value = vendor.industry || '';
            document.getElementById('vendorType').value = vendor.vendor_type || '';
            document.getElementById('vendorEmail').value = vendor.contact_email || '';
            document.getElementById('vendorPhone').value = vendor.contact_phone || '';
            document.getElementById('vendorAddress').value = vendor.address || '';
        } else {
            // Add mode
            title.textContent = 'Add Vendor';
            badge.classList.add('hidden');
        }

        modal.classList.remove('hidden');
        document.getElementById('vendorName').focus();
    }

    closeVendorModal() {
        document.getElementById('vendorModal').classList.add('hidden');
        this.currentVendor = null;
    }

    async handleVendorSubmit(e) {
        e.preventDefault();
        
        const formData = new FormData(e.target);
        const vendorData = {
            name: formData.get('name'),
            industry: formData.get('industry'),
            vendor_type: formData.get('vendor_type'),
            contact_email: formData.get('contact_email'),
            contact_phone: formData.get('contact_phone'),
            address: formData.get('address')
        };

        try {
            this.showLoading(true);
            
            let response;
            if (this.currentVendor) {
                // Update existing vendor
                response = await fetch(`/api/vendors/${this.currentVendor.id}`, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(vendorData)
                });
            } else {
                // Create new vendor
                response = await fetch('/api/vendors', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(vendorData)
                });
            }

            const result = await response.json();
            
            if (result.success) {
                this.showSuccess(this.currentVendor ? 'Vendor updated successfully!' : 'Vendor created successfully!');
                this.closeVendorModal();
                await this.loadVendors(); // Reload to show changes
            } else {
                this.showError('Failed to save vendor: ' + result.error);
            }
        } catch (error) {
            console.error('Error saving vendor:', error);
            this.showError('Network error while saving vendor');
        } finally {
            this.showLoading(false);
        }
    }

    async editVendor(vendor) {
        this.showVendorModal(vendor);
    }

    async deleteVendor(vendor) {
        if (!confirm(`Are you sure you want to delete "${vendor.name}"? This will also delete all associated surveys.`)) {
            return;
        }

        try {
            this.showLoading(true);
            
            const response = await fetch(`/api/vendors/${vendor.id}`, {
                method: 'DELETE'
            });

            const result = await response.json();
            
            if (result.success) {
                this.showSuccess('Vendor deleted successfully!');
                await this.loadVendors(); // Reload to show changes
            } else {
                this.showError('Failed to delete vendor: ' + result.error);
            }
        } catch (error) {
            console.error('Error deleting vendor:', error);
            this.showError('Network error while deleting vendor');
        } finally {
            this.showLoading(false);
        }
    }

    async createSurvey(vendor) {
        if (!this.selectedClientId) {
            this.showError('Please select a client first');
            return;
        }

        const client = this.clients.find(c => c.id === this.selectedClientId);
        if (!client) {
            this.showError('Selected client not found');
            return;
        }

        const currentYear = new Date().getFullYear();
        const surveyName = `${client.name} - ${vendor.name} Sustainability Assessment ${currentYear}`;
        
        const confirmed = confirm(
            `Create a new sustainability survey?\n\n` +
            `Client: ${client.name}\n` +
            `Vendor: ${vendor.name}\n` +
            `Year: ${currentYear}\n\n` +
            `This will include all questions from the question library.`
        );

        if (!confirmed) return;

        try {
            this.showLoading(true);
            
            const surveyData = {
                client_partner_id: client.client_partner_id,
                client_id: this.selectedClientId,
                vendor_id: vendor.id,
                survey_year: currentYear,
                survey_name: surveyName,
                description: `Annual sustainability evaluation of ${vendor.name} for ${client.name}`,
                start_date: new Date().toISOString().split('T')[0],
                end_date: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000).toISOString().split('T')[0], // 90 days from now
                include_all_questions: true
            };

            const response = await fetch('/api/annual-surveys', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(surveyData)
            });

            const result = await response.json();
            
            if (result.success) {
                this.showSuccess(`Survey created successfully! Added ${result.questions_added} questions.`);
                await this.loadVendors(); // Reload to show updated survey count
            } else {
                this.showError('Failed to create survey: ' + result.error);
            }
        } catch (error) {
            console.error('Error creating survey:', error);
            this.showError('Network error while creating survey');
        } finally {
            this.showLoading(false);
        }
    }

    filterVendors(searchTerm) {
        const filtered = this.vendors.filter(vendor => 
            vendor.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
            (vendor.industry && vendor.industry.toLowerCase().includes(searchTerm.toLowerCase())) ||
            (vendor.vendor_type && vendor.vendor_type.toLowerCase().includes(searchTerm.toLowerCase())) ||
            (vendor.contact_email && vendor.contact_email.toLowerCase().includes(searchTerm.toLowerCase()))
        );
        this.renderVendors(filtered);
    }

    updateStats() {
        const totalVendors = this.vendors.length;
        const totalSurveys = this.vendors.reduce((sum, vendor) => sum + (vendor.survey_count || 0), 0);
        
        document.getElementById('totalVendors').textContent = totalVendors;
        document.getElementById('totalSurveys').textContent = totalSurveys;
    }

    showEmptyState() {
        const grid = document.getElementById('vendorsGrid');
        const emptyState = document.getElementById('emptyState');
        const noVendorsState = document.getElementById('noVendorsState');

        grid.style.display = 'none';
        emptyState.style.display = 'block';
        noVendorsState.style.display = 'none';
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
    window.clientDashboard = new ClientDashboard();
});