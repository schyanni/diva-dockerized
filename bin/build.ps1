# this is a port of the build.sh script

# Set options

param(
    $I2P_LOGLEVEL='none',
    $DIVA_TESTNET=0,
    $JOIN_NETWORK="",
    $BASE_NETWORK="testnet.local",
    $SIZE_NETWORK=7,
    $PURGE=0,
    $BASE_IP="172.19.72.",
    $PORT=17468,
    $NODE_ENV="production",
    $LOG_LEVEL="info"
)

Set-Location "$PSScriptRoot/.."
$PROJECT_DIRECTORY= "$(Get-Location)"

# load helpers
. "$PROJECT_DIRECTORY\bin\util\echos.ps1"

# ----------------------------------------------------
# handle joining
if ($DIVA_TESTNET -gt 0) {
    $JOIN_NETWORK = "diva.i2p/testnet";
    $SIZE_NETWORK = 1;
    $BASE_DOMAIN = "testnet.diva.i2p";
}

if ($JOIN_NETWORK -ne "") {
    $SIZE_NETWORK = 1;
    $BASE_DOMAIN = "join.$BASE_DOMAIN"
}

try {
    Get-Command "docker"
}
catch {
    Write-Error "docker not available. Please install it first.";
    Exit 2;
}

try {
    Get-Command "docker-compose"
}
catch {
    Write-Error "docker compose not available. Please install it first.";
    Exit 2;
}

$PATH_DOMAIN = "$PROJECT_DIRECTORY/build/domains/$BASE_DOMAIN";

if (-not (Test-Path -Path $PATH_DOMAIN)) {
    New-Item "$PATH_DOMAIN" -ItemType Directory;
    New-Item "$PATH_DOMAIN/genesis" -ItemType Directory;
    New-Item "$PATH_DOMAIN/keys" -ItemType Directory;
    New-Item "$PATH_DOMAIN/state" -ItemType Directory;
    New-Item "$PATH_DOMAIN/blockstore" -ItemType Directory;
}

Set-Location $PATH_DOMAIN

# todo: check existence of docker and docker compose

if (Test-Path -Path "./diva.yml" ) {
    docker compose -f ./diva.yml down
}

if ($PURGE -gt 0) {
    Write-Warning "Deleting ALL local diva data and re-creating the environment..";

    if (Test-Path -Path "./diva.yml") {
        docker compose -f ./diva.yml down --volumes
    }

    Remove-Item -Path "$PATH_DOMAIN/genesis/*" -Recurse -Force
    Remove-Item -Path "$PATH_DOMAIN/keys/*" -Recurse -Force
    Remove-Item -Path "$PATH_DOMAIN/state/*" -Recurse -Force
    Remove-Item -Path "$PATH_DOMAIN/blockstore/*" -Recurse -Force  
}

if (-not (Test-Path -Path "./genesis/local.config")) {
    Write-Info "Creating Genesis Block using I2P";

    if (Test-Path -Path "./genesis-i2p.yml") {
        $env:SIZE_NETWORK=$SIZE_NETWORK;
        docker compose -f ./genesis-i2p.yml down --volumes
        Remove-Item env:SIZE_NETWORK
    }

    Copy-Item -Path "$PROJECT_DIRECTORY/build/genesis-i2p.yml" -Destination "./genesis-i2p.yml";
    $env:SIZE_NETWORK=$SIZE_NETWORK
    docker compose -f ./genesis-i2p.yml pull
    docker compose -f ./genesis-i2p.yml up -d
    Remove-Item env:SIZE_NETWORK

    Write-Info "Waiting for Key Generation"
    #wait until all keys are created
    while (-not (Test-Path -Path genesis/local.config)) {
        Start-Sleep -Seconds 2
    }

    #shut down genesis container and clean up
    $env:SIZE_NETWORK = $SIZE_NETWORK
    docker compose -f ./genesis-i2p.yml down --volumes
    Remove-Item env:SIZE_NETWORK
    Remove-Item -Path "./genesis-i2p.yml";

    #handle joining
    if ( $JOIN_NETWORK -ne "") {
        Remove-Item -Force -Path "./genesis/block.v5.json";
        Copy-Item -Path "$PROJECT_DIRECTORY/build/dummy.block.v5.json" -Destination "./genesis/block.v5.json";
    }

    Write-Info "Genesis Block successfully created"
}

Write-Info "Creating diva.yml file"


$env:JOIN_NETWORK = $JOIN_NETWORK;
$env:SIZE_NETWORK = $SIZE_NETWORK;
$env:BASE_DOMAIN = $BASE_DOMAIN;
$env:BASE_IP = $BASE_IP;
$env:PORT = $PORT;
$env:NODE_ENV = $NODE_ENV;
$env:LOG_LEVEL = $LOG_LEVEL;

& "$PROJECT_DIRECTORY\node_modules\.bin\ts-node.ps1" "$PROJECT_DIRECTORY\build\build.ts"

Remove-Item env:JOIN_NETWORK
Remove-Item env:SIZE_NETWORK
Remove-Item env:BASE_DOMAIN
Remove-Item env:BASE_IP
Remove-Item env:PORT
Remove-Item env:NODE_ENV
Remove-Item env:LOG_LEVEL

Set-Location -Path "$PROJECT_DIRECTORY"