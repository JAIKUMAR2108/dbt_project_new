{% set run_started_at = run_started_at_test() %}
{% set latest_created_at = get_latest_created_at() %}

{{
    config(
        materialized='table',
        unique_key='appointment_id',
        schema='staging',
        post_hook=[log_model_test(this.identifier, invocation_id, run_started_at,'success')]

    )
}}


select 
    *
from
    {{source('hospital','appointments')}}
where 
    created_at > to_timestamp('{{ latest_created_at }}')


