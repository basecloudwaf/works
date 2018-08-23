use xueshandai

drop table #1

DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @begin_date = '2018-01-01'
SET @end_date = '2018-08-01'

--select @begin_date as begin_date,@end_date as end_date

select a.begin_date,a.end_date
,a.capital  --�ۼƽ����ܶ�
,a.capital_worth  --��ֵ���ۼƽ����ܶ�
,a.capital_ordinary  --���ô��ۼƽ����ܶ�
,b.borrow_num --�ۼƽ��ױ���������ţ�
,b.loaner_num  --�ɹ����Ľ��������
,b.loaner_worth_num  --�ɹ����ľ�ֵ�����������
,b.loaner_ordinary_num  --�ɹ��������ô����������
,c.investor_num --�ɹ������ʽ��Ͷ��������
into #1
from ( 
select @begin_date as begin_date,@end_date as end_date 
,sum(capital) as capital  
,sum(case when category_type='worth' then capital else 0 end) as capital_worth 
,sum(case when category_type='ordinary' then capital else 0 end) as capital_ordinary 
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where a.date_created >= @begin_date and a.date_created < @end_date
and a.status not in(0,2)
) a 
left outer join (
select @begin_date as begin_date,@end_date as end_date
,count(1) as borrow_num
,count(distinct loaner_id)  as loaner_num
,count(distinct case when category_type='worth' then loaner_id else null end ) as loaner_worth_num
,count(distinct case when category_type='ordinary' then loaner_id else null end ) as loaner_ordinary_num
from borrow 
where full_time >= @begin_date and full_time <@end_date
and status in(4,5,6)
) b on a.begin_date=b.begin_date and a.end_date=b.end_date
left outer join (
select @begin_date as begin_date,@end_date as end_date
,count(distinct investor_id) as investor_num 
from borrow_invest a 
inner join borrow b on a.borrow_id = b.id
where b.full_time>=@begin_date and b.full_time<@end_date 
and b.status in(4,5,6)
and a.status not in(0,2)
) c on a.begin_date=c.begin_date and a.end_date=c.end_date


select begin_date,end_date
,capital  as �ۼƽ����ܶ�
,capital_worth  as ��ֵ���ۼƽ����ܶ�
,capital_ordinary  as ���ô��ۼƽ����ܶ�
,borrow_num as �ۼƽ��ױ��������
,loaner_num  as �ɹ����Ľ��������
,loaner_worth_num  as �ɹ����ľ�ֵ�����������
,loaner_ordinary_num  as �ɹ��������ô����������
,investor_num as �ɹ������ʽ��Ͷ��������
from #1


-- ======== �������  ============

drop table #2 

DECLARE @end_date varchar(10)
SET @end_date = '2018-08-01'

select @end_date as end_date
,sum(a.capital) as unrepay_capital  -- ������
,count(distinct a.loaner_id) as unrepay_loaner_num -- �������н��������
,count(distinct a.investor_id) as  unrepay_investor_num -- ��������Ͷ��������
,count(distinct case when need_receipt_time<@end_date and (a.status=2 or (a.status=4 and receipt_time>=@end_date) ) then borrow_id else null end) as overdue_borrow_num --���ڱ���
,sum(case when need_receipt_time<@end_date and (a.status=2 or (a.status=4 and receipt_time>=@end_date) ) then (capital+interest) else 0 end) as overdue_capital_interest_num --���ڽ��(����Ϣ)
,count(distinct case when datediff(dd,need_receipt_time,@end_date)>=90 and (a.status=2 or (a.status=4 and receipt_time>=@end_date) ) then borrow_id else null end) as bad_debt_num --��������
,sum(case when datediff(dd,need_receipt_time,@end_date)>=90 and (a.status=2 or (a.status=4 and receipt_time>=@end_date) ) then capital else 0 end) as bad_debt_capital --��������
into #2
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.full_time <@end_date
and ( (need_receipt_time>=@end_date and a.status=1) --����
   or (need_receipt_time>=@end_date and a.status=4 and receipt_time>=@end_date) --�ѻ�����ֹ����֮�󻹵�
   or (need_receipt_time<@end_date and a.status=2) -- ��ֹ����֮ǰ�軹������Ŀǰ���ڵ�
   or (need_receipt_time<@end_date and a.status=4 and receipt_time>=@end_date) -- ��ֹ����֮ǰ�軹�����ǽ�ֹ����֮�󻹵ģ����ڻ��
)



