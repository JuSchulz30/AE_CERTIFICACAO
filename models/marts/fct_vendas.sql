with
    cliente as (
        select 
            *
        from {{ ref("dim_cliente") }}
    )

    , cartao_credito as (
        select
            *
        from {{ref('dim_cartao_credito')}}
    )

    , localizacao as (
        select
            *
        from {{ref('dim_localizacao')}}
    )

    , produtos as (
        select
            *
        from {{ref('dim_produto')}}
    )

    , motivo_vendas as (
        select 
            *
        from {{ ref("dim_motivo_venda") }}
    )

    , vendedor as (
        select 
            *
        from {{ref('dim_vendedor')}} 
    )

    , salesorderdetail as (
        select 
            *
        from {{ref('stg_salesorderdetail')}}
    )

    , salesorderheader as (
        select 
            *
        from {{ref('stg_salesorderheader')}}
    )

    , intermediate as (
        select 
            * 
        from {{ ref("int_ordersdetail") }}
    )

    , final as (
        select
            {{ dbt_utils.generate_surrogate_key(
                        ['pk_pedido_detalhado']
                    )
                }}
            as sk_fato_vendas
            , int_ordersdetail.sk_vendas as fk_vendas
            , int_ordersdetail.pk_pedido_detalhado as fk_pedido_detalhado
            , int_ordersdetail.fk_produto
            , int_ordersdetail.fk_cliente
            , int_ordersdetail.fk_pedido
            , int_ordersdetail.fk_vendedor
            , int_ordersdetail.fk_territorio
            , int_ordersdetail.fk_endereco_envio
            , int_ordersdetail.fk_cartao_credito
            , dim_motivo_venda.motivo_venda_agregada
            , int_ordersdetail.data_pedido
            , int_ordersdetail.data_envio
            , int_ordersdetail.numero_pedido
            , int_ordersdetail.pedido_online
            , int_ordersdetail.qtd_pedido
            , int_ordersdetail.preco_unitario
            , int_ordersdetail.desconto_preco_unitario
            , int_ordersdetail.total_liquido
            , int_ordersdetail.frete_rateado
            , int_ordersdetail.imposto_rateado
            , int_ordersdetail.total_bruto
            , int_ordersdetail.nome_status_pedido
            , dim_cliente.nome_completo as cliente
            , dim_cliente.nome_loja as loja
            , dim_cliente.tipo_pessoa
        from int_ordersdetail
        left join dim_cliente on int_ordersdetail.fk_cliente = dim_cliente.pk_cliente
        left join dim_motivo_venda on int_ordersdetail.fk_pedido = dim_motivo_venda.id_pedido_venda
    )

    , organizar_colunas as (
        select
            sk_fato_vendas
            , fk_vendas
            , fk_pedido
            , fk_pedido_detalhado
            , fk_produto
            , fk_cliente
            , fk_cartao_credito
            , fk_vendedor
            , fk_endereco_envio
            , fk_territorio
            , data_pedido
            , data_envio            
            , cliente
            , tipo_pessoa
            , numero_pedido
            , pedido_online
            , qtd_pedido
            , motivo_venda_agregada 
            , preco_unitario
            , desconto_preco_unitario
            , total_liquido
            , frete_rateado
            , imposto_rateado
            , total_bruto
            , nome_status_pedido
            , loja
        from final
    )
select *
from organizar_colunas