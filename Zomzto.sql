CREATE TABLE USER_SESSIONS (
	SESSION_ID VARCHAR(20),
	USER_ID VARCHAR(20),
	CITY VARCHAR(50),
	DEVICE VARCHAR(20),
	SESSION_DATE DATE,
	AGE_GROUP VARCHAR(10),
	IS_NEW_USER VARCHAR(5)
);

SELECT * FROM user_sessions;
SELECT COUNT(*) FROM user_sessions;

CREATE TABLE funnel_events (
    Event_ID VARCHAR(20),
    Session_ID VARCHAR(20),
    Funnel_Step VARCHAR(50),
    Step_Number INT,
    Event_Time TIMESTAMP,
    Restaurant_Name VARCHAR(50),
    Cuisine VARCHAR(50),
    Order_Value DECIMAL(10,2),
    Payment_Method VARCHAR(50),
    Delivery_Time_Mins INT
);

SELECT * FROM funnel_events;
SELECT COUNT(*) FROM funnel_events;

-- 1.How many users reached each step of the funnel?
SELECT 
    step_number,
    funnel_step,
    COUNT(DISTINCT session_id) AS total_users
FROM funnel_events
GROUP BY step_number, funnel_step
ORDER BY step_number;


-- 2.What percentage of users dropped off at each step?
SELECT 
    step_number,
    funnel_step,
    COUNT(DISTINCT session_id) AS total_users,
    ROUND(COUNT(DISTINCT session_id) * 100.0 / 
    (SELECT COUNT(DISTINCT session_id) FROM funnel_events WHERE funnel_step = 'App Opened'), 2) AS pct_of_total
FROM funnel_events
GROUP BY step_number, funnel_step
ORDER BY step_number;

-- 3.What is the overall conversion rate from App Open to Delivery?
SELECT 
    (SELECT COUNT(DISTINCT session_id) FROM funnel_events WHERE funnel_step = 'App Opened') AS total_sessions,
    (SELECT COUNT(DISTINCT session_id) FROM funnel_events WHERE funnel_step = 'Order Delivered') AS converted_users,
    ROUND(
        (SELECT COUNT(DISTINCT session_id) FROM funnel_events WHERE funnel_step = 'Order Delivered') * 100.0 /
        (SELECT COUNT(DISTINCT session_id) FROM funnel_events WHERE funnel_step = 'App Opened'), 2
    ) AS overall_conversion_pct;

-- 4.Which city has the highest conversion rate?
SELECT 
    s.city,
    COUNT(DISTINCT s.session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN e.funnel_step = 'Order Delivered' THEN s.session_id END) AS delivered_orders,
    ROUND(COUNT(DISTINCT CASE WHEN e.funnel_step = 'Order Delivered' THEN s.session_id END) * 100.0 / 
    COUNT(DISTINCT s.session_id), 2) AS conversion_rate_pct
FROM user_sessions s
JOIN funnel_events e ON s.session_id = e.session_id
GROUP BY s.city
ORDER BY conversion_rate_pct DESC;

-- 5.Which device has the best conversion rate?
SELECT 
    s.device,
    COUNT(DISTINCT s.session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN e.funnel_step = 'Order Delivered' THEN s.session_id END) AS converted_orders
FROM user_sessions s
JOIN funnel_events e ON s.session_id = e.session_id
GROUP BY s.device
ORDER BY converted_orders DESC;

-- 6.Which cuisines are most ordered on Zomato?
SELECT 
    cuisine,
    COUNT(*) AS total_orders,
    ROUND(AVG(order_value), 2) AS avg_order_value,
    ROUND(SUM(order_value), 2) AS total_revenue
FROM funnel_events
WHERE funnel_step = 'Order Placed'
AND cuisine IS NOT NULL
GROUP BY cuisine
ORDER BY total_orders DESC;

-- 7.Do new users or returning users convert better?
SELECT 
    s.is_new_user,
    COUNT(DISTINCT s.session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN e.funnel_step = 'Order Delivered' THEN s.session_id END) AS converted,
    ROUND(COUNT(DISTINCT CASE WHEN e.funnel_step = 'Order Delivered' THEN s.session_id END) * 100.0 / 
    COUNT(DISTINCT s.session_id), 2) AS conversion_rate_pct
FROM user_sessions s
JOIN funnel_events e ON s.session_id = e.session_id
GROUP BY s.is_new_user
ORDER BY conversion_rate_pct DESC;

-- 8.Which payment method has the highest average order value?
SELECT 
    payment_method,
    COUNT(*) AS total_orders,
    AVG(order_value) AS avg_order_value
FROM funnel_events
WHERE funnel_step = 'Payment Completed'
GROUP BY payment_method
ORDER BY avg_order_value DESC;