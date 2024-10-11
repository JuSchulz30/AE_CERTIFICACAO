with 
    person as (
        select
            id_entid_comercial_pessoa
            , nome_completo
        from {{ref('stg_person')}}
    )

    , store as (
        select
            pk_loja
            , nome_loja
        from {{ref('stg_store')}}
    )

    , customer as (
        select 
            pk_cliente
            , fk_pessoa
            , fk_loja
        from {{ref('stg_customer')}}
    )

    , primeiro_pedido as (
        select
            salesorderheader.fk_cliente,
            min(salesorderheader.data_pedido) as data_primeiro_pedido
        from {{ ref('stg_salesorderheader') }} as salesorderheader
        group by salesorderheader.fk_cliente
    )

    , joined as (
            select
                customer.pk_cliente 
                , customer.fk_pessoa
                , person.nome_completo
                , customer.fk_loja
                , store.nome_loja
                , primeiro_pedido.data_primeiro_pedido
            from customer
            left join person on person.id_entid_comercial_pessoa = customer.pk_cliente
            left join store on store.pk_loja = customer.fk_loja
            left join primeiro_pedido on customer.pk_cliente = primeiro_pedido.fk_cliente
    )

    , transformed as (
        select
            -- Criado a chave surrogate para o id do cliente.     
            {{ dbt_utils.generate_surrogate_key(
                        ['pk_cliente']
                    )
                }} as sk_cliente
            , pk_cliente
            , nome_completo
            , nome_loja
            , data_primeiro_pedido
            , case 
                when fk_pessoa is null and fk_loja is not null then 'Loja'
                when fk_pessoa is not null and fk_loja is null then 'Pessoa Física'
                when fk_pessoa is not null and fk_loja is not null then 'Contato da loja'
                end as tipo_pessoa
        from joined
    )

select *
from transformed