select distinct name from mold where exists  (select id from cash_flow where event_type_id = mold.id and date_created >='2017-1-1 ' and date_created<'2018-1-1' and way='3')


use xueshandai

--帐户
drop table portrait.dbo.temp_member_account
select a.id as member_id,b.id as account_id
into portrait.dbo.temp_member_account
from member a 
inner join (select * from account where type='cash') b on a.id=b.member_id


--获取用户转帐的id，以前的业务,需要删除
select id from mold where code='transferIn'

select a.*
into portrait.dbo.temp_cashflow_todel
from cash_flow a 
inner join (select id 
from transfer_detail where payer_id !='16993') b on a.event_source = b.id
where event_type_id =44  

--检查需要删除的类型
select event_type_id,b.name,count(1) as c
from portrait.dbo.temp_cashflow_todel a 
inner join mold b on a.event_type_id = b.id
group by event_type_id,b.name


select a.id as cashflow_id
,c.member_id
,a.account_id
,event_type_id
,md.code,md.name
,event_source
,change as amount
,a.date_created
,way,description
into portrait.dbo.temp_cashflow_in
from cash_flow a 
left outer join (select id from portrait.dbo.temp_cashflow_todel) b on a.id=b.id
left outer join portrait.dbo.temp_member_account c on a.account_id=c.account_id
left outer join mold md on a.event_type_id = md.id
where a.way=3
and b.id is null

drop table portrait.dbo.temp_transfer
select id,receiver_id
,payer_id
,capital
,case when capital_type ='0' then '其他' when capital_type ='1' then '全额充值' when capital_type ='2' then '全额余额联盈回款'
	when capital_type ='3' then '全额投资回款' when capital_type ='4' then '混合资金' when capital_type ='5' then '续投奖励'
	when capital_type ='6' then '活动奖励'  when capital_type ='7' then '雪银票抽奖奖励'  when capital_type ='8' then '新手首投特权奖励'
	when capital_type ='9' then '2017信用卡还款奖励'  when capital_type ='10' then '2017新春红包'  when capital_type ='11' then '微信关注红包'
	when capital_type ='12' then '2017信用卡还款推荐人奖励'  when capital_type ='13' then '话费充值推荐人奖励'  when capital_type ='14' then '雪山贷十人计划'
	when capital_type ='15' then '首投抽奖奖励'  when capital_type ='16' then '新手体验标奖励'  when capital_type ='17' then '双节喜相逢'
	when capital_type ='18' then '转账投资账户奖励' when capital_type ='21' then '迎新春，翻牌有礼'
	end as activate
,date_created ,description 
into portrait.dbo.temp_transfer







select * from member where id =92346

92346
会员[xsd_13472551505]，信用卡还款奖励转入50元

use xueshandai
select capital_type,count(1) as c 
from transfer_detail
group by capital_type


drop table portrait.dbo.rp_reward_detail
select  a.*
,b.receiver_id,b.capital,b.activate,b.description as description_transfer
,case when a.code = 'transferIn' then b.activate else a.name end as activename
into portrait.dbo.rp_reward_detail
from  portrait.dbo.temp_cashflow_in a 
left outer join portrait.dbo.temp_transfer b on a.event_source = b.id
where a.code in ('recommentInvest','transferIn','recommend_invest_turn_in','voucher_to_cash_turn_in','investReward','mobile_online_subsidy','mobile_online_share','recommendedInvest')
and not(a.code in ('transferIn') and b.activate is null)

select 


select convert(varchar(4),date_created,120) as year,activename,sum(amount) as amount
from portrait.dbo.rp_reward_detail
group by convert(varchar(4),date_created,120),activename
order by amount desc





select top 10 *
from #1
where code in ('transferIn') 
and member_id <>receiver_id


select top 10 * from portrait.dbo.temp_cashflow_in

select code,name,count(1) as c
from portrait.dbo.temp_cashflow_in a 
group by code,name
order by c desc 

select m.id '用户id',cf.id as cashflow_id,change '金额',d.code,d.name '活动类型',cf.date_created '时间',cf.description 
into #1
from member m,mold d,cash_flow cf,account a 
where cf.way ='3' 
and cf.event_type_id = d.id
and d.code in ('recommentInvest','transferIn','recommend_invest_turn_in','voucher_to_cash_turn_in','mobile_online_subsidy','mobile_online_share','recommendedInvest')
and m.id = a.member_id
and a.type = 'cash'
and a.id = cf.account_id



