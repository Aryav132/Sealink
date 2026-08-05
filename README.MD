# ⚓ SeaLink — Port Management System

SeaLink is a comprehensive, full-stack Database Management System (DBMS) designed to handle the complex physical and administrative operations of a maritime shipping port. It features a Python-based interactive dashboard powered by a highly constrained, transaction-safe MySQL database.

## 🚀 Key Features

* **Complex Relational Modeling:** Built on a robust conceptual model handling Many-to-Many relationships (Voyages to Equipment) and Weak Entities, strictly enforced by foreign keys and domain constraints.
* **Automated Business Logic (Triggers):** Database-level triggers automatically manage equipment lifecycle flagging, prevent illegal physical movements, and automate berth status updates.
* **ACID Transactions:** Implements pessimistic locking (`SELECT ... FOR UPDATE`), atomic batch processing, and rollback mechanisms to ensure data integrity during concurrent double-booking or billing scenarios.
* **Advanced Analytics:** Utilizes complex SQL operations including CTEs, Window Functions, Relational Division, and Conditional Aggregation (Pivoting) to generate real-time fleet health and financial dashboards.
* **Interactive UI:** A fully functional Streamlit frontend allowing dispatchers, customs officers, and port managers to interact with the database in real time.

## 🛠️ Tech Stack
* **Frontend/Application:** Python, Streamlit, Pandas
* **Backend Database:** MySQL 8.0

## ⚙️ How to Run This Project Locally

**1. Set up the Database**
* Open MySQL Workbench.
* Open the `database/sealink.sql` file.
* Run the entire script to generate the schema, populate the mock data, build the triggers, and establish the transaction states.

**2. Set up the Python Environment**
Ensure you have Python installed, then run the following in your terminal:
`pip install -r requirements.txt`

**3. Connect the App**
* Open `app.py`.
* Locate the `get_connection()` function.
* Update the `user` and `password` parameters to match your local MySQL credentials.

**4. Launch the Dashboard**
`streamlit run app.py`

## 👥 Project Team (Group 10)
* Eshaan Garg
* Arnav Ranjan
* Aryan Jain
