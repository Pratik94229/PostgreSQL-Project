# This repository contains the code and analysis for a PostgreSQL project on a superstore dataset. The dataset consists of various columns representing different aspects of customer orders and products. The following is a description of the dataset columns:

    1) Customer_Name: Customer's Name
    2) Customer_Id: Unique ID of Customers
    3) Segment: Product Segment
    4) Country: United States
    5) City: City of the product ordered
    6) State: State of the product ordered
    7) Product_Id: Unique Product ID
    8) Category: Product category
    9) Sub_Category: Product subcategory
    10) Product_Name: Name of the product
    11) Sales: Sales contribution of the order
    12) Quantity: Quantity Ordered
    13) Discount: Percentage discount given
    14) Profit: Profit for the order
    15) Discount_Amount: Discount amount of the product
    16) Customer Duration: New or Old Customer
    17) Returned_Item: Whether the item was returned or not
    18) Returned_Reason: Reason for returning the item

# Exploratory Data Analysis (EDA)

The project begins with an exploratory data analysis of the dataset. The following EDA steps were performed:

    Checked the number of rows and columns in the dataset.
    Examined the presence of any null values in the dataset.

# Product Level Analysis

### The analysis then focuses on the product level, exploring various aspects of the products in the dataset. The following operations were performed:

    1) Identified the unique product categories in the dataset.
    2) Determined the number of products in each category.
    3) Found the number of subcategories products are divided into.
    4) Calculated the number of products in each subcategory.
    5) Identified the number of unique product names.
    6) Identified the top 10 frequently ordered products.
    7) Calculated the cost for each Order_ID with respective Product Name.
    8) Calculated the percentage profit for each Order_ID with respective Product Name.
    9) Calculated the overall profit of the store.
    10) Identified products with below-average sales and profits for potential optimization.

# Customer Level Analysis

### The analysis then shifts to the customer level, examining various characteristics and behaviors of customers. The following operations were performed:

    1) Determined the number of unique customer IDs.
    2) Identified customers who registered during the years 2014-2016.
    3) Calculated the total frequency of each Order_ID by each customer name in descending order.
    4) Calculated the cost of each customer name.
    5) Displayed the number of customers in each region in descending order.
    6) Identified the top 10 customers who order frequently.
    7) Displayed the records for customers living in the state of California with postal code 90032.
    8) Identified the top 20 customers who benefited the store.
    9) Identified the most successful and least successful states for the superstore.

# Order Level Analysis

### The analysis then focuses on order-level characteristics and patterns. The following operations were performed:

    1) Determined the number of unique orders.
    2) Calculated the sum total sales of the superstore.
    3) Calculated the time taken for an order to ship and converted it into the number of days in integer format.
    4) Extracted the year for respective Order_ID and Customer ID with quantity.
    5) Analyzed the sales impact on a yearly basis.
    6) Identified the top and worst sellers in terms of categories and sub-categories.

# Return Level Analysis

### The analysis then explores returns and reasons for returning items. The following operations were performed:

    1) Determined the number of returned orders.
    2) Identified the top 10 returned categories.
    3) Identified the top 10 returned sub-categories.
    4) Identified the top 10 customers who returned
