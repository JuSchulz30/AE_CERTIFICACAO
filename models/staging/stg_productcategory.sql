with
    rennamed as (
        select
            cast(productcategoryid as int) as id_categoria_produto
            , name as nome_categoria
            --rowguid ----não será usado agora
            --modifieddata
        from {{ source('erp', 'productcategory') }}
    )

select *
from rennamed