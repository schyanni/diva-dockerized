
Function Write-Warning() {
    Write-Host -ForegroundColor Yellow "$args"
}

Function Write-Error() {
    Write-Host -ForegroundColor Red "$args"
}

Function Write-Info() {
    Write-Host -ForegroundColor Green "$args"
}