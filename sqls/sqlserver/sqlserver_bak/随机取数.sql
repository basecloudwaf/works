-- ���ȡ��
select member_id,reg_time as ע��ʱ��,rown as �������, (rown % 4)+1 as �������
from (
select member_id,reg_time
,row_number() over(order by newid) as rown
from (
select a.id as member_id,a.reg_time ,newid() as newid
from member a 
left outer join (select distinct investor_id from borrow_invest ) b on a.id = b.investor_id
where b.investor_id is null
and a.is_admin=0
) a 
) a 




select member_id,reg_time as ע��ʱ��,mtype as ����
from (
select top 10 a.id as member_id,a.reg_time ,((checksum(Hashbytes('MD5',convert(varchar,reg_time,120))) % 4 +4) % 4 )+1 as mtype
,checksum(Hashbytes('MD5',convert(varchar,reg_time,120))) as checksum
from member a 
left outer join (select distinct investor_id from borrow_invest ) b on a.id = b.investor_id
where b.investor_id is null
and a.is_admin=0
) a 
where mtype=1


0266


