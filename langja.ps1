$LpURL = "http://fg.v4.download.windowsupdate.com/d/msdownload/update/software/updt/2013/09"
$CabFile = "lp_3d6c75e45f3247f9f94721ea8fa1283392d36ea2.cab"
$AppTemp = (Join-Path $Env:LOCALAPPDATA "Temp")
(New-Object Net.Webclient).DownloadFile("$LpURL/$CabFile", (Join-Path "$AppTemp" "$CabFile"))
Add-WindowsPackage -Online -PackagePath (Join-Path "$AppTemp" "$CabFile")
