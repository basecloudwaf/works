select * from borrow where loaner_id=41599 and status in (4,5,6)

select sum(amount) from borrow where id in (5020,5032,5034,5050)

select * from repayment_detail where borrow_id in (5020,5032,5034,5050) and status in (2) 

-- 逾期金额
select  sum(capital) as capital
,sum(interest) as interest
,sum(should_repay_balance) as should_repay_balance
,sum(should_repay_fee) as should_repay_fee
,sum(should_repay_balance+should_repay_fee) as should_pay
from repayment_detail 
where borrow_id in (5020,5032,5034,5050) 
and status in (2) 



-- 借款总额
select sum(amount) from borrow where loaner_id=41599 and status in (4,5,6)

-- 企业信息
select * from enterprise_info where member_id=41599

-- 用户信息
select * from member where id = 41599


