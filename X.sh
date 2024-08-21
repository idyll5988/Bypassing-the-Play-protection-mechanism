#!/system/bin/sh
[ ! "$MODDIR" ] && MODDIR=${0%/*}
[ -e ${MODDIR}/dev/*/.magisk/busybox ] && BB=$(echo ${MODDIR}/dev/*/.magisk/busybox);
[ -e ${MODDIR}/data/adb/magisk/busybox ] && BB=${MODDIR}/data/adb/magisk/busybox;
[ -e ${MODDIR}/data/adb/ap/bin/busybox ] && BB=${MODDIR}/data/adb/ap/bin/busybox;
[ -e ${MODDIR}/data/adb/ksu/bin/busybox ] && BB=${MODDIR}/data/adb/ksu/bin/busybox;
[ -e ${MODDIR}/system/bin/busybox ] && BB=${MODDIR}/system/bin/busybox;
[ -e ${MODDIR}/system/bin/toybox ] && SOS=${MODDIR}/system/bin/toybox;
[ "$BB" ] && export PATH="$BB:$PATH";
SUCCESS="✅"
FAILURE="❌"
date="$( date "+%y年%m月%d日%H时%M分%S秒")"
function write_value() {
	if [[ ! -f "$1" ]]; then
	    km2 "命令:($1) 位置不存在跳过..."
        return 1
    fi
	chmod +w "$1" 2> /dev/null 
	local curval=$(cat "$1" 2> /dev/null)
	if [[ "$curval" == "$2" ]]; then
	    km1 "命令:$1 参数已存在 ($2) 跳过..."
	    return 0
	fi
	if ! echo -n "$2" > "$1" 2> /dev/null; then
	    km2 "写入:($1) -❌-> 命令 $2 参数失败"
		return 1
	fi
	km1 "写入:$1 $curval -✅-> 命令 ($2) 参数成功"
}
function lock_value() {
	if [[ ! -f "$1" ]]; then
	    km2 "命令:($1) 位置不存在跳过..."
        return 1
    fi
	chown root:root "$1"
	chmod 0666 "$1" 2> /dev/null 
	local curval=$(cat "$1" 2> /dev/null)
	if [[ "$curval" == "$2" ]]; then
	    km1 "命令:$1 参数已存在 ($2) 跳过..."
	    return 0
	fi
	if ! echo -n "$2" > "$1" 2> /dev/null; then
	    km2 "写入:($1) -❌-> 命令 $2 参数失败"
		return 1
	fi
	chmod 0444 "$1"
	km1 "写入:$1 $curval -✅-> 命令 ($2) 参数成功"
	restorecon -R -F "$1" > /dev/null 2>&1
}
function X(){
local title="${2}"
local text="${1}"
#local word_count="`echo "${text}" | wc -c`"
#test "${word_count}" -gt "375" && text='文字超出限制，请尽量控制在375个字符！'
test -z "${title}" && title='idyll™®2018🌿'
test -z "${text}" && text='您未给出任何信息'
su -lp 2000 -c "cmd notification post -S messaging --conversation '${title}' --message '${title}':'${text}' 'Tag' '$(echo $RANDOM)' " >/dev/null 2>&1
}
X "$date📱设备性能优化已完成" "绕过Play保护机制@idyll™®2018🌿"