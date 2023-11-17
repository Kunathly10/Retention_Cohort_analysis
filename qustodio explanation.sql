--Starting
SELECT [order_id]
      ,[account_id]
      ,[start_date]
      ,[plan]
      ,[amount]
      ,[currency]
  FROM [model].[dbo].[qustodio_project]
-- We have 14,788 records
-- To check for duplicates
WITH sales_data AS (
  SELECT [order_id]
        ,[account_id]
        ,[start_date]
        ,[plan]
        ,[amount]
        ,[currency]
    FROM [model].[dbo].[qustodio_project]
)
, dup_check AS
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY order_id, account_id, [plan] ORDER BY start_date)dup_flag
	FROM sales_data
)

SELECT *
FROM dup_check

-- Transfer into a temp table
WITH sales_data AS (
  SELECT [order_id]
        ,[account_id]
        ,[start_date]
        ,[plan]
        ,[amount]
        ,[currency]
    FROM [model].[dbo].[qustodio_project]
)
, dup_check AS
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY order_id, account_id, [plan] ORDER BY start_date)dup_flag
	FROM sales_data
)

SELECT *
into #sales_data
FROM dup_check

---Cleaning Data
-- Appears that there are no duplicates value
-- There are 14,788 records to use for the analysis


----BEGIN COHORT ANALYSIS
select * from #sales_data

--Unique Identifier (accountid)
--Initial Start Date (First Invoice Date)
--amount
--plan
--Cohort grouping by date
-- To get the Cohort date
select
	account_id,
	[plan],
	min(start_date) first_purchase_date,
	DATEFROMPARTS(year(min(start_date)), month(min(start_date)), 1) Cohort_Date
from #sales_data
group by account_id, [plan]

-- Transfer into a temp table
select
	account_id,
	[plan],
	min(start_date) first_purchase_date,
	DATEFROMPARTS(year(min(start_date)), month(min(start_date)), 1) Cohort_Date
into #cohort
from #sales_data
group by account_id, [plan]

---Create Cohort Index
-- join the sales_data and the cohort records
-- Got the start year, start month, cohort year and cohort month
-- Then calculate the year and month difference 
-- After that then I used the formula "year_diff*12+month_diff+1" for the "COHORT INDEX"

SELECT mm.*,
		cohort_index = year_diff*12+month_diff+1
FROM


	(SELECT 
		m.*,
		year_diff = start_year - cohort_year,
		month_diff = start_month - cohort_month
	FROM
		(SELECT
			s.*,
			c.Cohort_Date,
			year(s.start_date) start_year,
			month(s.start_date) start_month,
			year(c.Cohort_date) cohort_year,
			month(c.Cohort_date) cohort_month
		from #sales_data s
		LEFT JOIN #cohort c
			on s.account_id = c.account_id
			) m
	)mm
ORDER BY account_id, Cohort_Date, cohort_index
--Transfer into a temp table
SELECT mm.*,
		cohort_index = year_diff*12+month_diff+1
INTO #cohort_retention
FROM


	(SELECT 
		m.*,
		year_diff = start_year - cohort_year,
		month_diff = start_month - cohort_month
	FROM
		(SELECT
			s.*,
			c.Cohort_Date,
			year(s.start_date) start_year,
			month(s.start_date) start_month,
			year(c.Cohort_date) cohort_year,
			month(c.Cohort_date) cohort_month
		from #sales_data s
		LEFT JOIN #cohort c
			on s.account_id = c.account_id
			) m
	)mm
-- customer index means the the number of months of purchase for each customer
-- To see the largest value for the cohort index
SELECT DISTINCT
		cohort_index
FROM #cohort_retention
ORDER BY 1 desc

-- Pivot data to see the cohort table
SELECT *
FROM

	(SELECT DISTINCT
			
			account_id,
			Cohort_Date,
			cohort_index,
			[plan]

	FROM #cohort_retention

	) tab1
	pivot(
	count(account_id)
	for Cohort_Index in
			([1],
			[2],
			[3],
			[4],
			[5],
			[6],
			[7],
			[8],
			[9],
			[10],
			[11],
			[12],
			[13],
			[14],
			[15],
			[16],
			[17],
			[18],
			[19],
			[20],
			[21],
			[22],
			[23],
			[24])
) as pivot_table
ORDER BY Cohort_Date
-- Transfering into a temp table

SELECT *
into #cohort_pivot
FROM

	(SELECT DISTINCT
			
			account_id,
			Cohort_Date,
			cohort_index,
			[plan]

	FROM #cohort_retention

	) tab1
	pivot(
	count(account_id)
	for Cohort_Index in
			([1],
			[2],
			[3],
			[4],
			[5],
			[6],
			[7],
			[8],
			[9],
			[10],
			[11],
			[12],
			[13],
			[14],
			[15],
			[16],
			[17],
			[18],
			[19],
			[20],
			[21],
			[22],
			[23],
			[24])
) as pivot_table

