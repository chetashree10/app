# Start Kafka
cd docker/kafka
docker-compose up -d

# Start MySQL
docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=appdb \
  -p 3306:3306 \
  -v $(pwd)/docker/mysql/init.sql:/docker-entrypoint-initdb.d/init.sql \
  mysql:8
