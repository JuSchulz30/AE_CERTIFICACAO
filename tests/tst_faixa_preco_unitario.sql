select
    count(*) as preco_unitario_invalido
from
    {{ ref('fct_vendas') }}
where
    preco_unitario < 0
having
    count(*) > 0