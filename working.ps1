<#
$siteroot = "www.thepowerof10.info"

$site = Invoke-WebRequest -uri "$siteroot/rankings/rankinglist.aspx?event=100&agegroup=ALL&sex=M&year=2018"
#$site.parsedhtml
clear-host
#$site.Content 

$athletes = $site.allelements | where {$_.tagname -eq "a" -and $_.href -like "/athletes/profile.aspx*"}
$athletes.count

$athletename = "Aidan Leach"

$athlete = $athletes | where {$_.innerhtml -eq $athletename}
$profileurl = $athlete.href
$profile = invoke-webrequest -uri "$siteroot$profileurl"
$profile.allelements | where {$_.tagname -like "*bestperformancesheader*"}

$test = $profile.AllElements | where {$_.tagname -eq "td" -and 
$test.tagname


$athleteprofile = "$siteroot$profileurl"
$r = Invoke-WebRequest $athleteprofile
& C:\Temp\competition_entrants\Get-WebRequestTable.ps1 $r -TableNumber 15| Format-Table -Auto



#>
clear-host
$athletename = "Charlotte Nicholls"
$genderid = "W"
$eventid = "SP4K"
write-host "Checking PB for $athletename in event $eventid..." -ForegroundColor Yellow
$site = "$siteroot/rankings/rankinglist.aspx?event=$eventid&agegroup=ALL&sex=$genderid&year=2018"
$siteparser = invoke-webrequest -uri $site
$athlete = $siteparser.allelements | where {$_.tagname -eq "a" -and $_.href -like "/athletes/profile.aspx*" -and $_.innerHTML -like "*$athletename*"}
$profileurl = $athlete.href
$athleteprofile = "$siteroot$profileurl"
$r = Invoke-WebRequest $athleteprofile
$tables = @($R.ParsedHtml.getElementsByTagName("TABLE"))

foreach ($table in $tables){
    $innertext = $table.innerText
    $classname = $table.className
    $uniquenumber = $table.uniquenumber
    if($classname -ne "alternatingrowspanel" -and $innertext -like "EventPB*"){
        $tablenumber = $uniquenumber
    }
}
#clear-host
$resultstable = & C:\Temp\competition_entrants\Get-WebRequestTable.ps1 $r -TableNumber $tablenumber | Format-Table -Auto
$results = & C:\Temp\competition_entrants\Get-WebRequestTable.ps1 $r -TableNumber $tablenumber
<#
foreach ($result in $results | where {$_.name -eq "P1"}) {
    $
    write-host $result.P2
}
#>
$PB = $results | where {$_.P1 -eq $eventid} | select -expandproperty P2
write-host "PB for $athletename in event $eventid is $PB" -ForegroundColor Cyan
