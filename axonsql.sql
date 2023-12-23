use classicmodels;


-- ******total sales*********
create view totalsales as
select sum(quantityordered*priceeach) from classicmodels.orderdetails;
select * from totalsales;


-- ******top 5 products ordered********
create view top5productsordered as
select productcode,sum(quantityordered) from classicmodels.orderdetails group by 1 order by 2 desc limit 5;


-- **** top 5 countries by sales********
alter table classicmodels.orderdetails
add  totalprice float;
update classicmodels.orderdetails set totalprice=quantityordered*priceeach;
select (quantityordered*priceeach) as totalprice from classicmodels.orderdetails;
create view top5countriesbysales as
select sum(orderdetails.totalprice),country from classicmodels.orderdetails  left join classicmodels.orders using(ordernumber)
join classicmodels.customers using(customernumber) group by 2 order by 1 desc limit 5;
select * from  top5countriesbysales;


-- ******* top 5 customers by sales*********
create view top5customersbysales as
select sum(orderdetails.totalprice),customername from classicmodels.orderdetails  left join classicmodels.orders using(ordernumber)
join classicmodels.customers using(customernumber) group by 2 order by 1 desc limit 5;
select * from top5customersbysales;



-- *****sum of quantity ordered by productline*****
create view quantityorderedbyproductlines as
select productline,sum(quantityordered) from classicmodels.orderdetails join classicmodels.orders using(ordernumber) join classicmodels.products using(productcode) group by 1 order by 2 desc ;



-- *****top 5 products by revenue*********
create view top5productsbyrevenue as
select productcode,sum(totalprice) from classicmodels.orderdetails group by 1 order by 2 desc limit 5;

alter table products
add profit float;
update products set profit=(products.MSRP-products.buyprice);
select  profit from classicmodels.products;



-- ********top 5 products by profit************
create view top5productsbyprofit as 
select productcode,profit from products order by 2 desc limit 5;


-- ******sum of profit by productline*******
create view sumofprofitbyproductline as 
select productline,sum(profit) from products group by 1 order by 2 desc;
select * from sumofprofitbyproductline;


-- **********totalinvestmentbyproductline********
alter table products
add investment float;
update products set investment=quantityinstock*buyprice;
create view totalinvestmentbyproductline as 
select productline,sum(investment) from products group by 1 order by 2 desc;
select * from totalinvestmentbyproductline;



-- *********top5investmentsbyproductcode*********
create view top5investmentsbyproductcode as
select  productcode,investment from products order by 2 desc limit 5;



-- **********sum of revenue by office**********
alter table customers 
rename column salesrepemployeenumber to employeenumber;
create view sumofrevenuebyoffice as
select offices.city,sum(amount) from 
offices join employees using(officecode)
join customers using(employeenumber)
join payments using(customernumber)
group by 1 order by 2 desc ;
select * from sumofrevenuebyoffice;


-- **********top 5salespersonsbysalesamount**************
create view top5salespersonsbysalesamount as
select employeenumber,firstname,sum(amount),offices.city from payments join customers using(customernumber)
join employees using(employeenumber)
join offices using(officecode)
group by 1 order by 3 desc limit 5;



-- ********variety of products in each productline************
create view varietyofproductsineachproductline as
select productline,count(distinct productcode) from products group by 1 order by 2 desc;
select * from  varietyofproductsineachproductline;



-- *************totalquantityinstockbyproductline***********
create view  totalquantityinstockbyproductline as
select productline,sum(quantityinstock) from products group by 1 order by 2 desc;

-- ***********averagedeliveryforshippedproductsbyproductline*********
create view averagedeliveryforshippedproductsbyproductline as
select productline,avg(datediff(shippedDate,orderDate))from orders join orderdetails using(ordernumber)
join products using(productcode)  where ordernumber in (select ordernumber from orders where orders.status="shipped") group by 1 order by 2 desc;
select * from averagedeliveryforshippedproductsbyproductline;

-- *************distribution of customers by country***********
create view countofcustomersbycountry as 
select customers.country,count(customername) from customers group by 1  order by 2 desc;


-- ************customers over the years************
select year(orderdate),count(distinct customernumber)  from orders group by 1;
-- the result shows number of customers increased from 2003 to 2004 and decreased drastically from 2004 to 2005


-- **************number of transactions by customers per year*********
select year(orderdate),count(customernumber)  from orders group by 1;
-- the result shows number of customers increased from 2003 to 2004 and decreased drastically from 2004 to 2005










