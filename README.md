# 🍕 Zomato Funnel Analysis — User Journey & Conversion Analytics

![Zomato](https://img.shields.io/badge/Domain-Food%20Delivery-red)
![Tools](https://img.shields.io/badge/Tools-PostgreSQL%20%7C%20Power%20BI-orange)
![Status](https://img.shields.io/badge/Status-Completed-green)

---

## 📌 Project Overview

This project analyzes the complete user journey on Zomato — from opening the app to receiving food delivery. The goal was to identify where users are dropping off in the ordering funnel and provide actionable business recommendations to improve conversion rates.

> *"Analyzed 1000 user sessions and 3548 funnel events using PostgreSQL for funnel analysis and Power BI for interactive dashboard reporting — identifying that only 23.4% of users who open the app complete a delivery."*

---

## 🎯 Business Problem

Zomato wants to understand:
- Where are users dropping off in the ordering journey?
- Which city has the highest order conversion rate?
- Which device (Android/iOS/Web) performs best?
- Which cuisines are most ordered?
- Which payment method is most preferred?
- Do new users convert better than returning users?

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| PostgreSQL (pgAdmin) | Funnel analysis using SQL |
| Power BI | Interactive funnel dashboard |
| GitHub | Project documentation |

---

## 📂 Project Structure

```
Zomato-Funnel-Analysis/
│
├── Data/
│   ├── User_Sessions.csv          # 1000 user session records
│   └── Funnel_Events.csv          # 3548 funnel event records
│
├── SQL/
│   └── Zomato_Funnel_Queries.sql  # All 8 SQL queries
│
├── Dashboard/
│   └── Zomato_Dashboard.png       # Power BI dashboard screenshot
│
└── README.md
```

---

## 📊 Dataset Overview

### Table 1 — User Sessions (1000 rows)
| Column | Description |
|--------|-------------|
| Session_ID | Unique session identifier |
| User_ID | Unique user identifier |
| City | City where session happened |
| Device | Android / iOS / Web |
| Session_Date | Date of session |
| Age_Group | 18-24 / 25-34 / 35-44 / 45+ |
| Is_New_User | Yes / No |

### Table 2 — Funnel Events (3548 rows)
| Column | Description |
|--------|-------------|
| Event_ID | Unique event identifier |
| Session_ID | Links to User Sessions table |
| Funnel_Step | Stage in the funnel |
| Step_Number | Order of the step (1-7) |
| Restaurant_Name | Restaurant viewed/ordered from |
| Cuisine | Type of cuisine |
| Order_Value | Value of order placed |
| Payment_Method | Payment method used |
| Delivery_Time_Mins | Time taken for delivery |

---

## 🗄️ SQL Analysis (PostgreSQL)

Wrote 8 business-focused SQL queries covering funnel analysis concepts:

### Funnel Steps Analyzed:
```
App Opened → Restaurant Viewed → Menu Opened → 
Item Added to Cart → Order Placed → Payment Completed → Order Delivered
```

### Query Concepts Covered:

| # | Business Question | SQL Concept |
|---|------------------|-------------|
| 1 | How many users reached each funnel step? | GROUP BY + COUNT DISTINCT |
| 2 | What % of users dropped off at each step? | Subquery + calculation |
| 3 | What is the overall conversion rate? | Multiple Subqueries |
| 4 | Which city has highest conversion? | JOIN two tables |
| 5 | Which device converts best? | JOIN + CASE WHEN |
| 6 | Which cuisines are most ordered? | GROUP BY + WHERE filter |
| 7 | New vs returning user conversion | JOIN + GROUP BY + CASE WHEN |
| 8 | Payment method by avg order value | GROUP BY + AVG + HAVING |

### Sample Query — Funnel Overview:
```sql
-- How many users reached each step of the funnel?
SELECT 
    step_number,
    funnel_step,
    COUNT(DISTINCT session_id) AS total_users,
    ROUND(COUNT(DISTINCT session_id) * 100.0 / 
    (SELECT COUNT(DISTINCT session_id) FROM funnel_events 
     WHERE funnel_step = 'App Opened'), 2) AS pct_of_total
FROM funnel_events
GROUP BY step_number, funnel_step
ORDER BY step_number;
```

### Sample Query — Conversion by City:
```sql
-- Which city has the highest conversion rate?
SELECT 
    s.city,
    COUNT(DISTINCT s.session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN e.funnel_step = 'Order Delivered' 
          THEN s.session_id END) AS delivered_orders,
    ROUND(COUNT(DISTINCT CASE WHEN e.funnel_step = 'Order Delivered' 
          THEN s.session_id END) * 100.0 / 
    COUNT(DISTINCT s.session_id), 2) AS conversion_rate_pct
FROM user_sessions s
JOIN funnel_events e ON s.session_id = e.session_id
GROUP BY s.city
ORDER BY conversion_rate_pct DESC;
```

---

## 📈 Power BI Dashboard

Built an interactive dashboard with Zomato branding covering:

- **KPI Cards** — Total Sessions, Avg Order Value, Orders Delivered
- **User Journey Funnel** — All 7 steps with drop-off visualization
- **Orders Delivered by City** — Bar chart comparing 8 cities
- **Sessions by Device** — Donut chart Android vs iOS vs Web
- **Top Cuisines Ordered** — Bar chart of most popular cuisines
- **Payment Method Preference** — Pie chart of payment breakdown
- **City Slicer** — Interactive filter to drill down by city

---

## 🔍 Key Business Insights

1. **Only 23.4% of users who open the app complete a delivery** — meaning 76.6% drop off somewhere in the journey
2. **Biggest drop-off happens between App Opened and Restaurant Viewed (28.3%)** — suggesting the home screen experience needs improvement
3. **Pizza is the most ordered cuisine** followed by Beverages and Desserts
4. **UPI leads payment methods at 25.58%** showing strong digital payment adoption
5. **Chennai and Hyderabad lead in orders delivered** by city
6. **Android, iOS and Web are almost equally split** at 35%, 33% and 32% respectively — showing Zomato has a strong cross-platform presence

---

## 💡 Business Recommendations

1. **Improve home screen personalization** to reduce the 28.3% drop-off at Restaurant Viewed stage
2. **Simplify the cart to checkout flow** — 30.7% drop-off between Order Placed and Payment is too high
3. **Focus marketing in Chennai and Hyderabad** where conversion is highest
4. **Promote UPI offers** since it's already the most preferred payment method
5. **Invest in Pizza and Beverages category** as they drive the most orders

---

## 🚀 How to Run This Project

1. Download `User_Sessions.csv` and `Funnel_Events.csv` from Data folder
2. Open pgAdmin and create a database called `zomato_db`
3. Run the CREATE TABLE queries from `Zomato_Funnel_Queries.sql`
4. Import both CSV files into their respective tables
5. Run the 8 SQL queries one by one
6. Open Power BI and connect to both CSV files to explore the dashboard

---

## 👩‍💻 Author

**Prerna Malhotra**
Aspiring Data Analyst | SQL • Power BI • Excel
📧 [prernamalhotra767@gmail.com]
🔗 [https://www.linkedin.com/in/prerna-malhotra-/]

