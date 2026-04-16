# Campus-Smart-Canteen-Management-System
A full-stack, database-driven application designed to digitize and automate traditional college canteen operations. This system eliminates manual record-keeping by seamlessly managing order placement, bill generation, inventory updates, and real-time data flow to improve overall efficiency.


🚀 Features
Automated Billing & Inventory: Utilizes advanced SQL triggers and stored procedures to automatically calculate order totals and reduce stock upon purchase.

Relational Database Architecture: Robust, normalized MySQL schema designed to store and link customer details, menu items, transactional orders, and line-item order details.


RESTful Backend API: A lightweight Python Flask server that exposes endpoints for fetching menu data, retrieving customer info, and securely processing new orders.

Interactive Web Interface: A simple, responsive HTML/JavaScript frontend that dynamically loads the menu from the database and allows users to place test orders.

Data Insights & Reporting: Structured to easily generate category-wise sales reports and identify top-selling food items.


🛠️ Technical Stack
Database: MySQL (Structured with primary/foreign keys, constraints, and normalization) 


Backend: Python, Flask Framework 

Frontend: HTML5, CSS, Vanilla JavaScript 

🗄️ Database Schema & Stored Procedures
The core logic of the application is handled directly at the database level using the following custom procedures:


create_new_order: Initializes a new transaction for a customer.

add_item_to_order: Inserts individual food items into the order details.

get_item_price & update_order_total: Internal functions that fetch current pricing and dynamically update the final bill.


💻 How to Run Locally
1. Database Setup

Install MySQL and start your local server.

Execute the database.sql script in your MySQL workbench or terminal to create the cms_db database, initialize the tables, and load the sample data.


2. Backend Setup

Ensure Python is installed on your machine.

Install the required dependencies:

Bash
pip install Flask mysql-connector-python
Open app.py and update the db_config dictionary with your local MySQL password.

Run the Flask server:

Bash
python app.py
3. Frontend Access

Open your web browser and navigate to http://127.0.0.1:5000/.

The UI will render the menu items directly from your database, and you can test the system by clicking "Place Sample Order"
