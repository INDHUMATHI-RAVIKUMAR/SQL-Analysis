CREATE DATABASE BIKE_STORE;
USE BIKE_STORE;
SELECT * FROM brands;
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM staffs;
SELECT * FROM stocks;
SELECT * FROM stores;

# join 
# brands Vs products based on brand id as common

# 	1)  INNER JOIN to view all the table columns

SELECT * FROM brands
JOIN products ON brands.brand_id = products.brand_id;

# 	2) INNER JOIN to view specific columns

SELECT brands.brand_id, brands.brand_name,products.product_id,products.product_name,products.category_id,products.model_year,products.list_price
FROM brands
JOIN products ON brands.brand_id = products.brand_id;

# 3) To view common columns in 2 table as single column using alias (AS) and object clause 
SELECT 
b.brand_id AS brand_id,
b.brand_name AS brand_name,
p.product_id AS product_id,
p.product_name AS product_name
FROM brands b
JOIN products p
ON
b.brand_id = p.brand_id;

# 4) USING ORDER BY
SELECT 
    first_name,
    last_name
FROM 
    customers
ORDER BY
    last_name;

# 5) ORDER BY BOTH THE COLUMNS

SELECT 
    first_name,
    last_name
FROM 
    customers
ORDER BY
    last_name, first_name;

#6) USNG DISTINCT AND SORTING 
SELECT 
    DISTINCT
    last_name
FROM 
    customers
ORDER BY 
    last_name ASC;
   # 7) USE LIMIT AS WELL AS DISTINCT AND ORDER BY AND SORTING  
    SELECT 
    DISTINCT
    last_name
FROM 
    customers
ORDER BY 
    last_name ASC
LIMIT 5;
# 8) USING WHERE CLAUSE 
SELECT 
    first_name,
    last_name
FROM 
    customers
WHERE
    last_name = 'Acevedo'
ORDER BY 
    first_name;
    # 9) LOGICAL OPERATOR AND OR 
    SELECT 
    first_name,
    last_name
FROM 
    customers
WHERE
    last_name = 'Acevedo'
AND
    first_name = 'Ester';
    
    SELECT 
    first_name,
    last_name
FROM 
    customers
WHERE
    last_name = 'Acevedo'
AND
    first_name = 'Ester'
OR
    first_name = 'Jamika';
    
    SELECT 
    first_name,
    last_name
FROM 
    customers
WHERE
    last_name = 'Acevedo'
AND
    (
    (first_name = 'Ester')
    OR 
    (first_name = 'Jamika')
    );

# 10) IN and NOT IN clause use
    
    SELECT 
    *
FROM 
    customers
WHERE
    state IN ('CA', 'NY')
LIMIT 5;

SELECT 
    *
FROM 
    customers
WHERE
    state IN ('CA', 'NY')
AND 
    phone IS NULL
LIMIT 5;


SELECT 
    *
FROM 
    customers
WHERE
    state NOT IN ('CA', 'NY')
AND 
    phone IS NOT NULL
LIMIT 5;

# 11) like and regular expression used 
SELECT 
    *
FROM 
    products
WHERE
    product_name LIKE 'T%'
LIMIT 5;

# 12) AGGRIGATE FUNCTIONS USED 

SELECT * 
FROM order_items
where list_price=(select MAX(list_price) FROM order_items );

# 13) Arithmatic operation 

SELECT 
  ROUND(  AVG(list_price * discount) )AS avg_discount_usd
FROM 
    order_items;
    
    # 14) Comparison Operators
    SELECT 
    ROUND(AVG(list_price * (1 - discount)), 2) AS avg_saleprice_usd
FROM 
    order_items
WHERE
    list_price >= 1000;
    
    # 15) GROUP BY & HAVING
    SELECT 
    order_id,
    ROUND(SUM(quantity * list_price * (1 - discount)), 2) final_sale_price
FROM 
    order_items
GROUP BY
    order_id;
    
    SELECT 
    order_id,
    ROUND(SUM(quantity * list_price * (1 - discount)), 2) final_sale_price
FROM 
    order_items
GROUP BY
    1
HAVING
    final_sale_price > 20000
ORDER BY
    2 DESC;
    
    #16) CASE & CAST
    
    SELECT 
    *,
    CASE WHEN shipped_date > required_date THEN 1
         ELSE 0
         END AS 'shipped_late'
FROM 
    orders
LIMIT 5;


SELECT 
    order_id,
    CAST(order_id AS float) AS order_id_float
FROM 
    orders
LIMIT 5;


# INNER JOIN
SELECT 
    *
FROM 
    orders
INNER JOIN
    customers
ON
    orders.customer_id = customers.customer_id
LIMIT 5;

# LEFT JOIN
SELECT 
    *
FROM 
    orders
LEFT JOIN
    customers
ON
    orders.customer_id = customers.customer_id
LIMIT 5;

#FULL OUTER JOIN
SELECT 
    *
FROM 
    orders
FULL JOIN
    customers
ON
    orders.customer_id = customers.customer_id
LIMIT 5;

