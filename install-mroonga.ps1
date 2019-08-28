Param(
  [Parameter(mandatory=$true)][String]$mariadbVersion,
  [Parameter(mandatory=$true)][String]$platform
)

function Wait-UntilRunning($cmdName) {
  do
  {
    Start-Sleep -s 1
    $Running = Get-Process $cmdName -ErrorAction SilentlyContinue
    Write-Output "Wait-UntilRunning"
    if ($Running -and ($(Get-Date) - $Running.StartTime) -lt 10) {
      Write-Output "< 10 sec"
    }
  } while (!$Running -or (($(Get-Date) - $Running.StartTime) -lt 10))
}

function Wait-UntilTerminate($cmdName) {
  do
  {
    Start-Sleep -s 1
    $Running = Get-Process $cmdName -ErrorAction SilentlyContinue
    Write-Output "Wait-UntilTerminate"
    Write-Output $Running
  } while ($Running)
}

function Install-Mroonga($mariadbVer, $arch, $installSqlDir) {
  cd "mariadb-$mariadbVer-$arch"
  Start-Process .\bin\mysqld.exe
  Wait-UntilRunning mysqld
  Get-Content "$installSqlDir\install.sql" | .\bin\mysql.exe -uroot
  Start-Process .\bin\mysqladmin.exe -ArgumentList "-uroot shutdown"
  Wait-UntilTerminate mysqld
  cd ..
}

$installSqlDir = ".\share\mroonga"

Install-Mroonga $mariadbVersion $platform $installSqlDir
