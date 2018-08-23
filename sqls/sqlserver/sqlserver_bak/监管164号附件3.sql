--���164�Ÿ���3
/*
019ѩɽ��164�Ÿ���20180903

����9��3�������һЩ����Ľ���
��������
�ֽ����������9��3���ϱ��ļ��ű���й��ĵ�һЩ����˵�����£�
1������ԭ�򣺸�����ҵ���յ������Ϣ��������д�꾡������ھ���ҵ���а��ա�
2������������Ϣ����ҵΪ�����Ĺ���ע����Ϣ�����˿������ĳʡĳ�С�
3������������������͡�Ͷ���˽�����ָ�����ı������Ϣ�ĺϼƣ��Ǻ�ͬ����
4��ͬһ����˶�ν���ͬһ�����˶�γ��裬�ϼ�ͳ�ƣ��������ա�����������ڼ��㡣
*/


--���ƴ�������Ԫ��	������/Ͷ�����������ˣ�


select getdate() as stat_date
,sum(should_receipt_balance) as should_receipt_balance_sum
,sum(fact_receipt_balance) as fact_receipt_balance_sum
,sum(should_receipt_balance-fact_receipt_balance)/100000000 as �������_��
,count(distinct a.borrow_id) as unrepay_borrow_num
,count(distinct a.loaner_id) as unrepay_loaner_num -- �������н��������
,count(distinct a.investor_id)*1.0/10000 as  Ͷ������_�� -- ��������Ͷ��������
,count(distinct case when a.status=2 then borrow_id else null end) as overdue_borrow_num --���ڱ���
,sum(case when a.status=2 then capital else 0 end) as overdue_capital --���ڽ��
,sum(case when a.status=2 then (capital+interest) else 0 end) as overdue_capital_interest --���ڽ��(����Ϣ)
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.status in (4,5,6)
and a.status in (1,2)

stat_date	should_receipt_balance_sum	fact_receipt_balance_sum	�������_��	unrepay_borrow_num	unrepay_loaner_num	Ͷ������_��	overdue_borrow_num	overdue_capital	overdue_capital_interest
2018-08-23 16:42:46.930	638788550.56	0.00	6.387885	737	599	10.6361000	4	4500000.00	4725000.00


select loaner_id
,m.real_name,m.idcard,mi.region
,me.company_name,me.business_license_no
,unpay_amount/10000 as �����_��
,need_receipt_time_max as ������
,case when a.status =1 then '����' when a.status=2 then '����' end as ���״̬
from (
select a.loaner_id
,a.status
,sum(should_receipt_balance-fact_receipt_balance) as unpay_amount
,max(need_receipt_time) as need_receipt_time_max
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.status in (4,5,6)
and a.status in (1,2)
group by a.loaner_id,a.status
) a 
inner join member m on a.loaner_id=m.id
left outer join member_id_card_info mi on a.loaner_id=mi.member_id
left outer join enterprise_info me on a.loaner_id=me.member_id
order by need_receipt_time_max




select top 10 * from member_id_card_info where member_id=41599

select top 10 * from borrow where loaner_id=995346



--���ƣ���ҵΪע�����ƣ���Ȼ��Ϊ������	
--֤�����루��ҵΪ��֯�������룬��Ȼ��Ϊ���֤���룩	
--��������ҵΪ����ע�����ڵأ���Ȼ��Ϊ���֤סַ��	
--������Ԫ��	
--������	
--���״̬�����������ڡ�������Ƿ��
