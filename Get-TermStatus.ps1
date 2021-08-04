<#.Synopsis
   This function will allow a technician to grab information about a group of users by copying them into their clipboard 
.DESCRIPTION
   This function will allow a technician to grab information about a group of users by copying them into their clipboard. The function will take either the '-paste' parameter
   or the '-first -last' parameter. If the list of users is in your clipboard, select the '-paste' parameter to use the information in your clipboard as the input for the function.
   If you would like to search for one user at a time, enter a first and last name with the '-firstname' and '-lastname' parameters.
.EXAMPLE
   Get_TermStatus -paste
.EXAMPLE
   Get-TermStatus -Firstname "Ben" -Lastname "Wharton"
#>

function Get-TermStatus
{
	[CmdletBinding()]
	Param
	(
		# -Paste will use the text from your clipboard as the input for the Get-TermStatus function
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $True,
				   ValueFromPipelineByPropertyName = $true,
                   ParameterSetName = "Paste",
				   Position = 0)]
		[switch]$Paste,
        [parameter(mandatory = $True,
                  ValueFromPipeline = $True,
                  ValueFromPipelineByPropertyName = $True,
                  ParameterSetName = "FirstLast")]
        [string]$First,
        [parameter(mandatory = $True,
                  ValueFromPipeline = $True,
                  ValueFromPipelineByPropertyName = $True,
                  ParameterSetName = "FirstLast")]
        [string]$Last
	)
	
	Begin
	{
        if($Paste.IsPresent)
        {
		    $users = Get-Clipboard
        }
        $gridview_object = @()
	}
	Process
	{
        if($Paste.IsPresent)
        {
		    foreach ($user in $users)
		    {
                if($user -ne "")
                {
			        $user_split = $user.split()
			        $first = $user_split[0]
			        $last = $user_split[1]
			        $gridview_object += (get-firstlast $first $last)
                }
		    }
        }
        else
        {
            $gridview_object += Get-FirstLast $First $Last
        }
	}
	End
	{
        $gridview_object | Out-GridView
	}
}

