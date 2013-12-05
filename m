From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support documentation
Date: Thu, 5 Dec 2013 13:58:06 +0100
Message-ID: <20131205125805.GX24997@rocoto.smurfnet.nu>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
 <1385656883-4420-2-git-send-email-leif.lindholm@linaro.org>
 <CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com>
 <20131202210719.GQ24997@rocoto.smurfnet.nu>
 <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Sealey <neko-HhXTZounMxbZATc7fWT8Dg@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Patch Tracking <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linaro-uefi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 04, 2013 at 03:06:47PM -0600, Matt Sealey wrote:
> By the time we get half-way through arm/kernel/head.S the cache and
> MMU has been turned off and on and off again by the decompressor, and
> after a large amount of guesswork and arbitrary restriction-based
> implementation, there's no guarantee that the kernel hasn't been
> decompressed over some important UEFI feature or some memory hasn't
> been trashed. You can't make that guarantee because by entering the
> plain zImage, you forfeited that information. This is at worst case
> going to be lots of blank screens and blinking serial console prompts
> and little more than frustration..

So, Grant covered the reason _why_ we coexist with zImage, so I won't
go into that. I will however point out that we are explicitly using the
UEFI interfaces to allocate the regions the zImage will decompress into.
This isn't guesswork, and has in fact already turned up issues with a
couple of UEFI board ports that reserved memory near 0 (which were
indeed previously being silently overwritten by the kernel
decompression).

We _are_ planning to do more development for subsequent patches, making
more use of the UEFI memory map. And by subsequent, I mean hopefully in
time for 3.14. I sneekily included this in the version of uefi.txt sent
out for separate review early November:
http://permalink.gmane.org/gmane.linux.kernel.efi/2657, but not in
the one included with this patch set (since the code isn't there yet).
But we considered it more important to get the basic support ready
first.

At that point, you will see the stub reading the dram_base from the
UEFI memory map rather than DT, and memblock_init getting its input
from there too.

Regards,

Leif
