with
    product as (
        select
            pk_produto
            , nome_produto
            , id_subcategoria_produto 
        from {{ref('stg_product')}}
    )

    , productsubcategory as (
        select
            id_subcategoria_produto 
            , id_categoria_produto 
            , nome_subcategoria
        from {{ref('stg_productsubcategory')}}
    )

    , productcategory as (
        select
            id_categoria_produto 
            , nome_categoria
        from {{ref('stg_productcategory')}}
    )

    , transformed as (
        select 
            -- Criado a chave surrogada para o id_produto.
            {{ dbt_utils.generate_surrogate_key(
                    ['pk_produto']
                )
            }} as sk_produto   
            , product.pk_produto
            , product.nome_produto
            , productcategory.nome_categoria
            , productsubcategory.nome_subcategoria
        from product
        left join productsubcategory on product.id_subcategoria_produto = productsubcategory.id_subcategoria_produto
        left join productcategory on productsubcategory.id_categoria_produto = productcategory.id_categoria_produto
    )

select *
from transformed