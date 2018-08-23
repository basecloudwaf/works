use xueshandai


select * from #member_inner

select id as member_id 
into #member_inner
from member
where id in (
131,11282,15600,22345,22346,22347,22348,22367,22369,22372,22444,22457,22462,22538,22539,22571,22804,
24523,25053,25054,25055,25936,26249,26260,26812,29187,29490,29495,29597,29600,29696,29761,30265,30357,
30514,30515,30517,31033,31073,31094,84593,84595,84596,84598,84599,84602,84603,84608,84610,85199,85200,
85201,85203,85204,85207,85209,85218,85219,85220,85356,85357,85358,85360,89600,89601,279385
)


investor_id	real_name	capital
31033	�ܵ���	10843494.00
29597	�־��	9493617.00
131	������	8591846.00
22457	����ƽ	7807484.00
22348	������	7655885.00
30357	�����	7433904.00
33007	����ƽ	7324521.00
36962	����	7209032.00
85220	��С��	7165752.00
22367	��Է	6958712.00



select count(1) from #member_inner

-- ���ձ���


drop table #1 

DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @end_date = '2018-08-01'

select investor_id,sum(a.capital) as capital
into #1
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.full_time <@end_date
and b.status in (4,5,6)
and ( (need_receipt_time>=@end_date and a.status=1) --
   or (need_receipt_time>=@end_date and a.status=4 and receipt_time>=@end_date) --��ֹ����֮�󻹵�
   or (need_receipt_time<@end_date and a.status=2) -- ��ֹ����֮ǰ�軹������Ŀǰ���ڵ�
   or (need_receipt_time<@end_date and a.status=4 and receipt_time>=@end_date) -- ��ֹ����֮ǰ�軹�����ǽ�ֹ����֮�󻹵�
)
group by investor_id
;

select investor_id as �û�id,b.uname as �û���
,case when c.member_id is not null then '��Ͷ' else '��Ͷ' end as �û�����
,capital as ���ձ���
from #1 a 
left outer join member b on a.investor_id = b.id
left outer join #member_inner c on a.investor_id=c.member_id



-- Ͷ�ʽ��
drop table #2

DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @begin_date = '2018-07-01'
SET @end_date = '2018-08-01'

select investor_id,borrow_id,capital
,b.cycle_type,b.cycle
,a.status
into #2
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.full_time>=@begin_date and b.full_time<@end_date and b.status in (4,5,6)
and a.status not in (0,2)

select status,count(1) as c from #2 group by status
select sum(capital) as capital from #2

select investor_id as �û�id,b.uname as �û���
,case when c.member_id is not null then '��Ͷ' else '��Ͷ' end as �û�����
,case when cycle_type=1 then '��' when cycle_type=2 then '��' end as ��������
,cycle as �������
,sum(capital) as Ͷ�ʽ��
from #2 a 
left outer join member b on a.investor_id = b.id
left outer join #member_inner c on a.investor_id=c.member_id
group by investor_id,b.uname,case when c.member_id is not null then '��Ͷ' else '��Ͷ' end,cycle_type,cycle



-- ��Ͷ�ؿ�(������Ϣ) -- ��ĩ����

DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @begin_date = '2018-08-01'
SET @end_date = '2018-09-01'


select @begin_date as begin_date,@end_date as end_date
,case when mi.member_id is not null then '��Ͷ' else '��Ͷ' end as �û�����
,sum(capital) as capital,sum(interest) as interest 
from receipt_detail a 
inner join borrow b on a.borrow_id = b.id
left outer join #member_inner mi on a.investor_id=mi.member_id
where  a.status =1
and b.status in (4,5,6)
and need_receipt_time>=@begin_date and need_receipt_time<@end_date
group by case when mi.member_id is not null then '��Ͷ' else '��Ͷ' end

--begin_date	end_date	�û�����	capital	interest
--2018-08-01	2018-09-01	��Ͷ	64366007.00	2075463.98
--2018-08-01	2018-09-01	��Ͷ	43093993.00	3800622.99

DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @begin_date = '2018-08-01'
SET @end_date = '2018-09-01'

select a.investor_id as �û�id
,m.uname as �û���
,capital as ����
,interest as ��Ϣ
,need_receipt_time as �ؿ�ʱ��
from receipt_detail a 
inner join borrow b on a.borrow_id = b.id
left outer join member m on a.investor_id = m.id
left outer join #member_inner mi on a.investor_id=mi.member_id
where  a.status =1
and b.status in (4,5,6)
and need_receipt_time>=@begin_date and need_receipt_time<@end_date
and mi.member_id is not null
order by �ؿ�ʱ��




