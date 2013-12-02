if cat /etc/issue | grep Ubuntu; then

BUILDSTRUCT=linux

else

BUILDSTRUCT=darwin

fi

RAMDISK="boot.img-ramdisk"

$BUILDSTRUCT/./mkbootfs $RAMDISK | gzip > newramdisk.cpio.gz
$BUILDSTRUCT/./mkbootimg --cmdline 'no_console_suspend=1 mms_ts.panel_id=18' --kernel zImage --ramdisk newramdisk.cpio.gz -o $3.img