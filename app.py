from flask import Flask, jsonify, request, render_template
import mysql.connector

app = Flask(__name__)

# Database configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'password', # Replace with your MySQL password
    'database': 'cms_db'
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/menu', methods=['GET'])
def get_menu():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM food_items;")
    items = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(items)

@app.route('/students', methods=['GET'])
def get_students():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM customers;")
    students = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(students)

@app.route('/place_order', methods=['POST'])
def place_order():
    data = request.json
    customer_id = data.get('customer_id')
    items = data.get('items') # List of dictionaries: [{'item_id': 1, 'qty': 2}]
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        # Step 1: Create Order
        cursor.callproc('create_new_order', [customer_id])
        for result in cursor.stored_results():
            order_id = result.fetchone()[0]
            
        # Step 2: Add Items
        for item in items:
            cursor.callproc('add_item_to_order', [order_id, item['item_id'], item['qty']])
            
        # Step 3: Update Total
        cursor.callproc('update_order_total', [order_id])
        for result in cursor.stored_results():
            final_bill = result.fetchone()[0]
            
        conn.commit()
        return jsonify({"message": "Order placed successfully!", "order_id": order_id, "total_bill": final_bill})
        
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

if __name__ == '__main__':
    app.run(debug=True)
