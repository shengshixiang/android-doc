# github 添加ssh key

新电脑,需要把生成ssh key,并且把公钥上传到github才能clone代码

# 步骤如下

* mkdir ~/.ssh

* cd ~/.ssh

* ssh-keygen -t ed25519 -C "starmenxie@qq.com"

* cat id_ed25519.pub，并且复制

* 登录github帐号

* 选择settings

* 选择左边的 SSH and GPG keys

* 点击 New SSH key

* Title ,填写 电脑名称

* Key,填写刚才复制的 ssh key

* 最后，点击 Add SSH key