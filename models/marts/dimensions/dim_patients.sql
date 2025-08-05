{{
    config(
        materialized='incremental',
        schema='dimensions',
        unique_key='patient_key'
    )
}}

with source as (
    select 
        * 
    from 
        {{ ref('ss_patients') }}
)

,new_records as (
select * from(
    select 
        *,
        row_number()over(partition by patient_id order by dbt_valid_to desc) as rn
    from
        source 
    )
    where 
        rn<=2
)

,insert_rec as (
    select 
        dbt_scd_id as patient_key,
        patient_id,
        first_name,
        last_name,
        gender,
        date_of_birth,
        contact_number,
        address,
        insurance_provider,
        insurance_number,
        email,
        registration_date,
        dbt_valid_from as effective_start_date,
        dbt_valid_to as effective_end_date,
        CASE
            when effective_end_date is null then 'Y'
            else 'N'
        end as is_current
    from 
        new_records
    where 
        rn=1
)

,update_rec as(
    select 
        dbt_scd_id as patient_key,
        patient_id,
        first_name,
        last_name,
        gender,
        date_of_birth,
        contact_number,
        address,
        insurance_provider,
        insurance_number,
        email,
        registration_date,
        dbt_valid_from as effective_start_date,
        dbt_valid_to as effective_end_date,
        CASE
            when effective_end_date is null then 'Y'
            else 'N'
        end as is_current
    from 
        new_records
    where 
        rn=2
)

select * from insert_rec 
union
select * from update_rec