select end_date as ��ֹ����
,unrepay_capital  as ������
,unrepay_loaner_num as �������н��������
,unrepay_investor_num as ��������Ͷ��������
,overdue_borrow_num as ���ڱ���
,overdue_capital_interest_num as ���ڽ��_����_��Ϣ
,bad_debt_num as ��������
,bad_debt_capital as ��������
from #2 

-- ==========================================

--׼�������
/*select sum(this_.should_repay_balance) as y0_, sum(this_.fact_repay_balance) as y1_ 
from repayment_detail this_ 
inner join borrow borrow_ali1_ on this_.borrow_id=borrow_ali1_.id 
left outer join flow_borrow borrow_ali1_1_ on borrow_ali1_.id=borrow_ali1_1_.id 
where this_.status in (1, 3) 
and borrow_id in(select id from borrow where full_time between '2018-01-01 00:00:00' and '2018-01-31 23:59:59') 
and (borrow_ali1_.category_type='ordinary' and borrow_ali1_.category='transfer')
*/

--Ͷ�ʱ������� & �����Ŀļ��ʱ���ܺ�
DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @begin_date = '2018-01-01'
SET @end_date = '2018-08-01'

select  @end_date as end_date,@end_date as end_date
,sum(case when cycle_type=2 then cycle else 0 end) as cycle_month  -- Ͷ�ʱ�������(�±�)
,sum(case when cycle_type=1 then cycle else 0 end) as cycle_day  -- Ͷ�ʱ�������(�ձ�)
,sum(datediff(dd,date_created,full_time)) as full_days --�����Ŀļ��ʱ���ܺ�(�걻Ͷ����ʱ�俪ʼ)
--,sum(amount) as amount
--,sum(interest_total) as interest_total
--,sum(loaner_total) as loaner_total
--,sum(interest_total)+sum(loaner_total) as cost  --��������ܳɱ�
from borrow 
where  full_time>=@begin_date and full_time<@end_date
and status in(4,5,6)

--end_date	    end_date	cycle_month	cycle_day	full_days	amount	interest_total	loaner_total	cost
--2018-06-01	2018-06-01	2883	    0	        1978	391500000.00	24034160.44	5523000.00	29557160.44

/* ��Ա�����
select a.id,a.amount,a.loaner_total,loaner_total/amount,b.fee,a.loaner_cost_id,cash,fee,b.rate
from borrow a 
left outer join management_cost b on a.loaner_cost_id = b.id
where a.status in(4,5,6)
and a.loaner_total<>b.fee
-- ��14������������
*/



--�������Ϣ��ϸ & Ͷ������Ϣ��ϸ

drop table #borrow_detail

DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @begin_date = '2018-01-01'
SET @end_date = '2018-08-01'

select a.id as borrow_id, loaner_id,cycle_type,cycle,loaner_total,rate,interest
into #borrow_detail
from borrow  a 
left outer join (select borrow_id,sum(interest) as interest 
from receipt_detail 
group by borrow_id
) b on a.id=b.borrow_id
where  full_time>=@begin_date and full_time<@end_date
and a.status in(4,5,6)


select top 10 * from receipt_detail 

-- �������Ϣ��ϸ

select borrow_id as ��id
,loaner_id as �����id
,cycle as ����
,cycle_type as ���޵�λ_1��2��
,interest as ��Ϣ
,loaner_total as ������
from #borrow_detail
order by borrow_id

--Ͷ������Ϣ��ϸ

select borrow_id as ��id
,cycle as ����
,cycle_type as ���޵�λ_1��2��
,interest as ��Ϣ
,rate as ����
from #borrow_detail
order by borrow_id


-- =======================

--ʮ������(�ڴ�)
select a.member_id,m.uname,m.real_name,capital
from (
select member_id,sum(capital) as capital
from repayment_detail a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
and a.status =1
group by member_id
) a 
inner join member m on a.member_id=m.id
order by capital desc



select * from repayment_detail where member_id=991074 and status=1 and capital>0
select * from borrow where id in (13353,13354)


--ʮ��Ͷ����(δ��)
DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @begin_date = '2018-01-01'
SET @end_date = '2018-08-01'

select investor_id,m.real_name,capital
from (
select investor_id,sum(a.capital) as capital
from receipt_detail a 
inner join borrow b on a.borrow_id=b.id 
where a.status in (1,2)
and b.status in (4,5,6) 
and b.full_time>=@begin_date and b.full_time<@end_date
group by investor_id
) a 
inner join member m  on a.investor_id=m.id
order by capital desc 



