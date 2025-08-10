# Sustainability Survey Questions - CRUD Editor

A web-based CRUD (Create, Read, Update, Delete) editor for managing sustainability survey questions with a Node.js backend and MySQL database.

## Features

- ✅ View all sustainability survey questions with pagination
- 🔍 Search questions by text content
- 🏷️ Filter by category and question type
- ➕ Add new questions
- ✏️ Edit existing questions
- 🗑️ Delete questions
- 📊 Responsive design for mobile and desktop

## Prerequisites

- Node.js (v14 or higher)
- MySQL (running on localhost:3306)
- MySQL database named `sustainability_survey` with questions table

## Installation

1. **Clone or navigate to the project directory:**
   ```bash
   cd "sustainability survey"
   ```

2. **Install Node.js dependencies:**
   ```bash
   npm install
   ```

3. **Ensure MySQL is running and accessible:**
   - Database: `sustainability_survey`
   - User: `root` (no password)
   - Host: `127.0.0.1:3306`

## Usage

1. **Start the server:**
   ```bash
   npm start
   ```
   
   Or for development with auto-restart:
   ```bash
   npm run dev
   ```

2. **Open your browser and navigate to:**
   ```
   http://localhost:3000
   ```

3. **Use the CRUD editor:**
   - Browse and search through your 455 sustainability questions
   - Click "Add New Question" to create questions
   - Click "Edit" on any question to modify it
   - Click "Delete" to remove questions
   - Use filters to narrow down the list

## API Endpoints

The backend provides RESTful API endpoints:

- `GET /api/questions` - Get all questions (with pagination and filtering)
- `GET /api/questions/:id` - Get a specific question
- `POST /api/questions` - Create a new question
- `PUT /api/questions/:id` - Update a question
- `DELETE /api/questions/:id` - Delete a question
- `GET /api/categories` - Get all unique categories
- `GET /api/stats` - Get database statistics

## Database Schema

The `sustainability_questions` table includes:
- `id` - Primary key
- `category` - Question category (GHG, Energy, etc.)
- `question_order` - Display order within category
- `question_text` - The actual question
- `question_type` - Systems, Best Practice, or Performance
- `answer_type` - boolean, numeric, multiple_choice, or percentage
- `effort_rating` - Difficulty rating (0-5)
- `impact_rating` - Impact rating (0-5)
- `max_points` - Maximum points for the question
- `created_at` - Creation timestamp
- `updated_at` - Last update timestamp

## Technologies Used

- **Backend:** Node.js, Express.js, MySQL2
- **Frontend:** Vanilla JavaScript, HTML5, CSS3
- **Database:** MySQL
- **Styling:** Modern CSS with flexbox and grid

## Troubleshooting

**Database Connection Issues:**
- Ensure MySQL is running on port 3306
- Check that the `sustainability_survey` database exists
- Verify the root user has no password or update credentials in `server.js`

**Port Conflicts:**
- If port 3000 is in use, the server will show an error
- You can change the port in `server.js` or set the PORT environment variable

**Node.js Dependencies:**
- Run `npm install` to ensure all dependencies are installed
- Check that you have Node.js v14 or higher installed