drop table #1

DECLARE @current_month varchar(50)
SET @current_month = '2018-08-01 00:00:00.000'

SELECT
    m.id '�û�ID',
    m.real_name '��ʵ����',
    m.mobile '�ֻ�����',
    gn.grade_name '��Ա����',
    m.reg_time 'ע��ʱ��',
    convert(varchar(10),mi.birthday,120) '����',
    MONTH(mi.birthday) as '�����·�',
    mi.current_address '��ַ',
    i.score '��ǰ����',
    b.total_net_assets '���¾��ʲ�',
    c.total_net_assets_max '��߾��ʲ�',
    case when not(m.is_valid_idcard = 1 and m.idcard <>'' and m.is_valid_mobile=1) then 'δʵ��'
       when b.total_net_assets IS NULL then '��ɫ(�޾��ʲ�)'
       when b.total_net_assets < 2000  then '��ɫ(���ʲ�С��2000)'
       when b.total_net_assets >= 2000 AND b.total_net_assets < c.total_net_assets_max * 0.2 then '��ɫ(���ʲ�����2000)'
       when b.total_net_assets>=2000 and c.total_net_assets_max*0.2<=b.total_net_assets and b.total_net_assets<c.total_net_assets_max*0.5 then '��ɫ'
       when b.total_net_assets>=2000 and c.total_net_assets_max*0.5<=b.total_net_assets and b.total_net_assets<c.total_net_assets_max*0.8 then '��ɫ'
       when b.total_net_assets>=2000 and c.total_net_assets_max*0.8<=b.total_net_assets then '��ɫ'
    end AS '��ɫ��ǩ'
into #1
from member m
LEFT JOIN (select member_id,max(score) as score from integral group by member_id) i ON m.id = i.member_id
LEFT JOIN (select * from (select *,ROW_NUMBER() over(partition by member_id order by id desc) as rown from member_info ) a where rown=1) mi ON m.id=mi.member_id
LEFT JOIN ( 
    select mv.member_id,vg.grade_name 
    from (SELECT MAX (id) id_max,member_id FROM member_vip GROUP BY member_id) mv
    inner join vip_association va on mv.id_max=va.membervip_id
    inner join vip_grade vg on va.vip_grade_id = vg.id
)gn ON m.id = gn.member_id
LEFT JOIN ( SELECT * FROM member_net_assets_info where current_month = @current_month ) b ON m.id = b.member_id 
LEFT JOIN ( SELECT member_id, MAX (total_net_assets) total_net_assets_max FROM member_net_assets_info where current_month<= @current_month GROUP BY member_id) c ON m.id = c.member_id
where m.is_admin = 0


select top 10 * from member_net_assets_info order by id desc

select ��ɫ��ǩ,count(1) as c  from #1 group by ��ɫ��ǩ

select count(1) as c from #1 where ��ɫ��ǩ in ('δʵ��','��ɫ(�޾��ʲ�)')  -- �ʲ�Ϊ0�Ŀͻ�

select count(���¾��ʲ�) as c2, count(1) as c ,count(distinct �û�ID ) as uv from #1

DECLARE @birthmonth int
set @birthmonth= 9
select �û�ID,��ʵ����,�ֻ�����,��Ա����,ע��ʱ��,����,��ַ,��ǰ����,���¾��ʲ�,��߾��ʲ�,��ɫ��ǩ
from  #1 a
left outer join #todelete b on a.�û�ID=b.member_id
where ��ɫ��ǩ not in ('δʵ��','��ɫ(�޾��ʲ�)') and �����·�=@birthmonth
and b.member_id is null
order by ��ɫ��ǩ,���¾��ʲ�



-- ��Ҫ�޳����û�id
select a.member_id
into #todelete
from member_xmgj_transfer a 
left outer join member_xmgj_zhaiquan b 
on a.member_id=b.payer_id
where b.payer_id is null







==============
SELECT
    m.id member_id,
    gn.grade_name ��Ա����,
    convert(varchar(10),mi.birthday,120) ����,
    mi.current_address ��ַ,
    case when b.total_net_assets < 2000  then '��ɫ(���ʲ�С��2000)'
       when b.total_net_assets >= 2000 AND b.total_net_assets < c.total_net_assets_max * 0.2 then '��ɫ(���ʲ�����2000)'
       when b.total_net_assets>=2000 and c.total_net_assets_max*0.2<=b.total_net_assets and b.total_net_assets<c.total_net_assets_max*0.5 then '��ɫ'
       when b.total_net_assets>=2000 and c.total_net_assets_max*0.5<=b.total_net_assets and b.total_net_assets<c.total_net_assets_max*0.8 then '��ɫ'
       when b.total_net_assets>=2000 and c.total_net_assets_max*0.8<=b.total_net_assets then '��ɫ'
    end AS ��ɫ��ǩ
from member m
LEFT JOIN (select * from (select *,ROW_NUMBER() over(partition by member_id order by id desc) as rown from member_info ) a where rown=1) mi ON m.id=mi.member_id
LEFT JOIN ( 
    select mv.member_id,vg.grade_name 
    from (SELECT MAX (id) id_max,member_id FROM member_vip GROUP BY member_id) mv
    inner join vip_association va on mv.id_max=va.membervip_id
    inner join vip_grade vg on va.vip_grade_id = vg.id
)gn ON m.id = gn.member_id
LEFT JOIN ( SELECT * FROM member_net_assets_info where current_month = '2018-07-01 00:00:00.000' ) b ON m.id = b.member_id 
LEFT JOIN ( SELECT member_id, MAX (total_net_assets) total_net_assets_max FROM member_net_assets_info where current_month<= '2018-07-01 00:00:00.000' GROUP BY member_id) c ON m.id = c.member_id
where m.is_admin = 0
and MONTH(mi.birthday)=8
and m.is_valid_idcard = 1 and m.idcard <>'' and m.is_valid_mobile=1
and b.total_net_assets>0


