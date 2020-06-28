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


log:
```
2020-06-28 00:29:49 block old=1355392, new=1355402 OK
2020-06-28 00:30:49 block old=1355402, new=1355406 OK
2020-06-28 00:31:49 block old=1355406, new=1355406 OK
2020-06-28 00:31:49 oops block not increasing!
2020-06-28 00:31:49 consecutive_fails=1
2020-06-28 00:32:49 block old=1355406, new=1355406 OK
2020-06-28 00:32:49 oops block not increasing!
2020-06-28 00:32:49 consecutive_fails=2
2020-06-28 00:33:49 block old=1355406, new=1355406 OK
2020-06-28 00:33:49 oops block not increasing!
2020-06-28 00:33:49 consecutive_fails=3
2020-06-28 00:34:49 block old=1355406, new=1355406 OK
2020-06-28 00:34:49 oops block not increasing!
2020-06-28 00:34:49 consecutive_fails=4
2020-06-28 00:35:49 block old=1355406, new=1355406 OK
2020-06-28 00:35:49 oops block not increasing!
2020-06-28 00:35:49 consecutive_fails=5
2020-06-28 00:36:49 5 consecutive fails! will restart daemon!
2020-06-28 00:36:49 docker restart centrifuge-amber-validator -t 60
centrifuge-amber-validator
2020-06-28 00:36:51 sleep 2m to let it connect to network...
2020-06-28 00:38:51 block old=1355406, new=1355491 OK
2020-06-28 00:39:51 block old=1355491, new=1355501 OK
2020-06-28 00:40:51 block old=1355501, new=1355511 OK
```
