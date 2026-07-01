++++++++++++++++++++++++++++++++++++++

++++ Data Model Review

++++++++++++++++++++++++++++++++++++++

Document Information
====================

Item            Value
--------------------------
Project ::			E-Commerce Analytics

Author ::			Partha Basak

Version ::			1.0

Date ::			    30/06/2026


Business Problem
=================

The business requires a centralized analytics data warehouse to analyze revenue, customers, products, sellers, payments and delivery performance. The raw csv file can not be used for reporting due to normalization, inconsistance data.


Source Systems
=================

File format :: csv
Source of:: customers, orders, product, sellers, paayments, reviews, order items


Business Requirements
======================

The business should be able to answer

	- Monthly revenue
	- Revenue by product category
	- Revenuue by sellers
	- Top customers
	- Delivery delays
	- Repeat customers
	- Average purchase rate
	- Average order Value
	- Customer geography
	- Product category performance
	
Grain Definition
=====================

Table :: Fact orders
Grain  :: One row per order
	
Table :: Fact orders items
Grain  :: One row per product within an order	

Table :: Fact payments
Grain  :: One row per payment transaction

Table :: Dimension Customers
Grain  :: One row per customer

Table :: Dimension Product
Grain  :: One row per product

Table :: Dimension Seller
Grain  :: One row per seller


Star Schema
==============

ER Diagram

