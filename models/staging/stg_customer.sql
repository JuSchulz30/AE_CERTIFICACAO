with
    rennamed as (
        select
            cast(customerid as int) as pk_cliente
            , cast(storeid as int) as fk_loja
            , cast(territoryid as int) as fk_territorio
            , cast(personid as int) as fk_pessoa
            --rowguide --não será usado agora
            --modifieddata 
        from {{ source('erp', 'customer') }}
    )
select *
from rennamed