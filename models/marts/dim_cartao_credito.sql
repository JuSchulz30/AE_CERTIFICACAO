with stg_salesorderheader as (
    select 
        distinct(fk_cartao_credito)
    from {{ref('stg_salesorderheader')}}
    where fk_cartao_credito is not null
)

, stg_creditcard as (
    select *
    from {{ref('stg_creditcard')}}
)

, transformed as (
    select
        -- Criado a chave surrogate para o id do cartão de crédito. 
        {{ dbt_utils.generate_surrogate_key(
                        ['fk_cartao_credito']
                    )
                }} as sk_cartao_credito 
        , stg_salesorderheader.fk_cartao_credito as id_cartao_credito
        , stg_creditcard.tipo_cartao
    from stg_salesorderheader 
    left join stg_creditcard on stg_salesorderheader.fk_cartao_credito = stg_creditcard.pk_cartao_credito
)

select *
from transformed