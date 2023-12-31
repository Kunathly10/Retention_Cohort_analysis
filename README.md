# Retention_Cohort_analysis
# Cohort Analysis Project Report

## Introduction

This project report provides an overview of a cohort analysis performed on the `Company Project` dataset. The purpose of this analysis is to gain insights into customer retention rates and understand how different customer cohorts behave over time.

## Data Overview

The dataset contains the following columns:
- `order_id`: Unique identifier for each order.
- `account_id`: Unique identifier for each customer account.
- `start_date`: The date when the purchase was made.
- `plan`: The subscription plan chosen by the customer.
- `amount`: The amount of money spent by the customer.
- `currency`: The currency in which the purchase was made.

The dataset contains 14,788 records.

## Data Cleaning

To ensure the quality of the data and to check for duplicates, a duplicate check was performed on the dataset. No duplicate values were found in the dataset, indicating that the data is clean and there are no records that need to be removed.

## Cohort Analysis

The cohort analysis was conducted to understand customer retention rates over time. The analysis includes the following steps:

1. **Cohort Grouping**: Customers were grouped into cohorts based on their account_id, plan, and the month of their first purchase. This grouping allows us to track how different cohorts of customers behave over time.

2. **Cohort Index Calculation**: The cohort index was calculated by determining the time difference between a customer's start_date and the cohort's start_date. This index helps in tracking the number of months each customer has been active in their cohort.

3. **Cohort Retention Table**: The data was further transformed to create a cohort retention table, which shows how many customers from each cohort are active in each subsequent month.

4. **Cohort Retention Rates**: The retention rates were calculated as percentages, showing the percentage of customers from each cohort who remain active in subsequent months.

## Results

The following results were obtained from the cohort analysis:

- The cohort analysis revealed how different customer cohorts retain over time, providing insights into customer behavior.
- Retention rates were calculated for each cohort, indicating the percentage of customers who remain active in each subsequent month.
- The average retention rates for each subscription plan were calculated, providing insights into the performance of different plans.

## Conclusion

The cohort analysis provides valuable insights into customer retention and behavior. It can be used to make data-driven decisions regarding subscription plans, customer engagement, and marketing strategies. This analysis serves as a powerful tool for understanding and improving customer retention within the context of the `qustodio_project` dataset.

For more detailed analysis and insights, please refer to the specific SQL queries in the accompanying documentation.

