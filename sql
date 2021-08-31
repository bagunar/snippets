# drop table
DROP TABLE nom_table

# select column's names from table
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'my_table'

# jsonb modif
update ranking_linkedin_shares set share_document=jsonb_set(share_document, '{text}', to_jsonb(split_part(share_document->>'text', '…voir plus', 1)), false) where share_document->>'text' like '%…voir plus';
