#

param(
    $DIVA_TESTNET=0,
    $BASE_DOMAIN="testnet.local",
    $NO_BOOTSTRAPPING=0
)

Set-Location "$PSScriptRoot/..";
$PROJECT_DIRECTORY= "$(Get-Location)";

. "$PROJECT_DIRECTORY\bin\util\echos.ps1"

try {
    Get-Command "docker"
}
catch {
    Write-Error "docker not available. Please install it first."
    Exit 1;
}

try {
    Get-Command "docker-compose"
}
catch {
    Write-Error "docker compose not available. Please install it first."
    Exit 2;
}

if( $DIVA_TESTNET -gt 0) {
    $BASE_DOMAIN = "join.testnet.diva.i2p";
}

$PATH_DOMAIN = "$PROJECT_DIRECTORY\build\domains\$BASE_DOMAIN";
if (-not (Test-Path -Path "$PATH_DOMAIN")) {
    Write-Error "Path not found: $PATH_DOMAIN";
    Exit 3;
}

Set-Location $PATH_DOMAIN;

if (-not (Test-Path -Path ".\diva.yml")) {
    Write-Host "File not found: $PATH_DOMAIN\diva.yml";
    Exit 4;
}

Write-Host "Pulling $PATH_DOMAIN";
docker compose -f ./diva.yml pull

Write-Host "Starting $PATH_DOMAIN";
$env:NO_BOOTSTRAPPING = $NO_BOOTSTRAPPING
docker compose -f ./diva.yml up -d
Remove-Item env:NO_BOOTSTRAPPING

Write-Host "Started $PATH_DOMAIN"
Set-Location $PROJECT_DIRECTORY