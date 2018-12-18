Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile Ubuntu.zip -UseBasicParsing
Expand-Archive .\Ubuntu.zip c:\Distros\Ubuntu
Rename-Item c:\distros\ubuntu\ubuntu1804.exe c:\distros\ubuntu\ubuntu.exe
