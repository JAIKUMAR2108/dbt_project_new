{{
    config(
        schema = 'intermediate',
        materialized='table'
    )
}}

select
    patient_id,
    coalesce(first_name,'unknown') as first_name,
    coalesce(last_name,'unknown') as last_name,
    coalesce(gender,'unknown') as gender,
    coalesce(date_of_birth,'1800-01-01') as date_of_birth,
    coalesce(contact_number,0000000000) as contact_number,
    coalesce(address,'unknown') as address,
    coalesce(registration_date,'01-01-1900') as registration_date,
    coalesce(insurance_provider,'unknown') as insurance_provider,
    coalesce(insurance_number,'unknown') as insurance_number,
    coalesce(email,'unknown') as email,
    created_at
from 
    {{ ref('stg_patients') }}