CREATE database dannys_diner;
use dannys_diner;
CREATE TABLE sales (
					customer_id VARCHAR(10),
					order_date DATE,
					product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);
INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  show tables;
select * from members;
select * from sales;
select * from menu;
/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
select customer_id as Name, sum(price)as Total from sales s join menu m on s.product_id = m.product_id group by customer_id;

-- 2. How many days has each customer visited the restaurant?
SELECT 
		CUSTOMER_ID AS NAME , COUNT(CUSTOMER_ID) AS NO_OF_TIME_VISITED
FROM 
		sales
group by 
		CUSTOMER_ID;

-- 3. What was the first item from the menu purchased by each customer?
select CUSTOMER_ID FROM SALES;
Select * from members;
select * from sales;
select * from menu;
SELECT M.PRODUCT_NAME,count(S.PRODUCT_ID) TOTAL FROM SALES S JOIN MENU M ON S.PRODUCT_ID = M.PRODUCT_ID 
GROUP BY M.PRODUCT_NAME order by TOTAL DESC LIMIT 1;
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?


SELECT * FROM (SELECT CUSTOMER_ID,PRODUCT_ID,COUNT(PRODUCT_ID) TOTAL FROM SALES group by CUSTOMER_ID,PRODUCT_ID ) T WHERE PRODUCT_ID = 3;

SELECT CUSTOMER_ID, MAX(PRODUCT_ID) TOTAL FROM SALES  GROUP BY  CUSTOMER_ID ;

-- 6. Which item was purchased first by the customer after they became a member?
Select * from members;
select * from sales;
select * from menu;
SELECT W.CUSTOMER_ID, W.ORDER_DATE,W.PRODUCT_ID,M.PRODUCT_NAME FROM (SELECT *FROM 
(SELECT S.CUSTOMER_ID,S.ORDER_DATE,S.PRODUCT_ID FROM SALES S JOIN MEMBERS M ON M.CUSTOMER_ID = S.CUSTOMER_ID 
WHERE S.ORDER_DATE < M.JOIN_DATE) T WHERE ORDER_DATE='2021-01-01') W JOIN MENU M ON M.PRODUCT_ID = W.PRODUCT_ID;
-- 7. Which item was purchased just before the customer became a member?

SELECT S.CUSTOMER_ID,S.ORDER_DATE,S.PRODUCT_ID FROM SALES S JOIN MEMBERS M ON M.CUSTOMER_ID = S.CUSTOMER_ID 
WHERE S.ORDER_DATE < M.JOIN_DATE;
Select * from members;
select * from sales;
select * from menu;

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT CUSTOMER_ID,PRODUCT_ID, COUNT(PRODUCT_ID) TOTAL_ITEM,sum(PRICE) TOTAL_PRICE FROM((SELECT T.CUSTOMER_ID,T.PRODUCT_ID,M.PRODUCT_NAME,M.PRICE FROM
(SELECT S.CUSTOMER_ID,S.ORDER_DATE,S.PRODUCT_ID FROM SALES S JOIN MEMBERS M ON M.CUSTOMER_ID = S.CUSTOMER_ID 
WHERE S.ORDER_DATE < M.JOIN_DATE) T JOIN MENU M ON M.PRODUCT_ID = T.PRODUCT_ID)) W group by CUSTOMER_ID,PRODUCT_ID;

SELECT S.CUSTOMER_ID,S.PRODUCT_ID,MM.PRODUCT_NAME,SUM(PRICE) TOTAL ,COUNT(S.PRODUCT_ID) AS TOTAL_ITEM FROM MEMBERS M JOIN SALES S ON M.CUSTOMER_ID = S.CUSTOMER_ID 
JOIN MENU MM ON S.PRODUCT_ID = MM.PRODUCT_ID WHERE S.ORDER_DATE < M.JOIN_DATE GROUP BY S.CUSTOMER_ID,S.PRODUCT_ID,MM.PRODUCT_NAME ;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT S.CUSTOMER_ID, S.PRODUCT_ID,M.PRODUCT_NAME,CASE WHEN S.PRODUCT_ID=1 THEN M.PRICE*20 ELSE M.PRICE*10 END AS TOTAL_POINTS
 FROM menu M JOIN SALES S ON M.PRODUCT_ID = S.PRODUCT_ID GROUP BY S.CUSTOMER_ID, S.PRODUCT_ID,M.PRODUCT_NAME,TOTAL_POINTS; 
 

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
-- how many points do customer A and B have at the end of January?
Select * from members;
select * from sales;
select * from menu;
SELECT DATE_ADD(day, 7, JOIN_date) FROM MEMBERS;
SELECT * FROM (SELECT *, DATE_ADD(JOIN_DATE, INTERVAL 7 DAY) FROM MEMBERS) T  ;

SELECT *,CASE WHEN S.ORDER_DATE BETWEEN (M.JOIN_DATE AND DATE_ADD(JOIN_DATE, INTERVAL 7 DAY)) THEN MM.PRICE*20 ELSE M.PRICE END AS TOTAL_POINTS
FROM MEMBERS M JOIN SALES S ON M.CUSTOMER_ID = S.CUSTOMER_ID 
JOIN MENU MM ON S.PRODUCT_ID = MM.PRODUCT_ID WHERE 
