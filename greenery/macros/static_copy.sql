{% macro static_copy(table_name) %}

    {%- set mappings = {
       "zip_mapping": {"file_name": "zip_mapping.csv", "file_parameters": "FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY='\"')"},
       "census": {"file_name": "census.csv", "file_parameters": "FILE_FORMAT = (TYPE = 'CSV' COMPRESSION = 'GZIP' FIELD_DELIMITER = ',' FIELD_OPTIONALLY_ENCLOSED_BY='\"') ON_ERROR = 'CONTINUE'"}
    } -%}


    {% call statement('copy_statement', fetch_result=True) %}

      BEGIN;

      TRUNCATE TABLE raw.static.{{ table_name }}
      ;

      COPY INTO raw.static.{{ table_name }}
      FROM @raw.snowpipe.s3/prefix/{{ mappings[table_name]['file_name'] }}
      {{ mappings[table_name]['file_parameters'] }}
      ;

      COMMIT;

    {%- endcall %}

    {{ log("Success: data copied into " ~table_name, info=True) }}

{% endmacro %}