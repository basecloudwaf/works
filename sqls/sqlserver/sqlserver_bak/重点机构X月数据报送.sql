use xueshandai

-- �滻��2018-06-����Ϊ��2018-07-

--------��F4���ĳ�ʼ������ܹ�ģ��������2017��6��30�յĴ����ܶ��������+��Ϣ��---

select (ac+bc)/100000000 from (

select '1' as aid,SUM(should_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') 
) a left join (
select '1' as aid,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end bc 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') and receipt_time>='2017-7-1 00:00:00' 
) b on a.aid = b.aid

-- 5.855959 

------------F5���ĳ�ʼ�����������Ϲ�ҵ���ģ��������2017��6��30�յĴ����У����н���100wԪ�Ľ���˴����ܶ����֮ǰ��һ�ַ�ʽͳ�ƣ�-----

select sum(fr.cp)/100000000 from (
select loaner_id,SUM(ac) cp,sum(scpl) s_capital from (
select loaner_id,sum(capital) scpl,sum(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') group by loaner_id
union all
select loaner_id,sum(capital) scpl,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end ac 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') and receipt_time>='2017-7-1 00:00:00' group by loaner_id
) r group by loaner_id having SUM(scpl) >1000000

) fr

-- 0.722483


--------------G1��ĩ����������ģ��������2018��7��25�յĴ����ܶ�--------


select (ac+bc)/100000000 from (

select '1' as aid,SUM(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') 
) a left join (
select '1' as aid,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end bc 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') and receipt_time>='2018-07-26 00:00:00' 
) b on a.aid = b.aid

--6.284147 

-------------------��G2���´�����ģ�仯����=G1-����2018��7��1�յĴ����ܶ--------


select (g1.ct-r.ct)/100000000 from (


select '1' rid,ac,bc,(ac+bc) ct from (

select '1' as aid,SUM(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') 
) a left join (
select '1' as aid,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end bc 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') and receipt_time>='2018-07-26 00:00:00' 
) b on a.aid = b.aid

) g1,(
select '1' rid,ac,bc,(ac+bc) ct from (

select '1' as aid,SUM(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-01 00:00:00') 
) a left join (
select '1' as aid,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end bc 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-01 00:00:00') and receipt_time>='2018-07-01 00:00:00' 
) b on a.aid = b.aid
) r where g1.rid = r.rid

-- 0.020408 

 

-----------------��G3��������������ģ�仯����=G1-F4---------------


select (g1.ct-r.ct)/100000000 from (


select '1' rid,ac,bc,(ac+bc) ct from (

select '1' as aid,SUM(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') 
) a left join (
select '1' as aid,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end bc 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') and receipt_time>='2018-07-26 00:00:00' 
) b on a.aid = b.aid


) g1,(
select '1' rid,ac,bc,(ac+bc) ct from (

select '1' as aid,SUM(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') 
) a left join (
select '1' as aid,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end bc 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') and receipt_time>='2017-7-1 00:00:00' 
) b on a.aid = b.aid
) r where g1.rid = r.rid

-- 0.428188

-------------------��H1��ĩ�����������Ϲ�ҵ���ģ��������2018��7��25�յĴ����У����н���100wԪ�Ľ���˴����ܶ����֮ǰ��һ�ַ�ʽͳ�ƣ�-------


select sum(fr.cp)/100000000 from (
select loaner_id,SUM(ac) cp,sum(scpl) s_capital from (
select loaner_id,sum(capital) scpl,sum(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') group by loaner_id
union all
select loaner_id,sum(capital) scpl,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end ac 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') and receipt_time>='2018-07-26 00:00:00' group by loaner_id
) r group by loaner_id having SUM(scpl) >1000000

) fr

-- 0.047250
 

-----------------��H2���´������Ϲ�ҵ��仯����H1-����2018��7��26�յĴ����У����н���100Ԫ�Ľ���˴����ܶ�


select(h1.ds-r.ds)/100000000 from (

select '1' rid,sum(fr.s_capital) bj,sum(fr.cp) ds from (
select loaner_id,SUM(ac) cp,sum(scpl) s_capital from (
select loaner_id,sum(capital) scpl,sum(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') group by loaner_id
union all
select loaner_id,sum(capital) scpl,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end ac 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') and receipt_time>='2018-07-26 00:00:00' group by loaner_id
) r group by loaner_id having SUM(scpl) >1000000

) fr

) h1,(

select '1' rid,sum(fr.s_capital) bj,sum(fr.cp) ds from (
select loaner_id,SUM(ac) cp,sum(scpl) s_capital from (
select loaner_id,sum(capital) scpl,sum(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail
 where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-01 00:00:00') group by loaner_id
union all
select loaner_id,sum(capital) scpl,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end ac 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-01 00:00:00') and receipt_time>='2018-07-01 00:00:00' group by loaner_id
) r group by loaner_id having SUM(scpl) >1000000

) fr

) r where h1.rid = r.rid

--- 0

 

----------------H3���������������Ϲ�ҵ���ģ�仯����H1-F5-----------

 

select (h1.ds-r.ds)/100000000 from (

select '1' rid,sum(fr.s_capital) bj,sum(fr.cp) ds from (
select loaner_id,SUM(ac) cp,sum(scpl) s_capital from (
select loaner_id,sum(capital) scpl,sum(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') group by loaner_id
union all
select loaner_id,sum(capital) scpl,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end ac 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') and receipt_time>='2018-07-26 00:00:00' group by loaner_id
) r group by loaner_id having SUM(scpl) >1000000

) fr

) h1,(

select '1' rid,sum(fr.s_capital) bj,sum(fr.cp) ds from (
select loaner_id,SUM(ac) cp,sum(scpl) s_capital from (
select loaner_id,sum(capital) scpl,sum(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') group by loaner_id
union all
select loaner_id,sum(capital) scpl,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end ac 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') and receipt_time>='2017-7-1 00:00:00' group by loaner_id
) r group by loaner_id having SUM(scpl) >1000000

) fr

) r where h1.rid = r.rid

-- -0.675233




