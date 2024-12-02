@echo off
:: Default IP Variables
set public_ip=200.200.200.200
set private_ip=10.200.79.130
set nginx_path=C:\nginx
set nginx_exe=%nginx_path%\nginx.exe

:menu
cls
echo ===============================
echo Port Forwarding and Nginx Manager
echo ===============================
echo [1] Add forwarding
echo [2] Remove forwarding
echo [3] List current configuration
echo [4] Restart Nginx
echo [5] Start/Stop Nginx
echo [6] Manage Addresses
echo [0] Quit
echo ===============================
set /p choice="Enter choice: "

if "%choice%"=="1" goto add_forwarding
if "%choice%"=="2" goto remove_forwarding
if "%choice%"=="3" goto list_configuration
if "%choice%"=="4" goto restart_nginx
if "%choice%"=="5" goto start_stop_nginx
if "%choice%"=="6" goto manage_addresses
if "%choice%"=="0" goto quit
echo Invalid choice, please try again.
pause
goto menu

:add_forwarding
cls
echo Add Port Forwarding
echo Current Public IP: %public_ip%
echo Current Private IP: %private_ip%
set /p public_port="Enter public port (listenport): "
set /p destination_port="Enter destination port (connectport): "
echo Adding port forwarding rule...
netsh interface portproxy add v4tov4 listenaddress=%public_ip% listenport=%public_port% connectaddress=%private_ip% connectport=%destination_port%
if errorlevel 1 (
    echo Failed to add forwarding rule.
) else (
    echo Forwarding rule added successfully!
)
pause
goto menu

:remove_forwarding
cls
echo Remove Port Forwarding
echo Current Public IP: %public_ip%
set /p public_port="Enter public port to remove (listenport): "
echo Removing port forwarding rule...
netsh interface portproxy delete v4tov4 listenaddress=%public_ip% listenport=%public_port%
if errorlevel 1 (
    echo Failed to remove forwarding rule.
) else (
    echo Forwarding rule removed successfully!
)
pause
goto menu

:list_configuration
cls
echo Current Port Forwarding Configuration:
netsh interface portproxy show v4tov4
pause
goto menu

:restart_nginx
cls
echo Restarting Nginx...
taskkill /F /IM nginx.exe >nul 2>&1
timeout /t 2 >nul
start %nginx_exe%
if errorlevel 1 (
    echo Failed to restart Nginx.
) else (
    echo Nginx restarted successfully!
)
pause
goto menu

:start_stop_nginx
cls
echo ===============================
echo [1] Start Nginx
echo [2] Stop Nginx
echo [0] Back to Main Menu
echo ===============================
set /p nginx_choice="Enter choice: "
if "%nginx_choice%"=="1" goto start_nginx
if "%nginx_choice%"=="2" goto stop_nginx
if "%nginx_choice%"=="0" goto menu
echo Invalid choice, please try again.
pause
goto start_stop_nginx

:start_nginx
cls
echo Starting Nginx...
start %nginx_exe%
if errorlevel 1 (
    echo Failed to start Nginx.
) else (
    echo Nginx started successfully!
)
pause
goto menu

:stop_nginx
cls
echo Stopping Nginx...
taskkill /F /IM nginx.exe >nul 2>&1
if errorlevel 1 (
    echo Failed to stop Nginx. It might not be running.
) else (
    echo Nginx stopped successfully!
)
pause
goto menu

:manage_addresses
cls
echo ===============================
echo Manage IP Addresses
echo ===============================
echo Explanation:
echo This menu is used to set the public IP of this VPS and the private IP of
echo the bare-metal or forwarded host. These values are used by the "netsh"
echo command to configure port forwarding on Windows Server.
echo The "netsh interface portproxy" command allows the redirection of traffic
echo from one IP/port pair to another, enabling services to be forwarded to
echo internal hosts or other services on the network.
echo ===============================
echo Current Public IP: %public_ip%
echo Current Private IP: %private_ip%
echo ===============================
echo [1] Change Public IP
echo [2] Change Private IP
echo [0] Back to Main Menu
echo ===============================
set /p address_choice="Enter choice: "
if "%address_choice%"=="1" goto change_public_ip
if "%address_choice%"=="2" goto change_private_ip
if "%address_choice%"=="0" goto menu
echo Invalid choice, please try again.
pause
goto manage_addresses

:change_public_ip
cls
echo Change Public IP
echo Current Public IP: %public_ip%
set /p new_public_ip="Enter new public IP: "
set public_ip=%new_public_ip%
echo Public IP updated to %public_ip%.
pause
goto manage_addresses

:change_private_ip
cls
echo Change Private IP
echo Current Private IP: %private_ip%
set /p new_private_ip="Enter new private IP: "
set private_ip=%new_private_ip%
echo Private IP updated to %private_ip%.
pause
goto manage_addresses

:quit
echo Exiting Port Forwarding and Nginx Manager...
pause
exit
