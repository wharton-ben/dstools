<# This PowerShell script is designed to either install or update the dstools.psm1 module.
The administrator can set the path where the module will be stored (in many cases this
will be on a network share accessable by the desktop support team) and store it in the
$dstoolsmodule variable. The script is simple, it will check to see if you have a directory
pointing to a PSModulePath. If it exists, the script will check for the dstools.psm1 module.
If that also exists, the script will compare the last write time of both modules. If the 
version on the network share is newer (modified more recently), it will be copied into 
the users PSModulePath and replace the old version. If the module is up to date, the user
will receive a message letting them know that the module is up to date. If it is not up
to date, the script will copy the newer version to the users PSModulePath. If the directory
does not exist at all, the entire path will be copied to the users PSModulePath.#>

<#Declare variables for the script. These variables will store the values for the PSModulePath
and the location where the master copy of the module is stored.#>

$dstoolsdir = "$env:USERPROFILE\documents\WindowsPowerShell\Modules\dstools"

$dstoolsmodule = #Enter the path where the dstools module master copy is located 

<#Test to see if the user already has a WindowsPowerShell\Modules directory, if they do, copy the module to the directory
if not, create the directory and then copy the module to the new directory#>

#Test-Path will test the existance of the $dstoolsdir
if (Test-path $dstoolsdir)
{
	#If the path exists, check to see if the module is there
	if (Test-Path $dstoolsdir\dstools.psm1)
	{
		<#Declare the variables to access the last write time of the file on the technician's
		device and the file located on the server.#>
		$latestversion = (Get-ItemProperty -path $dstoolsmodule).LastWriteTime
		$userversion = (Get-ItemProperty -Path $dstoolsdir\dstools.psm1).LastWriteTime
		<#Compare the two files. If the master copy has been updated more recently that the copy 
		on the tech's machine, update the module.#>
		if ($userversion -lt $latestversion)
		{
			copy-item -Path $dstoolsmodule -Destination $dstoolsdir
		}
		else
		{
			write-host "You already have the latest version of the dstools module." -ForegroundColor Cyan
		}
	}
	#If the path exists, but the module does not, copy the module into the path.
	else
	{
		copy-item -Path $dstoolsmodule -Destination $dstoolsdir
	}
}

#If the PSModulePath does not exist, create the directory and copy the dstools.psm1 module into the new directory.
else
{
	#make WindowsPowerShell\Modules\dstools directory
	mkdir $dstoolsdir
	copy-item -Path $dstoolsmodule -Destination $dstoolsdir
}