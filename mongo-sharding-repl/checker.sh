
echo "######################################################################"
echo "______________________________Вывод запущенных контейнеров______________________________"

docker compose -f docker-compose.yml ps -a

echo "######################################################################"

echo "______________________________Количество документов в shard1______________________________"

docker compose exec -T shard1 mongosh --port 27018  --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF


echo "######################################################################"


echo "______________________________Количество документов в shard1r2______________________________"

docker compose exec -T shard1r2 mongosh --port 27028 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

echo "######################################################################"

echo "______________________________Количество документов в shard1r3______________________________"

docker compose exec -T shard1r3 mongosh --port 27038 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

echo "######################################################################"



echo "______________________________Количество документов в shard2______________________________"

docker compose exec -T shard2 mongosh --port 27019  --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

echo "######################################################################"


echo "______________________________Количество документов в shard2r2______________________________"

docker compose exec -T shard2r2 mongosh --port 27029  --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

echo "######################################################################"



echo "______________________________Количество документов в shard2r2______________________________"

docker compose exec -T shard2r3 mongosh --port 27039  --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

echo "######################################################################"


echo "______________________________HTTP-запрос к веб-приложению______________________________"
curl http://127.0.0.1:8080/
echo "######################################################################"

