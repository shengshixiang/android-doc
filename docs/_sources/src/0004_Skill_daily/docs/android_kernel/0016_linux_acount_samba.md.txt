# linux账户

* 添加

    adduser luozh

* 删除

    deluser libing

# 添加samba用户

* 安装

    sudo apt-get install samba

* samba配置 home共享,sudo vim /etc/samba/smb.conf 
```
# user's home directory as \\server\username
[homes]
   comment = Home Directories
   browseable = no

# By default, the home directories are exported read-only. Change the
# next parameter to 'no' if you want to be able to write to them.
   read only = no

# File creation mask is set to 0700 for security reasons. If you want to
# create files with group=rw permissions, set next parameter to 0775.
   create mask = 0775

# Directory creation mask is set to 0700 for security reasons. If you want to
# create dirs. with group=rw permissions, set next parameter to 0775.
   directory mask = 0775

# By default, \\server\username shares can be connected to by anyone
# with access to the samba server.
# Un-comment the following parameter to make sure that only "username"
# can connect to \\server\username
# This might need tweaking when using external authentication schemes
   valid users = %S

```

* 添加用户

    sudo smbpasswd -a luozh

* 重启samba服务

    sudo service smbd restart

* 测试连接

    * win可通过\\ip\用户 访问你服务器文件
    * smb://ip/用户

* 查看samba用户

    pdbedit -L

* 删除samba用户

    smbpasswd -x   用户名

# samba 共享链接

* sudo vim /etc/samba/smb.conf
    ```
    # Allow users who've been granted usershare privileges to create
    # public shares, not just authenticated ones
    usershare allow guests = yes
    follow symlinks = yes
    wide links = yes
    unix extensions = no
    ```

* 重启samba服务,sudo service smbd restart