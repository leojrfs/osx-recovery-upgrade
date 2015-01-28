#!/bin/sh
read -p "Ensure Yosemite installer app is on your Applications folder and press [Enter]"

# Downloads Lion Recovery Update
echo "Downloading Lion Recovery Update"
curl -o /tmp/RecoveryHDUpdate.dmg -L http://support.apple.com/downloads/DL1464/en_US/RecoveryHDUpdate.dmg
OUT=$?
if [ $OUT != 0 ]; then
    echo "Download failed, please check your internet connection and try again."
    exit 1
fi

#access dmtest from RecoveryHDUpdate.pkg
echo "Mounting RecoveryHDUpdate.dmg"
hdiutil attach -nobrowse /tmp/RecoveryHDUpdate.dmg
OUT=$?
if [ $OUT != 0 ]; then
    echo "Mounting RecoveryHDUpdate.dmg has failed, as it may be corrupted, re-run the scritp to re-download"
    rm -rf /tmp/RecoveryHDUpdate*
    exit 1
fi

echo "Expanding RecoveryHDUpdate.pkg"
pkgutil --expand /Volumes/Mac\ OS\ X\ Lion\ Recovery\ HD\ Update/RecoveryHDUpdate.pkg /tmp/RecoveryHDUpdate
OUT=$?
if [ $OUT != 0 ]; then
    echo "Expanding RecoveryHDUpdate.pkg has failed, as it may be corrupted, re-run the scritp to re-download"
    rm -rf /tmp/RecoveryHDUpdate*
    exit 1
fi

#access BaseSystem.dmg and BaseSystem.chunklist
echo "Expanding InstallESD.dmg"
hdiutil attach -nobrowse /Applications/Install\ OS\ X\ Yosemite.app/Contents/SharedSupport/InstallESD.dmg
OUT=$?
if [ $OUT != 0 ]; then
    echo "Mounting InstallESD.dmg has failed, check if the OSX installed is in the /Applications directory"
    rm -rf /tmp/RecoveryHDUpdate*
    exit 1
fi
#build Recovery partition
echo "Building Recovery Partition. Please Wait"
/tmp/RecoveryHDUpdate/RecoveryHDUpdate.pkg/Scripts/Tools/dmtest ensureRecoveryPartition / /Volumes/OS\ X\ Install\ ESD/BaseSystem.dmg 0 0 /Volumes/OS\ X\ Install\ ESD/BaseSystem.chunklist
OUT=$?
if [ $OUT != 0 ]; then
    echo "Failed"
    rm -rf /tmp/RecoveryHDUpdate*
    exit 1
fi

#cleanup
echo "Cleaning up"
hdiutil eject /Volumes/Mac\ OS\ X\ Lion\ Recovery\ HD\ Update
rm -rf /tmp/RecoveryHDUpdate*
hdiutil eject /Volumes/OS\ X\ Install\ ESD/
exit 0
