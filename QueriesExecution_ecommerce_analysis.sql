# A. ORDER BY & GROUP BY
		# 1. ORDER BY (Sorting Data)
			-- a. Sort products by price (high to low)
			SELECT * FROM products 
			ORDER BY price DESC;

			-- b. Sort customers by join date (newest first)
			SELECT * FROM customers 
			ORDER BY join_date DESC;
			
		# 2. GROUP BY (Summarizing Data)
			-- a. Count orders per customer
			SELECT customer_id, COUNT(*) as order_count 
			FROM orders 
			GROUP BY customer_id;

			-- b. Total sales by product category
			SELECT p.category, SUM(oi.price * oi.quantity) as total_sales
			FROM order_items oi
			JOIN products p ON oi.product_id = p.product_id
			GROUP BY p.category;
        
 # B. JOINs (INNER, LEFT, RIGHT)
			-- 1. INNER JOIN (Matching Records Only)
					-- Get orders with customer details
					SELECT o.order_id, c.name, o.order_date, o.total_amount
					FROM orders o
					INNER JOIN customers c ON o.customer_id = c.customer_id;
			-- 2. LEFT JOIN (All Left Table + Matches)
					-- All customers (even if no orders)
					SELECT c.name, c.email, o.order_id
					FROM customers c
					LEFT JOIN orders o ON c.customer_id = o.customer_id;
			-- 3. RIGHT JOIN (All Right Table + Matches)
					-- All orders (even if customer data missing)
					SELECT o.order_id, c.name
					FROM customers c
					RIGHT JOIN orders o ON c.customer_id = o.customer_id;
                    
 # C. Subqueries
			-- 1. Subquery in WHERE
					-- Products priced above average
					SELECT name, price 
					FROM products 
					WHERE price > (SELECT AVG(price) FROM products);
			-- 2. Subquery in FROM
					-- Customers who spent more than $500
					SELECT c.name, total_spent
					FROM customers c
					JOIN (
						SELECT customer_id, SUM(total_amount) as total_spent
						FROM orders
						GROUP BY customer_id
					) as customer_totals ON c.customer_id = customer_totals.customer_id
					WHERE total_spent > 500;
                    
 # D. Aggregate Functions (SUM, AVG)
				-- 1. SUM (Total Values)
						-- a. Total revenue
						SELECT SUM(total_amount) as total_revenue FROM orders;

						-- b. Total quantity sold per product
						SELECT p.name, SUM(oi.quantity) as total_sold
						FROM order_items oi
						JOIN products p ON oi.product_id = p.product_id
						GROUP BY p.name;
				-- 2. AVG (Average Values)
						-- a. Average order value
						SELECT AVG(total_amount) as avg_order_value FROM orders;

						-- b. Average product price by category
						SELECT category, AVG(price) as avg_price
						FROM products
						GROUP BY category;
                        
 # E. Create Views
				-- 1. Create a View
						-- Customer order summary view
							CREATE VIEW customer_orders_view AS
							SELECT c.customer_id, c.name, 
								   COUNT(o.order_id) as order_count,
								   SUM(o.total_amount) as total_spent
							FROM customers c
							LEFT JOIN orders o ON c.customer_id = o.customer_id
							GROUP BY c.customer_id, c.name;
				-- 2. Query the View
								-- Use like a regular table
								SELECT * FROM customer_orders_view 
								WHERE total_spent > 500;
		
# F. Optimize Queries with Indexes
					-- 1. Create Indexes
                    -- Speed up customer lookups
						CREATE INDEX idx_customer_name ON customers(name);

						-- Faster category filtering
						CREATE INDEX idx_product_category ON products(category);

						-- Improve order date searches
						CREATE INDEX idx_order_date ON orders(order_date);
                        
                       -- 2. Verify Indexes
                       -- Show indexes on a table
						SHOW INDEX FROM customers;
                        
# G. Putting It All Together
					-- 1. Final Complex Query 
                    -- Monthly sales report with customer insights
						SELECT 
							DATE_FORMAT(o.order_date, '%Y-%m') as month,
							c.country,
							p.category,
							COUNT(DISTINCT o.order_id) as order_count,
							SUM(oi.quantity * oi.price) as revenue,
							AVG(oi.quantity * oi.price) as avg_order_value
						FROM orders o
						INNER JOIN customers c ON o.customer_id = c.customer_id
						INNER JOIN order_items oi ON o.order_id = oi.order_id
						INNER JOIN products p ON oi.product_id = p.product_id
						WHERE o.order_date BETWEEN '2023-01-01' AND '2023-12-31'
						GROUP BY month, c.country, p.category
						ORDER BY month, revenue DESC;