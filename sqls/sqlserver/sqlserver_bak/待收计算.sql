DECLARE @end_date varchar(10)
SET @end_date = '2018-08-13'

select @end_date as end_date
,sum(a.capital) as unrepay_capital  -- ������
,sum(a.should_receipt_balance) as should_receipt_balance  -- ����ܶ�
,count(distinct a.loaner_id) as unrepay_loaner_num -- �������н��������
,count(distinct a.investor_id) as  unrepay_investor_num -- ��������Ͷ��������
,count(distinct case when need_receipt_time<@end_date and (a.status=2 or (a.status=4 and receipt_time>=@end_date) ) then borrow_id else null end) as overdue_borrow_num --���ڱ���
,sum(case when need_receipt_time<@end_date and (a.status=2 or (a.status=4 and receipt_time>=@end_date) ) then (capital+interest) else 0 end) as overdue_capital_interest_num --���ڽ��(����Ϣ)
,count(distinct case when datediff(dd,need_receipt_time,@end_date)>=90 and (a.status=2 or (a.status=4 and receipt_time>=@end_date) ) then borrow_id else null end) as bad_debt_num --��������
,sum(case when datediff(dd,need_receipt_time,@end_date)>=90 and (a.status=2 or (a.status=4 and receipt_time>=@end_date) ) then capital else 0 end) as bad_debt_capital --��������

from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.full_time <@end_date
and ( (need_receipt_time>=@end_date and a.status=1) --����
   or (need_receipt_time>=@end_date and a.status=4 and receipt_time>=@end_date) --�ѻ�����ֹ����֮�󻹵�
   or (need_receipt_time<@end_date and a.status=2) -- ��ֹ����֮ǰ�軹������Ŀǰ���ڵ�
   or (need_receipt_time<@end_date and a.status=4 and receipt_time>=@end_date) -- ��ֹ����֮ǰ�軹�����ǽ�ֹ����֮�󻹵ģ����ڻ��
)

60326
106514

should_receipt_balance
111.20

select top 10 * from receipt_detail

end_date	unrepay_capital	unrepay_loaner_num	unrepay_investor_num	overdue_borrow_num	overdue_capital_interest_num	bad_debt_num	bad_debt_capital
2018-08-13	602760000.00	602	106484	4	4725000.00	4	4500000.00