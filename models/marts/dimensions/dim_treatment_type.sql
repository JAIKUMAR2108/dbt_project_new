{{
    config(
        materialized='incremental',
        schema='dimensions',
        unique_key='treatment_type'
    )
}}


with min_max as (
    select 
        concat('tt', row_number() over (order by treatment_type)) AS sk_treatment,
        treatment_type,
        description,
        concat(cast(min(cost)as string),' - ',cast(max(cost) as string)) as cost_range,
        current_timestamp() as last_updated
    from    
        {{ ref('int_treatments') }}
    group by 
    treatment_type,
    description
)

,updated_records as (
{% if is_incremental() %}
    select  
        m.*
    from
        min_max m left join {{this}} t
    on 
        m.treatment_type=t.treatment_type
    where
        t.treatment_type is null or
        m.description != t.description or
        m.cost_range != t.cost_range
{% else %}
    select
        *
    from 
        min_max
{% endif %}
)

select * from updated_records