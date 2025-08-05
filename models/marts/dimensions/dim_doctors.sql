{{
    config(
        materialized='incremental',
        schema='dimensions',
        unique_key='doctor_id'
    )
}}

with source as (
    select 
        doctor_id,
        first_name,
        last_name,
        specialization,
        phone_number,
        years_experience,
        hospital_branch,
        email,
        current_timestamp()  as last_updated_at
    from    
        {{ ref('int_doctors') }}
)

,updated_records as (
    {% if is_incremental() %}

    select
        s.*
    from 
        source s left join {{this}} t
    on 
        s.doctor_id=t.doctor_id
    where   
        t.doctor_id is null or
        s.first_name != t.first_name or
        s.last_name != t.last_name or
        s.specialization != t.specialization or 
        s.phone_number != t.phone_number or
        s.years_experience != t.years_experience or 
        s.hospital_branch != t.hospital_branch or
        s.email != t.email 

    {% else %}

        select * from source
        
    {% endif %}
)

select * from updated_records