AUTOMOUNT=true
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true
cd $MODPATH
if [ "$BOOTMODE" != true ]; then
  abort "-----------------------------------------------------------"
  ui_print "▌*! 请在 Magisk/KernelSU/APatch Manager 中安装"
  ui_print "▌*! 不支持从recovery中安装"
  abort "-----------------------------------------------------------"
elif [ "$KSU" = true ] && [ "$KSU_VER_CODE" -lt 10670 ]; then
  abort "-----------------------------------------------------------"
  ui_print "▌*! 请更新您的 KernelSU 和 KernelSU 管理器"
  abort "-----------------------------------------------------------"
fi
if [[ "$(getprop ro.build.version.sdk)" -lt 31 ]]; then
  ui_print "▌*"
  ui_print "▌*不能用于任何低于Android 12的设备."
  ui_print "▌*"

fi
service_dir="/data/adb/service.d"
if [ "$KSU" = "true" ]; then
  ui_print "▌*kernelSU版本: $KSU_VER ($KSU_VER_CODE)"
  [ "$KSU_VER_CODE" -lt 10683 ] && service_dir="/data/adb/ksu/service.d"
elif [ "$APATCH" = "true" ]; then
  APATCH_VER=$(cat "/data/adb/ap/version")
  ui_print "▌*APatch版本: $APATCH_VER"
else
  ui_print "▌*Magisk版本: $MAGISK_VER ($MAGISK_VER_CODE)"
fi
if [ ! -d "${service_dir}" ]; then
  mkdir -p "${service_dir}"
fi
if [ -d "/data/adb/modules/Play" ]; then
  rm -rf "/data/adb/modules/Play"
  ui_print "▌*已删除旧模块"
fi
EXTRACT() {
  ui_print "▌*为Magisk/KernelSU/APatch提取模块文件"
  unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH >&2
}
EXTRACT
PERMISSION() {
  ui_print "▌*正在设置权限"
  set_perm_recursive $MODPATH root root 0777
}
PERMISSION
CHARGE_FULL=$(cat /sys/class/power_supply/battery/charge_full)
CHARGE_FULL_DESIGN=$(cat /sys/class/power_supply/battery/charge_full_design)
DIFFERENCE=$(( $CHARGE_FULL_DESIGN - $CHARGE_FULL ))
CAPACITY=$(( $CHARGE_FULL / 1000 ))
CAPACITY_DESIGN=$(( $CHARGE_FULL_DESIGN / 1000 ))
BATTERY_HEALTH=$(( 100 * $CAPACITY / $CAPACITY_DESIGN ))
ROM=$(getprop ro.build.description | awk '{print $1,$3,$4,$5}')
[[ $"ROM" == "" ]] && ROM=$(getprop ro.bootimage.build.description | awk '{print $1,$3,$4,$5}')
[[ $"ROM" == "" ]] && ROM=$(getprop ro.system.build.description | awk '{print $1,$3,$4,$5}')
ui_print "▌*  🅼 🅼 🆇   *" 
ui_print "▌*🛠️写入系统优化*" 
ui_print "▌*🕛执行日期=$(date)*"
ui_print "▌*📱系统信息=$(uname -a)*" 
ui_print "▌*👑名称ROM=$ROM ($(getprop ro.product.vendor.device))*" 
ui_print "▌*🔧内核=$(uname -r)-$(uname -v)*"
ui_print "▌*📱手机制造商=$(getprop ro.product.manufacturer)*" 
ui_print "▌*📱手机品牌=$(getprop ro.product.brand)*" 
ui_print "▌*📱设备型号=$(getprop ro.product.model)*" 
ui_print "▌*⛏️安全补丁=$(getprop ro.build.version.security_patch)*" 
ui_print "▌*🅰️Android版本=$(getprop ro.build.version.release)*" 
ui_print "▌*🔋电池健康=$BATTERY_HEALTH%*"
ui_print "▌*阻止Play服务获取GSF ID，从而可能绕过Play保护机制！无视Play保护机制设置开启！"
ui_print "▌*🛠️完成优化*"

