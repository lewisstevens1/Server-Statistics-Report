# Lewis Stevens
# Get user input
$input = Read-Host -Prompt "Would you like to include column headers? [Y] Yes [N] No";

$output = "";
$servers = @(
    'BUNKERSERVERS1',
    'BUNKERSERVERS2',
    'BUNKERSERVERS3'
);

# Location for File Export
$source = "C:\listServers.csv";

$headers = @(
    'VMName',    
    'ProcessorCount',
    'MemoryAssigned',
    'Generation',
    'IntegrationServicesState',
    'State'
        
    #'Path',  
    #'ReplicationState',
    #'VMId',
    #'OperationalStatus',       
    #'CPUUsage',   
    #'Uptime',
    #'Id',
    #'Name',
    #'ConfigurationLocation',  
    #'PrimaryOperationalStatus',
    #'SecondaryOperationalStatus',
    #'StatusDescriptions',
    #'PrimaryStatusDescriptions',
    #'SecondaryStatusDescriptions',
    #'Status',
    #'Heartbeat',
    #'ReplicationHealth',
    #'ReplicationMode',
    #'MemoryDemand',
    #'MemoryStatus',
    #'ResourceMeteringEnabled',
    #'SmartPagingFileInUse',
    #'IntegrationServicesVersion',
    #'SnapshotFileLocation',
    #'AutomaticStartAction',
    #'AutomaticStopAction',
    #'AutomaticStartDelay',
    #'SmartPagingFilePath'
    #'NumaAligned',
    #'NumaNodesCount',
    #'NumaSocketCount',
    #'Key',
    #'IsDeleted',
    #'ComputerName',     
    #'Version',
    #'Notes',
    #'CreationTime',
    #'IsClustered',
    #'SizeOfSystemFile',
    #'ParentSnapshotId',
    #'ParentSnapshotName',
    #'MemoryStartup',
    #'DynamicMemoryEnabled',
    #'MemoryMinimum',
    #'MemoryMaximum',
    #'RemoteFxAdapter',
    #'NetworkAdapters',
    #'FibreChannelHostBusAdapters',
    #'ComPort1',
    #'ComPort2',
    #'FloppyDrive',
    #'DVDDrives',
    #'HardDrives',
    #'VMIntegrationService'
);

# Write headers
if($input.ToString().ToUpper().Substring(0,1) -eq "Y"){
    $headerString = '"BUNKER"';

    for($i=0; $i -lt $headers.Length; $i++){
        $headerString += ',"'+$headers[$i]+'"';
    }
    
    $output = $headerString;
}

# Execute remote command on each server.
$job = Invoke-Command $servers {

    Get-VM | %{
        $outputString += "`r`n" + '"'+$env:computername+'"';

        foreach($head in $using:headers){
            $outputString += ',"' + $_.$head + '"';
        } 
    }

    echo $outputString;

}  -AsJob


# Hold off from calling next command until previous has been completed, slower but safer.
Wait-Job $job


# Return job values.
$output += Receive-Job $job
   

# Write output to file.   
$output.TrimStart() | Out-File -filepath $source