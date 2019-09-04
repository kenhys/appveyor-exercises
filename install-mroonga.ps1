Param(
  [Parameter(mandatory=$true)][String]$mariadbVersion,
  [Parameter(mandatory=$true)][String]$platform
)

function Wait-UntilRunning($cmdName) {
  $Waiting = $TRUE
  do
  {
    switch ($cmdName) {
      "mysqld" {
        if (Test-Path stderr.txt) {
	  $Version = Get-Content mysqld.txt | Select-String -Pattern "^Version:"
	  if ($Version) {
	    $Waiting = $FALSE
	  }
        }
      }
      "mysql_install_db" {
        if (Test-Path install.txt) {
	  $Successful = Get-Content install.txt | Select-String -Pattern "successful"
	  if ($Successful) {
	    $Waiting = $FALSE
	  }
        }
      }
    }
    Start-Sleep -s 1
  } while ($Waiting)
}

function Wait-UntilTerminate($cmdName) {
  $Running = $TRUE
  do
  {
    if (Test-Path mysqld.txt) {
      $Complete = Get-Content mysqld.txt | Select-String -Pattern "Shutdown complete"
      if ($Complete) {
        $Running = $FALSE
      }
    }
    Start-Sleep -s 1
  } while ($Running)
}

function Install-Mroonga($mariadbVer, $arch, $installSqlDir) {
  Write-Output("Start to install Mroonga")
  cd "mariadb-$mariadbVer-$arch"
  if ("$mariadbVer" -eq "10.4.7") {
    Write-Output("Clean data directory")
    Remove-Item data -Recurse
    Start-Process .\bin\mysql_install_db.exe -RedirectStandardOutput install.txt
    Wait-UntilRunning mysql_install_db
  }
  Write-Output("Start mysqld.exe")
  Start-Process .\bin\mysqld.exe -ArgumentList "--console" -RedirectStandardError mysqld.txt
  Wait-UntilRunning mysqld
  Write-Output("Execute install.sql")
  Get-Content "$installSqlDir\install.sql" | .\bin\mysql.exe -uroot
  Write-Output("Shutdown mysqld.exe")
  Start-Process .\bin\mysqladmin.exe -ArgumentList "-uroot shutdown"
  Wait-UntilTerminate mysqld
  cd ..
  Write-Output("Finished to install Mroonga")
}

$installSqlDir = ".\share\mroonga"

Install-Mroonga $mariadbVersion $platform $installSqlDir
