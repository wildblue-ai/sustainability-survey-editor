# Sample Login Accounts

This document contains the login credentials for all demo accounts in the SustainEdit sustainability survey management system.

## Login Process

The system uses a **unified login page** where users must:
1. **Select their role** from the dropdown (SuperAdmin, Client Partner, Client, or Vendor)
2. **Enter their email** and password
3. The system validates that the email matches the selected role

All accounts use the same password: **`password123`**

## 1. SuperAdmin Account

**Role**: System Administrator
- **Email**: `admin@sustainedit.com`
- **Password**: `password123`
- **Name**: Sarah Johnson
- **Phone**: +1 (555) 001-2345
- **Address**: 123 Admin Street, Suite 500, San Francisco, CA 94105
- **Access**: Manage client partners, full system access

---

## 2. Client Partner Account

**Role**: Partner Organization Manager
- **Email**: `partner@greentech.com`
- **Password**: `password123`
- **Name**: Michael Chen
- **Phone**: +1 (555) 101-2345
- **Address**: 456 Sustainability Blvd, Floor 8, Portland, OR 97201
- **Organization**: GreenTech Consulting
- **Access**: Manage client companies under their partnership

---

## 3. Client Account

**Role**: Client Company User
- **Email**: `client@techcorp.com`
- **Password**: `password123`
- **Name**: Emma Rodriguez
- **Phone**: +1 (555) 201-2345
- **Address**: 789 Innovation Drive, Building A, Austin, TX 78701
- **Company**: TechCorp Manufacturing
- **Access**: Manage vendors and create sustainability surveys

---

## 4. Vendor Account

**Role**: Vendor/Supplier User
- **Email**: `vendor@steelworks.com`
- **Password**: `password123`
- **Name**: David Kim
- **Phone**: +1 (555) 301-2345
- **Address**: 321 Industrial Park Way, Cleveland, OH 44115
- **Company**: SteelWorks Ltd
- **Access**: Participate in assigned sustainability surveys

---

## Additional Sample Accounts

### Second Client Partner
- **Email**: `partner@ecopartners.com`
- **Password**: `password123`
- **Name**: Lisa Anderson
- **Phone**: +1 (555) 102-2345
- **Address**: 987 Green Valley Road, Suite 200, Denver, CO 80202
- **Organization**: EcoPartners Group

### Second Client
- **Email**: `client@localfood.com`
- **Password**: `password123`
- **Name**: James Wilson
- **Phone**: +1 (555) 202-2345
- **Address**: 654 Farm Fresh Lane, Seattle, WA 98101
- **Company**: LocalFood Co

### Second Vendor
- **Email**: `vendor@cleanenergy.com`
- **Password**: `password123`
- **Name**: Maria Garcia
- **Phone**: +1 (555) 302-2345
- **Address**: 147 Solar Panel Drive, Phoenix, AZ 85001
- **Company**: CleanEnergy Solutions

---

## Quick Access URLs

- **Main Application**: http://localhost:3000
- **SuperAdmin Dashboard**: http://localhost:3000/superadmin.html
- **Partner Dashboard**: http://localhost:3000/partner-dashboard.html
- **Client Dashboard**: http://localhost:3000/client-dashboard.html
- **Direct Login**: http://localhost:3000/login.html

---

## Security Notes

⚠️ **Important**: These are demo accounts for testing purposes only.

- All passwords are identical for simplicity: `password123`
- In production, each account should have unique, strong passwords
- User data includes realistic names, phone numbers, and addresses for testing
- The system uses bcrypt password hashing for security

---

## Testing Workflow

1. **SuperAdmin Flow**:
   - Select "SuperAdmin" role → Enter admin@sustainedit.com / password123
   - Manage client partners in SuperAdmin dashboard
   - Access Survey Preview to review vendor experience
   - Create new partner organizations

2. **Partner Flow**:
   - Select "Client Partner" role → Enter partner@greentech.com / password123
   - Select your partner organization from dropdown
   - Manage client companies under your partnership

3. **Client Flow**:
   - Select "Client" role → Enter client@techcorp.com / password123
   - Select your client company from dropdown
   - Manage vendors and create sustainability surveys

4. **Vendor Flow**:
   - Select "Vendor" role → Enter vendor@steelworks.com / password123
   - View assigned sustainability surveys
   - Complete survey responses

## Role Security

The system now validates that:
- Users can only login with the role that matches their account
- Attempting to login with the wrong role will show: "Account not found for the selected role"
- Each role has appropriate dashboard access and permissions

---

*Generated for SustainEdit - Sustainability Survey Management System*