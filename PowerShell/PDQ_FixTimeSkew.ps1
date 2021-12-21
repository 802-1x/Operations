w32tm /stripchart /computer:au.pool.ntp.org /dataonly /samples:10 >c:\temp\TimeSkew.log

Send-MailMessage -Subject "PDQMaster Time Status" -To email@domain -From time@domain -SmtpServer FQDNEmailServer -Attachments "c:\temp\TimeSkew.log"
