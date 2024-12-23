#!/bin/bash

echo "############################################################################################"
echo "________________________________Enable configSrv_______________________________________________"

docker compose exec -T configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate({_id : "config_server",configsvr: true,members: [{ _id : 0, host : "configSrv:27017" }]});
exit();
EOF

sleep 10

echo "############################################################################################"
echo "________________________________Config shard1 and replics_______________________________________________"


docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
rs.initiate({_id : "shard1",members: [{ _id : 0, host : "shard1:27018" },{ _id : 1, host: "shard1r2:27028" },{ _id : 2, host: "shard1r3:27038" }]});
exit();
EOF

sleep 10



echo "############################################################################################"
echo "________________________________Config shard2 and replics_______________________________________________"



docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
rs.initiate({_id : "shard2",members: [{ _id : 0, host : "shard2:27019" },{ _id : 1, host: "shard2r2:27029" },{ _id : 2, host: "shard2r3:27039" }]});
EOF

sleep 10


echo "############################################################################################"
echo "________________________________Add shard1 to mongos router_______________________________________________"



docker compose exec -T mongos_router mongosh --port 27020 --quiet<<EOF
sh.addShard( "shard1/shard1:27018,shard1r2:27028,shard1r3:27038");
sh.addShard( "shard2/shard2:27019,shard2r2:27029,shard2r3:27039");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
use somedb
for(var i = 0; i < 1500; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
EOF


