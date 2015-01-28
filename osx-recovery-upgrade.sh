#!/bin/sh
read -p "Ensure Yosemite installer app is on your Applications folder and press [Enter]"

#
echo "Downloading Lion Recovery Update"
curl -o /tmp/RecoveryHDUpdate.dmg -L http://support.apple.com/downloads/DL1464/en_US/RecoveryHDUpdate.dmg; then
if [ $? != 0 ]; then
    echo "Download failed, please check your internet connection and try again."
    exit 1
fi
#access dmtest from RecoveryHDUpdate.pkg
#rm -rf /private/tmp/RecoveryHDUpdate
echo "Expanding RecoveryHDUpdate.pkg"
hdiutil attach -nobrowse /tmp/RecoveryHDUpdate.dmg
pkgutil --expand /Volumes/Mac\ OS\ X\ Lion\ Recovery\ HD\ Update/RecoveryHDUpdate.pkg /tmp/RecoveryHDUpdate

#access BaseSystem.dmg and BaseSystem.chunklist
echo "Expanding InstallESD.dmg"
hdiutil attach -nobrowse /Applications/Install\ OS\ X\ Yosemite/Contents/SharedSupport/InstallESD.dmg

#build Recovery partition
echo "Building Recovery Partition. Please Wait"
/tmp/RecoveryHDUpdate/RecoveryHDUpdate.pkg/Scripts/Tools/dmtest ensureRecoveryPartition / /Volumes/OS\ X\ Install\ ESD/BaseSystem.dmg 0 0 /Volumes/OS\ X\ Install\ ESD/BaseSystem.chunklist

#cleanup
echo "Cleaning up"
hdiutil eject /Volumes/Mac\ OS\ X\ Lion\ Recovery\ HD\ Update
rm -rf /tmp/RecoveryHDUpdate.dmg
hdiutil eject /Volumes/OS\ X\ Install\ ESD/
#sudo touch /Library/Preferences/SystemConfiguration/com.apple.Boot.plist
#sudo kextcache -f -u /
exit 0
