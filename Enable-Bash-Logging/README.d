# Enable the logs who logged in via SSH to your server

### Edit the bashrc file and add the below lines
```
sudo -e /etc/bash.bashrc
```

### Add the below line
```
export PROMPT_COMMAND='RETRN_VAL=$?;logger -p local6.debug "$(whoami) [$$]: $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" ) [$RETRN_VAL]"'
```

### Setup the logging file
sudo -e /etc/rsyslog.d/bash.conf

### Add below contenet to log in log file
```
local6.*    /var/log/commands.log
```

### Restart Rsyslog
```
sudo service rsyslog restart
```

### Lets Rotate the Logs
```
sudo -e /etc/logrotate.d/rsyslog
```

### Added the following line at end
```
/var/log/commands.log
```

### Now you can check the log files for logs.
