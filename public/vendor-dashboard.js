class VendorDashboard {
    constructor() {
        this.currentUser = null;
        this.surveys = [];
        this.filteredSurveys = [];
        this.currentSurvey = null;
        this.init();
    }

    async init() {
        await this.checkAuthentication();
        await this.loadData();
        this.setupEventListeners();
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
            
            if (userData.success && userData.user.role === 'vendor') {
                this.currentUser = userData.user;
                this.updateUI();
            } else {
                console.error('Access denied: vendor role required');
                alert('Access denied. Vendor role required.');
                window.location.href = '/login.html';
            }
        } catch (error) {
            console.error('Authentication check failed:', error);
            window.location.href = '/login.html';
        }
    }

    updateUI() {
        if (this.currentUser) {
            document.getElementById('userName').textContent = this.currentUser.name || this.currentUser.email;
        }
    }

    setupEventListeners() {
        // Filter event listeners
        document.getElementById('statusFilter').addEventListener('change', () => this.filterSurveys());
        document.getElementById('yearFilter').addEventListener('change', () => this.filterSurveys());
    }

    async loadData() {
        try {
            await this.loadSurveys();
            this.updateOverviewCards();
            this.renderSurveys();
        } catch (error) {
            console.error('Error loading data:', error);
            this.showError('Failed to load dashboard data');
        }
    }

    async loadSurveys() {
        try {
            const response = await fetch(`/api/surveys?vendor_id=${this.currentUser.vendor_id}`);
            if (!response.ok) throw new Error('Failed to fetch surveys');
            
            const data = await response.json();
            this.surveys = data.surveys || [];
            this.filteredSurveys = [...this.surveys];
        } catch (error) {
            console.error('Error loading surveys:', error);
            this.surveys = [];
            this.filteredSurveys = [];
        }
    }

    updateOverviewCards() {
        const total = this.surveys.length;
        const completed = this.surveys.filter(s => s.status === 'completed').length;
        const pending = this.surveys.filter(s => s.status === 'draft' || s.status === 'active').length;

        document.getElementById('totalSurveys').textContent = total;
        document.getElementById('completedSurveys').textContent = completed;
        document.getElementById('pendingSurveys').textContent = pending;
    }

    filterSurveys() {
        const statusFilter = document.getElementById('statusFilter').value;
        const yearFilter = document.getElementById('yearFilter').value;

        this.filteredSurveys = this.surveys.filter(survey => {
            const statusMatch = !statusFilter || survey.status === statusFilter;
            const yearMatch = !yearFilter || survey.survey_year.toString() === yearFilter;
            return statusMatch && yearMatch;
        });

        this.renderSurveys();
    }

    renderSurveys() {
        const container = document.getElementById('surveysContainer');
        
        if (this.filteredSurveys.length === 0) {
            container.innerHTML = `
                <div class="text-center py-8">
                    <i class="fas fa-file-alt text-gray-300 text-4xl mb-3"></i>
                    <h3 class="text-lg font-medium text-gray-900 mb-2">No surveys found</h3>
                    <p class="text-gray-500">No sustainability surveys have been assigned to you yet.</p>
                </div>
            `;
            return;
        }

        const surveysHTML = this.filteredSurveys.map(survey => this.renderSurveyCard(survey)).join('');
        container.innerHTML = surveysHTML;
    }

    renderSurveyCard(survey) {
        const statusColors = {
            draft: 'bg-gray-100 text-gray-700',
            active: 'bg-blue-100 text-blue-700',
            completed: 'bg-green-100 text-green-700'
        };

        const statusIcons = {
            draft: 'fas fa-edit',
            active: 'fas fa-play-circle',
            completed: 'fas fa-check-circle'
        };

        return `
            <div class="border border-gray-200 rounded-lg p-6 hover:shadow-md transition-shadow cursor-pointer" 
                 onclick="openSurveyDetails(${survey.id})">
                <div class="flex items-start justify-between mb-4">
                    <div class="flex-1">
                        <h3 class="text-lg font-semibold text-gray-900 mb-2">${survey.survey_name}</h3>
                        <p class="text-sm text-gray-600 mb-3">${survey.description || 'No description provided'}</p>
                    </div>
                    <span class="px-3 py-1 rounded-full text-xs font-medium ${statusColors[survey.status]}">
                        <i class="${statusIcons[survey.status]} mr-1"></i>
                        ${survey.status.charAt(0).toUpperCase() + survey.status.slice(1)}
                    </span>
                </div>
                
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                    <div>
                        <span class="text-gray-500">Client:</span>
                        <div class="font-medium text-gray-900">${survey.client_name}</div>
                    </div>
                    <div>
                        <span class="text-gray-500">Partner:</span>
                        <div class="font-medium text-gray-900">${survey.partner_name}</div>
                    </div>
                    <div>
                        <span class="text-gray-500">Year:</span>
                        <div class="font-medium text-gray-900">${survey.survey_year}</div>
                    </div>
                    <div>
                        <span class="text-gray-500">Deadline:</span>
                        <div class="font-medium text-gray-900">
                            ${survey.end_date ? new Date(survey.end_date).toLocaleDateString() : 'Not set'}
                        </div>
                    </div>
                </div>

                ${survey.status === 'active' ? `
                    <div class="mt-4 pt-4 border-t border-gray-200">
                        <button onclick="event.stopPropagation(); takeSurvey(${survey.id})" 
                                class="w-full bg-primary-500 text-white py-2 px-4 rounded-lg hover:bg-primary-600 transition-colors">
                            <i class="fas fa-play mr-2"></i>
                            Take Survey
                        </button>
                    </div>
                ` : ''}
            </div>
        `;
    }

    showError(message) {
        const container = document.getElementById('surveysContainer');
        container.innerHTML = `
            <div class="text-center py-8">
                <i class="fas fa-exclamation-triangle text-red-400 text-4xl mb-3"></i>
                <h3 class="text-lg font-medium text-gray-900 mb-2">Error</h3>
                <p class="text-gray-500">${message}</p>
            </div>
        `;
    }
}

