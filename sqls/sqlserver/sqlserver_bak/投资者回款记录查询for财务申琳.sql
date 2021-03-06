use xueshandai

select top 10 * from recommend


select referrer_id,count(1) as c ,count(distinct member_id) as uv
into #1
from recommend
group by referrer_id


select top 10 * from #1

select case when c >=3
,count(1) as cc
from #1
group by c
order by c


select distinct borrow_id  from receipt_detail where status in (2)


select * from receipt_detail where is_be_overdue=1 and need_receipt_time>='2018-04-01'




select convert(varchar(7),need_receipt_time,120) as d
, status,is_be_overdue,sum(capital) 
from receipt_detail  
where is_be_overdue=1
group by convert(varchar(7),need_receipt_time,120),status,is_be_overdue
order by d




select b.full_time,a.* 

select top 10 * from borrow_invest



capital	borrow	investor	loaner	loaner2
5828366600.00	11160	135699	1766	1766

select top 10 * from borrow


-- 获取提现记录
select  * from account_withdraw where date_created>='2018-08-02' and date_created<'2018-08-03' and explain='成功' order by cash desc

-- 获取投资回款记录
select  * 
from receipt_history a 
inner join (select   distinct member_id from account_withdraw where date_created>='2018-08-02' and date_created<'2018-08-03' and explain='成功') b 
on a.investor_id=b.member_id
where a.receipt_time>='2018-07-01' and a.receipt_time<'2018-08-03'
order by a.investor_id,receipt_time desc



select * from account where member_id=50122

-- 流水
select top 30 description,* from cash_flow where account_id=898532 order by id desc 


select * from receipt_detail where investor_id=50122 order by need_receipt_time desc