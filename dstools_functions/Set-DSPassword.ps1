<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.188
	 Created on:   	5/19/2021 11:05 PM
	 Created by:   	BW069340
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		This function will generate a strong password from a list of dictionary words listed in a .txt file.
		This password is intended to be used as a temporary password only.
#>


Function Set-DSPassword
{
	[CmdletBinding()]
	param(
		[parameter(Mandatory = $true,
			 ValueFromPipeline = $true)]
		[string]$Path,
		[parameter(Mandatory = $true)]
		[int]$minlength
	)
	
	<#The $Dictionary and $Dictionary2 variables will contain a random word from a list that is stored in a .txt file
		*The $Special variable will contain a special character from a list
		*The $Number variable will contain a random number from 0 - 9
		*If the password is too short, a number will be appended to the password until the password meets the requirements from the domain
		*Once the password is the correct length, a special character will be added to the end of the password.
	#>
	begin
	{
		$Dictionary = Get-Content -Path $Path | Get-Random -Count 1
		$Dictionary2 = Get-Content -Path $Path | Get-Random -Count 1
		$Special = Get-Random ('!', '?')
		$Number = Get-Random -Minimum 0 -Maximum 10
		$Password = $Dictionary + $Dictionary2 + $Number
	}
	process
	{
		if ($Password.length -lt ($minlength - 1))
		{
			do
			{
				$Number = Get-Random -Minimum 0 -Maximum 10
				$Password = $Password + $Number
			}
			while ($Password.length -lt ($minlength - 1))
		}$Password = $Password + $Special
	}
	end
	{
		return $Password
	}
}


