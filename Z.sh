#!/system/bin/sh
[ ! "$MODDIR" ] && MODDIR=${0%/*}
MODPATH="/data/adb/modules/Play"
[[ ! -e ${MODDIR}/ll/log ]] && mkdir -p ${MODDIR}/ll/log
source "${MODPATH}/scripts/X.sh"
function log() {
logfile=1000000
maxsize=1000000
if  [[ "$(stat -t ${MODDIR}/ll/log/设置.log | awk '{print $2}')" -eq "$maxsize" ]] || [[ "$(stat -t ${MODDIR}/ll/log/设置.log | awk '{print $2}')" -gt "$maxsize" ]]; then
rm -f "${MODDIR}/ll/log/设置.log"
fi
}
cd ${MODDIR}/ll/log
log
globals=(
"package_verifier_enable 0"
"verify_apps 0"
"google_play_scanning disabled"
"google_play_protection_disabled 1"
)
success_count=0
failure_count=0
for command in "${globals[@]}"; do
    if su -c settings put --user current global $command >/dev/null 2>&1; then
        success_count=$((success_count + 1))
    else
        failure_count=$((failure_count + 1))
        failed_commands+=("$command")
    fi
done
echo "$date *global全局设置*" >> 设置.log
sleep 1
echo "$date *成功应用的命令总数: $success_count*" >> 设置.log
echo "$date *未应用的命令总数: $failure_count*" >> 设置.log
secures=(
"verify_apps 0"
)
success_count=0
failure_count=0
for command in "${secures[@]}"; do
    if su -c settings put --user current secure $command >/dev/null 2>&1; then
        success_count=$((success_count + 1))
    else
        failure_count=$((failure_count + 1))
        failed_commands+=("$command")
    fi
done
echo "$date *secure安全设置*" >> 设置.log
sleep 1
echo "$date *成功应用的命令总数: $success_count*" >> 设置.log
echo "$date *未应用的命令总数: $failure_count*" >> 设置.log
if [ ${#failed_commands[@]} -gt 0 ]; then
    echo "$date *以下命令未能成功应用*" >> 设置.log
    for failed_command in "${failed_commands[@]}"; do
        echo "$date $failed_command" >> 设置.log
    done
fi
echo "$date *设置完成*" >> 设置.log

