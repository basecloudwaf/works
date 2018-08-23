
-- �û�VIP
select member_id,vip_rank,grade_name
from (
select a.id,a.member_id,a.remark,a.begin_date,a.end_date,a.is_end
,b.membervip_id,b.vip_grade_id
,c.grade_name,c.lower,c.upper,c.rank as vip_rank
,ROW_NUMBER() OVER(PARTITION BY a.member_id ORDER BY a.id desc) as  rown
from member_vip a 
inner join vip_association b on a.id=b.membervip_id
inner join vip_grade c on b.vip_grade_id = c.id
) a where rown=1 and is_end=0



-- �����������������

DECLARE @end_date varchar(10)
SET @end_date = '2018-03-01'

select @end_date as stat_date,investor_id,sum(a.capital) as balance
into #1
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.status in (4,5,6) and b.full_time <@end_date
and ( (need_receipt_time>=@end_date and a.status=1) --����
   or (need_receipt_time>=@end_date and a.status=4 and receipt_time>=@end_date) --�ѻ�����ֹ����֮�󻹵�
   or (need_receipt_time<@end_date and a.status=2) -- ��ֹ����֮ǰ�軹������Ŀǰ���ڵ�
   or (need_receipt_time<@end_date and a.status=4 and receipt_time>=@end_date) -- ��ֹ����֮ǰ�軹�����ǽ�ֹ����֮�󻹵ģ����ڻ��
)
group by investor_id

select sum(balance) as balance from #1

select GETDATE()





