--Dataset: Bitcoin and Ethereum Historical Dataset
--Source: yahoofinance.com and coingecko.com
--Queried using: SSMS
--Queried by: @IdrisOnX (Twitter), @IdrisOnIn (Linkedin)


--Display bitcoin historical data
SELECT * FROM BTC;

--Check the latest date on the bitcoin historical dataset
SELECT * FROM BTC
Order by date DESC;

--Display ethereum historical data
SELECT * FROM ETH;

--Check the latest date on the ethereum historical dataset
SELECT * FROM ETH
Order by date DESC;


--Verify number of rows for both BTC and ETH respectively to make sure their rows are of thesame lenght
SELECT count(date) number_of_rows_for_btc
FROM BTC;

SELECT count(date) number_of_rows_for_eth
FROM ETH;

--Calculate the average prices of bitcoin for the past five years and two months
SELECT "date",AVG("close") btc_average_price
FROM BTC
WHERE "date" IS NOT NULL
GROUP BY "date";

--Calculate the average price for ethereum for the past five years and two months
SELECT "date", AVG("close") eth_average_price
FROM ETH
WHERE "date" IS NOT NULL
GROUP BY "date"
order by "Date" desc;

/* 
OR you just use the below to extract the average price for each currencies;
SELECT "date", "adj_close"
FROM ETH
order by "date" desc;
*/

--veiw the total volumn for bitcoin and erthereum respectively
SELECT "date", "Total_Volume" btc_volume
FROM BTC
WHERE "date" IS NOT NULL
order by "date" desc;


SELECT "date", "Total_Volume" eth_volume
FROM ETH
WHERE "date" IS NOT NULL
order by "date" desc;

--Calculate the overall average market capitalization for bitcoin for the past five years till last date on the data set
SELECT AVG(market_cap) Btc_Avg_MCap
FROM BTC;

--Calculate the overall average market capitalization for ethereum for the past five years till last date on the data set
SELECT AVG(market_cap) Eth_Avg_MCap
FROM ETH;


--calculations of the 30days moving averages for bitcoin and ethereum
SELECT
    date,"close",
    AVG("close") OVER (
        ORDER BY date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS 'btc_30days_moving_average'
FROM
    btc
	WHERE "close" IS NOT NULL
	ORDER BY "date";


SELECT
    date,"close",
    AVG("close") OVER (
        ORDER BY date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS 'eth_30days_moving_average'
FROM
    eth
	WHERE "close" IS NOT NULL
	ORDER BY "date";


--calculate the percentage change in price for both bitcoin and ethereum respectively
SELECT
   "date", "close",
    ("close" - LAG("close")
    OVER (ORDER BY "date")) / LAG("close") 
	OVER (ORDER BY "date") * 100 Percentage_Change_in_Price
FROM "btc"
WHERE "close" IS NOT NULL;


SELECT
   "date", "close",
    ("close" - LAG("close")
    OVER (ORDER BY "date")) / LAG("close") 
	OVER (ORDER BY "date") * 100 Percentage_Change_in_Price
FROM "eth"
WHERE "close" IS NOT NULL;


/*so i got curious about how bitcoin and ethereum contributed to the overall worth of the crypto market. 
this is where the introduction of market capitalization comes into the queries, 
and also importation of a new dataset to enable answering a few important queestion.

now after the importation of a new dataset(Total_MC) containing the 
historical total market capitalization of the crytocurrency market, i can now proceed answering the questions needed to drive at a conclusion
*/

--lets first of all veiw the dataset
SELECT *
	FROM Total_MC

--now lets view that(Market_Cap) of bitcoin and ethereum respectively
SELECT "date","Market_Cap"
	FROM Btc

SELECT "date","Market_Cap"
	FROM Eth

--next, i subtract the market cap value of both bitcoin and ethereum from the value of total crypto market capitalization
SELECT T."date", T."Market_Cap" - COALESCE(b."Market_Cap", 0)
-COALESCE(e."Market_Cap", 0) Others, b."Market_Cap" Bitcoin_MC, e."Market_Cap" Ethereum_MC
FROM Total_MC as T
LEFT JOIN btc b ON T."date" = b."date"
LEFT JOIN eth e ON T."date" = e."date";

--the moment of truth, where the percentage contributions of bitcoin and ethereum to the crytocurrency market will be calculated
SELECT T."date", 
b."Market_Cap" / t."Market_Cap" * 100 Bitcoin_MC, 
e."Market_Cap" / t."Market_Cap" * 100 Ethereum_MC,
(T."Market_Cap" - COALESCE(b."Market_Cap", 0) - COALESCE(e."Market_Cap", 0)) /COALESCE(t."Market_Cap", 0) * 100 Others_MC
FROM Total_MC as T
LEFT JOIN btc b ON T."date" = b."date"
LEFT JOIN eth e ON T."date" = e."date";


--get the latest market dominance for btc, and eth against other currencies

/*
I will have to perform web scraping for this to work, but SQL itself wasn't designed for web scraping. 
SQL is a language used for managing and querying data in relational database management systems (RDBMS). 
It's primarily used for tasks such as data retrieval, insertion, updating, and deletion within a database.

While SQL can interact with web data through databases where web data might be stored, 
it doesn't provide native capabilities for web scraping. To perform web scraping, 
i would generally utilize a visualization tool of choice or a programming language like Python along with appropriate libraries.
Checkout my PowerBi visual(s) to see the the outcome of the webscrabing carried out.
*/
