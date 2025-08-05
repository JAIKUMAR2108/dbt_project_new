{% macro log_model_test(model_name,run_id,run_started_at,status, control_table='CONTROL_TABLE.CT.ct') %}

{% set run_ended_at=modules.datetime.datetime.utcnow() %}

{% set run_duration=(run_ended_at.timestamp()-run_started_at.timestamp()) %}



insert into {{control_table}}(model_name,run_id,run_started_at,run_ended_at,status,run_duration,created_at) values
(
    '{{model_name}}',
    '{{run_id}}',
    '{{run_started_at}}',
    '{{run_ended_at}}',
    '{{status}}',
     {{run_duration}},
     current_timestamp()
);

{% endmacro %}

