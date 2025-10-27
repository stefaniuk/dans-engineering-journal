---
layout: post
title: "A Revised Way of Generating SSH Keys"
date: 2017-09-02 22:16:00 Europe/London
tags: [ssh, security, cryptography, ed25519, linux, devops]
comments: true
---
I've been using 4096-bit RSA SSH keys for quite a few years. The RSA keys are very compatible. They've been working on various operating systems as well as on mobile devices. They are also known as being slow and potentially insecure if created with a small amount of bits, especially after the year 2013. Today, I decided to do some research to find an alternative configuration. Things have moved on since my last check. Large keys are still considered secure, however the [__elliptic curve cryptography__](https://en.wikipedia.org/wiki/Elliptic_curve_cryptography) has become much more popular in the recent decade.

_"The primary benefit promised by elliptic curve cryptography is a smaller key size, reducing storage and transmission requirements, i.e. that an elliptic curve group could provide the same level of security afforded by an RSA-based system with a large modulus and correspondingly larger key: for example, a 256-bit elliptic curve public key should provide comparable security to a 3072-bit RSA public key."_

My take on it is that if this new signature algorithm can give us similar or even __better level of security__ (yes, its implementation is more secure than RSA) with a __comparable flexibility__ using __less resources__, it is definitely time to adopt it. For anyone who is interested in a detailed explanation how exactly it works a lot of papers have been published providing mathematical rationale behind it.

[__Ed25519__](https://ed25519.cr.yp.to/) is a digital signature scheme based on Twisted Edwards curves. Its has been [added to the OpenSSH codebase](https://github.com/openssh/openssh-portable/commit/5be9d9e3cbd9c66f24745d25bf2e809c1d158ee0#diff-e71776f50c4432cb9cd999367424de20) on the 7th of December 2013. Since then no issue was reported against it.

The easies way to generate such an SSH key is by using the `ssh-keygen` command of the OpenSSH package:

    ssh-keygen -t ed25519 -o -a 100

The `-t ed25519` parameter is used to generate two asymmetrical keys based on the elliptic curve cryptography. The output is produced in the new [RFC4716](https://tools.ietf.org/html/rfc4716) format rather than the well known PEM and the flag `-o` to support it is implied by default so it can be omitted. It enforces use of a modern key derivation function (KDF) powered by combination of [PBKDF2 and bcrypt](https://github.com/openssh/openssh-portable/blob/f104da263de995f66b6861b4f3368264ee483d7f/openbsd-compat/bcrypt_pbkdf.c). In practice this means that our keypair is more resistant to brute-force password cracking. This is especially true when combined with the `-a <rounds>` parameter which specifies the number of key derivation function rounds to be used. Higher the number more time it takes to unlock the key.

Time to see the result of the above command. Here is an example of my revised way of generating SSH keys along with content of the files.

&nbsp;
```shell
$ ssh-keygen -t ed25519 -a 100 -C "my-key-comment" -f my-key-name
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in my-key-name.
Your public key has been saved in my-key-name.pub.
The key fingerprint is:
SHA256:GIh0NDZ6WhZLyFJxq8dpbJ7aAwfEpJdgBsgxs/5NziM my-key-comment
The key's randomart image is:
+--[ED25519 256]--+
|*@*+X            |
|==OO B           |
|.+= B .          |
|...O . o         |
| .o.B.. S        |
|  o=*.           |
|   Eo=           |
|   oo .          |
|  . ..           |
+----[SHA256]-----+
$ puttygen my-key-name -C "my-key-comment" -o my-key-name.ppk
Enter passphrase to load key:
$ ls -la my-key-name*
-rw-------  1 dan  staff  464  3 Sep 21:27 my-key-name
-rw-------  1 dan  staff  304  3 Sep 21:27 my-key-name.ppk
-rw-r--r--  1 dan  staff   96  3 Sep 21:27 my-key-name.pub
$ cat my-key-name
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAACmFlczI1Ni1jYmMAAAAGYmNyeXB0AAAAGAAAABA+HlsP7o
3Jzj8b+N+WhbEuAAAAZAAAAAEAAAAzAAAAC3NzaC1lZDI1NTE5AAAAIErbaYC9ZHLEtCY3
uDDl0LqRwlxLSGoHO1IBrvhzikyVAAAAoD632B3FjYbZmkLco+r7BVIvK3r1Cn2dJE8Q4N
l9IES8bieUYPxDi3uu3gaIcWwygdHTM5zFMqWePJgNP2M0jvfLkQLbaJd816D/BYwUGcTR
3Mgo7Rnf1qqoen70rwl67bbTaN8D0M5dNL5EkYdKvOoiRhoyQEIdptNOWF6rjwMyfloWw9
JMKCOfYrSUB4pDf6mgbWw7+60IUrIc+BeAQgc=
-----END OPENSSH PRIVATE KEY-----
$ cat my-key-name.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIErbaYC9ZHLEtCY3uDDl0LqRwlxLSGoHO1IBrvhzikyV my-key-comment
$ cat my-key-name.ppk
PuTTY-User-Key-File-2: ssh-ed25519
Encryption: aes256-cbc
Comment: my-key-comment
Public-Lines: 2
AAAAC3NzaC1lZDI1NTE5AAAAIErbaYC9ZHLEtCY3uDDl0LqRwlxLSGoHO1IBrvhz
ikyV
Private-Lines: 1
63bsFlto1i20tXwFu3xveXsGtDD7hEmsM0FrIGqviHn4O2xXG9Pwjmhmwf+z8rJe
Private-MAC: 72102d9a0f158f653577df276fcf329b482df329
```
