---to print top 5 selling products from each category by sales


select top 2  * from Superstore_orders; 





with cat_product_sales as (

select category,product_id,sum(sales) as category_sales
from Superstore_orders
group by category,product_id )

,rnk_sales as (select *
,rank() over(partition by category order by category_sales desc) as rn
from cat_product_sales)

select * from
rnk_sales
where rn<=5;