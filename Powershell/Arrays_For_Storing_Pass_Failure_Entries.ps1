
$logLocation = "C:\Source\Logs"

$logFiles = Get-ChildItem $logLocation

$TestNameList = @()
$PassList = @() 
$FailList = @()

$logFileCount=0;
foreach ($logFile in $logFiles){
          
          if($logFile.Name.StartsWith("Simulator_Tests")){
              $resultLog=$logFile
              $logFileCount++
           }else { continue }   

$resultLogLocation = $logLocation+"\"+$resultLog.Name

$Second_Line=(Get-Content $resultLogLocation)[1]
$Test_Name= $Second_line.Substring(0, $Second_Line.IndexOf(":"))
$Test_Name= $Test_Name.Substring(0,$Test_Name.length - 7)
$Test_Name=$Test_Name.Trim()



$TEST_PASS=Select-String -Path $resultLogLocation -Pattern "RESULT: PASS"
$TEST_FAIL=Select-String -Path $resultLogLocation -Pattern "RESULT: FAIL"

$TestNameList+=$Test_Name 
$PassList +=$TEST_PASS.count
$FailList += $TEST_FAIL.count  

}

$Date_Suffix= $Today=(Get-Date).ToString('_dd_MM_yyyy')

$ReportFileName=$logLocation+"\TestReport"+$Date_Suffix+".csv" 

Add-Content $ReportFileName "`n`nSimulator Tests Results"
$Today=(Get-Date).ToString('MM/dd/yyyy')
Add-Content  $ReportFileName "Test Date, Feature, Tests, Fails, Passes, Pass Rate"

$TotalTestCount=0
$TotalPassCount=0
$TotalFailCount=0



for($i =0; $i -lt $logFileCount; $i++)
    {  
    $Feature= $TestNameList[$i]
    $TestCount= $FailList[$i] + $PassList[$i]
    $TotalTestCount+=$TestCount
    $PassRate= ($PassList[$i]/$TestCount)*100
    $PassRate=[math]::round($PassRate,2)
    $Passes= $PassList[$i]
    $TotalPassCount+=$Passes
    $Fails= $FailList[$i]
    $TotalFailCount+=$Fails

    Add-Content $ReportFileName "$Today, $Feature, $TestCount, $Fails, $Passes,  $PassRate %" 
    }

    $TotalPassRate= ($TotalPassCount/$TotalTestCount)*100

    $TotalPassRate=[math]::round($TotalPassRate,2)

    Add-Content $ReportFileName "$Today, Total, $TotalTestCount, $TotalFailCount, $TotalPassCount, $TotalPassRate %" 