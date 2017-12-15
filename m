From: Locane <locane-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Booting LiveCD image from EFI PXE?
Date: Thu, 14 Dec 2017 16:53:50 -0800
Message-ID: <CAC5dixEdsA=_fGJ92+u_rKxmF9CTAScDj5Et_=9bngTC9JdCrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hello everyone!  I currently have a haphazard PXE EFI server up and
serving my company's network, but I'm having a lot of trouble getting
a CentOS LiveCD image to load.  The file is a grub.cfg and uses
grub-style syntax (it's the only way I could get things to work).

The LiveCD entry looks like this:

menuentry 'Do not use broken livecd' {
   linuxefi images/LiveCD/vmlinuz initrd=images/LiveCD/initrd.img
ksdevice=bootif lang=  root=live:/boot.iso kssendmac text
ks=http://<Server IP>/cblr/svc/op/ks/profile/LiveCD
   initrdefi images/LiveCD/initrd.img
}

These kernel options work in the legacy PXE menu, but not here.  The
error I get is "error: can't allocate initrd", and then the system
loads to a crashed kernel panic and stays there forever.

I know the files exist and are there (they work in the legacy PXE
menu).  Any ideas?
