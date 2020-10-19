
1) Creating (destroing) infrastructure in AWS for ansible learning:
    3 x EC2 (Amazon Linux 2, RHEL 8, Ubuntu 18, Uuntu 16)

2) Playbooks:

  ping.yml:
    ping servers from aws group

  apache.yml:
    Istall Apache Web Server (if not exist).
    Copy my test WebPage (index.html)  to server.
    Restart Apache service (if content changed).
    
  groups_and_users.yml:
    Create 3 groups (decops/dev/qa) and 3 users (devops/developer/tester).
    
  packages.yml:
    Install any packeges for differetn OS
