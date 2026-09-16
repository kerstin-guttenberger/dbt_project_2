with orders as (
    select * from {{ source('default', 'jaffle_shop_orders') }}  -- or {{ ref('stg_orders') }}
),

monthly as (
    select
        extract(month from order_date) as order_month,
        count(user_id) as total_customers,
        count(case when status in ('returned', 'return_pending') then user_id end) as cust_returns
    from orders
    group by 1
)

select
    order_month,
    total_customers,
    cust_returns,
    round(cust_returns / nullif(total_customers, 0) * 100, 2) as return_rate
from monthly
order by order_month desc