/*

Análise Exploratória com SQL Server

*/

select * from [dbo].[bike_stores_analysis]


-- Qual o faturamento total?

select
	sum(revenue) as FaturamentoTotal
from bike_stores_analysis

-- Qual a quantidade total de vendas?

select
	sum(qtde) as QtdeTotal
from bike_stores_analysis


-- Quanto foi o total e a média de faturamento por ano?

select
	year(order_date) as Ano,
	sum(revenue) as TotalFaturamento,
	avg(revenue) as MediaFaturamento
from bike_stores_analysis
group by year(order_date)

-- Qual são os produtos que mais faturam?

select top(10)
	product_name as Produto,
	sum(revenue) as TotalFaturamento
from bike_stores_analysis
group by product_name
order by TotalFaturamento desc


-- Qual é o ticket médio por produtos?

select
	product_name as Produto,
	(sum(revenue) / sum(qtde)) as TicketMedio
from bike_stores_analysis
group by product_name
order by TicketMedio desc

-- Qual foi a quantidade de vendas, a média e o faturamento total por vendedores em 2016?

select
	year(order_date) as Ano,
	seller as Vendedor,
	sum(revenue) as FaturamentoTotal,
	avg(revenue) as MediaFaturamento,
	sum(qtde) as QtdeVendas
from bike_stores_analysis
where year(order_date) like '2016'
group by year(order_date), seller
order by FaturamentoTotal desc

-- Qual foi o total e a média de faturamento por loja em 2018?

select distinct
	year(order_date) as Ano,
	store_name as Loja,
	sum(revenue) over(partition by store_name) as FaturamentoTotal,
	avg(revenue) over(partition by store_name) as MediaFaturamento
from bike_stores_analysis
where year(order_date) like '2018'
order by FaturamentoTotal desc

-- Quais são as categorias?

select distinct
	category_name as Categoria
from bike_stores_analysis


-- Quantidade de produtos distintos por categoria?

select distinct
	category_name as Categoria,
	count(distinct product_name) as QtdProduto
from bike_stores_analysis
group by category_name


-- Qual a categoria com a maior quantidade de vendas?

select distinct top(1)
	category_name as Categoria,
	sum(qtde) as Qtde
from bike_stores_analysis
group by category_name
order by Qtde desc

-- Qual a categoria com o maior faturamento em vendas?

select distinct top(1)
	category_name as Categoria,
	sum(revenue) as FaturamentoTotal
from bike_stores_analysis
group by category_name
order by FaturamentoTotal desc


-- Quais são os clientes com maior faturamento?

select distinct top(10)
	customers as Cliente,
	sum(qtde) over(partition by customers) as Qtde,
	sum(revenue) over( partition by customers) as FaturamentoTotal
from bike_stores_analysis
order by FaturamentoTotal desc

-- Quais as cidade com menos representatividade em vendas?

select distinct top(10)
	city,
	state,
	sum(revenue) as FaturamentoTotal
from bike_stores_analysis
group by city, state
order by FaturamentoTotal

-- Qual o produto mais vendido na cidade com menos vendas?

select distinct top(1)
	product_name as Produto,
	sum(qtde) as QtdeVendas,
	sum(revenue) as Faturamento
from bike_stores_analysis
where city like 'Tonawanda'
group by product_name
order by QtdeVendas desc

-- Qual a variação de faturamento ano contra ano (YoY)?

select
  Ano, 
  Faturamento, 
  (Faturamento / nullif(lag(Faturamento) 
  over(order by Ano), 0)-1) * 100 as VarAnoAnterior
from
  (
    select
      year(order_date) as Ano, 
	  sum(revenue) as Faturamento
    from bike_stores_analysis
    group by year(order_date)
  )
  VarAnoAnterior