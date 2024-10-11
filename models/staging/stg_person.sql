with
    rennamed as (
        select
            cast(businessentityid as int) as id_entid_comercial_pessoa
            --Função concat() adotada para concatenar nomes, nomes do meio e sobrenomes.
            , concat(ifnull(firstname,' '),' ',ifnull(middlename,' '),' ',ifnull(lastname,' ')) as nome_completo
            , case
              when persontype = 'SC' then 'Loja' 
                when persontype = 'IN' then 'Cliente Varejo'
                when persontype = 'SP' then 'Vendedor'
                when persontype = 'EM' then 'Funcionario (nao-vendas)'
                when persontype = 'VC' then 'Fornecedor'
                when persontype = 'GC' then 'Contato Geral'
                else null
            end as tipo_pessoa
            --namestyle --não será usado agora
            --suffix
            --emailpromotion
            --additionalcontactinfo
            --demographics
            --rowguid
            --modifieddate
        from {{ source('erp', 'person') }}
    )
select *
from rennamed