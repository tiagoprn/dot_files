# How to get more customization options

<https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome>


# How to enable

On your profile folder, you must create a symbolic link named "chrome" pointing to the root of this folder.

E.g. of a profile folder:
```bash
$ ls -la --color=never ~/.mozilla/firefox/eq3v3a6a.default-release/

total 106M
drwx------ 19 tiago.lima domain^users tiago.lima 4,0K 2022-05-19 07:40 ./
drwx------  6 tiago.lima domain^users tiago.lima 4,0K 2022-05-12 08:18 ../
-rw-r--r--  1 tiago.lima domain^users tiago.lima    0 2022-05-19 07:35 .parentlock
-rw-r--r--  1 tiago.lima domain^users tiago.lima  34K 2022-05-19 07:40 AlternateServices.txt
-rw-r--r--  1 tiago.lima domain^users tiago.lima    0 2021-01-18 07:16 ClientAuthRememberList.txt
-rw-r--r--  1 tiago.lima domain^users tiago.lima    0 2021-01-18 07:16 SecurityPreloadState.txt
-rw-r--r--  1 tiago.lima domain^users tiago.lima  63K 2022-05-19 07:40 SiteSecurityServiceState.txt
-rw-r--r--  1 tiago.lima domain^users tiago.lima 2,7K 2022-05-12 03:38 activity-stream.discovery_stream.json
-rw-r--r--  1 tiago.lima domain^users tiago.lima 6,3K 2022-05-19 07:35 addonStartup.json.lz4
-rw-r--r--  1 tiago.lima domain^users tiago.lima  14K 2022-05-18 08:18 addons.json
-rw-r--r--  1 tiago.lima domain^users tiago.lima   45 2022-05-19 07:37 autofill-profiles.json
-rw-------  1 tiago.lima domain^users tiago.lima 516K 2020-01-21 06:37 blocklist.xml
drwx------  2 tiago.lima domain^users tiago.lima 4,0K 2022-05-19 06:15 bookmarkbackups/
-rw-r--r--  1 tiago.lima domain^users tiago.lima  216 2022-05-19 06:04 broadcast-listeners.json
drwx------  4 tiago.lima domain^users tiago.lima 4,0K 2021-10-26 15:53 browser-extension-data/
-rw-------  1 tiago.lima domain^users tiago.lima 384K 2022-04-18 08:54 cert9.db
-rw-------  1 tiago.lima domain^users tiago.lima 3,4K 2022-04-18 08:54 cert_override.txt
lrwxrwxrwx  1 tiago.lima domain^users tiago.lima   37 2021-11-22 09:21 chrome -> /storage/src/dot_files/firefox/chrome/
-rw-------  1 tiago.lima domain^users tiago.lima  161 2022-05-13 08:05 compatibility.ini
-rw-------  1 tiago.lima domain^users tiago.lima  939 2019-08-06 17:12 containers.json
-rw-r--r--  1 tiago.lima domain^users tiago.lima 224K 2022-04-27 09:19 content-prefs.sqlite
-rw-r--r--  1 tiago.lima domain^users tiago.lima 1,5M 2022-05-19 07:40 cookies.sqlite
-rw-r--r--  1 tiago.lima domain^users tiago.lima 545K 2022-05-19 07:40 cookies.sqlite-wal
drwx------  3 tiago.lima domain^users tiago.lima 4,0K 2022-05-19 07:36 crashes/
drwx------  4 tiago.lima domain^users tiago.lima 4,0K 2022-05-19 07:36 datareporting/
-rw-r--r--  1 tiago.lima domain^users tiago.lima  117 2022-04-14 19:22 enumerate_devices.txt
drwx------  2 tiago.lima domain^users tiago.lima 4,0K 2022-04-27 08:12 extensions/
-rw-r--r--  1 tiago.lima domain^users tiago.lima  75K 2022-05-18 08:08 extensions.json
-rw-r--r--  1 tiago.lima domain^users tiago.lima 1,9K 2021-12-15 05:45 extension-preferences.json
-rw-------  1 tiago.lima domain^users tiago.lima  886 2021-07-02 05:55 extension-settings.json
-rw-r--r--  1 tiago.lima domain^users tiago.lima  37M 2022-05-19 07:35 favicons.sqlite
-rw-r--r--  1 tiago.lima domain^users tiago.lima 257K 2022-05-19 07:40 favicons.sqlite-wal
drwx------  3 tiago.lima domain^users tiago.lima 4,0K 2022-05-13 08:18 features/
-rw-r--r--  1 tiago.lima domain^users tiago.lima 384K 2022-05-19 07:40 formhistory.sqlite
drwx------  3 tiago.lima domain^users tiago.lima 4,0K 2021-03-25 18:26 gmp/
drwxr-xr-x  3 tiago.lima domain^users tiago.lima 4,0K 2019-11-01 10:05 gmp-gmpopenh264/
drwxr-xr-x  3 tiago.lima domain^users tiago.lima 4,0K 2022-05-17 08:18 gmp-widevinecdm/
-rw-r--r--  1 tiago.lima domain^users tiago.lima 2,1K 2022-03-11 08:54 handlers.json
-rw-------  1 tiago.lima domain^users tiago.lima 288K 2019-08-09 10:03 key4.db
lrwxrwxrwx  1 tiago.lima domain^users tiago.lima   18 2022-05-19 07:35 lock -> 127.0.1.1:+2895807
-rw-r--r--  1 tiago.lima domain^users tiago.lima 176K 2022-05-19 04:29 logins.json
-rw-r--r--  1 tiago.lima domain^users tiago.lima 176K 2022-05-18 22:16 logins-backup.json
drwx------  2 tiago.lima domain^users tiago.lima 4,0K 2019-12-03 19:13 mediacapabilities/
drwx------  2 tiago.lima domain^users tiago.lima 4,0K 2022-02-27 02:28 minidumps/
-rw-------  1 tiago.lima domain^users tiago.lima 561K 2022-05-19 07:35 notificationstore.json
-rw-r--r--  1 tiago.lima domain^users tiago.lima 160K 2022-05-19 07:40 permissions.sqlite
drwxr-xr-x  2 tiago.lima domain^users tiago.lima 4,0K 2022-03-11 10:42 personality-provider/
-rw-------  1 tiago.lima domain^users tiago.lima  482 2019-08-06 17:12 pkcs11.txt
-rw-r--r--  1 tiago.lima domain^users tiago.lima  30M 2022-05-19 07:35 places.sqlite
-rw-r--r--  1 tiago.lima domain^users tiago.lima 1,3M 2022-05-19 07:40 places.sqlite-wal
-rw-------  1 tiago.lima domain^users tiago.lima  172 2020-01-28 08:21 pluginreg.dat
-rw-------  1 tiago.lima domain^users tiago.lima  46K 2022-05-19 07:40 prefs.js
-rw-------  1 tiago.lima domain^users tiago.lima  15K 2020-06-04 17:17 prefs-1.js
-rw-r--r--  1 tiago.lima domain^users tiago.lima  64K 2022-05-19 07:35 protections.sqlite
drwx------  2 tiago.lima domain^users tiago.lima 4,0K 2022-05-19 07:36 saved-telemetry-pings/
-rw-r--r--  1 tiago.lima domain^users tiago.lima 4,0K 2022-05-19 07:35 search.json.mozlz4
drwxr-xr-x  2 tiago.lima domain^users tiago.lima 4,0K 2020-04-10 10:58 security_state/
-rw-r--r--  1 tiago.lima domain^users tiago.lima  40K 2022-05-18 07:00 serviceworker.txt
-rw-r--r--  1 tiago.lima domain^users tiago.lima   90 2022-05-19 07:35 sessionCheckpoints.json
drwx------  2 tiago.lima domain^users tiago.lima 4,0K 2022-05-19 07:41 sessionstore-backups/
-rw-------  1 tiago.lima domain^users tiago.lima 1,6K 2021-07-22 17:28 shield-preference-experiments.json
-rw-------  1 tiago.lima domain^users tiago.lima   84 2020-06-19 19:26 shield-recipe-client.json
-rw-------  1 tiago.lima domain^users tiago.lima 3,5K 2022-05-19 04:29 signedInUser.json
drwxr-xr-x  5 tiago.lima domain^users tiago.lima 4,0K 2022-03-03 08:40 storage/
-rw-r--r--  1 tiago.lima domain^users tiago.lima  99K 2022-05-19 07:35 storage.sqlite
-rw-r--r--  1 tiago.lima domain^users tiago.lima 128K 2019-11-01 10:03 storage-sync.sqlite
-rw-r--r--  1 tiago.lima domain^users tiago.lima  32K 2020-07-30 07:21 storage-sync-v2.sqlite
-rw-r--r--  1 tiago.lima domain^users tiago.lima  32K 2022-05-19 07:35 storage-sync-v2.sqlite-shm
-rw-r--r--  1 tiago.lima domain^users tiago.lima 1,4M 2022-05-19 07:35 storage-sync-v2.sqlite-wal
-rw-------  1 tiago.lima domain^users tiago.lima   50 2019-08-06 17:12 times.json
drwx------  6 tiago.lima domain^users tiago.lima 4,0K 2022-05-19 07:37 weave/
-rw-r--r--  1 tiago.lima domain^users tiago.lima  30M 2022-05-19 07:40 webappsstore.sqlite
-rw-------  1 tiago.lima domain^users tiago.lima 2,0K 2022-05-19 07:35 xulstore.json
```
