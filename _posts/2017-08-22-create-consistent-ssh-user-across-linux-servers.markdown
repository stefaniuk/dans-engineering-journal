---
layout: post
title: "Create Consistent SSH User Accounts Across Multiple Linux Servers"
date: 2017-08-22 22:29:00 Europe/London
tags: [linux, ssh, ansible, devops, automation, security, bash]
comments: true
---

Due to a specific design requirements on a project I've been working on recently I needed to create a consistent system account on all the Linux servers across all the environments. This account supposed to have the following characteristics:

* Same GID and UID
* Both password and public SSH key are set
* Only the SSH key-based authentication is allowed
* Privileged operations are executed without having to provide password (optional)

As you can tell this is an admin type account that is usually created just after the installation of an operating system.

Servers are up and running. Setting it up by hand could be an option. However, this would be a very old-fashioned approach though. I already have an automation tool in place. My favorite one is Ansible due to its simple architecture. Whether or not our configuration management framework is really advanced and facilitates tweaking of every aspect of an OS or a VM in my opinion the best language to script it is Bash. The change will be expressed in a most readable way that every sysadmin or platform engineer as they are called these days will understand. I'm going to use Ansible only as an orchestration tool to ship the script across and execute it without any user interaction.

Here is our sample input:

{% highlight shell %}
id=1000
username="dan"
password="s3cr3t"
ssh_pk="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGA++RFH4MfQ+697dSNS+p2Hx0a4X56pnDrMIbDozYUPcbY6rictsJvsakaF2yMlR9xW0nEWichdwB5dFxoVQ9E6n6ygRB5Q88j+SOsvVA+wjCJ0+Ittfrb9/dTrnuSWT58p1HKaCDOJdx402P41DZGw4Fq+JKTEvP+H0AbOdUifNMrZBPZ0kOv/0bNT839ytI6rKGi+3w42TN37k7H02TmAFPnip3YpLrUMNxMHulxyzaQ2ueAILGmPac2pz6hU6OflSCkptiV7yDYv/LnjFDSzagFP0dIr5jkT+XenpJOXgdXA/g3/4aOUHfo9tEQngC9ANKbaB3pRwAfGM35V35 my-key"
{% endhighlight %}

But before we create such a user let's check if the ID that we intent to use is available. If it is already taken we need to find the current user, terminate all his processes, change the UID and GID, then fix file ownership accordingly.

{% highlight shell %}
uname=$(grep $id /etc/passwd | cut -f1 -d:)
gname=$(grep $id /etc/group | cut -f1 -d:)
ps -o pid -u $uname | xargs kill -9
if [ -n "$uname" ]; then
    usermod -u 1111 $uname
    find / -user $id -exec chown -h 1111 {} \;
fi
if [ -n "$gname" ]; then
    groupmod -g 1111 $gname
    find / -group $id -exec chgrp -h 1111 {} \;
fi
{% endhighlight %}

Now, we are ready to create a new system user.

{% highlight shell %}
groupadd -g $id $username
useradd -m -s /bin/bash -u $id -g $username -G sudo,docker $username
echo "$username:$password" | chpasswd
{% endhighlight %}

SSH key-based authentication provides cryptographic strength that even extremely long passwords cannot offer. So, this will be our preferred method of granting access to a system and ...

{% highlight shell %}
mkdir -p /home/$username/.ssh
echo "$ssh_pk" >> /home/$username/.ssh/authorized_keys
chmod 600 /home/$username/.ssh/authorized_keys
chown -R $username:$username /home/$username
{% endhighlight %}

... we make sure the above is the only method of authentication by changing the OpenSSL daemon configuration.

{% highlight shell %}
sed -i "s/^PasswordAuthentication yes/#PasswordAuthentication yes/g" \
    /etc/ssh/sshd_config
{% endhighlight %}

The last thing we may want to do is to allow privileged operations without password. This may come handy while the same system account is used to perform other automated tasks that normally would prompt for a user password.

{% highlight shell %}
echo "$username ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$username
{% endhighlight %}

There we have it. A simple way to test it could be by loading the private key locally using the `ssh-add` command and trying to `ssh` into the server.

In my next blog post I will show how to create a minimal Ansible orchestration script.