-- Converting to rates as percentages
SELECT 
			Cohort_Date, [plan],
			1.0 * [1] / [1] * 100 as [1],
			1.0 * [2] / [1] * 100 as [2],
			1.0 * [3] / [1] * 100 as [3],
			1.0 * [4] / [1] * 100 as [4],
			1.0 * [5] / [1] * 100 as [5],
			1.0 * [6] / [1] * 100 as [6],
			1.0 * [7] / [1] * 100 as [7],
			1.0 * [8] / [1] * 100 as [8],
			1.0 * [9] / [1] * 100 as [9],
			1.0 * [10] / [1] * 100 as [10],
			1.0 * [11] / [1] * 100 as [11],
			1.0 * [12] / [1] * 100 as [12],
			1.0 * [13] / [1] * 100 as [13],
			1.0 * [14] / [1] * 100 as [14],
			1.0 * [15] / [1] * 100 as [15],
			1.0 * [16] / [1] * 100 as [16],
			1.0 * [17] / [1] * 100 as [17],
			1.0 * [18] / [1] * 100 as [18],
			1.0 * [19] / [1] * 100 as [19],
			1.0 * [20] / [1] * 100 as [20],
			1.0 * [21] / [1] * 100 as [21],
			1.0 * [22] / [1] * 100 as [22],
			1.0 * [23] / [1] * 100 as [23],
			1.0 * [23] / [1] * 100 as [24]
FROM #cohort_pivot
ORDER BY Cohort_Date

-- To view the average  by plan
WITH RetentionPCT AS 
	(SELECT 
			Cohort_Date, [plan],
			1.0 * [1] / [1] * 100 as [1],
			1.0 * [2] / [1] * 100 as [2],
			1.0 * [3] / [1] * 100 as [3],
			1.0 * [4] / [1] * 100 as [4],
			1.0 * [5] / [1] * 100 as [5],
			1.0 * [6] / [1] * 100 as [6],
			1.0 * [7] / [1] * 100 as [7],
			1.0 * [8] / [1] * 100 as [8],
			1.0 * [9] / [1] * 100 as [9],
			1.0 * [10] / [1] * 100 as [10],
			1.0 * [11] / [1] * 100 as [11],
			1.0 * [12] / [1] * 100 as [12],
			1.0 * [13] / [1] * 100 as [13],
			1.0 * [14] / [1] * 100 as [14],
			1.0 * [15] / [1] * 100 as [15],
			1.0 * [16] / [1] * 100 as [16],
			1.0 * [17] / [1] * 100 as [17],
			1.0 * [18] / [1] * 100 as [18],
			1.0 * [19] / [1] * 100 as [19],
			1.0 * [20] / [1] * 100 as [20],
			1.0 * [21] / [1] * 100 as [21],
			1.0 * [22] / [1] * 100 as [22],
			1.0 * [23] / [1] * 100 as [23],
			1.0 * [23] / [1] * 100 as [24]

	FROM #cohort_pivot
	)
-- Calculate average retention rate for each plan
SELECT
  [plan],
  AVG([1]) AS Avg_Retention_1,
  AVG([2]) AS Avg_Retention_2,
  AVG([3]) AS Avg_Retention_3,
  AVG([4]) AS Avg_Retention_4,
  AVG([5]) AS Avg_Retention_5,
  AVG([6]) AS Avg_Retention_6,
  AVG([7]) AS Avg_Retention_7,
  AVG([8]) AS Avg_Retention_8,
  AVG([9]) AS Avg_Retention_9,
  AVG([10]) AS Avg_Retention_10,
  AVG([11]) AS Avg_Retention_11,
  AVG([12]) AS Avg_Retention_12,
  AVG([13]) AS Avg_Retention_13,
  AVG([14]) AS Avg_Retention_14,
  AVG([15]) AS Avg_Retention_15,
  AVG([16]) AS Avg_Retention_16,
  AVG([17]) AS Avg_Retention_17,
  AVG([18]) AS Avg_Retention_18,
  AVG([19]) AS Avg_Retention_19,
  AVG([20]) AS Avg_Retention_20,
  AVG([21]) AS Avg_Retention_21,
  AVG([22]) AS Avg_Retention_22,
  AVG([23]) AS Avg_Retention_23,
  AVG([24]) AS Avg_Retention_24
FROM RetentionPct
GROUP BY [plan]
ORDER BY [plan];

-- Just to see the amount generated by each plan
SELECT DISTINCT
      [account_id]
      ,[start_date]
      ,[plan]
      ,[amount]
      ,[currency],
	sum_total = SUM(amount) OVER(PARTITION BY ([plan])) 
  FROM [model].[dbo].[qustodio_project]
