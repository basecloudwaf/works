/*
�ۼƳɽ�������Ԫ��		��ֹĿǰ������	
�ۼƳ���������		�ۼƽ��������	
ע���û��������ˣ�		���ڽ���������ˣ�	
���ڳ����������ˣ�		��ֹĿǰ���������������	
��ֹĿǰ�����������ҵ��		��ֹĿǰ������������ˣ�	0
��ľ������/��Ԫ��		��ľ����ҵ/��Ԫ��	
�˾�Ͷ�ʽ���Ԫ��		���ƽ�������ʣ�%��	
ƽ������ʱ�䣨Сʱ��		ƽ��������ޣ��£�	
ǰ10��Ͷ���˳�����ռ��(%)		ǰ10�����˴������ռ�ȣ�%)	
ǰ10��Ͷ���˳�����		ǰ10�����˴������	
��󵥻�����ˣ���ҵ�����		��󵥻�����ˣ����ˣ����	
������ϵ������ ��		������ϵ������	��
��ֹĿǰ���ڽ��		��ֹĿǰ���ڱ���	
��Ŀ���30��������		����30��δ�Ҹ�Ͷ���˽�����	
����90�죨���������Ͻ��		����90�죨���������ϱ���	
�ۼƴ������ 0		�ۼƴ�������	0
�����������Ԫ��		��ҵ�������Ԫ��	
����������		
Ͷ���û�����ֲ�	"0-50��ռ��        % 51-60��ռ��        %  61������ռ��        %"

*/

use xueshandai

select count(1) as ע���û����� from member
--943713

select count(1) as c
,sum(capital)/10000 as �ۼƳɽ���_��
,count(distinct investor_id) as �ۼƳ���������
,count(distinct a.loaner_id) as �ۼƽ��������
,sum(capital)/count(distinct investor_id) as �˾�Ͷ�ʽ��_��Ԫ
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)



DECLARE @end_date varchar(10)
SET @end_date = '2018-08-15'

select count(1) as c
,sum(a.capital) as ������
,sum(a.should_receipt_balance) as ����ܶ�
,count(distinct a.loaner_id) as ���������
,count(distinct a.investor_id) as Ͷ��������
,count(distinct borrow_id) as ����
,count(distinct case when a.status=2 then borrow_id else null end) as ���ڱ���
,sum(case when a.status=2 then capital else 0 end) as ���ڽ��
,sum(case when a.status=2 then should_receipt_balance else 0 end) as ���ڽ��_����Ϣ
,count(distinct case when datediff(dd,need_receipt_time,getdate())>=90 and a.status=2 then borrow_id else null end) as ��������gt90
,sum(case when datediff(dd,need_receipt_time,getdate())>=90 and a.status=2 then capital else 0 end) as ��������gt90
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.status in (4,5,6) and a.status in (1,2)



-- (����+����)�ı�
select case when category='worth' then '����' else '��ҵ' end as ������
,case when cycle_type=1 then '�ձ�' when cycle_type=2 then '�±�' end as ������
,count(1) as ����
,count(distinct loaner_id) as ���������
,avg(amount) as  ��ľ���
,avg(rate) as ���ƽ��������
,avg(cycle*1.0) as ƽ���������
,avg(datediff(minute,DATEADD(day,-7,fund_deadline),full_time)*1.0/60) as ƽ������ʱ��_Сʱ
from borrow a 
inner join (select distinct borrow_id from receipt_detail where status in (1,2)) b on a.id=b.borrow_id
group by case when category='worth' then '����' else '��ҵ' end
,case when cycle_type=1 then '�ձ�' when cycle_type=2 then '�±�' end


-- ǰʮ��Ͷ����

select * from (
select * 
,row_number() over(order by capital desc ) as rown
from (
select investor_id,sum(a.capital) as capital
from receipt_detail a 
inner join borrow b on a.borrow_id=b.id 
where a.status in (1,2)
and b.status in (4,5,6) 
group by investor_id
) a 
) a 
where rown<=10

select sum(case when rown<=10 then capital else 0 end) as ǰ10��Ͷ���˳�����
,sum(capital) as Ͷ���ܶ�
,sum(case when rown<=10 then capital else 0 end)/sum(capital) as ǰ10��Ͷ���˳�����ռ��
from (
select * 
,row_number() over(order by capital desc ) as rown
from (
select investor_id,sum(a.capital) as capital
from receipt_detail a 
inner join borrow b on a.borrow_id=b.id 
where a.status in (1,2)
and b.status in (4,5,6) 
group by investor_id
) a 
) a 

--ǰ10��Ͷ���˳�����	Ͷ���ܶ�	ǰ10��Ͷ���˳�����ռ��
--81380620.00	601260000.00	0.135350


-- ǰʮ������
select *
from (
select * 
,row_number() over(order by capital desc ) as rown
from (
select a.loaner_id,sum(a.capital) as capital,sum(should_receipt_balance) as should_receipt_balance
from receipt_detail a 
inner join borrow b on a.borrow_id=b.id 
where a.status in (1,2)
and b.status in (4,5,6) 
and b.id not in (13354) -- ���޳��˱�???
group by a.loaner_id
) a 
) a 
where rown<=10

select sum(case when rown<=10 then capital else 0 end) as ǰ10�����˴�������
,sum(capital) as ��������
,sum(case when rown<=10 then should_receipt_balance else 0 end) as ǰ10�����˴������
,sum(should_receipt_balance) as �������
,sum(case when rown<=10 then should_receipt_balance else 0 end)/sum(should_receipt_balance) as ǰ10�����˴������ռ��
from (
select * 
,row_number() over(order by should_receipt_balance desc ) as rown
from (
select a.loaner_id,sum(a.capital) as capital,sum(should_receipt_balance) as should_receipt_balance
from receipt_detail a 
inner join borrow b on a.borrow_id=b.id 
where a.status in (1,2)
and b.status in (4,5,6) 
and b.id not in (13354) -- ���޳��˱�???
group by a.loaner_id
) a 
) a 


-- Ͷ���û�����ֲ�	"0-50��ռ�� % 51-60��ռ�� %  61������ռ�� %"

select age_area
,count(1) as ��Ͷ����
from (
select a.*
,case when age<=50 then '0-50��'
 when age>50 and age<=60 then '51-60��'
 when age>60 then '61������'
 end as age_area
from (
select a.*
,b.birthday
,datediff(year,b.birthday,getdate()) as age
from (
select distinct investor_id
from receipt_detail a
inner join borrow b on a.borrow_id=b.id 
where a.status in (1,2)
and b.status in (4,5,6)
) a 
inner join member_id_card_info b on a.investor_id =b.member_id
) a 
) a 
group by age_area


select count(1) as c ,count(distinct member_id) as uv from member_id_card_info


--����14����������Ϣ�н������Ӫ����
/*
��Ͻ��׶��Ԫ��	
Ͷ������������	
��������������	
�����������	
�������ڽ��׶��Ԫ��
*/


-- ��������ʱ�����
select convert(varchar(4),b.full_time,120) as y
,sum(a.capital)/10000 as ��Ͻ��׶�_��Ԫ
,count(distinct a.investor_id) as Ͷ������
,count(distinct a.loaner_id) as ��������
,count(distinct a.borrow_id) as �����
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
group by convert(varchar(4),b.full_time,120)
order by y desc


-- ���ڽ���
select convert(varchar(4),need_receipt_time,120) as y,sum(capital) as capital,sum(receipt
from receipt_detail 
where status in (2)
group by  convert(varchar(4),need_receipt_time,120)
order by y
