<#
.Synopsis
   This function will allow an administrator to find all of the ACLs applied to a network share's child folders.
.DESCRIPTION
   If a user needs access to all subfolders within a parent folder, this command will allow you to get a list of all of the security groups that have access to the folder. 
.PARAMETER Path
   Specifies the path to the parent folder.
.PARAMETER Match
   Specifies a string to match a security group name to.
.EXAMPLE
   PS> Get-ChildFolderACL -path \\server\root\parent_folder
.EXAMPLE
   PS> Get-ChildFolderACL -path \\server\root\parent_folder -match group_name
#>
function Get-ChildFolderACL
{
	[CmdletBinding()]
	[OutputType([string])]
	Param
	(
		# Param1 help description
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0)]
		[string]$Path,
		[Parameter(Mandatory = $false)]
		[string]$Match = "*"
	)
	
	Begin
	{
		set-location $path
	}
	Process
	{
		foreach ($child in Get-ChildItem)
		{
			$child_item = $child.Name
			
			foreach ($acl in get-acl -path $child_item | select-object -ExpandProperty access)
			{
				if ($acl.identityreference -like "*$Match*")
				{
					try
					{
						$owner = Get-ADGroup ([string]$acl.identityreference).Split("\")[1] -Properties managedby
					}
					catch
					{
						Write-Warning "This group/member does not have a manager listed."
					}
					
					Write-Host "$($owner.managedby) $(([string]$acl.identityreference).Split("\")[1])"
				}
				
			}
			
		}
	}
	End
	{
		Write-host "`nComplete." -ForegroundColor Green
	}
}


