{% macro star(exclude_field_1, exclude_field_2) %}

select
{{ dbt_utils.star(from=ref('my_model'), except=["exclude_field_1", "exclude_field_2"]) }}
from {{ ref('my_model') }}


{% endmacro %}