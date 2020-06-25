# substrate-restart-stalled-blocks

this script will:

0. check block height in prometheus
1. if it is stalled for more than 5 times by 1 minute - it will restart node

BUG1: if the chain is stalled, then your node will keep getting restarted...


currently this is only tested with centrifuge running in docker

## INSTALL
0. node must be running with prometheus enabled!
1. adjust your variables:
    * prometheus_port
    * docker_container_name
2. if you are running without docker, you can change `restart_daemon()` to be like `systemctl restart $your_service_name`
3. run in screen/tmux/any other background you like


TODO:

0. systemctl support
1. telegram notif
