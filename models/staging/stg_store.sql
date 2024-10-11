with
    rennamed as (
        select
            cast(businessentityid as varchar) as pk_loja            
            , cast(salespersonid as int) as fk_vendedor
            , cast(name as varchar) as nome_loja
            --demographics --não será usado agora
            --rowguid
            --modifieddate 
        from {{ source("erp", "store") }}
    )
select *
from
    rennamed