#SELF JOIN
SELECT 
    t1.customer_id,
    MAX(t1.order_date) most_recent_order,
    MAX(t2.order_date) second_most_recent_order
FROM 
    orders t1
INNER JOIN
    orders t2
ON 
    t1.customer_id = t2.customer_id
AND
    t1.order_date > t2.order_date
GROUP BY
    1;
    
    # UNION
    SELECT 
    product_id,
    product_name,
    model_year,
    list_price
FROM 
    products
WHERE
    model_year = 2016
UNION
SELECT 
    product_id,
    product_name,
    model_year,
    list_price
FROM 
    products
WHERE
    model_year = 2019;
    
    # Subquery
    
    SELECT 
    *
FROM 
    products
WHERE
    model_year = 2019
AND
    list_price > (
                  SELECT
                      AVG(list_price)
                  FROM
                      products
                  WHERE
                      model_year = 2019
                 );
                 
                 SELECT 
    DISTINCT
    order_id,
    customer_id
FROM 
    orders
WHERE
    order_id IN (
                  SELECT
                      DISTINCT
                      order_id
                  FROM
                      order_items
                  INNER JOIN
                      products
                      ON
                      order_items.product_id = products.product_id
                  AND
                      brand_id = 9
                  AND
                      discount >= .20
                 );
                 
                 # EXISTS
                 SELECT 
    DISTINCT
    order_id,
    customer_id
FROM 
    orders
WHERE
    EXISTS (
            SELECT
                1
            FROM
                order_items
            WHERE
                discount >= .20
            AND
                order_items.order_id = orders.order_id
            );
            
            # Common Table Expressions (CTE)--WITH CLAUSE 
            
            WITH category_sales AS (
    SELECT
        DISTINCT
        order_id,
        order_items.product_id,
        quantity,
        order_items.list_price,
        quantity * order_items.list_price AS line_subtotal,
        category_id
    FROM
        order_items
    INNER JOIN
        products
    ON
        order_items.product_id = products.product_id
        
)
SELECT
    category_id,
    SUM(line_subtotal) AS revenue,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT order_id) AS total_orders
FROM 
    category_sales
GROUP BY
    1
ORDER BY
    2 DESC;
    # RECURSIVE 
    WITH RECURSIVE employee_hierarchy AS (
    SELECT
        staff_id,
        manager_id,
        first_name || ' ' || last_name AS full_name
    FROM
        staffs t1
    WHERE
        manager_id IS NULL
    UNION ALL
    SELECT
        t2.staff_id,
        t2.manager_id,
        t2.first_name || ' ' || t2.last_name AS full_name
        FROM
        staffs t2
    INNER JOIN
        employee_hierarchy eh
    ON
        t2.manager_id = eh.staff_id  
)

SELECT
    *
FROM
    employee_hierarchy;
    
    # Window Functions
    #Window Frame: A window function's calculations are based on a "window frame," which defines the range of rows to include in the calculation. The window frame can be defined 
    #using the OVER clause and can include rows before and/or after the current row, based on partitioning and ordering specifications
    
    #Partitioning: You can partition the result set into groups of rows using the PARTITION BY clause. 
    #Each partition is treated as a separate set for window function calculations.
    
    #Ordering: The ORDER BY clause defines the order of rows within each partition. 
    #This order determines how the window frame is constructed for each row.
    
    #Functions: Common window functions include SUM(), AVG(), ROW_NUMBER(), RANK(), DENSE_RANK(), LEAD(), LAG(), and more. 
    #These functions can be applied over the window frame to perform calculations.
    
    WITH daily_orders AS (
    SELECT
        order_date,
        store_id,
        COUNT(*) AS orders
    FROM
        orders
    GROUP BY
        1,2
)

SELECT
    order_date,
    store_id,
    AVG(orders) OVER(PARTITION BY store_id 
    ORDER BY order_date ASC
                     ROWS BETWEEN 14 PRECEDING AND 15 FOLLOWING) AS moving_avg_30d
FROM
    daily_orders;
    
    
    
    WITH customer_stats AS (
    SELECT
        customer_id,
        SUM(quantity * list_price * (1 - discount)) AS total_spent,
        COUNT(DISTINCT orders.order_id) AS total_orders,
        julianday('2018-12-29') - julianday(MAX(order_date)) AS days_since_last_purchase
    FROM
        orders
    INNER JOIN
        order_items
    ON
        orders.order_id = order_items.order_id
        GROUP BY
        1
)

SELECT
    customer_id,
    CASE WHEN total_orders > 1 THEN 'repeat buyer'
         ELSE 'one-time buyer'
         END AS purchase_frequency,
    CASE WHEN days_since_last_purchase < 90 THEN 'recent buyer'
         ELSE 'not recent buyer'
         END AS purchase_recency,
    CASE WHEN total_spent/(SELECT MAX(total_spent) FROM customer_stats) >= .65 THEN 'big spender'
         WHEN total_spent/(SELECT MAX(total_spent) FROM customer_stats) <= .30 THEN 'low spender'
         ELSE 'average spender' 
         END AS buying_power
FROM
    customer_stats