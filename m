From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] Enable reset attack mitigation
Date: Fri, 18 Aug 2017 22:37:26 +0200
Message-ID: <20170818203726.GA10696@wunner.de>
References: <20170804212010.15064-1-mjg59@google.com>
 <CAKv+Gu89bW5CrddxFan095NK_ZmcCpeG_vzx1BuxJ+z-yj3VGQ@mail.gmail.com>
 <CACdnJuty5W0EPLQvBsM=1ySRwCz5Kh4Ht_brZ5pn9ueyF9fT5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACdnJuty5W0EPLQvBsM=1ySRwCz5Kh4Ht_brZ5pn9ueyF9fT5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 18, 2017 at 12:08:34PM -0700, Matthew Garrett wrote:
> On Fri, Aug 18, 2017 at 11:52 AM, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > So how would that work with, e.g., the keys for your encrypted file
> > system? Surely, you can't expect the kernel to drop that secret when
> > userland asks it to, so there will always be a window where userland
> > has set the variable but the kernel is not ready to drop its secrets
> > yet.
> 
> If the kernel doesn't synchronously zero the key when dm-crypt is torn
> down, that feels like a bug?

In the case of a root filesystem layered atop dm-crypt, tearing down
dm-crypt depends on userland, more specifically the init system.

With systemd + dracut it's possible to pivot back into an initrd
on shutdown and this allows for proper teardown of dm-crypt and
subsequent wiping of the key material from memory.

With initramfs-tools this is not possible and to the best of my
knowledge the key material is still resident in memory on shutdown:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=778849

Another case where key material may still be resident are IPsec tunnels.
Granted, user space could tear these down as well on shutdown but what
if it doesn't?

The patch itself seems to be of value, perhaps it can be moved forward
if the commit message is rephrased to leave open the contentious issue
if and when memory wiping by the firmware is disabled, to be discussed
separately.  I'd vote for a machanism whereby user space signals to the
kernel that it no longer has secrets, and the kernel can then signal to
the firmware that memory need not be cleared if it also no longer holds
secrets.  Just my 2 cents anyway.

Thanks!

Lukas
