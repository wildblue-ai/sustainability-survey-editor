class SustainabilityEditor {
    constructor() {
        this.questions = [];
        this.categories = {};
        this.editingId = null;
        this.stats = null;
        this.activeCategory = null;
        this.draggedElement = null;
        this.draggedQuestionId = null;
        this.currentUser = null;
        
        this.initializeElements();
        this.attachEventListeners();
        this.checkAuthentication();
    }
    
    initializeElements() {
        // Main elements
        this.searchInput = document.getElementById('searchInput');
        this.addNewBtn = document.getElementById('addNewBtn');
        this.addQuestionBtn = document.getElementById('addQuestionBtn');
        this.expandAllBtn = document.getElementById('expandAllBtn');
        this.collapseAllBtn = document.getElementById('collapseAllBtn');
        this.categoriesContainer = document.getElementById('categoriesContainer');
        this.categoryNav = document.getElementById('categoryNav');
        this.emptyState = document.getElementById('emptyState');
        
        // Stats elements
        this.totalQuestionsEl = document.getElementById('totalQuestions');
        this.totalCategoriesEl = document.getElementById('totalCategories');
        
        // Modal elements
        this.modal = document.getElementById('questionModal');
        this.modalTitle = document.getElementById('modalTitle');
        this.questionForm = document.getElementById('questionForm');
        this.closeBtn = document.querySelector('.modal-close');
        this.cancelBtn = document.getElementById('cancelBtn');
        this.deleteBtn = document.getElementById('deleteBtn');
        this.questionIdBadge = document.getElementById('questionIdBadge');
        this.displayQuestionId = document.getElementById('displayQuestionId');
        
        // Loading
        this.loading = document.getElementById('loading');
    }
    
    attachEventListeners() {
        // Search
        this.searchInput.addEventListener('input', () => this.debounce(this.handleSearch.bind(this), 300)());
        
        // Buttons
        this.addNewBtn.addEventListener('click', () => this.showModal());
        if (this.addQuestionBtn) {
            this.addQuestionBtn.addEventListener('click', () => this.showModal());
        }
        this.expandAllBtn.addEventListener('click', () => this.expandAllCategories());
        this.collapseAllBtn.addEventListener('click', () => this.collapseAllCategories());
        
        // Modal
        this.closeBtn.addEventListener('click', () => this.hideModal());
        this.cancelBtn.addEventListener('click', () => this.hideModal());
        this.deleteBtn.addEventListener('click', () => this.handleDeleteFromModal());
        this.questionForm.addEventListener('submit', (e) => this.handleSubmit(e));
        
        // Close modal on outside click
        this.modal.addEventListener('click', (e) => {
            if (e.target === this.modal) {
                this.hideModal();
            }
        });
        
        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && !this.modal.classList.contains('hidden')) {
                this.hideModal();
            }
        });
    }
    
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }
    
    showLoading() {
        this.loading.classList.remove('hidden');
    }
    
    hideLoading() {
        this.loading.classList.add('hidden');
    }
    
    async loadData() {
        this.showLoading();
        try {
            // Load questions and stats in parallel
            const [questionsResponse, statsResponse] = await Promise.all([
                fetch('/api/questions?limit=1000'),
                fetch('/api/stats')
            ]);
            
            const questionsData = await questionsResponse.json();
            const statsData = await statsResponse.json();
            
            if (questionsData.success && statsData.success) {
                this.questions = questionsData.questions;
                this.stats = statsData.stats;
                this.organizeQuestions();
                this.renderStats();
                this.renderCategoryNavigation();
                this.renderCategories();
            } else {
                console.error('Error loading data');
                this.showNotification('Error loading data', 'error');
            }
        } catch (error) {
            console.error('Network error:', error);
            this.showNotification('Network error occurred', 'error');
            this.loadSampleData();
        }
        this.hideLoading();
    }
    
    loadSampleData() {
        // Sample data for demonstration
        this.questions = [
            {
                id: 1,
                category: 'GHG',
                question_order: 1,
                question_text: 'We measure and track all applicable Scope 1 GHG emissions, in accordance with the GHG Protocol.',
                question_type: 'Systems',
                answer_type: 'boolean',
                effort_rating: 2.0,
                impact_rating: 1.0,
                max_points: 2
            },
            {
                id: 2,
                category: 'Energy',
                question_order: 1,
                question_text: 'We measure and track energy use by facility.',
                question_type: 'Systems',
                answer_type: 'boolean',
                effort_rating: 2.0,
                impact_rating: 1.0,
                max_points: 2
            }
        ];
        
        this.stats = {
            total: 2,
            byCategory: [
                { category: 'GHG', count: 1 },
                { category: 'Energy', count: 1 }
            ],
            byType: [
                { question_type: 'Systems', count: 2 }
            ]
        };
        
        this.organizeQuestions();
        this.renderStats();
        this.renderCategoryNavigation();
        this.renderCategories();
    }
    
    organizeQuestions() {
        this.categories = {};
        this.questions.forEach(question => {
            if (!this.categories[question.category]) {
                this.categories[question.category] = [];
            }
            this.categories[question.category].push(question);
        });
        
        // Sort questions within each category by order
        Object.keys(this.categories).forEach(category => {
            this.categories[category].sort((a, b) => a.question_order - b.question_order);
        });
    }
    
    renderStats() {
        if (!this.stats) return;
        
        this.totalQuestionsEl.textContent = this.stats.total;
        this.totalCategoriesEl.textContent = this.stats.byCategory.length;
    }
    
    renderCategoryNavigation() {
        const categoryNames = this.getSortedCategoryNames();
        
        const navHtml = categoryNames.map(categoryName => {
            const questions = this.categories[categoryName];
            const isActive = this.activeCategory === categoryName;
            
            return `
                <div class="flex items-center justify-between px-4 py-2 rounded-md cursor-pointer transition-all text-sm ${isActive ? 'bg-primary-50 text-primary-500 font-medium' : 'hover:bg-gray-50'}" 
                     onclick="editor.selectCategory('${categoryName}')">
                    <span>${this.getCategoryDisplayName(categoryName)}</span>
                    <span class="text-xs font-medium px-2 py-1 rounded-full ${isActive ? 'bg-primary-500 text-white' : 'bg-gray-200 text-gray-600'}">${questions.length}</span>
                </div>
            `;
        }).join('');
        
        this.categoryNav.innerHTML = navHtml;
    }
    
    selectCategory(categoryName) {
        this.activeCategory = categoryName;
        this.renderCategoryNavigation();
        
        // Scroll to category in main content
        const categoryElement = document.getElementById(`category-${categoryName.replace(/[^a-zA-Z0-9]/g, '-')}`);
        if (categoryElement) {
            categoryElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }
    
    renderCategories() {
        const categoryNames = this.getSortedCategoryNames();
        
        if (categoryNames.length === 0) {
            this.emptyState.classList.remove('hidden');
            this.categoriesContainer.classList.add('hidden');
            return;
        }
        
        this.emptyState.classList.add('hidden');
        this.categoriesContainer.classList.remove('hidden');
        
        const categoriesHtml = categoryNames.map(categoryName => {
            const questions = this.categories[categoryName];
            const categoryId = categoryName.replace(/[^a-zA-Z0-9]/g, '-');
            
            return `
                <div class="bg-white rounded-xl shadow-sm overflow-hidden transition-all hover:shadow-md" id="category-${categoryId}">
                    <div class="flex items-center justify-between p-4 cursor-pointer border-b border-transparent hover:bg-gray-50 transition-all category-header" onclick="editor.toggleCategory('${categoryId}')">
                        <div class="flex items-center gap-3">
                            <div class="w-8 h-8 bg-primary-50 rounded-lg flex items-center justify-center text-sm">
                                ${this.getCategoryIcon(categoryName)}
                            </div>
                            <div>
                                <div class="text-base font-semibold text-gray-900">${this.getCategoryDisplayName(categoryName)}</div>
                            </div>
                        </div>
                        <div class="flex items-center gap-4">
                            <span class="bg-gray-100 text-gray-600 px-2 py-1 rounded-md text-xs font-medium question-count-badge">${questions.length}</span>
                            <i class="fas fa-chevron-down text-gray-400 text-sm transition-transform expand-toggle"></i>
                        </div>
                    </div>
                    <div class="max-h-0 overflow-hidden transition-all duration-300 category-content" id="content-${categoryId}">
                        <div class="p-0">
                            <!-- Drop zone for first position -->
                            <div class="drop-zone-first h-1 w-full border-t-2 border-dashed border-gray-300 mb-2" 
                                 data-category="${categoryName}"
                                 data-insert-position="0"
                                 ondragover="editor.handleDropZoneOver(event)" 
                                 ondrop="editor.handleDropZoneFirst(event)">
                            </div>
                            ${this.renderQuestions(questions)}
                        </div>
                    </div>
                </div>
            `;
        }).join('');
        
        this.categoriesContainer.innerHTML = categoriesHtml;
    }
    
    getSortedCategoryNames() {
        const categoryOrder = [
            'GHG',
            'Energy',
            'Transportation',
            'Water',
            'Eco Impacts',
            'Waste',
            'Materials',
            'Circularity',
            'Employee H&S',
            'Employee Experience',
            'DEI',
            'Community',
            'Customer',
            'Supply Chain',
            'G&L'
        ];
        
        const availableCategories = Object.keys(this.categories);
        console.log('Available categories:', availableCategories);
        
        // Sort categories according to the specified order
        const orderedCategories = categoryOrder.filter(category => 
            availableCategories.includes(category)
        );
        console.log('Ordered categories:', orderedCategories);
        
        // Add any categories not in the order list at the end
        const unorderedCategories = availableCategories.filter(category =>
            !categoryOrder.includes(category)
        ).sort();
        console.log('Unordered categories:', unorderedCategories);
        
        const result = [...orderedCategories, ...unorderedCategories];
        console.log('Final category order:', result);
        
        // Force browser to see this is a new version
        if (result.length > 0) {
            document.title = 'Green-metrics.com - ' + result.length + ' categories';
        }
        
        return result;
    }

    getCategoryDisplayName(categoryName) {
        const displayNames = {
            'GHG': 'Greenhouse Gas Emissions',
            'Employee H&S': 'Employee Health & Safety',
            'DEI': 'Diversity, Equity & Inclusion',
            'G&L': 'Governance & Leadership'
        };
        
        return displayNames[categoryName] || categoryName;
    }
    
    getCategoryIcon(categoryName) {
        const icons = {
            'GHG': '🌿',
            'Energy': '⚡',
            'Transportation': '🚗',
            'Water': '💧',
            'Eco Impacts': '🌍',
            'Waste': '♻️',
            'Materials': '🏗️',
            'Circularity': '🔄',
            'Employee H&S': '🛡️',
            'Employee Experience': '👥',
            'DEI': '🤝',
            'Community': '🏘️',
            'Customer': '👤',
            'Supply Chain': '🔗',
            'G&L': '⚖️'
        };
        
        return icons[categoryName] || '📊';
    }
    
    renderQuestions(questions) {
        return questions.map(question => {
            const typeClass = question.question_type.toLowerCase().replace(/ /g, '-');
            const typeColors = {
                'systems': 'bg-blue-50 text-blue-700',
                'best-practice': 'bg-green-50 text-green-700', 
                'performance': 'bg-orange-50 text-orange-700'
            };
            
            return `
                <div class="flex items-start gap-4 p-6 border-b border-gray-100 last:border-b-0 transition-all hover:bg-gray-50 question-item bg-white" 
                     draggable="true" 
                     data-question-id="${question.id}" 
                     data-question-order="${question.question_order}"
                     ondragstart="editor.handleDragStart(event)" 
                     ondragover="editor.handleDragOver(event)" 
                     ondrop="editor.handleDrop(event)" 
                     ondragend="editor.handleDragEnd(event)">
                    <div class="drag-handle cursor-grab active:cursor-grabbing text-gray-400 hover:text-gray-600 p-1 flex items-center justify-center transition-colors" title="Drag to reorder">
                        <i class="fas fa-grip-vertical text-sm"></i>
                    </div>
                    <div class="w-8 h-8 bg-primary-500 text-white rounded-full flex items-center justify-center text-sm font-semibold flex-shrink-0 mt-0.5">${question.question_order}</div>
                    <div class="flex-1 min-w-0 cursor-pointer" onclick="editor.editQuestion(${question.id})">
                        <div class="text-base leading-6 text-gray-900">${question.question_text}</div>
                    </div>
                    <div class="flex-shrink-0" onclick="event.stopPropagation()">
                        <select class="px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500" 
                                onchange="editor.updateAnswerType(${question.id}, this.value)"
                                value="${question.answer_type}">
                            <option value="boolean" ${question.answer_type === 'boolean' ? 'selected' : ''}>Yes/No</option>
                            <option value="numeric" ${question.answer_type === 'numeric' ? 'selected' : ''}>Numeric</option>
                            <option value="multiple_choice_single" ${question.answer_type === 'multiple_choice_single' || question.answer_type === 'multiple_choice' ? 'selected' : ''}>Multiple Choice (Select One)</option>
                            <option value="multiple_choice_multiple" ${question.answer_type === 'multiple_choice_multiple' ? 'selected' : ''}>Multiple Choice (Select Multiple)</option>
                            <option value="multiple_choice_yesno" ${question.answer_type === 'multiple_choice_yesno' ? 'selected' : ''}>Multiple Choice (Yes/No Each)</option>
                            <option value="percentage" ${question.answer_type === 'percentage' ? 'selected' : ''}>Percentage</option>
                            <option value="free_text" ${question.answer_type === 'free_text' ? 'selected' : ''}>Free Text Entry</option>
                        </select>
                    </div>
                </div>
            `;
        }).join('');
    }
    
    toggleCategory(categoryId) {
        const header = document.querySelector(`#category-${categoryId} .category-header`);
        const content = document.getElementById(`content-${categoryId}`);
        const toggle = header?.querySelector('.expand-toggle');
        const badge = header?.querySelector('.question-count-badge');
        
        if (!header || !content) return;
        
        const isExpanded = content.style.maxHeight && content.style.maxHeight !== '0px';
        
        if (isExpanded) {
            // Collapse this category
            content.style.maxHeight = '0px';
            toggle?.classList.remove('rotate-180');
            header.classList.remove('border-b-gray-200');
            header.classList.add('border-b-transparent');
            badge?.classList.remove('bg-primary-500', 'text-white');
            badge?.classList.add('bg-gray-100', 'text-gray-600');
        } else {
            // First, collapse all other categories
            this.collapseAllCategories();
            
            // Then expand this category
            content.style.maxHeight = content.scrollHeight + 'px';
            toggle?.classList.add('rotate-180');
            header.classList.add('border-b-gray-200');
            header.classList.remove('border-b-transparent');
            badge?.classList.add('bg-primary-500', 'text-white');
            badge?.classList.remove('bg-gray-100', 'text-gray-600');
            
            // Scroll the expanded category to the top of the view
            // Wait for both collapse and expand animations to complete
            setTimeout(() => {
                const categoryElement = document.getElementById(`category-${categoryId}`);
                if (categoryElement) {
                    categoryElement.scrollIntoView({ 
                        behavior: 'smooth', 
                        block: 'start',
                        inline: 'nearest'
                    });
                }
            }, 350); // Wait for collapse (300ms) + expand animations to finish
        }
    }
    
    expandAllCategories() {
        document.querySelectorAll('.category-content').forEach(content => {
            content.style.maxHeight = content.scrollHeight + 'px';
        });
        document.querySelectorAll('.expand-toggle').forEach(toggle => {
            toggle.classList.add('rotate-180');
        });
        document.querySelectorAll('.category-header').forEach(header => {
            header.classList.add('border-b-gray-200');
            header.classList.remove('border-b-transparent');
        });
        document.querySelectorAll('.question-count-badge').forEach(badge => {
            badge.classList.add('bg-primary-500', 'text-white');
            badge.classList.remove('bg-gray-100', 'text-gray-600');
        });
    }
    
    collapseAllCategories() {
        document.querySelectorAll('.category-content').forEach(content => {
            content.style.maxHeight = '0px';
        });
        document.querySelectorAll('.expand-toggle').forEach(toggle => {
            toggle.classList.remove('rotate-180');
        });
        document.querySelectorAll('.category-header').forEach(header => {
            header.classList.remove('border-b-gray-200');
            header.classList.add('border-b-transparent');
        });
        document.querySelectorAll('.question-count-badge').forEach(badge => {
            badge.classList.remove('bg-primary-500', 'text-white');
            badge.classList.add('bg-gray-100', 'text-gray-600');
        });
    }
    
    handleSearch() {
        const searchTerm = this.searchInput.value.toLowerCase().trim();
        
        if (searchTerm === '') {
            // Show all categories and questions
            this.renderCategories();
            return;
        }
        
        // Filter questions that match the search term
        const filteredCategories = {};
        
        Object.keys(this.categories).forEach(categoryName => {
            const matchingQuestions = this.categories[categoryName].filter(question =>
                question.question_text.toLowerCase().includes(searchTerm) ||
                question.question_type.toLowerCase().includes(searchTerm) ||
                question.answer_type.toLowerCase().includes(searchTerm)
            );
            
            if (matchingQuestions.length > 0) {
                filteredCategories[categoryName] = matchingQuestions;
            }
        });
        
        // Temporarily store original categories and render filtered ones
        const originalCategories = this.categories;
        this.categories = filteredCategories;
        this.renderCategories();
        
        // Auto-expand categories with search results
        setTimeout(() => {
            this.expandAllCategories();
        }, 100);
        
        // Restore original categories
        this.categories = originalCategories;
    }
    
    showModal(question = null) {
        this.editingId = question ? question.id : null;
        this.modalTitle.textContent = question ? 'Edit Question' : 'Add New Question';
        
        if (question) {
            // Show and populate question ID badge
            this.questionIdBadge.classList.remove('hidden');
            this.displayQuestionId.textContent = question.id;
            // Show delete button for existing questions
            this.deleteBtn.classList.remove('hidden');
            
            // Populate form with question data
            document.getElementById('category').value = question.category;
            document.getElementById('questionOrder').value = question.question_order;
            document.getElementById('questionText').value = question.question_text;
            document.getElementById('questionType').value = question.question_type;
            document.getElementById('answerType').value = question.answer_type;
            document.getElementById('effortRating').value = question.effort_rating || '';
            document.getElementById('impactRating').value = question.impact_rating || '';
            document.getElementById('maxPoints').value = question.max_points;
        } else {
            // Hide question ID badge for new questions
            this.questionIdBadge.classList.add('hidden');
            // Hide delete button for new questions
            this.deleteBtn.classList.add('hidden');
            // Reset form for new question
            this.questionForm.reset();
        }
        
        this.modal.classList.remove('hidden');
        
        // Focus first input
        setTimeout(() => {
            const firstInput = this.modal.querySelector('select, input, textarea');
            if (firstInput) firstInput.focus();
        }, 100);
    }
    
    hideModal() {
        this.modal.classList.add('hidden');
        this.editingId = null;
        this.questionForm.reset();
        // Hide the question ID badge
        this.questionIdBadge.classList.add('hidden');
        this.displayQuestionId.textContent = '';
    }
    
    async handleSubmit(e) {
        e.preventDefault();
        
        const formData = new FormData(this.questionForm);
        const questionData = {
            category: formData.get('category'),
            question_order: parseInt(formData.get('questionOrder')),
            question_text: formData.get('questionText'),
            question_type: formData.get('questionType'),
            answer_type: formData.get('answerType'),
            effort_rating: formData.get('effortRating') ? parseFloat(formData.get('effortRating')) : null,
            impact_rating: formData.get('impactRating') ? parseFloat(formData.get('impactRating')) : null,
            max_points: parseInt(formData.get('maxPoints'))
        };
        
        this.showLoading();
        
        try {
            const url = this.editingId ? `/api/questions/${this.editingId}` : '/api/questions';
            const method = this.editingId ? 'PUT' : 'POST';
            
            const response = await fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(questionData)
            });
            
            const result = await response.json();
            
            if (result.success) {
                this.showNotification(
                    this.editingId ? 'Question updated successfully' : 'Question created successfully',
                    'success'
                );
                this.hideModal();
                await this.loadData();
            } else {
                this.showNotification(result.error || 'An error occurred', 'error');
            }
        } catch (error) {
            console.error('Error saving question:', error);
            this.showNotification('Network error occurred', 'error');
            
            // For demo purposes, simulate success
            if (this.editingId) {
                const questionIndex = this.questions.findIndex(q => q.id === this.editingId);
                if (questionIndex !== -1) {
                    this.questions[questionIndex] = { ...questionData, id: this.editingId };
                }
            } else {
                const newId = Math.max(...this.questions.map(q => q.id), 0) + 1;
                this.questions.push({ ...questionData, id: newId });
            }
            this.hideModal();
            this.organizeQuestions();
            this.renderStats();
            this.renderCategoryNavigation();
            this.renderCategories();
            this.showNotification(
                this.editingId ? 'Question updated (demo mode)' : 'Question created (demo mode)',
                'success'
            );
        }
        
        this.hideLoading();
    }
    
    async editQuestion(id) {
        const question = this.questions.find(q => q.id === id);
        if (question) {
            this.showModal(question);
        }
    }

    async updateAnswerType(questionId, newAnswerType) {
        const question = this.questions.find(q => q.id === questionId);
        if (!question) return;

        const oldAnswerType = question.answer_type;
        question.answer_type = newAnswerType; // Optimistically update

        try {
            const response = await fetch(`/api/questions/${questionId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    category: question.category,
                    question_order: question.question_order,
                    question_text: question.question_text,
                    question_type: question.question_type,
                    answer_type: newAnswerType,
                    effort_rating: question.effort_rating,
                    impact_rating: question.impact_rating,
                    max_points: question.max_points
                })
            });

            const result = await response.json();
            
            if (result.success) {
                this.showNotification('Answer type updated successfully', 'success');
            } else {
                // Revert on failure
                question.answer_type = oldAnswerType;
                this.renderCategories();
                this.showNotification(result.error || 'Failed to update answer type', 'error');
            }
        } catch (error) {
            // Revert on error
            question.answer_type = oldAnswerType;
            this.renderCategories();
            this.showNotification('Answer type updated (demo mode)', 'success');
        }
    }
    
    handleDeleteFromModal() {
        if (this.editingId) {
            this.deleteQuestion(this.editingId);
        }
    }

    async deleteQuestion(id) {
        if (!confirm('Are you sure you want to delete this question?')) {
            return;
        }
        
        this.showLoading();
        
        try {
            const response = await fetch(`/api/questions/${id}`, {
                method: 'DELETE'
            });
            
            const result = await response.json();
            
            if (result.success) {
                this.hideModal();
                this.showNotification('Question deleted successfully', 'success');
                await this.loadData();
            } else {
                this.showNotification(result.error || 'An error occurred', 'error');
            }
        } catch (error) {
            console.error('Error deleting question:', error);
            this.showNotification('Network error occurred', 'error');
            
            // For demo purposes, simulate success
            this.hideModal();
            this.questions = this.questions.filter(q => q.id !== id);
            this.organizeQuestions();
            this.renderStats();
            this.renderCategoryNavigation();
            this.renderCategories();
            this.showNotification('Question deleted (demo mode)', 'success');
        }
        
        this.hideLoading();
    }
    
    showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        
        // Add icon based on type
        const icons = {
            success: 'fas fa-check-circle',
            error: 'fas fa-exclamation-circle',
            info: 'fas fa-info-circle',
            warning: 'fas fa-exclamation-triangle'
        };
        
        notification.innerHTML = `
            <i class="${icons[type] || icons.info}"></i>
            <span>${message}</span>
        `;
        
        // Add styles
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            color: white;
            z-index: 1002;
            font-weight: 500;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            transform: translateX(100%);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        `;
        
        // Set background color based on type
        const colors = {
            success: '#28a745',
            error: '#dc3545',
            info: '#17a2b8',
            warning: '#ffc107'
        };
        notification.style.backgroundColor = colors[type] || colors.info;
        
        document.body.appendChild(notification);
        
        // Animate in
        setTimeout(() => {
            notification.style.transform = 'translateX(0)';
        }, 100);
        
        // Remove after 4 seconds
        setTimeout(() => {
            notification.style.transform = 'translateX(100%)';
            setTimeout(() => {
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
                }
            }, 300);
        }, 4000);
    }
    
    // Drag and Drop Methods
    handleDragStart(e) {
        this.draggedElement = e.currentTarget;
        this.draggedQuestionId = parseInt(e.currentTarget.dataset.questionId);
        
        console.log('DRAG START - Question ID:', this.draggedQuestionId);
        
        // Add dragging visual feedback
        e.currentTarget.classList.add('opacity-50', 'scale-95');
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/html', e.currentTarget.outerHTML);
    }
    
    handleDragOver(e) {
        e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
        
        const draggedOver = e.currentTarget;
        const draggedOverId = parseInt(draggedOver.dataset.questionId);
        
        // Don't allow dropping on itself
        if (draggedOverId === this.draggedQuestionId) {
            return;
        }
        
        // Add visual feedback for drop target
        draggedOver.classList.add('border-t-4', 'border-primary-500');
        
        // Remove border from siblings
        const siblings = draggedOver.parentNode.querySelectorAll('.question-item');
        siblings.forEach(sibling => {
            if (sibling !== draggedOver) {
                sibling.classList.remove('border-t-4', 'border-primary-500');
            }
        });
    }
    
    handleDrop(e) {
        e.preventDefault();
        
        const droppedOn = e.currentTarget;
        const droppedOnId = parseInt(droppedOn.dataset.questionId);
        const droppedOnOrder = parseInt(droppedOn.dataset.questionOrder);
        
        console.log('=== DROP DETECTION DEBUG ===');
        console.log('Dragged question ID:', this.draggedQuestionId);
        console.log('Dropped on question ID:', droppedOnId, 'Order:', droppedOnOrder);
        
        // Don't process if dropping on itself
        if (droppedOnId === this.draggedQuestionId) {
            console.log('Dropped on self - ignoring');
            return;
        }
        
        // Find the dragged question
        const draggedQuestion = this.questions.find(q => q.id === this.draggedQuestionId);
        const droppedOnQuestion = this.questions.find(q => q.id === droppedOnId);
        
        console.log('Found dragged question:', draggedQuestion?.id, draggedQuestion?.question_order);
        console.log('Found target question:', droppedOnQuestion?.id, droppedOnQuestion?.question_order);
        
        if (!draggedQuestion || !droppedOnQuestion) {
            console.log('ERROR: Could not find questions!');
            return;
        }
        
        // Only allow reordering within the same category
        if (draggedQuestion.category !== droppedOnQuestion.category) {
            this.showNotification('Questions can only be reordered within the same category', 'warning');
            return;
        }
        
        // Update question orders
        this.reorderQuestions(draggedQuestion, droppedOnQuestion);
    }
    
    handleDragEnd(e) {
        console.log('DRAG END - Question ID:', this.draggedQuestionId);
        
        // Remove visual feedback
        e.currentTarget.classList.remove('opacity-50', 'scale-95');
        
        // Remove drop target visual feedback from all items
        const allQuestions = document.querySelectorAll('.question-item');
        allQuestions.forEach(item => {
            item.classList.remove('border-t-4', 'border-primary-500');
        });
        
        // Clean up drop zone visual feedback
        const allDropZones = document.querySelectorAll('.drop-zone-first');
        allDropZones.forEach(zone => {
            zone.style.backgroundColor = '';
            zone.style.borderTop = '';
        });
        
        // Reset drag state
        this.draggedElement = null;
        this.draggedQuestionId = null;
    }
    
    async reorderQuestions(draggedQuestion, targetQuestion) {
        const category = draggedQuestion.category;
        const categoryQuestions = this.categories[category].sort((a, b) => a.question_order - b.question_order);
        
        console.log('=== DRAG AND DROP DEBUG ===');
        console.log('Dragged question:', draggedQuestion.id, 'order:', draggedQuestion.question_order);
        console.log('Target question:', targetQuestion.id, 'order:', targetQuestion.question_order);
        console.log('Before reorder:', categoryQuestions.map(q => `ID:${q.id} Order:${q.question_order}`));
        
        // Store expanded state of categories before reordering
        const expandedCategories = this.getExpandedCategories();
        
        // Remove dragged question from its current position
        const draggedIndex = categoryQuestions.findIndex(q => q.id === draggedQuestion.id);
        let targetIndex = categoryQuestions.findIndex(q => q.id === targetQuestion.id);
        
        // Special case: first position (fake target with ID -1)
        if (targetQuestion.id === -1 && targetQuestion.question_order === 0) {
            targetIndex = -1; // This indicates "insert at beginning"
            console.log('Detected first position drop');
        }
        
        console.log('Array indices - Dragged:', draggedIndex, 'Target:', targetIndex);
        
        if (draggedIndex === -1) {
            console.log('ERROR: Could not find dragged question');
            return;
        }
        
        // Simple approach: when you drop on a question, you want to be positioned right after it
        // So if we drop on question at position N, we want to be at position N+1
        
        // Remove the dragged question first
        categoryQuestions.splice(draggedIndex, 1);
        
        // Determine insertion position based on drag direction and user intent
        let insertPosition;
        
        // Special case: dropping at first position (targetIndex = -1)
        if (targetIndex === -1) {
            insertPosition = 0; // Insert at the very beginning
        } else if (draggedIndex < targetIndex) {
            // Dragging DOWN (e.g., drag Q1 to Q2): want to appear AFTER the target
            insertPosition = targetIndex; // After removal, this is right after target
        } else {
            // Dragging UP (e.g., drag Q3 to Q1): want to take the target's position
            insertPosition = targetIndex; // Take the target's current position
        }
        console.log('targetIndex:', targetIndex, 'insertPosition:', insertPosition);
        
        categoryQuestions.splice(insertPosition, 0, draggedQuestion);
        
        console.log('After reorder:', categoryQuestions.map(q => `ID:${q.id} Order:${q.question_order}`));
        console.log('=== END DEBUG ===');
        
        // Update question orders
        const updatePromises = categoryQuestions.map((question, index) => {
            const newOrder = index + 1;
            question.question_order = newOrder;
            
            // Update in main questions array too
            const mainQuestionIndex = this.questions.findIndex(q => q.id === question.id);
            if (mainQuestionIndex !== -1) {
                this.questions[mainQuestionIndex].question_order = newOrder;
            }
            
            // Update in database
            return this.updateQuestionOrder(question.id, newOrder);
        });
        
        try {
            this.showLoading();
            await Promise.all(updatePromises);
            
            // Refresh the display
            this.organizeQuestions();
            this.renderCategories();
            
            // Restore expanded state after rendering
            this.restoreExpandedCategories(expandedCategories);
            
            this.showNotification('Questions reordered successfully', 'success');
        } catch (error) {
            console.error('Error reordering questions:', error);
            this.showNotification('Error reordering questions', 'error');
            // Reload data to restore original state
            await this.loadData();
        } finally {
            this.hideLoading();
        }
    }
    
    async updateQuestionOrder(questionId, newOrder) {
        const response = await fetch(`/api/questions/${questionId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                question_order: newOrder
            })
        });
        
        if (!response.ok) {
            throw new Error(`Failed to update question ${questionId}`);
        }
        
        return response.json();
    }
    
    // Drop zone handlers for first position
    handleDropZoneOver(e) {
        e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
        
        // Add visual feedback
        e.currentTarget.style.backgroundColor = 'rgba(26, 179, 148, 0.1)';
        e.currentTarget.style.borderTop = '4px solid #1ab394';
    }
    
    handleDropZoneFirst(e) {
        try {
            e.preventDefault();
            
            console.log('=== DROP ZONE FIRST DEBUG ===');
            console.log('Dragged question ID:', this.draggedQuestionId);
            console.log('Dropping at position 0 (first)');
            
            const category = e.currentTarget.dataset.category;
            const draggedQuestion = this.questions.find(q => q.id === this.draggedQuestionId);
            
            if (!draggedQuestion || draggedQuestion.category !== category) {
                console.log('Invalid drag operation', {draggedQuestion, category});
                return;
            }
            
            // Create a fake "target" question for position 0
            const fakeTarget = {
                id: -1,
                category: category,
                question_order: 0  // This will make it insert at position 0
            };
            
            console.log('Reordering to first position');
            this.reorderQuestions(draggedQuestion, fakeTarget);
        } catch (error) {
            console.error('Error in handleDropZoneFirst:', error);
        }
    }
    
    // Helper methods for preserving expanded state during reorder
    getExpandedCategories() {
        const expandedCategories = new Set();
        const categoryContents = document.querySelectorAll('.category-content');
        
        categoryContents.forEach(content => {
            // Check if category is expanded by looking at maxHeight
            if (content.style.maxHeight && content.style.maxHeight !== '0px') {
                const categoryId = content.id.replace('content-', '');
                expandedCategories.add(categoryId);
            }
        });
        
        return expandedCategories;
    }
    
    restoreExpandedCategories(expandedCategories) {
        expandedCategories.forEach(categoryId => {
            const header = document.querySelector(`#category-${categoryId} .category-header`);
            const content = document.getElementById(`content-${categoryId}`);
            const toggle = header?.querySelector('.expand-toggle');
            const badge = header?.querySelector('.question-count-badge');
            
            if (header && content) {
                // Expand the category
                content.style.maxHeight = content.scrollHeight + 'px';
                toggle?.classList.add('rotate-180');
                header.classList.add('border-b-gray-200');
                header.classList.remove('border-b-transparent');
                badge?.classList.add('bg-primary-500', 'text-white');
                badge?.classList.remove('bg-gray-100', 'text-gray-600');
            }
        });
    }

    // Authentication methods
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
                this.updateUIForUser();
                this.loadData(); // Now load data after authentication
                
                // Hide loading overlay once authenticated
                const loadingOverlay = document.getElementById('auth-loading');
                if (loadingOverlay) {
                    loadingOverlay.style.display = 'none';
                }
            }
        } catch (error) {
            console.error('Authentication check failed:', error);
            window.location.href = '/login.html';
        }
    }

    updateUIForUser() {
        if (!this.currentUser) return;

        // Redesign header to have user info on top row
        const header = document.querySelector('header');
        if (header) {
            // Create the new two-row header structure
            header.className = 'bg-white border-b border-gray-200';
            header.innerHTML = `
                <!-- Top row with user info -->
                <div class="border-b border-gray-100 bg-gray-50">
                    <div class="flex items-center justify-between px-8 py-2">
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i class="fas fa-user text-xs"></i>
                            <span>Welcome, ${this.escapeHtml(this.currentUser.name)}</span>
                            <span class="px-2 py-0.5 bg-primary-100 text-primary-700 text-xs rounded-full font-medium">${this.currentUser.role}</span>
                        </div>
                        <button onclick="editor.logout()" class="flex items-center gap-2 px-3 py-1 text-sm text-gray-600 hover:text-gray-800 hover:bg-gray-100 rounded-md transition-all">
                            <i class="fas fa-sign-out-alt text-xs"></i>
                            <span>Logout</span>
                        </button>
                    </div>
                </div>
                
                <!-- Main header row with title and controls -->
                <div class="flex items-center justify-between px-8 py-4 gap-8">
                    <div class="flex-1">
                        <h1 class="text-2xl font-semibold text-gray-900 mb-1">Question Library</h1>
                        <p class="text-sm text-gray-600">Manage your sustainability survey questions</p>
                    </div>
                    <div class="flex items-center gap-6">
                        <div class="relative min-w-80">
                            <i class="fas fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400 text-sm"></i>
                            <input type="text" id="searchInput" placeholder="Search questions..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg text-sm bg-white focus:outline-none focus:ring-3 focus:ring-primary-50 focus:border-primary-500 transition-all">
                        </div>
                        <div class="flex gap-2">
                            <button id="expandAllBtn" class="inline-flex items-center gap-2 px-2 py-2 bg-gray-100 text-gray-600 rounded-md hover:bg-gray-200 transition-all text-sm font-medium">
                                <i class="fas fa-expand-alt text-xs"></i>
                                <span class="hidden lg:inline">Expand All</span>
                            </button>
                            <button id="collapseAllBtn" class="inline-flex items-center gap-2 px-2 py-2 bg-gray-100 text-gray-600 rounded-md hover:bg-gray-200 transition-all text-sm font-medium">
                                <i class="fas fa-compress-alt text-xs"></i>
                                <span class="hidden lg:inline">Collapse All</span>
                            </button>
                        </div>
                    </div>
                </div>
            `;

            // Re-attach event listeners since we rebuilt the header
            this.reattachHeaderEventListeners();
        }

        // Update survey tools based on role
        this.updateSurveyTools();
    }

    reattachHeaderEventListeners() {
        // Re-attach search functionality
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('input', () => this.debounce(this.handleSearch.bind(this), 300)());
        }

        // Re-attach add question button
        const addQuestionBtn = document.getElementById('addQuestionBtn');
        if (addQuestionBtn) {
            addQuestionBtn.addEventListener('click', () => this.showModal());
        }

        // Re-attach expand/collapse buttons
        const expandAllBtn = document.getElementById('expandAllBtn');
        const collapseAllBtn = document.getElementById('collapseAllBtn');
        
        if (expandAllBtn) {
            expandAllBtn.addEventListener('click', () => this.expandAllCategories());
        }
        
        if (collapseAllBtn) {
            collapseAllBtn.addEventListener('click', () => this.collapseAllCategories());
        }
    }

    updateSurveyTools() {
        const surveyToolsContainer = document.getElementById('surveyTools');
        if (!surveyToolsContainer) return;

        let toolsHtml = '';

        // SuperAdmin gets survey preview access
        if (this.currentUser.role === 'superadmin') {
            toolsHtml += `
                <a href="survey-preview.html" class="flex items-center gap-3 px-3 py-2 text-primary-700 bg-primary-50 hover:bg-primary-100 rounded-md transition-all">
                    <i class="fas fa-clipboard-check text-sm"></i>
                    <span class="text-sm font-medium">Survey Preview</span>
                </a>
            `;
        }

        // All roles can see their relevant survey tools
        // Future: Add role-specific survey management tools here

        surveyToolsContainer.innerHTML = toolsHtml;
        
        // Hide the section if no tools are available
        const surveyToolsSection = surveyToolsContainer.closest('.px-6');
        if (toolsHtml.trim() === '') {
            surveyToolsSection.style.display = 'none';
        } else {
            surveyToolsSection.style.display = 'block';
        }
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

// Initialize the editor when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.editor = new SustainabilityEditor();
});