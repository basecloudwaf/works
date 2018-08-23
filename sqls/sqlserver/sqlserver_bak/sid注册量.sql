
SELECT a.id as member_id,a.reg_time as 'ע��ʱ��'
,b.sid
,CASE WHEN b.sid IN ('mtimount', 'wtimount') THEN '��â��' 
WHEN b.sid IN ('mmojifen', 'wmojifen') THEN 'ħ����' 
WHEN b.sid IN ('mthomson', 'wthomson') THEN '��ķѷ' 
WHEN b.sid IN ('mqishuo', 'wqishuo') THEN '��˶'
WHEN b.sid IN ('mairuix', 'wairuix') THEN '������'
WHEN b.sid IN ('myingdie', 'wyingdie') THEN 'ӳ��'
when b.sid like '%p2peye%' THEN '��������'
else b.sid END AS '������Դ'
,c.date_created as '�״�Ͷ��ʱ��',c.capital AS '�״�Ͷ�ʽ��', c.cycle AS '�״�Ͷ������'
from member a 
inner join register_attach_info b on a.id=b.register_user_id
left outer join (
    select * from (
    select a.*,b.cycle
    ,ROW_NUMBER() OVER (PARTITION BY investor_id ORDER BY a.date_created asc) as rown
    from borrow_invest a 
    inner join borrow b on a.borrow_id=b.id
    where b.status in (4,5,6)
    ) a where rown=1
) c on a.id=c.investor_id
where ( b.sid IN ('mtimount', 'wtimount')
or b.sid in ('mmojifen','wmojifen')
or b.sid in ('mthomson','wthomson')
or b.sid in ('mqishuo','wqishuo')
or b.sid in ('mairuix','wairuix')
or b.sid in ('myingdie','wyingdie')
or b.sid like '%p2peye%'
)


