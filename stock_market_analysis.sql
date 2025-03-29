create database stocks_analysis;

use stocks_analysis;

create table market_data(
	stock_id varchar(10),
    trade_date date,
    open_price decimal(9,2),
    close_price decimal(9,2),
    high_price decimal(9,2),
    low_price decimal(9,2),
    volume int,
    primary key (stock_id, trade_date));
    
select * 
from market_data;



-- Daily Price Change/Movement
/*
This query calculates the absolute price movement for each stock by computing the difference between the closing and opening prices on a given day.
Helps identify daily gainers and losers in the stock market. 
*/
select stock_id, trade_date, close_price-open_price as price_change
from market_data;


-- 7-Day Moving Average
/*
A moving average smooths out price fluctuations and identifies trends over time. This query calculates the 7-day moving average of closing prices.
Investors use moving averages to filter out short-term price fluctuations and detect ongoing trends.
*/
select stock_id, trade_date, avg(close_price)over(partition by stock_id order by trade_date rows between 6 preceding and current row) as moving_avg_7d
from market_data;


-- Highest & Lowest Prices of a stock in a month
/*
This query extracts the highest and lowest stock prices within each month to track overall market performance.
Useful for identifying historical resistance and support levels in trading.
*/
select stock_id, date_format(trade_date, "%Y-%m") as `month`, max(high_price) as max_price, min(low_price) as min_price
from market_data
group by stock_id, `month`;


-- Volatility Analysis
/*
Stock volatility is a measure of risk and market uncertainty.
High volatility signals higher risk & greater price fluctuations.
*/
select stock_id, trade_date, (high_price - low_price) / low_price * 100 as volatility_percentage
from market_data;


-- Best Performing Stocks in the Last Month
/*
This query identifies stocks with the highest returns in the last month by computing percentage growth.
Investors can use this to spot strong-performing stocks for potential investment.
*/
select stock_id, (max(close_price)-min(open_price))/min(open_price) * 100 AS monthly_return
from market_data
where trade_date>=date_sub(curdate(), interval 1 month)
group by stock_id
order by monthly_return desc;

















