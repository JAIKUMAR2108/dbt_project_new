{{
    config(
        schema = 'intermediate',
        materialized='table'
    )
}}

select 
    coalesce(bill_id,'unknown') as bill_id,
    coalesce(patient_id,'unknown') as patient_id,
    coalesce(treatment_id,'unknown') as treatment_id,
    coalesce(bill_date,'1800-01-01') as bill_date,
    coalesce(amount,0) as amount,
    coalesce(payment_method,'unknown') as payment_method,
    coalesce(payment_status,'unknown') as payment_status,
    created_at
from 
    {{ ref('stg_billing') }}