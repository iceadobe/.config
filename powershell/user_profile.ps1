## IMPORTS
Import-Module posh-git
Import-Module Terminal-Icons
Import-Module z

## CONFIGURATION 
#  -----/ PSReadLine
#use PSReadLine only for PowerShell and VS Code
if ($host.Name -eq 'ConsoleHost' -or $host.Name -eq 'Visual Studio Code Host' ) {
    #ensure the correct version is loaded
    Import-Module PSReadline
    #ListView currently works only with -EditMode Windows properly
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -PredictionSource History
    #add background color to the prediction preview
    Set-PSReadLineOption -Colors @{InlinePrediction = "$([char]0x1b)[36;7;238m]"}
    #change the key to accept suggestions (default is right arrow)
    Set-PSReadLineKeyHandler -Function AcceptSuggestion -Key 'ALT+r'
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
}

#   -----/ FZF Search
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

## DUNZO!!! 
#   -------/ load aliases
set CONFIG_PATH "~/.config/powershell"
[string]::join([environment]::newline, (get-content -path $CONFIG_PATH/aliases.ps1)) |Invoke-Expression
[string]::join([environment]::newline, (get-content -path $CONFIG_PATH/aliases-k8s.ps1)) |Invoke-Expression
#   -------/ setup prompt
oh-my-posh init pwsh --config $CONFIG_PATH/spaceship.omp.json | Invoke-Expression