<!DOCTYPE html>
<html>
<head>
<title>er_diagram.html</title>
<meta charset="utf-8"/>
</head>
<body>
<div class="mxgraph" style="max-width:100%;border:1px solid transparent;" data-mxgraph="{&quot;highlight&quot;:&quot;#0000ff&quot;,&quot;nav&quot;:true,&quot;resize&quot;:true,&quot;xml&quot;:&quot;&lt;mxfile host=\&quot;app.diagrams.net\&quot;&gt;&lt;diagram name=\&quot;Page-1\&quot; id=\&quot;_11cyzUqbrWJtUu7rR72\&quot;&gt;&lt;mxGraphModel dx=\&quot;1414\&quot; dy=\&quot;743\&quot; grid=\&quot;1\&quot; gridSize=\&quot;10\&quot; guides=\&quot;1\&quot; tooltips=\&quot;1\&quot; connect=\&quot;1\&quot; arrows=\&quot;1\&quot; fold=\&quot;1\&quot; page=\&quot;1\&quot; pageScale=\&quot;1\&quot; pageWidth=\&quot;827\&quot; pageHeight=\&quot;1169\&quot; math=\&quot;0\&quot; shadow=\&quot;0\&quot;&gt;&lt;root&gt;&lt;mxCell id=\&quot;0\&quot;/&gt;&lt;mxCell id=\&quot;1\&quot; parent=\&quot;0\&quot;/&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-1\&quot; parent=\&quot;1\&quot; style=\&quot;rounded=0;whiteSpace=wrap;html=1;\&quot; value=\&quot;Fact Orders\&quot; vertex=\&quot;1\&quot;&gt;&lt;mxGeometry height=\&quot;40\&quot; width=\&quot;120\&quot; x=\&quot;350\&quot; y=\&quot;470\&quot; as=\&quot;geometry\&quot;/&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-3\&quot; parent=\&quot;1\&quot; style=\&quot;rounded=0;whiteSpace=wrap;html=1;\&quot; value=\&quot;Dimension Customer\&quot; vertex=\&quot;1\&quot;&gt;&lt;mxGeometry height=\&quot;40\&quot; width=\&quot;120\&quot; x=\&quot;350\&quot; y=\&quot;390\&quot; as=\&quot;geometry\&quot;/&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-4\&quot; edge=\&quot;1\&quot; parent=\&quot;1\&quot; source=\&quot;Orq65L6ts-I6RwSXNnL5-3\&quot; style=\&quot;endArrow=classic;html=1;rounded=0;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;\&quot; target=\&quot;Orq65L6ts-I6RwSXNnL5-1\&quot; value=\&quot;\&quot;&gt;&lt;mxGeometry height=\&quot;50\&quot; relative=\&quot;1\&quot; width=\&quot;50\&quot; as=\&quot;geometry\&quot;&gt;&lt;mxPoint x=\&quot;390\&quot; y=\&quot;510\&quot; as=\&quot;sourcePoint\&quot;/&gt;&lt;mxPoint x=\&quot;440\&quot; y=\&quot;460\&quot; as=\&quot;targetPoint\&quot;/&gt;&lt;/mxGeometry&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-5\&quot; parent=\&quot;1\&quot; style=\&quot;rounded=0;whiteSpace=wrap;html=1;\&quot; value=\&quot;Dimension Date\&quot; vertex=\&quot;1\&quot;&gt;&lt;mxGeometry height=\&quot;40\&quot; width=\&quot;120\&quot; x=\&quot;200\&quot; y=\&quot;470\&quot; as=\&quot;geometry\&quot;/&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-6\&quot; parent=\&quot;1\&quot; style=\&quot;rounded=0;whiteSpace=wrap;html=1;\&quot; value=\&quot;Dimension Seller\&quot; vertex=\&quot;1\&quot;&gt;&lt;mxGeometry height=\&quot;40\&quot; width=\&quot;120\&quot; x=\&quot;510\&quot; y=\&quot;470\&quot; as=\&quot;geometry\&quot;/&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-7\&quot; edge=\&quot;1\&quot; parent=\&quot;1\&quot; source=\&quot;Orq65L6ts-I6RwSXNnL5-5\&quot; style=\&quot;endArrow=classic;html=1;rounded=0;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;\&quot; target=\&quot;Orq65L6ts-I6RwSXNnL5-1\&quot; value=\&quot;\&quot;&gt;&lt;mxGeometry height=\&quot;50\&quot; relative=\&quot;1\&quot; width=\&quot;50\&quot; as=\&quot;geometry\&quot;&gt;&lt;mxPoint x=\&quot;390\&quot; y=\&quot;510\&quot; as=\&quot;sourcePoint\&quot;/&gt;&lt;mxPoint x=\&quot;440\&quot; y=\&quot;460\&quot; as=\&quot;targetPoint\&quot;/&gt;&lt;/mxGeometry&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-8\&quot; edge=\&quot;1\&quot; parent=\&quot;1\&quot; source=\&quot;Orq65L6ts-I6RwSXNnL5-6\&quot; style=\&quot;endArrow=classic;html=1;rounded=0;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;\&quot; target=\&quot;Orq65L6ts-I6RwSXNnL5-1\&quot; value=\&quot;\&quot;&gt;&lt;mxGeometry height=\&quot;50\&quot; relative=\&quot;1\&quot; width=\&quot;50\&quot; as=\&quot;geometry\&quot;&gt;&lt;mxPoint x=\&quot;390\&quot; y=\&quot;510\&quot; as=\&quot;sourcePoint\&quot;/&gt;&lt;mxPoint x=\&quot;440\&quot; y=\&quot;460\&quot; as=\&quot;targetPoint\&quot;/&gt;&lt;/mxGeometry&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-9\&quot; parent=\&quot;1\&quot; style=\&quot;rounded=0;whiteSpace=wrap;html=1;\&quot; value=\&quot;Fact Order Items\&quot; vertex=\&quot;1\&quot;&gt;&lt;mxGeometry height=\&quot;40\&quot; width=\&quot;120\&quot; x=\&quot;350\&quot; y=\&quot;545\&quot; as=\&quot;geometry\&quot;/&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-10\&quot; parent=\&quot;1\&quot; style=\&quot;rounded=0;whiteSpace=wrap;html=1;\&quot; value=\&quot;Dimension Product\&quot; vertex=\&quot;1\&quot;&gt;&lt;mxGeometry height=\&quot;40\&quot; width=\&quot;120\&quot; x=\&quot;350\&quot; y=\&quot;620\&quot; as=\&quot;geometry\&quot;/&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-11\&quot; parent=\&quot;1\&quot; style=\&quot;rounded=0;whiteSpace=wrap;html=1;\&quot; value=\&quot;Fact Payments\&quot; vertex=\&quot;1\&quot;&gt;&lt;mxGeometry height=\&quot;40\&quot; width=\&quot;120\&quot; x=\&quot;350\&quot; y=\&quot;690\&quot; as=\&quot;geometry\&quot;/&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-12\&quot; edge=\&quot;1\&quot; parent=\&quot;1\&quot; style=\&quot;endArrow=classic;html=1;rounded=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;\&quot; target=\&quot;Orq65L6ts-I6RwSXNnL5-1\&quot; value=\&quot;\&quot;&gt;&lt;mxGeometry height=\&quot;50\&quot; relative=\&quot;1\&quot; width=\&quot;50\&quot; as=\&quot;geometry\&quot;&gt;&lt;mxPoint x=\&quot;410\&quot; y=\&quot;540\&quot; as=\&quot;sourcePoint\&quot;/&gt;&lt;mxPoint x=\&quot;440\&quot; y=\&quot;460\&quot; as=\&quot;targetPoint\&quot;/&gt;&lt;/mxGeometry&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-13\&quot; edge=\&quot;1\&quot; parent=\&quot;1\&quot; source=\&quot;Orq65L6ts-I6RwSXNnL5-10\&quot; style=\&quot;endArrow=classic;html=1;rounded=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;exitX=0.5;exitY=0;exitDx=0;exitDy=0;\&quot; target=\&quot;Orq65L6ts-I6RwSXNnL5-9\&quot; value=\&quot;\&quot;&gt;&lt;mxGeometry height=\&quot;50\&quot; relative=\&quot;1\&quot; width=\&quot;50\&quot; as=\&quot;geometry\&quot;&gt;&lt;mxPoint x=\&quot;410\&quot; y=\&quot;610\&quot; as=\&quot;sourcePoint\&quot;/&gt;&lt;mxPoint x=\&quot;470\&quot; y=\&quot;560\&quot; as=\&quot;targetPoint\&quot;/&gt;&lt;/mxGeometry&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-14\&quot; edge=\&quot;1\&quot; parent=\&quot;1\&quot; source=\&quot;Orq65L6ts-I6RwSXNnL5-11\&quot; style=\&quot;endArrow=classic;html=1;rounded=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;exitX=0.5;exitY=0;exitDx=0;exitDy=0;\&quot; target=\&quot;Orq65L6ts-I6RwSXNnL5-10\&quot; value=\&quot;\&quot;&gt;&lt;mxGeometry height=\&quot;50\&quot; relative=\&quot;1\&quot; width=\&quot;50\&quot; as=\&quot;geometry\&quot;&gt;&lt;mxPoint x=\&quot;210\&quot; y=\&quot;755\&quot; as=\&quot;sourcePoint\&quot;/&gt;&lt;mxPoint x=\&quot;210\&quot; y=\&quot;720\&quot; as=\&quot;targetPoint\&quot;/&gt;&lt;/mxGeometry&gt;&lt;/mxCell&gt;&lt;mxCell id=\&quot;Orq65L6ts-I6RwSXNnL5-15\&quot; parent=\&quot;1\&quot; style=\&quot;rounded=0;whiteSpace=wrap;html=1;fillColor=light-dark(#FFFFFF,#B266FF);\&quot; value=\&quot;&amp;lt;font style=&amp;quot;font-size: 18px;&amp;quot;&amp;gt;ER DIAGRAM&amp;lt;/font&amp;gt;\&quot; vertex=\&quot;1\&quot;&gt;&lt;mxGeometry height=\&quot;50\&quot; width=\&quot;400\&quot; x=\&quot;200\&quot; y=\&quot;280\&quot; as=\&quot;geometry\&quot;/&gt;&lt;/mxCell&gt;&lt;/root&gt;&lt;/mxGraphModel&gt;&lt;/diagram&gt;&lt;/mxfile&gt;&quot;,&quot;toolbar&quot;:&quot;pages zoom layers lightbox&quot;,&quot;page&quot;:0}"></div>
<script type="text/javascript" src="https://app.diagrams.net/js/viewer-static.min.js"></script>
</body>
</html>

