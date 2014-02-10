if cat /etc/issue | grep Ubuntu; then

BUILDSTRUCT=linux

else

BUILDSTRUCT=darwin

fi

$BUILDSTRUCT/./mkbootfs boot.img-ramdisk | gzip > newramdisk.cpio.gz
$BUILDSTRUCT/./mkbootimg --cmdline 'no_console_suspend=1 mms_ts.panel_id=18' --kernel zImage --ramdisk newramdisk.cpio.gz -o boot.img