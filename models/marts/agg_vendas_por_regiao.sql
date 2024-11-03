with
    vendas as (
        select *
        from {{ ref('stg_salesorderheader') }}
    )

    , vendas_detalhes as (
        select *
        from {{ ref('stg_salesorderdetail') }}
    )

    , stg_territorio as (
        select *
        from {{ref('stg_salesterritory')}}
    )

    , stg_provincia as (
        select *
        from {{ref('stg_stateprovince')}}
    )

    , stg_pais as (
        select *
        from {{ref('stg_countryregion')}}
    )

    , joined as (
        select 
            distinct vendas.pk_pedido --distinct para evitar duplicações.
            , stg_territorio.pk_territorio
            , vendas_detalhes.fk_produto
            , vendas.status_pedido
            , stg_territorio.nome_territorio as territorio
            , stg_pais.pais
            , vendas_detalhes.qtd_pedido
            , vendas_detalhes.preco_unitario
        from vendas
        inner join vendas_detalhes on vendas_detalhes.fk_pedido = vendas.pk_pedido
        inner join stg_territorio on vendas.fk_territorio = stg_territorio.pk_territorio
        inner join stg_provincia on stg_territorio.pk_territorio = stg_provincia.fk_territorio
        inner join stg_pais on stg_provincia.fk_pais = stg_pais.pk_pais
        /* Para filtrar somente as vendas desses pedidos. Campo condicional = "status_pedido", 
        se for igual a 2 ("Pedido Aprovado") e 5 ("Pedido Enviado"), então é uma venda. */
        where status_pedido in (2,5)
    )

    , metricas as (
        select
            pk_territorio
            , pk_pedido
            , territorio
            , pais
            , count(distinct pk_pedido) AS total_pedidos -- Total de pedidos
            , cast(sum(qtd_pedido * preco_unitario) AS NUMERIC(18,2)) AS total_vendas -- Total de vendas
        FROM joined
        GROUP BY             
            pk_territorio
            , pk_pedido
            , territorio
            , pais
    )
     
select * 
from metricas