# backend/query_engine.py
import difflib

# Map of known table/columns
TABLES = {
    "products": ["prodcts", "products"],
    "customers": ["custmrs", "customers"],
    "transactions": ["transctns", "transactions"]
} 

COLUMNS = {
    "product_name": ["prod_name", "product_name"],
    "category": ["Category", "category"],
    "price": ["Price", "price"],
    "customer_name": ["cust_name", "customer_name"],
    "region": ["region"],
    "amount": ["amount"],
    "transaction_date": ["transaction_date"]
}


def match_column(user_word):
    for key, options in COLUMNS.items():
        match = difflib.get_close_matches(user_word.lower(), [o.lower() for o in options], n=1)
        if match:
            return key
    return None


def match_table(user_word):
    for key, options in TABLES.items():
        match = difflib.get_close_matches(user_word.lower(), [o.lower() for o in options], n=1)
        if match:
            return key
    return None


def question_to_sql(question: str):
    question = question.lower()

    # 1. Top-selling products
    if "top" in question and "product" in question and "sale" in question:
        return """
        SELECT p.prod_name AS product_name, SUM(t.amount) AS total_sales
        FROM transctns t
        JOIN prodcts p ON t.product_id = p.id
        GROUP BY p.prod_name
        ORDER BY total_sales DESC
        LIMIT 5
        """

    # 2. Total sales overall
    if "total" in question and "sale" in question:
        return """
        SELECT SUM(amount) AS total_sales
        FROM transctns
        """

    # 3. Sales by region
    if "sales" in question and "region" in question:
        return """
        SELECT c.region, SUM(t.amount) AS total_sales
        FROM transctns t
        JOIN custmrs c ON t.customer_id = c.id
        GROUP BY c.region
        ORDER BY total_sales DESC
        """

    # 4. Average price by category
    if "average" in question and "price" in question:
        return """
        SELECT p.category, AVG(p.price) AS avg_price
        FROM prodcts p
        GROUP BY p.category
        """

    # 5. Most expensive product
    if "most expensive" in question or "highest price" in question:
        return """
        SELECT prod_name AS product_name, price
        FROM prodcts
        ORDER BY price DESC
        LIMIT 1
        """

    # 6. Cheapest product
    if "cheapest" in question or "lowest price" in question:
        return """
        SELECT prod_name AS product_name, price
        FROM prodcts
        ORDER BY price ASC
        LIMIT 1
        """

    # 7. Top customers
    if "top" in question and "customer" in question:
        return """
        SELECT c.cust_name AS customer_name, SUM(t.amount) AS total_spent
        FROM transctns t
        JOIN custmrs c ON t.customer_id = c.id
        GROUP BY c.cust_name
        ORDER BY total_spent DESC
        LIMIT 5
        """

    # 8. Sales by category
    if "sales" in question and "category" in question:
        return """
        SELECT p.category, SUM(t.amount) AS total_sales
        FROM transctns t
        JOIN prodcts p ON t.product_id = p.id
        GROUP BY p.category
        """

    # Default: unknown
    return None

def format_answer(sql: str, rows: list):
    if not rows:
        return {"text": "No data found.", "chart": None}

    chart = None
    answer = "Data retrieved."

    # Top-selling products
    if "GROUP BY p.prod_name" in sql:
        answer = f"Top selling products:\n" + "\n".join([f"{r['product_name']}: ${r['total_sales']}" for r in rows])
        chart = {
            "type": "bar",
            "labels": [r["product_name"] for r in rows],
            "values": [r["total_sales"] for r in rows],
        }

    # Total sales
    elif "SUM(amount)" in sql and "FROM transctns" in sql:
        answer = f"Total sales: ${rows[0]['total_sales']}"
        chart = None

    # Sales by region
    elif "GROUP BY c.region" in sql:
        answer = "Sales by region:\n" + "\n".join([f"{r['region']}: ${r['total_sales']}" for r in rows])
        chart = {
            "type": "pie",
            "labels": [r["region"] for r in rows],
            "values": [r["total_sales"] for r in rows],
        }

    # Average price by category
    elif "AVG(p.price)" in sql:
        answer = "Average price by category:\n" + "\n".join([f"{r['category']}: ${r['avg_price']:.2f}" for r in rows])
        chart = {
            "type": "bar",
            "labels": [r["category"] for r in rows],
            "values": [r["avg_price"] for r in rows],
        }

    # Most expensive product
    elif "ORDER BY price DESC" in sql:
        top = rows[0]
        answer = f"Most expensive product is {top['product_name']} priced at ${top['price']}."

    # Cheapest product
    elif "ORDER BY price ASC" in sql:
        top = rows[0]
        answer = f"Cheapest product is {top['product_name']} priced at ${top['price']}."

    # Top customers
    elif "GROUP BY c.cust_name" in sql:
        answer = "Top customers:\n" + "\n".join([f"{r['customer_name']}: ${r['total_spent']}" for r in rows])
        chart = {
            "type": "bar",
            "labels": [r["customer_name"] for r in rows],
            "values": [r["total_spent"] for r in rows],
        }

    # Sales by category
    elif "GROUP BY p.category" in sql:
        answer = "Sales by category:\n" + "\n".join([f"{r['category']}: ${r['total_sales']}" for r in rows])
        chart = {
            "type": "pie",
            "labels": [r["category"] for r in rows],
            "values": [r["total_sales"] for r in rows],
        }

    return {"answer": answer, "chart": chart}
 