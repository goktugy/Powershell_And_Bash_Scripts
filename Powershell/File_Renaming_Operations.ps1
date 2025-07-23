
#$Last_Updated_Files = Get-ChildItem 'C:\tmp' | Where {$_.LastWriteTime} | select -last 2

$logFiles = Get-ChildItem 'C:\Simulator_AutoTests\logs' 

foreach ($logFile in $logFiles){
          
          if($logFile.Name.StartsWith("SIMCOT_test_result")){
              $copyfile=$logFile
           }else { continue }   
        

$source= "C:\Simulator_AutoTests\logs\"+ $copyfile.Name      
$destination = "C:\Destination\Logs" 

if($copyfile){
   Copy-Item $source $destination
   }
$file_to_rename = $destination+"\"+$copyfile.Name

$Second_Line=(Get-Content $file_to_rename)[1]
$Test_Name= $Second_line.Substring(0, $Second_Line.IndexOf(":"))
$Test_Name= $Test_Name.Substring(0,$Test_Name.length - 7)
$Test_Name=$Test_Name.Trim()
$Test_Name=$Test_Name.Replace(" ","_")
$Today=(Get-Date).ToString('_dd_MM_yyyy')
$Test_Name="\Simulator_Tests_"+$Test_Name+$Today+".log"
$Test_Name=$destination+$Test_Name

Rename-Item $file_to_rename $Test_Name

}
