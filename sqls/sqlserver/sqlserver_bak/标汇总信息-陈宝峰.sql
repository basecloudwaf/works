use xueshandai

drop table #1
drop table #2
drop table #3
drop table #4
drop table #all

DECLARE @stat_date varchar(10)
SET @stat_date = '2018-08-01'

select @stat_date as stat_date,
		a.id as borrow_id,
		a.loaner_id ,
		case when a.category='ordinary' then '担保标' when a.category='transfer' then '信用标' when a.category='worth' then '净值标' else '其他'  end  as category,
		REPLACE(REPLACE(REPLACE(REPLACE(a.name,CHAR(13),''),CHAR(10),''),CHAR(9),''),' ','') as loan_name,
		DATEADD(dd,-7,a.fund_deadline) start_borrow_time,
		a.full_time, 
		a.cycle,
		case when a.cycle_type='1' then '天' when a.cycle_type='2' then '月' else '其他'  end  as cycle_type,
		case when a.repay_type='1' then '一次性还款' when a.repay_type='2' then '每月等额本息' when a.repay_type='3' then '按月付息，到期还本'  when a.repay_type='4' then '按季还息' else '其他'  end  as repay_type,
		case when a.interest_type='0' then '投标计息' when a.interest_type='1' then '满标计息' else '其他'  end  as interest_type,
		a.amount as borrow_amount ,
		a.loaner_fee_total ,
		a.loaner_total,
		a.rate as borrow_rate,
		b.b_caipital as invest_capital,
		b.b_interest as invest_interest,
		b.b_ct as invests,
		b.ct_investor as investors,
		c.mx_time as last_repayment_time,
		c.un_repayment_capital,
		c.s_capital,
		c.s_interest,
		c.s_balance,
		c.f_balance,
		c.s_fee,
		c.f_fee
into #2
from (
select id,loaner_id,category,name,full_time,fund_deadline,cycle,cycle_type,repay_type,interest_type,amount,loaner_fee_total,loaner_total,rate 
from borrow 
where status in(4,5,6) and ( full_time < @stat_date or full_time is null) 
and not(interest_type='0' and  full_time is null  and DATEADD(dd,-7,fund_deadline) >= @stat_date)
) a ,(
select borrow_id,SUM(capital) b_caipital,sum(interest) b_interest,sum(loan_fee_rate) b_fee
,COUNT(id) b_ct,count(distinct investor_id) ct_investor 
from borrow_invest group by borrow_id
) b ,(
select borrow_id,MAX(need_repayment_time) mx_time,SUM(capital) s_capital,SUM(interest) s_interest,
sum(should_repay_balance) s_balance,
SUM(case when repayment_time<@stat_date then fact_repay_balance else 0 end ) f_balance,
sum(should_repay_fee) s_fee,
SUM(case when repayment_time<@stat_date then fact_repay_fee else 0 end) f_fee,
-- sum(case when repayment_time is null or need_repayment_time>=@stat_date  or repayment_time>=@stat_date  then capital else 0 end ) as un_repayment_capital,
sum(case when repayment_time is null or repayment_time>=@stat_date  then capital else 0 end ) as un_repayment_capital
from repayment_detail group by borrow_id
) c where a.id = b.borrow_id and a.id = c.borrow_id order by a.id


select * from #2 where borrow_id=12090

--如果是投标记息,并且full_time为null的话，那么取DATEADD(dd,-7,fund_deadline)为满标时间
-- repayment_time>=@stat_date 表示逾期还款


select *
into #all
from (
select * from #1
union all
select * from #2
--union all
--select * from #3
--union all
--select * from #4
) a 

select top 10 * from #all

select stat_date
,count(1) as c 
,sum(un_repayment_capital) as un_repayment_capital
,max(coalesce(full_time,start_borrow_time)) as max_full_time
from #all
group by stat_date
order by stat_date

--2017-03-01	8970	2017-02-28 22:50:02.500
--2017-04-01	9134	2017-03-31 20:43:22.030
--2018-03-01	10515	2018-02-28 22:33:27.300
--2018-04-01	10634	2018-03-31 21:35:56.187
--2017-06-01	9390	2017-05-31 17:16:20.9500000
--2018-06-01	10858	2018-05-31 23:33:15.6670000
2017-08-01	9662	558052000.00	2017-07-31 19:49:05.6430000
2018-08-01	11157	605760000.00	2018-07-31 17:47:40.7070000

drop table #output

