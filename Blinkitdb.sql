Drop table if exists Blinkitdata ;
--Create table BlinkitData
Create table BlinkitData(Item_Fat_Content Varchar(50),
						 Item_Identifer Varchar(50),Item_Type Varchar(50),
						 Outlet_Establishment_Year int,Outlet_Identifier Varchar(50),
				  Outlet_Location_Type Varchar(50),Outlet_Size Varchar(50),Outlet_Type Varchar(50),
				 Item_Visibility numeric(10,9),Item_Weight numeric(10,2),Sales numeric(10,6),Rating numeric(10,2));


--Import the data of Blinkit to database
Copy BlinkitData(Item_Fat_Content,Item_Identifer,Item_Type,Outlet_Establishment_Year,Outlet_Identifier,
				  Outlet_Location_Type,Outlet_Size,Outlet_Type,Item_Visibility,Item_Weight,Sales,Rating)
from 'C:\Program Files\PostgreSQL\16\data\Files\BlinkitData.csv'
CSV Header;

Select * from BlinkitData;

Select count(*) from BlinkitData;

--Data Cleaning
Update BlinkitData
Set Item_Fat_Content=
CASE
When Item_Fat_Content IN ('LF','low fat') Then 'Low Fat'
When Item_Fat_Content='reg' Then 'Regular'
Else Item_Fat_Content
End;

Select distinct Item_Fat_Content  from BlinkitData;    --To verify the output

------******----KPI'S Requirements--------------******--------------:
--Total Sales: The overall revenue generated from all the items sold:
Select concat(cast(sum(sales)/1000000 as Decimal(10,2)),'M') as Total_sales_Millions from blinkitData;

--Average Sales: The average revenue per sale:
Select cast(avg(Sales) as decimal(10,1)) as Average_Sales from BlinkitData;

--No of items: The total count of different items sold:
Select count(*) as No_of_Items from BlinkitData;

--Average Rating: The average customer rating of items sold:
Select cast(avg(Rating) as decimal(10,2))as Average_Rating from BlinkitData;

-----------*******----Granular Requirements-----******------:
--Total Sales,Average Sales,No.of Items sold,Average Rating by Fat Content:
Select Item_Fat_Content, 
            concat(cast(sum(sales)/1000 as decimal(10,2)),'K') as Total_sales_Thousands,
			 cast(avg(sales)as decimal (10,1)) as Average_sales,
			 count(*) as No_of_Items, cast(avg(Rating) as decimal(10,2)) as Average_Rating
from BlinkitData
Group by Item_Fat_Content
Order by Total_Sales_Thousands Desc;


--Total sales,Average Sales,No.of Items sold,Average Rating by Item Type:
Select Item_Type, 
            cast(sum(sales) as decimal(10,2))as Total_sales,
			 cast(avg(sales)as decimal (10,1)) as Average_sales,
			 count(*) as No_of_Items, cast(avg(Rating) as decimal(10,2)) as Average_Rating
from BlinkitData
Group by Item_Type
Order by Total_Sales Desc;

--Fat Content by outlet for total sales,Average Sales,No.of Items sold,Average Rating:
Select outlet_Location_Type,Item_Fat_Content,
            cast(sum(sales) as decimal(10,2))as Total_sales,
			 cast(avg(sales)as decimal (10,1)) as Average_sales,
			 count(*) as No_of_Items, cast(avg(Rating) as decimal(10,2)) as Average_Rating
from BlinkitData
Group by outlet_Location_Type,Item_Fat_Content
Order by outlet_Location_Type,Item_Fat_Content desc;


--Total Sales,Average Sales,No.of Items sold,Average Rating by Outlest Establishment:
Select outlet_establishment_year,
            cast(sum(sales) as decimal(10,2))as Total_sales,
			 cast(avg(sales)as decimal (10,1)) as Average_sales,
			 count(*) as No_of_Items, 
			 cast(avg(Rating) as decimal(10,2)) as Average_Rating
from BlinkitData
Group by outlet_establishment_year
Order by Total_sales desc;

------------*****----Chart's Requirements-----****------------:
--Percentage of Sales By oulet Size:
Select outlet_size, 
           cast(sum(Sales)as decimal(10,2)) as Total_Sales,
		   cast((sum(sales) * 100.0 / sum(sum(sales)) over()) as decimal(10,2))as Sales_Percentage
from blinkitdata
Group by outlet_size
Order by Total_Sales desc;

--Sales by Outlet Locations:
Select outlet_location_type, 
            cast(sum(sales) as decimal(10,2))as Total_sales,
			cast(avg(sales)as decimal(10,1))as Average_sales,
			count(*) as No_of_Items, 
			cast(avg(Rating) as decimal(10,2)) as Average_Rating
from Blinkitdata
Group by outlet_location_type
order by Total_sales desc;


--All Metrics by Outlet type:
Select outlet_type, 
             cast(sum(sales) as decimal(10,2))as Total_sales,
			 cast(avg(sales)as decimal(10,1))as Average_sales,
			 count(*) as No_of_Items, 
			 cast(avg(Rating) as decimal(10,2)) as Average_Rating
from Blinkitdata
Group by outlet_type
order by Total_sales desc;
