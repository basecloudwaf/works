
累计出借额（元）     	
累计注册用户数（人）	
累计为出借人赚取收益（元）	
平台运营时间 	
2018年7月出借额（元）     	
"2018年7月出借额分布
按区域排名Top 5"	省份、占比
7月出借人性别比例	男、女
7月出借人年龄分布（百分比）	"25以下，25~35岁  36~50岁  50岁以上"
7月出借人省份分布Top 5	省份、占比
7月满标笔数分布	1期、2期、3期、6期、12期、18期，各期数的满标百分比
7月出借人数分布	1期、2期、3期、6期、12期、18期，各期数的出借人百分比


/* postgres

-- 获取用户的最后一次登陆的省份

drop table tmp1;
create table tmp1 as 
select a.investor_id,sum(a.capital) as capital
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
and a.date_created>='2018-01-01' and a.date_created<='2018-07-01'
group by a.investor_id
;

-- 1月以后的最后一次登录
drop table tmp2;
create table tmp2 as
select a.*,b.ip,b.lastsigntime
from tmp1 a 
inner join (
  select * from member_last_signin_ip 
  where lastsigntime>='2018-01-01'
) b on a.investor_id=b.member_id
;

-- 对登录日期不做限制
drop table tmp2;
create table tmp2 as
select a.*,b.ip,b.lastsigntime
from tmp1 a 
inner join member_last_signin_ip b on a.investor_id=b.member_id
;



select count(1) as c ,count(ip) as c2,count(distinct ip) as c3,count(distinct investor_id) as investor_num, sum(capital) as capital from tmp2;
  c   |  c2  |  c3  | investor_num |   capital
------+------+------+--------------+--------------
 4694 | 4694 | 4245 |         4694 | 580900400.00


drop table ip_to_map_province;
create table ip_to_map_province as 
select distinct ip from tmp2 
;

-- 以下为python处理
python3 get_ip_province.py

drop table tmp4;
create table tmp4 as 
select a.*,b.province
from tmp2 a 
left outer join ip_do_map_province b on a.ip=b.ip
;



select province
,count(1) as c
,count(distinct investor_id) as investor_num
,sum(capital) as capital 
from tmp4 a 
left outer join member_inner b on a.investor_id=b.member_id
where b.member_id is null
group by province 
order by capital desc ;


*/

use xueshandai

-- 
select a.member_id 
into #member_xmgj
from member_xmgj_transfer a 
left outer join member_xmgj_zhaiquan b 
on a.member_id=b.payer_id
where b.payer_id is null


-- 累计投资总额,客户累计收益

select (capital+264873400.00)/100000000 as 累计投资总额
,(interest+22402427)/100000000 as 客户累计收益
,invest_num as 平台累计投资人次
,capital_max as 个人最高单笔投资金额
from (
select sum(capital) as capital
,sum(interest) as  interest
,count(1) as invest_num
,max(capital) as capital_max
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
and a.date_created<'2018-07-01'
) a 


select max(capital) as 个人最高累计投资金额
from (
select investor_id,sum(capital) as capital
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
and a.date_created<'2018-07-01'
group by investor_id
) a 


select count(1) as c ,count(distinct member_id) as 实名认证用户数
from (
select a.id as member_id
,coalesce(b.date_created,c.date_created) as date_identified
from member a 
left outer join (select * from platform_customer where operate_type=2) b on a.id=b.member_id
left outer join (
select * from (
select *
,ROW_NUMBER() OVER(PARTITION BY member_id ORDER BY id desc) as  rown
from account_bank where operate_status=1 and authenticate_status=2 and auditing_status=1
) a where rown=1
) c on a.id=c.member_id
where (b.member_id is not null or c.member_id is not null)
and reg_time<'2018-07-01' 
) a 

--2018年上半年成交额
--2018年上半年赚取收益
select sum(capital) as capital
,sum(interest) as  interest
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
and a.date_created>='2018-01-01' and a.date_created<'2018-07-01'


select count(1) as 注册人数
from member 
where reg_time >='2018-01-01' and reg_time <'2018-07-01'


-- 满标时间统计
select b.cycle_type,b.cycle,count(distinct borrow_id) as borrow_num
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
and b.full_time>='2018-01-01' and b.full_time<'2018-07-01'
group by b.cycle_type,b.cycle
order by cycle





/*
drop table #1 
-- 需要剔除部分投标名单
select a.borrow_id,a.investor_id,a.capital,b.cycle,b.cycle_type,c.birthday,c.gender
,DATEDIFF(year,c.birthday,getdate()) as oldy
--,DATEDIFF(dd,c.birthday,getdate())*1.0/365 as oldyear
into #1
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
left outer join member_info c on a.investor_id=c.member_id
left outer join #member_xmgj mx on a.investor_id=mx.member_id
where b.status in (4,5,6)
and a.date_created>='2018-07-01' and a.date_created<='2018-08-01'
and mx.member_id is null
*/

drop table #1 
-- 不剔除部分投标名单
select a.borrow_id,a.investor_id,a.capital,b.cycle,b.cycle_type,c.birthday,c.gender
,DATEDIFF(year,c.birthday,getdate()) as oldy
into #1
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
left outer join member_id_card_info c on a.investor_id=c.member_id
where b.status in (4,5,6)
and a.date_created>='2018-01-01' and a.date_created<'2018-07-01'

select top 10 * from member_id_card_info

-- 性别
select gender,count(distinct investor_id) as investor_num ,sum(capital) as capital
from #1
group by gender


select gender,count(1) as c 
from (select distinct investor_id,gender from #1) a 
group by gender

-- 年龄  "25以下，25~35岁  36~50岁  50岁以上"
select year_area,count(1) as c 
from (
select distinct investor_id
,case when oldy<25 then '1-25以下'
      when oldy>=25 and oldy<=35 then '2-25~35岁' 
	  when oldy>35 and oldy<=50 then '3-36~50岁'
	  when oldy>50 then '4-50岁以上'
end as year_area
from #1
) a 
group by year_area
order by year_area


平均投资金额

select year(birthday)/10 as y,count(1) as invest_num,count(distinct investor_id) as investor_num,sum(capital) as capital
,sum(capital)/count(distinct investor_id) as 平均投资金额
from #1
group by year(birthday)/10
order by y

select * from #1 where birthday>='2000-01-01' group by investor_id order by capital desc 

select * from member_id_card_info where member_id=33122

select * from member_info where member_id=33122

select * from borrow_invest where investor_id=33122


select * from member_info where member_id in (18764,145107,289165)

select * from borrow_invest where investor_id in (18764,145107,289165) and date_created>='20-01-01'


-- 笔数标
select cycle,count(1) as c 
from (select distinct borrow_id,cycle from #1) a 
group by cycle
order by cycle


-- 投资人标 
select cycle,count(1) as c 
from (select 
distinct investor_id,cycle 
from #1 a 
) a 
group by cycle
order by cycle


-- 历史个人最高投资金额(网站数据)
select investor_id,SUM(a.capital) as invest_capital  from
(
select investor_id, capital, activate_time as invest_time from borrow_invest where status in (1, 3)
union all
-- 历史的非合规标(蔡华卫)
select investor_id, capital, subscription_time as invest_time from balance_invest_detail where status in (1, 2)
) as a
where invest_time<'2017-07-01'
group by a.investor_id 
order by invest_capital desc


--union all
--select investor as investor_id,amount as capital,date_created as invest_time from bill_order

