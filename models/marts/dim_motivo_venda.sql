with stg_salesorderheadersalesreason as (
    select *
    from {{ref('stg_salesorderheadersalesreason')}}
)

, stg_salesreason as (
    select *
    from {{ref('stg_salesreason')}}
)

, reasonbyorderid as (
    select 
        stg_salesorderheadersalesreason.fk_pedido as id_pedido_venda
        , stg_salesreason.motivo_venda as motivo_venda
    from stg_salesorderheadersalesreason
    left join stg_salesreason on stg_salesorderheadersalesreason.fk_motivo_venda = stg_salesreason.pk_motivo_venda
)

, transformed as (
    select
        -- Criado a chave surrogada para o id pedido de venda.
        {{ dbt_utils.generate_surrogate_key(
                    ['id_pedido_venda']
                )
            }} as sk_pedido_venda
        , id_pedido_venda
        -- função usada para agregar em uma linha quaisquer motivos múltiplos atribuídos a um único pedido.
        , listagg(motivo_venda, ', ') within group (order by motivo_venda asc) as motivo_venda_agregada
    from reasonbyorderid
    group by id_pedido_venda
)

select *
from transformed