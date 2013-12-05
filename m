From: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support documentation
Date: Thu, 05 Dec 2013 11:08:48 +0000
Message-ID: <20131205110848.A9385C40710@trevor.secretlab.ca>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org> < 1385656883-4420-2-git-send-email-leif.lindholm@linaro.org> < CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com> < 20131202210719.GQ24997@rocoto.smurfnet.nu> < CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Sealey <neko-HhXTZounMxbZATc7fWT8Dg@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Patch Tracking <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linaro-uefi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 4 Dec 2013 15:06:47 -0600, Matt Sealey <neko-HhXTZounMxbZATc7fWT8Dg@public.gmane.org> wrote:
> If your platform has UEFI, then your platform has UEFI - if you built
> a multiplatform kernel that needs to boot on U-Boot, then you glued an
> EFI stub to it to make it boot. At some point between the stub and the
> runtime services driver, you're going through 10,000 lines of code
> with the information that it *is* running on top of UEFI completely
> lost to the boot process.
> 
> I believe I am also objecting to the idea that the way this is BEST
> implemented is to take a stock zImage (decompressor+Image payload) and
> glue a stub in front to resolve the interface issue when the
> implication is extra complication to the boot process.

Adding UEFI support to an existing image type was a design goal when we
started. Having yet another image format which is not compatibile with
existing firmware adds yet another barrier to migrating from U-Boot to
UEFI, or to supporting multiplatforms.

g.
