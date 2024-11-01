with 
    salesorderheader as (
        select
            *
            , pk_pedido as fk_pedido
        from {{ref('stg_salesorderheader')}}
    )

    , orderdetail as (
        select
            *
        from {{ref('stg_salesorderdetail')}}
    )

    , status_pedido as (
        select
            pk_pedido
            , status_pedido
            , case 
                when status_pedido = 1 then 'Em processo'
                when status_pedido = 2 then 'Aprovado'
                when status_pedido = 3 then 'Em espera'
                when status_pedido = 4 then 'Rejeitado'
                when status_pedido = 5 then 'Enviado'
                when status_pedido = 6 then 'Cancelado'
                else 'sem_status'
            end as nome_status_pedido
        from salesorderheader
    )

    , joined as (
            select
                orderdetail.pk_pedido_detalhado
                , orderdetail.fk_produto
                , salesorderheader.fk_cliente
                , salesorderheader.fk_pedido
                , salesorderheader.fk_vendedor
                , salesorderheader.fk_territorio
                , salesorderheader.fk_endereco_envio
                , salesorderheader.fk_cartao_credito
                , salesorderheader.data_pedido
                , salesorderheader.data_envio
                , salesorderheader.numero_pedido
                , salesorderheader.pedido_online
                , status_pedido.nome_status_pedido
                , orderdetail.qtd_pedido
                , orderdetail.preco_unitario
                , orderdetail.desconto_preco_unitario
                , salesorderheader.frete
                , salesorderheader.imposto                
            from orderdetail
            inner join salesorderheader on orderdetail.fk_pedido = salesorderheader.fk_pedido
            left join status_pedido on salesorderheader.pk_pedido = status_pedido.pk_pedido
    )

    , metricas as (
        select
            *
             -- Valor referente ao preço do produto sem imposto e frete.
            , preco_unitario * (1 - desconto_preco_unitario) * qtd_pedido as total_liquido 
            -- rateado o frete pela quantidade de ítens no mesmo pedido.
            , cast(frete / count(*) over(partition by fk_pedido) as numeric(18,2)) as frete_rateado
            -- rateado o imposto pela quantidade de ítens no mesmo pedido.
            , cast(imposto / count(*) over(partition by fk_pedido) as numeric(18,2)) as imposto_rateado
            , preco_unitario * qtd_pedido as total_bruto
        from joined
    )
    -- Criado uma chave surrogate, com o fk_pedido e fk_produto.
    , chave_primaria as (
        select
            fk_pedido::varchar || '-' || fk_produto::varchar as sk_vendas
            , *
        from metricas
    )

    , organizar_colunas as (
        select
            sk_vendas
            , pk_pedido_detalhado
            , fk_produto
            , fk_cliente
            , fk_pedido
            , fk_vendedor
            , fk_territorio
            , fk_endereco_envio
            , fk_cartao_credito
            , data_pedido
            , data_envio
            , numero_pedido
            , qtd_pedido
            , nome_status_pedido
            , pedido_online
            , preco_unitario
            , desconto_preco_unitario
            , total_liquido
            , frete_rateado
            , imposto_rateado
            , total_bruto
        from chave_primaria
    )

select *
from organizar_colunas