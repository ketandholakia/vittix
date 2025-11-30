# VittiX - Desktop Business Application Framework

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Built with Delphi](https://img.shields.io/badge/Built%20with-Delphi%20VCL-red.svg)](https://www.embarcadero.com/products/delphi)

VittiX is a modular, role-based desktop application framework built using **Delphi (VCL)** and **Firebird SQL**. It provides a robust foundation for building small to medium enterprise resource planning (ERP) or accounting applications, featuring user management, dynamic permissions, masters data modules, and built-in database tools.

## ✨ Features

* **Role-Based Access Control (RBAC):** Permissions are checked dynamically against the user's role on every action execution, ensuring granular security.
* **Dynamic UI Control:** The main menu and actions are enabled/disabled based on the logged-in user's rights using the `TActionManager`.
* **Database Connectivity:** Uses **FireDAC** for fast, native connection to the **Firebird SQL** database.
* **User & Security Management:** Dedicated forms for managing users, roles (e.g., 'admin', 'manager'), and the permission matrix.
* **Custom Shortcuts:** Users can define and save their own keyboard shortcuts via the `uShortcutManager` logic.
* **Database Tools:** Integrated database backup and restore functionality (`uBackupManager`) with status checks on the main form status bar.
* **Modular Masters:** Framework ready for forms managing core business entities (Companies, Products, Customers, UOM, States, Transporters).

---

## 🚀 Getting Started

### Prerequisites

1.  **Delphi IDE:** Requires Delphi 10.x or newer (uses VCL framework).
2.  **Firebird SQL:** A running instance of Firebird (tested with version 3.0 or 4.0).
3.  **Components:** Requires standard VCL components and FireDAC. (Note: If using third-party components like Raize or DevExpress for specific UI elements, list them here.)

### Installation and Setup

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/your-username/vittix.git](https://github.com/your-username/vittix.git)
    ```

2.  **Database Setup:**
    * Restore or create a new Firebird database using the schema.
    * Ensure the core tables are populated: `USERS`, `ROLES`, `PERMISSIONS`, and `ROLE_PERMISSIONS`.
    * Run the initial data inserts to create the base **`ADMIN`** role and the necessary permissions (e.g., `manage_users`, `manage_permissions`).

3.  **Configure Connection:**
    * Open the project file in the Delphi IDE.
    * Navigate to the Data Module (`uDMmain`).
    * Update the `FDConnectionmain` parameters (Database path, User\_Name, Password) to point to your local Firebird instance.

4.  **Run:** Compile and run the project.

---

## 🗄️ Database Schema (Core RBAC)

The security model is defined by these core relational tables:

| Table Name | Primary Key | Key Columns | Purpose |
| :--- | :--- | :--- | :--- |
| **`ROLES`** | `ROLE_ID` | `ROLE_NAME` (VARCHAR 50) | Defines user groups (e.g., admin, manager). |
| **`PERMISSIONS`** | `PERMISSION_ID` | `PERMISSION_NAME` (VARCHAR 50) | Dictionary of all rights (e.g., manage\_users). |
| **`USERS`** | `USER_ID` | `ROLE_ID` (FK) | Links users to their assigned role. |
| **`ROLE_PERMISSIONS`** | (Composite) | `ROLE_ID` (FK), `PERMISSION_KEY` (or `PERMISSION_ID`) | Grants specific permissions to a specific role. |

---

## ⚙️ Core Modules and Logic

### `uRolesPermissionsForm.pas`

This form provides the central UI for managing access rights.

* **Loading:** The left list box (`lstRoles`) loads roles from the **`ROLES`** table. The right checklist box (`chkListPermissions`) loads all available rights from the **`PERMISSIONS`** table.
* **Saving:** The `SavePermissionsForRole` procedure implements the "Delete and Re-insert" strategy, ensuring the `ROLE_PERMISSIONS` table accurately reflects the checked items for the selected role.

### `uShortcutManager.pas`

* Manages shortcut persistence by reading and writing action mappings to a JSON configuration file (`ConfigPath`).
* Applies shortcuts to actions within the **`TActionManager`** using the VCL's `TextToShortCut` and `ShortCutToText` functions.

---

## 🤝 Contribution

Contributions are welcome! If you find a bug or have an enhancement idea, please open an issue or submit a pull request.

1.  Fork the repository.
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.