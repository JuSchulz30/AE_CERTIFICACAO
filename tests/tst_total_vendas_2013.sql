/* Teste de vendas brutas no ano de 2013 - Auditado por Carlos 
 Total = $12.646.112,1607 */

/* Teste da quantidade de pedidos em 2013 auditado pela contabilidade */
 
{{ config (
        severity = 'error'
    )
}}
 
 with
    vendas_2013 as (
        select 
            COUNT(DISTINCT fk_pedido) as total_pedidos
        from {{ ref('fct_vendas') }}
        where data_pedido between '2013-01-01' and '2013-12-31'
        --3915
    )
select total_pedidos
from vendas_2013
where total_pedidos = 4182