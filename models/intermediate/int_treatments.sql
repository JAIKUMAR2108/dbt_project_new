{{
    config(
        schema = 'intermediate',
        materialized='table'
    )
}}


select 
    treatment_id,
    coalesce(appointment_id,'unknown') as appointment_id,
    coalesce(treatment_type,'unknown') as treatment_type,
    coalesce(description,'unknown') as description,
    coalesce(cost,0) as cost,
    coalesce(treatment_date,'1800-01-01') as treatment_date,
    created_at
from 
    {{ ref('stg_treatments') }}