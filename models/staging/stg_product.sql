with
    rennamed as (
        select
            cast(productid as int) as pk_produto
            , cast(name as varchar) as nome_produto
            , cast(productnumber as varchar) as numero_produto
            , cast(safetystocklevel as int) as _nivel_estoque_seguranca
            , cast(reorderpoint as varchar) as ponto_de_reabastecimento
            , cast(daystomanufacture as varchar) as dias_para_fabricar
            --conversão de productsubcategoryid para varchar e tratamento de nulos.
            , cast(productsubcategoryid as int) as id_subcategoria_produto
            --conversão de data.
            , sellstartdate::date as data_inicio_venda
            --standardcost
            --listprice
            --finishedgoodsflag --não será usado agora
            --size
            --makeflag
            --productline
            --sizeunitmeasurecode
            --productmodelid
            --weight
            --weightunitmeasurecode
            --class
            --color
            --style
            --sellenddate
            --discontinueddate
            --rowguid
            --modifieddate
        from {{ source("erp", "product") }}
    )
select *
from
    rennamed