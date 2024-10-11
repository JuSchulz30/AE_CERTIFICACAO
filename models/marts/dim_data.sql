with
    date_range as (
        select
            seq4() as day_offset,
            dateadd(day, seq4(), '2010-01-01'::date) as date
        from table(generator(rowcount => 1706)) -- 5844 dias cobrem de 2010-01-01 a 2015-12-31
    )

select
    date
    , year(date) as ano
    , month(date) as mes
    , day(date) as dia
    , to_char(date, 'MON') as nome_mes -- Abreviação do mês
    , to_char(date, 'DY') as dia_da_semana -- Abreviação do dia da semana
    , quarter(date) as trimestre
from date_range