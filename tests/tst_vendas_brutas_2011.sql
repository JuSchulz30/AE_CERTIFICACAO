/* Teste de vendas brutas no ano de 2011 - Auditado por Carlos 
 Total = $12.646.112,1607 */

with vendas_2011 as (
    select 
        --SUM(preco_unitario * qtd_pedido) as vendas_brutas
        ROUND(SUM(preco_unitario * qtd_pedido), 4) AS vendas_brutas
    from {{ ref('int_ordersdetail') }}
    where data_pedido between '2011-01-01' and '2011-12-31'
)

select
    vendas_brutas
from vendas_2011
where vendas_brutas <> 12646112.1607
