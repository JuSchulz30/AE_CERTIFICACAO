with
    rennamed as (
        select
            cast(salesorderid as int) as fk_pedido
            , cast(salesreasonid as int) as fk_motivo_venda
            --modifieddate will not be used now
        from {{ source("erp", "salesorderheadersalesreason") }}
    )
select *
from
    rennamed