with
    rennamed as (
        select
            cast(productsubcategoryid as int) as id_subcategoria_produto
            , cast(productcategoryid as int) as id_categoria_produto
            , cast(name as varchar) as nome_subcategoria
        from {{ source('erp', 'productsubcategory') }}
    )

select *
from rennamed