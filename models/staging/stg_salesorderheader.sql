with
    rennamed as (
        select
            cast(salesorderid as int) as pk_pedido
            , cast(customerid as int) as fk_cliente
            , cast(salespersonid as int) as fk_vendedor 
            , cast(territoryid as int) as fk_territorio
            , cast(shiptoaddressid as varchar) as fk_endereco_envio
            , cast(creditcardid as int) as fk_cartao_credito
            , cast(orderdate as date) as data_pedido
            , shipdate::date as data_envio
            , cast(status as int) as status_pedido            
            , cast(purchaseordernumber as varchar) as numero_pedido            
            , cast(shipmethodid as int) as metodo_envio_id            
            , cast(subtotal as numeric(18,2)) as subtotal_vendas
            , cast(taxamt as numeric(18,2)) as imposto
            , cast(freight as numeric(18,2)) as frete
            , cast(totaldue as numeric(18,2)) as total_devido           
        , case
            when onlineorderflag = True then 'Online'
            else 'Store'
            end as pedido_online
             --revisionnumber --não será usado agora.
            --duedate
            --accountnumber
            --billtoaddressid
            --creditcardapprovalcode
            --currencyrateid
            --rowguid
            --modifieddate 
        from {{ source("erp", "salesorderheader") }}
    )
select *
from
    rennamed