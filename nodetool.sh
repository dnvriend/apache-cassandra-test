#!/bin/bash
echo "==================   Help for nodetool   ========================="
echo "nodetool.sh status            : Print cluster information like state, load, IDs, etc"
echo "nodetool.sh info              : Print node information like uptime, load, etc"
echo "nodetool.sh version           : Print cassandra version"
echo "nodetool.sh netstats          : Print network information on provided host"
echo "nodetool.sh help [command]    : Gives information about a nodetool commands"
echo "nodetool.sh help              : Display help information"
echo "=================================================================="
docker exec -it cassandra nodetool $1 $2