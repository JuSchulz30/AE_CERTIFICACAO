with
    rennamed as (
        select
            cast(businessentityid as int) as id_funcionario
            , cast(jobtitle as varchar) as cargo
            , cast(gender as varchar) as genero
            , cast(hiredate as date) as data_contratacao
            --nationalidnumber --não será usado agora
            --loginid
            --birthdate
            --maritalstatus
            --salariedflag
            --vacationhours
            --sickleavehours
            --currentflag
            --organizationnode
            --rowguid
            --modifiedate            
        from {{ source('erp', 'employee') }}
    )
select *
from rennamed