with
    rennamed as (
        select
            cast(businessentityid as int) as id_vendedor
            , cast(territoryid as int) as id_territorio
            , cast(salesquota as numeric(18,2)) as cota_vendas
            , cast(bonus as numeric(18,2)) as bonus
            , cast(commissionpct as numeric(18,2)) as percentual_comissao
            , cast(salesytd as numeric(18,2)) as vendas_acumuladas
            , cast(saleslastyear as numeric(18,2)) as vendas_ano_passado
            --rowguid --não será usado agora
            --modifiedate            
        from {{ source('erp', 'salesperson') }}
    )
select *
from rennamed