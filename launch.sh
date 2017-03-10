#!/bin/bash
export VM_HOST=localhost

wait() {
while true; do
  if ! nc -z $VM_HOST $1
  then
    echo "$2 not available, retrying..."
    sleep 1
  else
    echo "$2 is available"
    break;
  fi
done;
}

docker rm -f $(docker ps -aq)
docker-compose up -d
wait 9042 Cassandra
./cqlsh.sh