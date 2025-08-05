{% snapshot ss_patients %}
    {{
        config(
            target_schema='snapshot',
            unique_key='patient_id',
            strategy='check',
            check_cols=['first_name','last_name','gender','date_of_birth','contact_number','address','registration_date','insurance_provider','insurance_number','email']
        )
    }}

    select * from {{ ref('int_patitents') }}

 {% endsnapshot %}