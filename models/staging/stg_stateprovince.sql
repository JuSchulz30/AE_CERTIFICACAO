with
    rennamed as (
        select
            cast(stateprovinceid as int) as pk_estado
            , cast(countryregioncode as varchar) as fk_pais            
            , cast(territoryid as varchar) as fk_territorio
            , cast(name as varchar) as nome_estado
            , cast(stateprovincecode as varchar) as codigo_estado            
            --isonlystateprovinceflag --não será usado agora
            --rowguid
            --modifieddate 
        from {{ source("erp", "stateprovince") }}
    )
select *
from
    rennamed