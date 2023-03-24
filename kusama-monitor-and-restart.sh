#!/bin/bash
######### default vars
prometheus_port=9615 #### default installation is 9615
prometheus_host="127.0.0.1"
service_name="kusama-validator"
metric_height='substrate_block_height'
log_time_zone="UTC"
max_fails_to_restart=5

###command-line args
### -p port (default 9615)
### -h host (default 127.0.0.1)
### -s service name (default kusama-validator)
### -m maximum errors before restartt (default 5)
while getopts p:h:s:m: flag
do
    case "${flag}" in
        p) prometheus_port=${OPTARG};;
        h) prometheus_host=${OPTARG};;
        s) service_name=${OPTARG};;
        m) max_fails_to_restart=${OPTARG};;
    esac
done


############### functions
function log() {
        echo $(TZ=$log_time_zone date "+%Y-%m-%d %H:%M:%S") "${1}"
}

####https://stackoverflow.com/a/3951175
#### check string IS a number
function check_number() {
        _string_to_check=$1
        case $_string_to_check in
                ''|*[!0-9]*) echo "error" ;;
                *) echo "OK" ;;
        esac
}

function restart_daemon() {
        log "systemctl restart $service_name"
        systemctl restart $service_name
}

function get_metrics() {
        curl -s "${prometheus_host}:${prometheus_port}/metrics"
}

####function get_peers() {
####    local _peers=$(get_metrics | awk '/^'${metric_peers}'/{print $2}')
####    case $(check_number "$_peers") in
####            "error") echo "error" ;;
####            *) echo $_peers
####    esac
####}

function get_best_block() {
        local _best_block=$(get_metrics | grep "^${metric_height}" | awk '/best/ {print $2}')
        case $(check_number "$_best_block") in
                "error") echo "error" ;;
                *) echo $_best_block
        esac
}

function alert_telegram() {
        log "TODO: alert telegram"
        #TODO: alert telegram!
}




############ main
old_block=$(get_best_block)
case $old_block in
        "error")
                log "number_error after getting block! exit..."
                exit
        ;;
esac

consecutive_fails=0

log "block=$old_block"

while :; do
        sleep 1m

        if (( consecutive_fails >= max_fails_to_restart )); then
                log "5 consecutive fails! will restart daemon!"
                restart_daemon
                log "sleep 2m to let it connect to network..."
                sleep 2m
        fi

        new_block=$(get_best_block)
        case $new_block in
                "error")
                        log "number_error after getting block!"
                        consecutive_fails=$(( consecutive_fails + 1 ))
                        continue        ### do not check if error getting block
                ;;
        esac

        log "block old=$old_block, new=$new_block OK"

        if (( new_block > old_block )); then
                old_block=$new_block
                consecutive_fails=0
        else
                log "oops block not increasing!"
                consecutive_fails=$(( consecutive_fails + 1 ))
                log "consecutive_fails=$consecutive_fails"
        fi
done
