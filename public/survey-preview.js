class SurveyPreview {
    constructor() {
        this.categories = {};
        this.categoryNames = [];
        this.currentCategoryIndex = 0;
        this.currentUser = null;
        this.categoryIcons = {
            'GHG': 'fas fa-smog',
            'Energy': 'fas fa-bolt',
            'Transportation': 'fas fa-truck',
            'Water': 'fas fa-tint',
            'Eco Impacts': 'fas fa-leaf',
            'Waste': 'fas fa-recycle',
            'Materials': 'fas fa-cube',
            'Circularity': 'fas fa-sync-alt',
            'Employee H&S': 'fas fa-hard-hat',
            'Employee Experience': 'fas fa-users',
            'DEI': 'fas fa-hands-helping',
            'Community': 'fas fa-home',
            'Customer': 'fas fa-handshake',
            'Supply Chain': 'fas fa-link',
            'G&L': 'fas fa-gavel'
        };
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
                    this.showMessage('Access denied. SuperAdmin privileges required.', 'error');
                    setTimeout(() => window.location.href = '/', 2000);
                    return;
                }
                
                await this.loadSurveyData();
            }
        } catch (error) {
            console.error('Authentication check failed:', error);
            window.location.href = '/login.html';
        }
    }

    async loadSurveyData() {
        try {
            this.showLoading(true);
            
            const response = await fetch('/api/survey-preview');
            const data = await response.json();
            
            if (data.success) {
                this.categories = data.categories;
                this.categoryNames = data.categoryNames;
                
                this.setupCategoryTabs();
                this.renderCurrentCategory();
                this.updateNavigation();
            } else {
                this.showMessage('Failed to load survey data: ' + data.error, 'error');
            }
        } catch (error) {
            console.error('Error loading survey data:', error);
            this.showMessage('Network error while loading survey data', 'error');
        } finally {
            this.showLoading(false);
        }
    }

    setupCategoryTabs() {
        const tabsContainer = document.getElementById('categoryTabs');
        
        const tabsHtml = this.categoryNames.map((categoryName, index) => {
            const isActive = index === this.currentCategoryIndex;
            const questionCount = this.categories[categoryName].length;
            
            return `
                <button onclick="surveyPreview.goToCategory(${index})" 
                        class="flex items-center justify-between w-full px-4 py-3 text-sm font-medium rounded-lg transition-all mb-2 ${
                            isActive 
                                ? 'bg-primary-500 text-white shadow-md' 
                                : 'text-gray-700 hover:text-gray-900 hover:bg-gray-50 border border-gray-200'
                        }">
                    <div class="flex items-center gap-3">
                        <div class="w-8 h-8 rounded-lg flex items-center justify-center ${
                            isActive ? 'bg-white bg-opacity-20' : 'bg-gray-100'
                        }">
                            <i class="${this.categoryIcons[categoryName] || 'fas fa-folder'} text-sm ${
                                isActive ? 'text-white' : 'text-gray-600'
                            }"></i>
                        </div>
                        <span class="font-medium">${this.getCategoryDisplayName(categoryName)}</span>
                    </div>
                    <span class="px-2 py-1 text-xs rounded-full font-medium ${
                        isActive ? 'bg-white text-primary-500' : 'bg-gray-100 text-gray-600'
                    }">${questionCount}</span>
                </button>
            `;
        }).join('');
        
        tabsContainer.innerHTML = tabsHtml;
    }

    getCategoryDisplayName(category) {
        const displayNames = {
            'GHG': 'Greenhouse Gas',
            'Employee H&S': 'Employee Health & Safety',
            'DEI': 'Diversity & Inclusion',
            'G&L': 'Governance & Leadership',
            'Eco Impacts': 'Environmental Impacts'
        };
        return displayNames[category] || category;
    }

    renderCurrentCategory() {
        const currentCategoryName = this.categoryNames[this.currentCategoryIndex];
        const questions = this.categories[currentCategoryName] || [];
        
        // Update category header
        document.getElementById('categoryTitle').textContent = this.getCategoryDisplayName(currentCategoryName);
        document.getElementById('categoryDescription').textContent = 
            `Review ${questions.length} sustainability questions in the ${this.getCategoryDisplayName(currentCategoryName)} category`;
        document.getElementById('questionCounter').textContent = `1/${questions.length}`;
        document.getElementById('currentCategory').textContent = this.getCategoryDisplayName(currentCategoryName);
        document.getElementById('progressText').textContent = 
            `${questions.length} question${questions.length !== 1 ? 's' : ''}`;
        
        // Update category icon
        const iconElement = document.getElementById('categoryIcon');
        iconElement.className = this.categoryIcons[currentCategoryName] || 'fas fa-folder';
        iconElement.classList.add('text-primary-500', 'text-xl');
        
        // Render questions
        this.renderQuestions(questions);
        
        // Update category position
        document.getElementById('categoryPosition').textContent = 
            `${this.currentCategoryIndex + 1}/${this.categoryNames.length}`;
        
        // Update tabs
        this.setupCategoryTabs();
    }

    renderQuestions(questions) {
        const container = document.getElementById('questionsContainer');
        
        const questionsHtml = questions.map((question, index) => {
            return this.createQuestionCard(question, index + 1);
        }).join('');
        
        container.innerHTML = questionsHtml;
    }

    createQuestionCard(question, questionNumber) {
        const inputField = this.createInputField(question);
        
        return `
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-6 hover:shadow-md transition-all">
                <div class="flex items-start gap-4">
                    <div class="flex-shrink-0">
                        <div class="w-8 h-8 bg-primary-500 text-white rounded-full flex items-center justify-center text-sm font-bold">
                            ${questionNumber}
                        </div>
                    </div>
                    
                    <div class="flex-1 min-w-0">
                        <div class="mb-4">
                            <h3 class="text-lg font-medium text-gray-900 mb-2 leading-relaxed">
                                ${this.escapeHtml(question.question_text)}
                            </h3>
                            
                        </div>
                        
                        <div class="bg-gray-50 rounded-lg p-4">
                            ${inputField}
                        </div>
                        
                    </div>
                </div>
            </div>
        `;
    }

    createInputField(question) {
        const baseClasses = "w-full px-3 py-2 border border-gray-300 rounded-md text-sm bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all";
        
        switch (question.answer_type) {
            case 'boolean':
                return `
                    <div class="space-y-2">
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="q${question.id}" value="yes" class="text-primary-500 focus:ring-primary-500">
                            <span class="text-sm text-gray-700">Yes</span>
                        </label>
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="q${question.id}" value="no" class="text-primary-500 focus:ring-primary-500">
                            <span class="text-sm text-gray-700">No</span>
                        </label>
                    </div>
                `;
                
            case 'numeric':
                return `<input type="number" class="${baseClasses}" placeholder="Enter a number..." step="0.01">`;
                
            case 'percentage':
                return `
                    <div class="relative">
                        <input type="number" class="${baseClasses} pr-8" placeholder="Enter percentage..." min="0" max="100" step="0.1">
                        <div class="absolute inset-y-0 right-0 flex items-center pr-3">
                            <span class="text-gray-500 text-sm">%</span>
                        </div>
                    </div>
                `;
                
            case 'multiple_choice_single':
                return `
                    <div class="space-y-2">
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="q${question.id}" value="option1" class="text-primary-500 focus:ring-primary-500">
                            <span class="text-sm text-gray-700">Option 1</span>
                        </label>
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="q${question.id}" value="option2" class="text-primary-500 focus:ring-primary-500">
                            <span class="text-sm text-gray-700">Option 2</span>
                        </label>
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="q${question.id}" value="option3" class="text-primary-500 focus:ring-primary-500">
                            <span class="text-sm text-gray-700">Option 3</span>
                        </label>
                    </div>
                `;

            case 'multiple_choice_multiple':
                return `
                    <div class="space-y-2">
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="checkbox" name="q${question.id}" value="option1" class="text-primary-500 focus:ring-primary-500 rounded">
                            <span class="text-sm text-gray-700">Option 1</span>
                        </label>
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="checkbox" name="q${question.id}" value="option2" class="text-primary-500 focus:ring-primary-500 rounded">
                            <span class="text-sm text-gray-700">Option 2</span>
                        </label>
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="checkbox" name="q${question.id}" value="option3" class="text-primary-500 focus:ring-primary-500 rounded">
                            <span class="text-sm text-gray-700">Option 3</span>
                        </label>
                    </div>
                `;

            case 'multiple_choice_yesno':
                return `
                    <div class="space-y-3">
                        <div class="flex items-center justify-between py-2 border-b border-gray-100">
                            <span class="text-sm text-gray-700">Option 1</span>
                            <div class="flex items-center gap-4">
                                <label class="flex items-center gap-1 cursor-pointer">
                                    <input type="radio" name="q${question.id}_option1" value="yes" class="text-primary-500 focus:ring-primary-500">
                                    <span class="text-xs text-gray-600">Yes</span>
                                </label>
                                <label class="flex items-center gap-1 cursor-pointer">
                                    <input type="radio" name="q${question.id}_option1" value="no" class="text-primary-500 focus:ring-primary-500">
                                    <span class="text-xs text-gray-600">No</span>
                                </label>
                            </div>
                        </div>
                        <div class="flex items-center justify-between py-2 border-b border-gray-100">
                            <span class="text-sm text-gray-700">Option 2</span>
                            <div class="flex items-center gap-4">
                                <label class="flex items-center gap-1 cursor-pointer">
                                    <input type="radio" name="q${question.id}_option2" value="yes" class="text-primary-500 focus:ring-primary-500">
                                    <span class="text-xs text-gray-600">Yes</span>
                                </label>
                                <label class="flex items-center gap-1 cursor-pointer">
                                    <input type="radio" name="q${question.id}_option2" value="no" class="text-primary-500 focus:ring-primary-500">
                                    <span class="text-xs text-gray-600">No</span>
                                </label>
                            </div>
                        </div>
                        <div class="flex items-center justify-between py-2">
                            <span class="text-sm text-gray-700">Option 3</span>
                            <div class="flex items-center gap-4">
                                <label class="flex items-center gap-1 cursor-pointer">
                                    <input type="radio" name="q${question.id}_option3" value="yes" class="text-primary-500 focus:ring-primary-500">
                                    <span class="text-xs text-gray-600">Yes</span>
                                </label>
                                <label class="flex items-center gap-1 cursor-pointer">
                                    <input type="radio" name="q${question.id}_option3" value="no" class="text-primary-500 focus:ring-primary-500">
                                    <span class="text-xs text-gray-600">No</span>
                                </label>
                            </div>
                        </div>
                    </div>
                `;

            case 'free_text':
                return `
                    <div class="space-y-2">
                        <textarea class="${baseClasses} min-h-32 resize-vertical" placeholder="Enter your response (up to 1000 characters)..." rows="4" maxlength="1000"></textarea>
                        <div class="text-xs text-gray-500 text-right">0/1000 characters</div>
                    </div>
                `;

            case 'multiple_choice':
                // Legacy support - treat as single choice
                return `
                    <div class="space-y-2">
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="q${question.id}" value="option1" class="text-primary-500 focus:ring-primary-500">
                            <span class="text-sm text-gray-700">Option 1</span>
                        </label>
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="q${question.id}" value="option2" class="text-primary-500 focus:ring-primary-500">
                            <span class="text-sm text-gray-700">Option 2</span>
                        </label>
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="q${question.id}" value="option3" class="text-primary-500 focus:ring-primary-500">
                            <span class="text-sm text-gray-700">Option 3</span>
                        </label>
                    </div>
                `;
                
            default:
                return `<textarea class="${baseClasses} min-h-20 resize-vertical" placeholder="Enter your response..." rows="3"></textarea>`;
        }
    }

    createEffortImpactIndicators(question) {
        if (!question.effort_rating && !question.impact_rating) {
            return '';
        }

        const createRatingBar = (label, rating, color) => {
            if (!rating) return '';
            
            const percentage = (rating / 5) * 100;
            return `
                <div class="flex items-center gap-2">
                    <span class="text-xs font-medium text-gray-600 w-12">${label}</span>
                    <div class="flex-1 bg-gray-200 rounded-full h-2">
                        <div class="h-2 rounded-full ${color}" style="width: ${percentage}%"></div>
                    </div>
                    <span class="text-xs font-medium text-gray-600 w-8">${rating}</span>
                </div>
            `;
        };

        return `
            <div class="mt-4 pt-4 border-t border-gray-100">
                <div class="space-y-2">
                    ${createRatingBar('Effort', question.effort_rating, 'bg-orange-500')}
                    ${createRatingBar('Impact', question.impact_rating, 'bg-green-500')}
                </div>
            </div>
        `;
    }

    goToCategory(categoryIndex) {
        if (categoryIndex >= 0 && categoryIndex < this.categoryNames.length) {
            this.currentCategoryIndex = categoryIndex;
            this.renderCurrentCategory();
            this.updateNavigation();
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    }

    nextCategory() {
        if (this.currentCategoryIndex < this.categoryNames.length - 1) {
            this.goToCategory(this.currentCategoryIndex + 1);
        }
    }

    previousCategory() {
        if (this.currentCategoryIndex > 0) {
            this.goToCategory(this.currentCategoryIndex - 1);
        }
    }

    updateNavigation() {
        const prevButton = document.getElementById('prevButton');
        const nextButton = document.getElementById('nextButton');
        
        prevButton.disabled = this.currentCategoryIndex === 0;
        nextButton.disabled = this.currentCategoryIndex === this.categoryNames.length - 1;
        
        // Update button text for last category
        if (this.currentCategoryIndex === this.categoryNames.length - 1) {
            nextButton.innerHTML = '<span>Complete</span><i class="fas fa-check"></i>';
        } else {
            nextButton.innerHTML = '<span>Next</span><i class="fas fa-chevron-right"></i>';
        }
    }

    showLoading(show) {
        const loading = document.getElementById('loading');
        if (show) {
            loading.classList.remove('hidden');
        } else {
            loading.classList.add('hidden');
        }
    }

    showMessage(message, type = 'info') {
        const container = document.getElementById('messageContainer');
        const messageDiv = document.createElement('div');
        
        const bgColor = type === 'success' ? 'bg-green-500' : type === 'error' ? 'bg-red-500' : 'bg-blue-500';
        const icon = type === 'success' ? 'fa-check-circle' : type === 'error' ? 'fa-exclamation-circle' : 'fa-info-circle';
        
        messageDiv.className = `${bgColor} text-white px-6 py-3 rounded-lg shadow-lg flex items-center gap-2 transform transition-all duration-300 translate-x-full`;
        messageDiv.innerHTML = `
            <i class="fas ${icon}"></i>
            <span>${message}</span>
        `;

        container.appendChild(messageDiv);

        // Animate in
        setTimeout(() => {
            messageDiv.classList.remove('translate-x-full');
        }, 10);

        // Remove after delay
        setTimeout(() => {
            messageDiv.classList.add('translate-x-full');
            setTimeout(() => {
                if (messageDiv.parentNode) {
                    messageDiv.remove();
                }
            }, 300);
        }, type === 'success' ? 2000 : 4000);
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
            window.location.href = '/login.html';
        }
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Initialize the survey preview when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.surveyPreview = new SurveyPreview();
});