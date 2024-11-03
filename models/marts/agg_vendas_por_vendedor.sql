with
    vendedores as (
        select
            id_vendedor
            , id_territorio
            , cota_vendas
            , vendas_acumuladas as vendas_ano_atual
        from {{ ref('stg_salesperson') }}
    )
    
    , pessoas as (
        select
            nome_completo as vendedor
            , id_entid_comercial_pessoa
            --, id_territorio
            --, cota_vendas
            --, vendas_acumuladas as vendas_ano_atual
        from {{ ref('stg_person') }}
        where tipo_pessoa = 'Vendedor'
    )

    , metricas_vendas AS (
    SELECT
        vendas.fk_vendedor
        , sum(qtd_pedido) AS total_quantidade_vendida
        , cast(sum((preco_unitario * (1 - desconto_preco_unitario))) as numeric(18,2)) as total_vendas
        , cast(sum(preco_unitario * qtd_pedido) - sum((preco_unitario * (1 - desconto_preco_unitario))) as numeric(18,2)) as total_desconto        
        , cast(count(distinct fk_pedido) as int) as total_pedidos
        , cast(count(distinct fk_cliente) as int) as total_clientes
        , cast(round(avg(total_liquido), 2) as numeric(18,2)) as valor_medio_pedido
    FROM {{ ref('int_ordersdetail') }} vendas
    GROUP BY vendas.fk_vendedor
)

SELECT
    vendedores.id_vendedor
    , vendedores.id_territorio
    , pessoas.vendedor
    , vendedores.cota_vendas
    , vendedores.vendas_ano_atual
    , metricas_vendas.total_quantidade_vendida
    , metricas_vendas.total_vendas
    , metricas_vendas.total_desconto    
    , metricas_vendas.total_pedidos
    , metricas_vendas.total_clientes
    , metricas_vendas.valor_medio_pedido
    , CASE
        WHEN metricas_vendas.total_vendas >= vendedores.cota_vendas THEN 'Cota Atingida'
        ELSE 'Cota Não Atingida'
      END AS status_cota
FROM
    vendedores
LEFT JOIN
    metricas_vendas ON vendedores.id_vendedor = metricas_vendas.fk_vendedor
LEFT JOIN
    pessoas ON vendedores.id_vendedor = pessoas.id_entid_comercial_pessoa