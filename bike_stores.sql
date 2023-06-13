select
	a.order_id,
	a.order_date,
	concat(b.first_name,' ', b.last_name) as customers,
	b.city,
	b.state,
	sum(c.quantity) as qtde,
	sum(c.quantity * c.list_price) as revenue,
	d.product_name,
	f.category_name,
	e.store_name,
	concat(g.first_name,' ', g.last_name) as seller
from sales.orders as a
join sales.customers as b on a.customer_id = b.customer_id
join sales.order_items as c on a.order_id = c.order_id
join production.products as d on c.product_id = d.product_id
join production.categories as f on d.category_id = f.category_id
join sales.stores as e on a.store_id = e.store_id
join sales.staffs as g on a.staff_id = g.staff_id
group by
	a.order_id, concat(b.first_name,' ', b.last_name), a.order_date, b.city, b.state, product_name, category_name, e.store_name, concat(g.first_name,' ', g.last_name)
order by a.order_id

