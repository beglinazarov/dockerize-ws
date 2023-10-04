# Use a Windows Server Core image as the base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set environment variables for RDP
ENV USERNAME=dev
ENV PASSWORD=dev123

# Install RDP feature and enable RDP
RUN powershell -Command \
    Install-WindowsFeature -Name RDS-RD-Server; \
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0; \
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1; \
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name "MaxInstanceCount" -Value 2 -PropertyType DWORD; \
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name "MinEncryptionLevel" -Value 1 -PropertyType DWORD; \
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name "fAllowUnauthenticatedTSConnections" -Value 1 -PropertyType DWORD; \
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name "fSingleSessionPerUser" -Value 0 -PropertyType DWORD; \
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name "fPromptForPassword" -Value 0 -PropertyType DWORD; \
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name "LocalAccountTokenFilterPolicy" -Value 1

# Create a user for RDP
RUN net user $env:USERNAME $env:PASSWORD /add && \
    net localgroup Administrators $env:USERNAME /add

# Expose RDP port
EXPOSE 3389

# Start RDP service on container startup
CMD ["cmd.exe", "/C", "C:\\Windows\\System32\\tscon.exe", "0", "/dest:console"]
