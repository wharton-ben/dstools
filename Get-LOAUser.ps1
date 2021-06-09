<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.188
	 Created on:   	5/17/2021 7:35 PM
	 Created by:   	BW069340
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

<#
.Synopsis
   This function takes a username (or a list of usernames) as an argument and lists the user's LOA Status.
.DESCRIPTION
   This function takes a username (or a list of usernames) as an argument and lists the user's LOA Status. 
.EXAMPLE
   Get-LOAUser -users 47082

.EXAMPLE
   Get-LOAUser -users 12345, 47832, 2345
#>

function Get-LOAUser
{
	[cmdletbinding()]
	param (
		[Parameter(
				   mandatory = $true,
				   ParameterSetName = "users",
				   valuefrompipelinebypropertyname = $true)]
		[string[]]$users,
		[Parameter(
				   Mandatory = $false,
				   ParameterSetName = "clipboard")]
		[Switch]$paste
	)
	# Find the attributes that are set by the LOA scripts
	
	if ($paste)
	{
		$users = Get-Clipboard
	}
	
	foreach ($user in $users)
	{
		if ($user -ne "")
		{
			$userdetails = Get-ADUser $user -Properties description, logonworkstations | select description, logonworkstations
			if (Get-ADPrincipalGroupMembership $user | where { $_.name -like "LOA Accounts" })
			{
				$LOAGroup = $true
			}
			else
			{
				$LOAGroup = $false
			}
			$details = [ordered]@{
				"User"	      = $user;
				"Description" = $userdetails.description;
				"Logon WS"    = $userdetails.logonworkstations;
				"LOA Group"   = $LOAGroup
			}
			$results = New-Object psobject -Property $details
			$results
		}
	}
}

