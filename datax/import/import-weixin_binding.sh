# sh run-weixin_binding.sh 20180424

if [ $# -eq 0 ]
then
    echo "absent parameter yyyymmdd"
    exit
fi

rdate=$1

echo $rdate

echo ==== create datax.json

# 全量
python3 createjson-pt.py dbo_weixin_binding $rdate

# 增量
# python3 createjson-pt.py dbo_weixin_binding_dadd $rdate

echo ==== datax
# 全量
python /var/www/datax/bin/datax.py day/odps2postgresql-dbo_weixin_binding-$rdate.json

# 增量
# python /var/www/datax/bin/datax.py day/odps2postgresql-dbo_weixin_binding_dadd-$rdate.json


echo ==== psql
psql  -v pt="'$rdate'" -f import/import-weixin_binding-after.sql "dbname=xueshandai user=xueshandai password=Xueshandai123$"