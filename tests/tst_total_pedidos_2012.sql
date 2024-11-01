 /* Teste da quantidade de pedidos em 2012 auditado pelo comercial */
 
{{ config (
        severity = 'error'
    )
}}
 
 with
    qnt_compras as (
        select 
            COUNT(DISTINCT fk_pedido) as total_pedidos
        from {{ ref('fct_vendas') }}
        where data_pedido between '2012-01-01' and '2012-12-31'
        --3915
    )
select total_pedidos
from qnt_compras
where total_pedidos = 3915