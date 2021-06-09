<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.188
	 Created on:   	5/20/2021 12:08 AM
	 Created by:   	BW069340
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
import-module activedirectory

function New-DSADAccount
{
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[Validatescript({
				if (-not ($_ | test-path))
				{ throw "The file path specified is not valid." } })]
		[system.IO.FileInfo]$Path
	)
	
	<#
	Description: This script pulls from a CSV file located on the user's local hard drive
	  *  It will create each account and generate a password
	  *  Set Primgrp as the default group and remove Domain users
	  *  Populate FTP3 with the user's email and credentials and send them
	#>
	
	
	BEGIN 
	{
		#Region - Initial import of the CSV, declares an area to hold account details in
		$csv = Import-Csv -Path $Path
		$results = @()
		#endregion
	}
	PROCESS
	{
	    
	}
	END
	{
		EndBlock
	}
	
	
	#Region - The Foreach loop which each user's details will be run through
	ForEach ($test in $csv)
	{
		
		$OU = $test.OU
		
		#This is where the specific path for the Client OU is designated
		
		#$Path = "OU=$($comboboxSelectDomain.Text),OU=Tier3,OU=USVA-DC,OU=Accounts,OU=Clients,DC=LCAHNCRKC,DC=net"
		$Path = "OU=$($comboboxSelectDomain.Text),OU=Active,OU=VA_Sandbox_Users,OU=Users,OU=LEID_VA,OU=Clients,DC=leid_va,DC=cernerasp,DC=com"
		$results = @()
		$pwlength = 16
		
		#region - Declares the variables for use in the script
		$UserFirstname = $test.First
		$UserLastname = $test.Last
		$Initials = $test.Initials
		$join = $test.First + $test.Last
		$UserDisplayName = "$Userlastname, $UserFirstName $Initials"
		$userID = $test.userid
		$userPrincipal = $userID + "@leid_va.cernerasp.com"
		$Description = $test.credential
		$Email = $test.Email
		$StreetAddress = $test.StreetAddress
		$City = $test.City
		$State = $test.State
		$PostalCode = $test.PostalCode
		$OfficePhone = $test.OfficePhone
		$accountExpiration = (get-date).AddDays(365)
		$ADpwd = (Set-Password)
		#endregion
		
	}
	
	
	#endregion
		
		#region - Details stored in the $details variable will be exported to the VAACTResults.csv file. 
		$details = [ordered]@{
			"OU"		   = $($comboboxSelectDomain.Text);
			"First"	       = $UserFirstname;
			"Last"		   = $UserLastname;
			"Username"	   = $userID;
			"Email"	       = $Email;
			"EDIPI"	       = $EDIPI;
			"Password"	   = $ADpwd;
			"Action Taken" = $Action;
			
		}
		$resultdate = Get-Date -Format "hh-mm-MM-dd-yyyy"
		$resultfile = "C:\VA Provisioning Team\VAACTresults$($resultdate).csv"
		$results += New-Object System.Management.Automation.PSObject -property $details | Export-Csv $resultfile -NoTypeInformation -force -Append
		#endregion
	}
	
	#endregion
	
	#region - script completed, launch results file.
	#The user will receive notification that the users have been created. The message on the screen will prompt them to check for details in the results file. Results will launch automatically. 
	
	$note.popup("Complete, check the contents of the VAACT results file for details.")
	Start-Process $resultsfile
	
	#endregion
}

