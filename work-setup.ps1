$graphical = @(
    @{name = "Microsoft.VisualStudio.2022.Professional" }
    # @{name = "Microsoft.VisualStudio.2022.Professional-Preview" }
);

$apps = @(
    @{name = "Microsoft.PowerToys" }
    @{name = "Microsoft.WindowsTerminal" }
    @{name = "Microsoft.VisualStudioCode" }
    @{name = "GitHub.GitHubDesktop" }
    @{name = "7zip.7zip" }
    @{name = "ShareX.ShareX" }
    @{name = "Notepad++.Notepad++" }
    @{name = "Postman.Postman" }
);

function install_gui {
    Write-Host -ForegroundColor Cyan "Installing new Apps wit GUI"
    Foreach ($gui in $graphical) {
        $listGUI = winget list --exact -q $gui.name
        if (![String]::Join("", $listGUI).Contains($gui.name)) {
            Write-Host -ForegroundColor Yellow "Install:" $gui.name
            if ($gui.source -ne $null) {
                winget install --exact --interactive --accept-package-agreements --accept-source-agreements $gui.name --source $gui.source
                if ($LASTEXITCODE -eq 0) {
                    Write-Host -ForegroundColor Green $gui.name "successfully installed."
                }
                else {
                    $gui.name + " couldn't be installed." | Add-Content "$DesktopPath\$errorlog"
                    Write-Host
                    Write-Host -ForegroundColor Red $gui.name "couldn't be installed."
                    Write-Host -ForegroundColor Yellow "Write in $DesktopPath\$errorlog"
                    Write-Host
                    Pause
                }
            }
            else {
                winget install --exact --interactive --accept-package-agreements --accept-source-agreements $gui.name
                if ($LASTEXITCODE -eq 0) {
                    Write-Host -ForegroundColor Green $gui.name "successfully installed."
                }
                else {
                    $gui.name + " couldn't be installed." | Add-Content "$DesktopPath\$errorlog"
                    Write-Host
                    Write-Host -ForegroundColor Red $gui.name "couldn't be installed."
                    Write-Host -ForegroundColor Yellow "Write in $DesktopPath\$errorlog"
                    Write-Host
                    Pause
                }            
            }
        }
        else {
            Write-Host -ForegroundColor Yellow "Skip installation of" $gui.name
        }
    }
    Pause
    Clear-Host
}

### Install Apps silent ###
function install_silent {
    Write-Host -ForegroundColor Cyan "Installing new Apps"
    Foreach ($app in $apps) {
        $listApp = winget list --exact -q $app.name
        if (![String]::Join("", $listApp).Contains($app.name)) {
            Write-Host -ForegroundColor Yellow  "Install:" $app.name
            # MS Store apps
            if ($app.source -ne $null) {
                winget install --exact --silent --accept-package-agreements --accept-source-agreements $app.name --source $app.source
                if ($LASTEXITCODE -eq 0) {
                    Write-Host -ForegroundColor Green $app.name "successfully installed."
                }
                else {
                    $app.name + " couldn't be installed." | Add-Content "$DesktopPath\$errorlog"
                    Write-Host
                    Write-Host -ForegroundColor Red $app.name "couldn't be installed."
                    Write-Host -ForegroundColor Yellow "Write in $DesktopPath\$errorlog"
                    Write-Host
                    Pause
                }    
            }
            # All other Apps
            else {
                winget install --exact --silent --scope machine --accept-package-agreements --accept-source-agreements $app.name
                if ($LASTEXITCODE -eq 0) {
                    Write-Host -ForegroundColor Green $app.name "successfully installed."
                }
                else {
                    $app.name + " couldn't be installed." | Add-Content "$DesktopPath\$errorlog"
                    Write-Host
                    Write-Host -ForegroundColor Red $app.name "couldn't be installed."
                    Write-Host -ForegroundColor Yellow "Write in $DesktopPath\$errorlog"
                    Write-Host
                    Pause
                }  
            }
        }
        else {
            Write-Host -ForegroundColor Yellow "Skip installation of" $app.name
        }
    }
    Pause
    Clear-Host
}

function finish {
    Write-Host
    Write-Host -ForegroundColor Magenta  "Installation finished"
    Write-Host
    Pause
}

function menu {
    [string]$Title = 'Winget Menu'
    Clear-Host
    Write-Host "================ $Title ================"
    Write-Host
    Write-Host "1: Do all steps below"
    Write-Host
    Write-Host "2: Install Apps under graphical"
    Write-Host "3: Install Apps under apps"
    Write-Host
    Write-Host -ForegroundColor Magenta "0: Quit"
    Write-Host
    
    $actions = "0"
    while ($actions -notin "0..3") {
    $actions = Read-Host -Prompt 'What you want to do?'
        if ($actions -in 0..3) {
            if ($actions -eq 0) {
                exit
            }
            if ($actions -eq 1) {
                install_gui
                install_silent
                finish
            }
            if ($actions -eq 2) {
                install_gui
                finish
            }
            if ($actions -eq 3) {
                install_silent
                finish
            }
            menu
        }
        else {
            menu
        }
    }
}
menu