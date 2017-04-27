################################################################################
# OnlineBackup.ps1 - Windows script for stoney backup
################################################################################
#
# Copyright (C) 2017 stepping stone GmbH
#                    Switzerland
#                    http://www.stepping-stone.ch
#                    support@stepping-stone.ch
#
# Authors:
#  Jens Müller <jens.müller@stepping-stone.ch>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public 
# License as published  by the Free Software Foundation, version
# 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public
# License  along with this program.
# If not, see <http://www.gnu.org/licenses/>.
#
#
# Description:
# Backup script for data backup with stoney backup accounts.
#
# Usage:
# OnlineBackup.ps1 -c <config>
#
# Example:
# OnlineBackup.ps1 -c OnlineBackup.conf
################################################################################

#Start-Transcript -path 'C:\Users\sst-BackupTest\OnlineBackup\OnlineBackup-debug.log' -append

# Declare Variables
$firstRun = $true
$lockFile = "$env:WINDIR\Temp\OnlineBackup.lock"
$logfile = 'C:\Users\user\OnlineBackup\OnlineBackup.log'
$userHome = 'C:\Users\user\'
$remoteUser = '4000000'
$sshKey = 'C:\Users\user\.stoney-backup\id_ed25519'
$includeFile = '/cygdrive/C/Users/sst-BackupTest/OnlineBackup/OnlineBackupIncludeFiles.conf'
$excludeFile = '/cygdrive/C/Users/sst-BackupTest/OnlineBackup/OnlineBackupExcludeFiles.conf'
$scheduledHour = '12'
$scheduledMinute = '00'
$remoteHost = 'kvm-0003.stepping-stone.ch'
$localDir = '/cygdrive'
$remoteDir = 'kvm-0204'

# Test, if the stoney-backup/bin folder is in the PATH environment.
# If not, add it
If (-not ($env:Path -like '*C:\Program Files\stoney-backup\bin*')){
	$env:Path += ";C:\Program Files\stoney-backup\bin"
}

If (-not ($env:HOME -like "C:\Users\")){
	$env:HOME = "C:\Users\"
}

# Log Start
Add-Content $logFile "Online Backup started at $(Get-Date)."

# Test, if lock file exists (other instance running) and exit if true
If (-not (Test-Path $lockFile)) {
	New-Item $lockFile -type file | Out-Null
}
Else {
	Add-Content $logFile "Online Backup already running. Exiting at $(Get-Date)."
	Exit 1
}

# Sync the files via rsync.
Add-Content $logFile "Transfering Files"

& rsync -rlHtvze "'C:\Program Files\stoney-backup\bin\ssh.exe' -i $sshKey -o 'UserKnownHostsFile $userHome\.stoney-backup\.ssh\known_hosts'" --files-from=$includeFile --exclude-from=$excludeFile --delete --delete-excluded $localDir $remoteUser@kvm-0003.stepping-stone.ch:incoming/$remoteDir/backup/

Add-Content $logFile "File Transfer complete."

# Remove the lock file.
Remove-Item $lockFile

Add-Content $logFile "Online Backup finished successful at $(Get-Date)."

#Stop-Transcript
