with
    rennamed as (
        select
            cast(countryregioncode as varchar) as pk_pais
            , cast(name as varchar) as pais
            -- modifieddata -- não será usado agora
        from {{ source('erp', 'countryregion') }}
    )
select *
from rennamed