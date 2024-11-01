with
    rennamed as (
        select
            cast(salesorderid as int) as fk_pedido
            , cast(salesorderdetailid as int) as pk_pedido_detalhado
            , cast(productid as int) as fk_produto
            , cast(orderqty as int) as qtd_pedido
            --, cast(unitprice as numeric(18,2)) as preco_unitario
            , CAST(unitprice as float) as preco_unitario
            , cast(unitpricediscount as float) as desconto_preco_unitario
            --carriertrackingnumber --não será usado agora
            --specialofferid
            --rowguid
            --modifiedate            
        from {{ source('erp', 'salesorderdetail') }}
    )
select *
from rennamed