// Global functions for event handlers
function openSurveyDetails(surveyId) {
    const survey = window.dashboard.surveys.find(s => s.id === surveyId);
    if (!survey) return;

    window.dashboard.currentSurvey = survey;
    
    document.getElementById('modalTitle').textContent = survey.survey_name;
    document.getElementById('modalContent').innerHTML = `
        <div class="space-y-6">
            <div>
                <h4 class="font-semibold text-gray-900 mb-2">Survey Information</h4>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                    <div>
                        <span class="text-gray-500">Client:</span>
                        <div class="font-medium">${survey.client_name}</div>
                    </div>
                    <div>
                        <span class="text-gray-500">Partner:</span>
                        <div class="font-medium">${survey.partner_name}</div>
                    </div>
                    <div>
                        <span class="text-gray-500">Year:</span>
                        <div class="font-medium">${survey.survey_year}</div>
                    </div>
                    <div>
                        <span class="text-gray-500">Status:</span>
                        <div class="font-medium capitalize">${survey.status}</div>
                    </div>
                    <div>
                        <span class="text-gray-500">Start Date:</span>
                        <div class="font-medium">${survey.start_date ? new Date(survey.start_date).toLocaleDateString() : 'Not set'}</div>
                    </div>
                    <div>
                        <span class="text-gray-500">End Date:</span>
                        <div class="font-medium">${survey.end_date ? new Date(survey.end_date).toLocaleDateString() : 'Not set'}</div>
                    </div>
                </div>
            </div>
            
            ${survey.description ? `
                <div>
                    <h4 class="font-semibold text-gray-900 mb-2">Description</h4>
                    <p class="text-gray-600">${survey.description}</p>
                </div>
            ` : ''}
            
            <div>
                <h4 class="font-semibold text-gray-900 mb-2">Survey Progress</h4>
                <div class="bg-gray-200 rounded-full h-2">
                    <div class="bg-primary-500 h-2 rounded-full" style="width: ${survey.status === 'completed' ? '100' : survey.status === 'active' ? '25' : '0'}%"></div>
                </div>
                <p class="text-sm text-gray-500 mt-1">
                    ${survey.status === 'completed' ? 'Survey completed' : survey.status === 'active' ? 'Survey in progress' : 'Survey not started'}
                </p>
            </div>
        </div>
    `;

    // Show/hide take survey button
    const takeSurveyBtn = document.getElementById('takeSurveyBtn');
    takeSurveyBtn.style.display = survey.status === 'active' ? 'block' : 'none';
    
    document.getElementById('surveyModal').classList.remove('hidden');
}

function closeSurveyModal() {
    document.getElementById('surveyModal').classList.add('hidden');
    window.dashboard.currentSurvey = null;
}

function takeSurvey(surveyId = null) {
    const id = surveyId || window.dashboard.currentSurvey?.id;
    if (!id) return;
    
    // Redirect to survey taking interface
    window.location.href = `/survey-preview.html?survey_id=${id}&mode=take`;
}

async function logout() {
    try {
        await fetch('/api/auth/logout', {
            method: 'POST',
            credentials: 'include'
        });
    } catch (error) {
        console.error('Logout error:', error);
    }
    window.location.href = '/login.html';
}

// Initialize dashboard when page loads
document.addEventListener('DOMContentLoaded', () => {
    window.dashboard = new VendorDashboard();
});