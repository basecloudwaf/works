select avg(cash) as cash_avg
from account_withdraw
where 
--withdraw_way not in (6)  -- �ǳɱ����
status in (4)  --COMPLETE("������")
and date_created>='2018-01-01'
