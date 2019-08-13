# Sysmon Threat Intelligence Configuration #

## Use ##

### Auto-Install with Auto Update Script:###
~~~~
As admin user from the CMD: Install-Sysmon.bat
Ensure to update rules in the https://raw.githubusercontent.com/cyberhuntersolns/sysmon-config/develop/sysmonconfig-export.xml file as it is the master.
~~~~
### Install Win Log Beat to Ship Event Logs:###
~~~~
1. Download Winlogbeat:  https://www.elastic.co/downloads/beats/winlogbeat
2. Unzip the winlogbeat-7.3.0-windows-x86_64.zip file
3. Rename the directory "winlogbeat"
4. Place it under c:\Program Files
5. Edit the YML file to ship Sysmon to Logstash:

winlogbeat.event_logs:
  - name: Microsoft-Windows-Sysmon/Operational
    processors:
      - script:
          lang: javascript
          id: sysmon
          file: ${path.home}/module/sysmon/config/winlogbeat-sysmon.js
fields:
  logzio_codec: json
  token: XXXXXXX
  type: wineventlog
fields_under_root: true
#The following processors are to ensure compatibility with version 7
processors:
- rename:
    fields:
     - from: "agent"
       to: "beat_agent"
    ignore_missing: true
- rename:
    fields:
     - from: "log.file.path"
       to: "source"
    ignore_missing: true    
output.logstash:
  hosts: ["listener.logz.io:5015"]
  ssl:
    certificate_authorities: ['C:\ProgramData\Filebeat\COMODORSADomainValidationSecureServerCA.crt']

6. In Powershell as Admin: cd to c:\Program Files\winlogbeat
7. .\install-service-winlogbeat.ps1 -c .\winlogbeat.yml
8. Restart-Service winlogbeat
~~~~
## Hide Sysmon from services.msc ##
~~~~
Hide:
sc sdset Sysmon D:(D;;DCLCWPDTSD;;;IU)(D;;DCLCWPDTSD;;;SU)(D;;DCLCWPDTSD;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;WD)
Restore:
sc sdset Sysmon D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;WD)

~~~~
