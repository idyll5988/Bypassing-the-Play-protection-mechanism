#!/system/bin/sh
while [ -z "$(resetprop sys.boot_completed)" ]; do
  sleep 5
done
MODDIR=${0%/*}
km1() {
	echo -e "$@" >>优化.log
	echo -e "$@"
}
km2() {
	echo -e "❗️ $@" >>优化.log
	echo -e "❗️ $@"
}
MODPATH="/data/adb/modules/Play"
[[ ! -e $MODDIR/scripts/ll/log ]] && mkdir -p $MODDIR/scripts/ll/log
source "$MODPATH/scripts/X.sh"
function log() {
logfile=1000000
maxsize=1000000
if  [[ "$(stat -t $MODDIR/scripts/ll/log/优化.log | awk '{print $2}')" -eq "$maxsize" ]] || [[ "$(stat -t $MODDIR/scripts/ll/log/优化.log | awk '{print $2}')" -gt "$maxsize" ]]; then
rm -f "$MODDIR/scripts/ll/log/优化.log"
fi
}
X "$date📱欢迎使用设备性能优化" "🛠️idyll_绕过Play保护机制™@idyll™®2018🌿"
cd $MODDIR/scripts/ll/log
log
if [[ -d ${MODDIR}/scripts ]]; then
  start_time=$(date +%s.%N)
  for i in $(ls ${MODDIR}/scripts/*); do
    if [ -f "${i}" ]; then
    chmod 0777 "${i}"
	{
    su -c nohup "${i}" &
	} &
    while [ $(jobs | wc -l) -ge $thread_num ]; do
    sleep 1
    done
    wait
	end_time=$(date +%s.%N)
    elapsed=$(echo "$end_time - $start_time" | bc)
    formatted_time=$(printf "%.3f" $elapsed)
    echo "$date *已执行文件${i}用时$formatted_time秒*" >>优化.log
    fi
  done
else
  echo "$date*自定义服务文件夹不存在*" >>优化.log
fi