select 
stat_date as 截止日期,
borrow_id '标号',
loaner_id '借款人id',
category '产品类型',
case when category in ('担保标','信用标') then '机构' when category in ('净值标') then '个人' else category  end '借款类型',
REPLACE(loan_name,CHAR(44),'，') '标名',
start_borrow_time '投标时间',
full_time '满标时间', 
datediff(Minute,start_borrow_time,full_time)/24.0/60.0 as '满标用时(天)',
cycle '借款期限',
cycle_type '借款期限单位',
case when cycle_type='天' then cycle/30 else cycle end as  '借款期限(月)',
repay_type '还款方式',
interest_type '计息方式',
borrow_amount '借款金额',
loaner_fee_total '管理费率',
loaner_total '管理费',
borrow_rate '利率',
invest_capital '实际投资金额',
invest_interest '实际利息',
(loaner_total+invest_interest)/borrow_amount/(case when cycle_type='天' then cycle*1.0/365 else cycle*1.0/12 end) as '综合年化资金成本率',
(loaner_total+invest_interest)/borrow_amount/(case when cycle_type='天' then cycle*1.0/365 else cycle*1.0/12 end)*borrow_amount as '综合年化资金成本',
invests '投资笔数',
investors '出借人数',

last_repayment_time '最后一期还款时间',
un_repayment_capital '未偿还本金',
s_capital '应还款本金',
s_interest '应还款利息',
s_balance '应还款金额',
f_balance '实际还款金额',
s_fee '罚息金额',
f_fee '实收罚息金额',

case when last_repayment_time>=stat_date then '未到期' else '到期' end as '是否到期',
case when last_repayment_time>=stat_date and last_repayment_time<DATEADD(month,1,stat_date) then '1个月以内到期'
  when last_repayment_time>=DATEADD(month,1,stat_date) and last_repayment_time<DATEADD(month,4,stat_date) then '1~3个月以内到期'
  when last_repayment_time>=DATEADD(month,4,stat_date) and last_repayment_time<DATEADD(month,7,stat_date) then '3~6个月以内到期'
  when last_repayment_time>=DATEADD(month,7,stat_date) and last_repayment_time<DATEADD(month,13,stat_date) then '6~12个月以内到期'
  when last_repayment_time>=DATEADD(month,13,stat_date) then '12个月以上到期'
  end as '未到期类别'
into #output
from #all

======================================================================
select * from #output

select count(1) as c from #output


select stat_date,
case when category in ('担保标','信用标') then '机构' when category in ('净值标') then '个人' else category  end '借款人类型'
,count(1) as borrows
,count(distinct loaner_id) as 借款人数
from #all
group by stat_date,case when category in ('担保标','信用标') then '机构' when category in ('净值标') then '个人' else category end
order by stat_date



==============================================
--有效标


drop table #1
select top 10 
select 
borrow_id,repayment_time,capital,interest,should_repay_balance,should_repay_fee,fact_repay_balance,fact_repay_fee
into #1
from repayment_detail a
inner join (
  select id,loaner_id,category,name,full_time,fund_deadline,cycle,cycle_type,repay_type,interest_type,amount,loaner_fee_total,loaner_total,rate 
  from borrow 
  where status between 4 and 6 
) b on a.borrow_id=b.id
where repayment_time>='2017-01-01' and repayment_time<'2018-01-01'

select *,fact_repay_balance-capital as fact_repay_interest  from #1 order by borrow_id,repayment_time

select borrow_id as 标ID,repayment_time 还款时间,capital 本金,interest 利息,
fact_repay_balance as 实际还款金额, 
fact_repay_fee as 实际罚息,
fact_repay_balance-capital as 实际利息  
from #1 order by borrow_id,repayment_time

select top 10 *,fact_repay_balance-capital as fact_repay_interest  from #1 where should_repay_balance<>fact_repay_balance

select top 10 *,fact_repay_balance-capital as fact_repay_interest  from #1 where fact_repay_fee>0

select *
from repayment_detail
where borrow_id = 10060


use xueshandai
select top 10 * from repayment_detail


--投标明细
select a.id as borrow_id,a.loaner_id,b.investor_id
into #2
from (
select id,loaner_id,category,name,full_time,fund_deadline,cycle,cycle_type,repay_type,interest_type,amount,loaner_fee_total,loaner_total,rate 
from borrow 
where status between 4 and 6 and ( full_time <'2018-4-1 00:00:00' or full_time is null)
) a ,(
select id,borrow_id,capital,interest,loan_fee_rate,investor_id from borrow_invest
) b
where a.id = b.borrow_id

--check
select count(1) as c,count(distinct loaner_id) as c2 from #1

select count(distinct loaner_id) as loaners,count(distinct investor_id) as investors from #2
