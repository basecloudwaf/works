-- psql  -v pt="'20180424'" -f proc-notice.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180424'

-- 全量

--notice
/*
create table notice as 
select id
,version,created_by,date_created,last_updated,receive_no,receive_type,receiver_id,send_time
,status,type_id,updated_by,content,return_code,title,sms_return_code,sms_channel
,pt
from dbo_notice
;
*/

--notice不会更新数据，因此采用插入方式即可


delete from notice 
where date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD');

INSERT INTO notice 
SELECT id
,version,created_by,date_created,last_updated,receive_no,receive_type,receiver_id,send_time
,status,type_id,updated_by,content,return_code,title,sms_return_code,sms_channel
,pt
FROM dbo_notice_dadd
where pt=:pt
and date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD')
;

-- 清空增量数据
DELETE FROM dbo_notice_dadd where pt=:pt;



