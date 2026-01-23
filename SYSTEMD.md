https://last9.io/blog/linux-commands-cheat-sheet/

https://signoz.io/guides/systemctl-logs/
https://cisofy.com/lynis/
List every loaded service that is running, active, or failed in the system:

# sudo systemctl list-units --type=service --all
List all Disabled services in the system:

# sudo systemctl list-unit-files --type=service --state=disabled
List all Enabled services in the system:

# sudo systemctl list-unit-files --type=service --state=enabled
List every loaded service that is active state in the system:

# sudo systemctl list-units --type=service --state=active
List every loaded service that is running state in the system: This is my favorite command

# sudo systemctl list-units --type=service --state=running
List every loaded service that is failed state in the system:

# sudo systemctl list-units --type=service --state=failed
List every loaded service that is exited state in the system:

# sudo systemctl list-units --type=service --state=exited
