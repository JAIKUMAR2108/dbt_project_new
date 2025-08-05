{% macro get_latest_created_at(control_table='CONTROL_TABLE.CT.ct') %}

    {% set query %}
    select 
    max(created_at) as latest_created_at
    from    
        {{control_table}}
    WHERE
        model_name = '{{ this.name }}'
    {% endset %}

    {% set results = run_query(query) %}

    {% if execute and results %}
        {% set column_val = results.columns[0].values() %}
        {% if column_val and column_val[0] is not none %}
            {% do return(column_val[0]) %}
        {% else %}
            {% do return("1899-01-01 00:00:00") %} 
        {% endif %}
    {% else %}
        {% do return("1899-01-01 00:00:00") %}
    {% endif %}

{% endmacro %}




