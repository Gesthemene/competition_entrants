[CmdletBinding(DefaultParameterSetName="url")]
Param (
    [Parameter(ParameterSetName="url")]
    [string]$URL = "http://coinmarketcap.com/currencies/views/all"
)

cls
Write-Verbose "Retrieving informatoin from web"
$HTML = Invoke-WebRequest -Uri $URL
If ($HTML.StatusCode -ne 200)
{   Throw "Page did not load properly, aborting."
}

$RawTables = $HTML.ParsedHtml.getElementsByTagName("table")
Write-Verbose "Found $($RawTables.Count) tables in HTML"
$TableNum = 1
ForEach ($RawTable in $RawTables)
{   Write-Verbose "Parsing headers for Table #$TableNum"
    $InnerHTML = ($RawTable | select innerHtml).innerHtml -split "`n"

    $Search = $InnerHTML | Select-String -Pattern "<th ?.*?>(.*?)</th>" -AllMatches
    $Fields = [ordered]@{}
    ForEach ($Line in $Search)
    {   ForEach ($Field in $Line.Matches)
        {   $Fields.Add($Field.Groups[1].Value,$null)
        }
    }

    Write-Verbose "Parsing table data for Table #$TableNum"
    If ($Fields.Count -gt 0)
    {   $Search = $InnerHTML | Select-String -Pattern "<td ?.*?>(.*?)</td>" -AllMatches
        $Row = [PSCustomObject]$Fields
        $Index = 0
        $Table = ForEach ($Match in $Search.Matches)
        {   $Field = $Fields.GetEnumerator().Name[$Index]
            $Row.$Field = ($Match.Groups[1].Value -replace "<.*?>","").Trim()
            If ($Index -eq ($Fields.Count - 1))
            {   $Index = 0
                Write-Output $Row
                $Row = [PSCustomObject]$Fields
            }
            Else
            {   $Index ++
            }
        }
        [PSCustomObject]@{
            Raw = $InnerHTML
            Data = $Table
            Fields = $Fields
        }
    }
    Else
    {   Write-Warning "Unable to determine headers for Table #$TableNum, skipping it"
    }
    $TableNum ++
}