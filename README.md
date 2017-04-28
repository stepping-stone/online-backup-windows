OnlineBackup.ps1 - Windows script for stoney backup

Copyright (C) 2017 stepping stone GmbH
                   Switzerland
                   http://www.stepping-stone.ch
                   support@stepping-stone.ch

Authors:
Jens Müller <jens.müller@stepping-stone.ch>

This program is free software: you can redistribute it and/or
modify it under the terms of the GNU Affero General Public
License as published  by the Free Software Foundation, version
3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public
License  along with this program.
If not, see <http://www.gnu.org/licenses/>.


Description:
Backup script for data backup with stoney backup accounts.

Usage:
OnlineBackup.ps1 -c <config>

Example:
OnlineBackup.ps1 -c OnlineBackup.conf

# online-backup-windows
Windows script for Online Backup

Script to execute a simple Online Backup task through powershell. This script is currently work-in-progress.

# Requirements:
* Powershell
* True UTF-8 capable editor (e.g. Notepad++)

# Installation:
Copy the files into a folder the user has access to. Move or copy OnlineBackupExcludeFiles.conf.default and OnlineBackupIncludeFiles.conf.default to *.conf and edit them to specify which folders should be included. Make sure to save the files in UTF-8 encoding (In Notepad++: "Encoding" -> "Encode in UTF-8").
Create a SSH key and store it on the Backup Server (step 1 to 3 of this manual: https://www.stoney-backup.com/en/support/installation-manual/linux-cli/ ). Store the private SSH key in a file.
Now, adjust the variables in the script (OnlineBackup.ps1) to the correct paths and settings. The OnlineBackup.conf configuration file is currently unused and will be implemented later.

To complete the setup, run the script in powershell to verify the settings. 
Example command:
rsync -rlHtvze "'C:\Program Files\stoney-backup\bin\ssh.exe' -i 'C:\Users\sst-BackupTest\.stoney-backup\id_ed25519' -o 'UserKnownHostsFile C:\Users\sst-BackupTest\.stoney-backup\.ssh\known_hosts'" --files-from='/cygdrive/C/Users/sst-BackupTest/OnlineBackup/OnlineBackupIncludeFiles.conf' --exclude-from='/cygdrive/C/Users/sst-BackupTest/OnlineBackup/OnlineBackupExcludeFiles.conf' --delete --delete-excluded /cygdrive 4000412@kvm-0003.stepping-stone.ch:incoming/kvm-0204/backup/

If everything is ok, create a Task to run it automatically:
* Open the Task Scheduler
* Create a new Basic Task
* Select when the task should be executed
* As action, select "Start a program" and insert the following code:
powershell.exe -file "C:\Users\user\OnlineBackup\OnlineBackup.ps1" -c OnlineBackup.conf < NUL


