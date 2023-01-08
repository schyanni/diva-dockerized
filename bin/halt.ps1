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
    Write-Host "docker not available. Please install it first."
    Exit 1;
}

try {
    Get-Command "docker-compose"
}
catch {
    Write-Host "docker compose not available. Please install it first."
    Exit 2;
}

if( $DIVA_TESTNET -gt 0) {
    $BASE_DOMAIN = "join.testnet.diva.i2p";
}

$PATH_DOMAIN = "$PROJECT_DIRECTORY\build\domains\$BASE_DOMAIN";
if (-not (Test-Path -Path "$PATH_DOMAIN")) {
    Write-Host "Path not found: $PATH_DOMAIN";
    Exit 3;
}

Set-Location $PATH_DOMAIN;

if (-not (Test-Path -Path ".\diva.yml")) {
    Write-Host "File not found: $PATH_DOMAIN\diva.yml";
    Exit 4;
}

Write-Host "Halting $PATH_DOMAIN";
docker compose -f ./diva.yml down

Write-Host "Halted $PATH_DOMAIN"
Set-Location $PROJECT_DIRECTORY