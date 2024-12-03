# drop table
DROP TABLE nom_table

# select column's names from table
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'my_table'

# jsonb modif
update table set my_column=jsonb_set(my_column, '{text}', to_jsonb(split_part(my_column->>'text', '…voir plus', 1)), false) where my_column->>'text' like '%…voir plus';

SELECT                                                                                                                                                              
    tablename,
    pg_size_pretty(pg_total_relation_size(tablename::regclass)) as total_size,
    pg_size_pretty(pg_indexes_size(tablename::regclass)) as index_size
FROM pg_tables 
WHERE schemaname = 'public' order by pg_total_relation_size(tablename::regclass) desc limit 20;

SELECT 
    pg_size_pretty(sum(pg_total_relation_size(tablename::regclass))) as total_size,
    pg_size_pretty(sum(pg_indexes_size(tablename::regclass))) as index_size
FROM pg_tables 
WHERE schemaname = 'public';
