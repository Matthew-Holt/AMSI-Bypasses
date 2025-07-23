$listener = [System.Net.Sockets.TcpListener]31337
$listener.Start()
Write-Host "Listening on port 31337..."

$client = $listener.AcceptTcpClient()
Write-Host "Connection received from $($client.Client.RemoteEndPoint)"

$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$reader = New-Object System.IO.StreamReader($stream)
$writer.AutoFlush = $true

while ($client.Connected) {
    Write-Host -NoNewline "PS> "
    $cmd = Read-Host
    if ($cmd -eq 'exit') {
        break
    }

    $writer.WriteLine($cmd)
    
    Start-Sleep -Milliseconds 500
    while ($stream.DataAvailable) {
        $response = $reader.ReadLine()
        Write-Host $response
    }
}

$reader.Close()
$writer.Close()
$stream.Close()
$client.Close()
$listener.Stop()
