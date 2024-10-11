with stg_salesorderheader as (
    select 
        distinct(fk_endereco_envio)
    from {{ref('stg_salesorderheader')}}
)

, stg_address as (
    select *
    from {{ref('stg_address')}}
)

, stg_stateprovince as (
    select *
    from {{ref('stg_stateprovince')}}
)

, stg_countryregion as (
    select *
    from {{ref('stg_countryregion')}}
)

, transformed as (
    select
        -- Criado a chave surrogate para o id do endereço de envio.
        {{ dbt_utils.generate_surrogate_key(
                    ['fk_endereco_envio']
                )
            }} as sk_endereco_envio
        , stg_salesorderheader.fk_endereco_envio 
        , stg_address.cidade as cidade
        , stg_stateprovince.nome_estado as estado
        , stg_countryregion.pais
    from stg_salesorderheader
    left join stg_address on stg_salesorderheader.fk_endereco_envio = stg_address.pk_endereco
    left join 	stg_stateprovince on stg_address.fk_estado = stg_stateprovince.pk_estado
    left join stg_countryregion on stg_stateprovince.fk_pais = stg_countryregion.pk_pais 
)

select *
from transformed