###########################################
# Foundry Local Installation
###########################################
# Windows
winget install Microsoft.FoundryLocal
winget upgrade --id Microsoft.FoundryLocal

# MAC OS
#brew tap microsoft/foundrylocal
#brew install foundrylocal

###########################################
# Download phi4 reasoning model
###########################################
foundry model download phi-4-mini-reasoning

###########################################
# Load phi4 reasoning model to foundry service
###########################################
foundry model load phi-4-mini-reasoning

###########################################
# Get foundry model uri & model id
###########################################
$serviceUri = [System.Uri]((foundry service status).Split(' ') | Where-Object {
    [System.Uri]::TryCreate($_, [System.UriKind]::Absolute, [ref]$null)
} | Select-Object -First 1)
$modelUri = "$($serviceUri.Scheme)://$($serviceUri.Host):$($serviceUri.Port)"
$modelUri 

$modelId = (((foundry model info phi-4-mini-reasoning) -split '\s{2,}')[-1])
$modelId

##########################################
# Store configuration in ./config/config.env
##########################################
$configurationFile = "./config/config.env"
function Set-ConfigurationFileVariable($configurationFile, $variableName, $variableValue) {
    if (Select-String -Path $configurationFile -Pattern $variableName) {
        (Get-Content $configurationFile) | Foreach-Object {
            $_ -replace "$variableName = .*", "$variableName = $variableValue"
        } | Set-Content $configurationFile
    } else {
        Add-Content -Path $configurationFile -value "$variableName = $variableValue"
    }
}

Set-ConfigurationFileVariable $configurationFile "ModelUri" $modelUri
Set-ConfigurationFileVariable $configurationFile "ModelId" $modelId



