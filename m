From: Felix Braun <Felix.Braun-Qbh6zKbeHLYtq+zhY6Lx4A@public.gmane.org>
Subject: Unable to set efi boot variables on 3.10-rc3
Date: Tue, 28 May 2013 20:40:32 +0200
Message-ID: <1369766432.2827.13.camel@eressea>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi there,

I'm unable to set efi boot variables using efibootmgr 0.6.0 using
kernels 3.9.x (x=0..4) and 3.10-rc3 on an ASUS E45M1-M PRO Board using
the most current firmware (1202). Things worked fine with kernels 3.7.x
(x=4..10). I have not been able to boot 3.8 for unrelated reasons.

When I try to write something to the efi boot variables, I get an kernel
error

# efibootmgr
BootCurrent: 0000
Timeout: 1 seconds
BootOrder: 0000,0002,0003
Boot0000* Linux
Boot0002* Hard Drive
Boot0003* CD/DVD Drive
# efibootmgr -n2
# tail /var/log/messages
 [Firmware Bug]: Broken EFI implementation is returning
MaxVariableSize=0

Mounting efivarfs I have been able to delete variables. I have not found
a way to store things in efivarfs because I can't figure out valid
names.

On boot up, I get a number of the following error messages:

e820: too many entries; ignoring [mem 0x01d8a000-0x01d8ffff]
e820: too many entries; ignoring [mem 0x01d90000-0x01d91fff]
...

is that maybe related?

Any pointers would be welcome. Please copy me to any mail as I am not
subscribed.

Thanks in adcance!
Felix
