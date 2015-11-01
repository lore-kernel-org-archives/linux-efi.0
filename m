From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v9 1/1] efi: a misc char interface for user to update efi
 firmware
Date: Sun, 1 Nov 2015 11:29:45 +0100
Message-ID: <20151101102944.GA12711@pd.tnic>
References: <1446055138-26047-1-git-send-email-hock.leong.kweh@intel.com>
 <1446055138-26047-2-git-send-email-hock.leong.kweh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446055138-26047-2-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Fleming Matt <matt.fleming@intel.com>, h.peter.anvin@intel.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 29, 2015 at 01:58:57AM +0800, Kweh, Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> 
> Introducing a kernel module to expose capsule loader interface
> (misc char device file note) for user to upload capsule binaries.
> 
> Example method to load the capsule binary:
> cat firmware.bin > /dev/efi_capsule_loader

$ cat "some_dumb_file" > /dev/efi_capsule_loader
Killed

and in dmesg:

[   34.033982] efi_capsule_loader: efi_capsule_flush: capsule upload not complete
[   58.765683] ------------[ cut here ]------------
[   58.769349] WARNING: CPU: 5 PID: 3904 at drivers/firmware/efi/capsule.c:83 efi_capsule_supported+0x103/0x150()
[   58.775063] Modules linked in:
[   58.776474] CPU: 5 PID: 3904 Comm: cat Not tainted 4.3.0-rc7+ #3
[   58.779044] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[   58.783387]  ffffffff81957aa0 ffff880079793d78 ffffffff812cb2ea 0000000000000000
[   58.786749]  ffff880079793db0 ffffffff81055981 00010102464c457f 0000000000000000
[   58.790140]  0000000000401e3b 0000000000000001 ffff880078660704 ffff880079793dc0
[   58.793353] Call Trace:
[   58.794343]  [<ffffffff812cb2ea>] dump_stack+0x4e/0x84
[   58.796416]  [<ffffffff81055981>] warn_slowpath_common+0x91/0xd0
[   58.798773]  [<ffffffff81055a7a>] warn_slowpath_null+0x1a/0x20
[   58.800962]  [<ffffffff8157ae93>] efi_capsule_supported+0x103/0x150
[   58.803292]  [<ffffffff8157d559>] efi_capsule_write+0x269/0x390
[   58.805563]  [<ffffffff81183ef8>] __vfs_write+0x28/0xe0
[   58.807591]  [<ffffffff81183e9a>] ? __vfs_read+0xaa/0xe0
[   58.809612]  [<ffffffff811847d5>] vfs_write+0xb5/0x1a0
[   58.811272]  [<ffffffff811a33be>] ? __fget_light+0x6e/0x90
[   58.813073]  [<ffffffff81185412>] SyS_write+0x52/0xc0
[   58.814720]  [<ffffffff816cff5b>] entry_SYSCALL_64_fastpath+0x16/0x73
[   58.816665] ---[ end trace 94c0c141f9b0ec01 ]---
[   58.818179] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   58.820427] IP: [<          (null)>]           (null)
[   58.820630] PGD 79af8067 PUD 79781067 PMD 0 
[   58.820630] Oops: 0010 [#1] PREEMPT SMP 
[   58.820630] Modules linked in:
[   58.820630] CPU: 5 PID: 3904 Comm: cat Tainted: G        W       4.3.0-rc7+ #3
[   58.820630] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[   58.820630] task: ffff8800771417c0 ti: ffff880079790000 task.ti: ffff880079790000
[   58.820630] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   58.820630] RSP: 0018:ffff880079793dc8  EFLAGS: 00010282
[   58.820630] RAX: ffff88007a01b4e0 RBX: 00010102464c457f RCX: ffff880078660704
[   58.820630] RDX: ffff880079793dd8 RSI: 0000000000000001 RDI: ffff880079793dd0
[   58.820630] RBP: ffff880079793e08 R08: 0000000000000000 R09: 0000000000000000
[   58.820630] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[   58.820630] R13: 0000000000401e3b R14: 0000000000000001 R15: ffff880078660704
[   58.820630] FS:  00007ffff7fe1700(0000) GS:ffff88007c000000(0000) knlGS:0000000000000000
[   58.820630] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   58.820630] CR2: 0000000000000000 CR3: 000000007ab90000 CR4: 00000000000406e0
[   58.820630] Stack:
[   58.820630]  ffffffff8157ae24 ffff88007a01b4e0 0000000000000002 ffff880078660700
[   58.820630]  ffff880077060000 0000000000001000 ffffea0001dc1800 ffff880077060000
[   58.820630]  ffff880079793e48 ffffffff8157d559 0000000000000402 ffff8800799cbc00
[   58.820630] Call Trace:
[   58.820630]  [<ffffffff8157ae24>] ? efi_capsule_supported+0x94/0x150
[   58.820630]  [<ffffffff8157d559>] efi_capsule_write+0x269/0x390
[   58.820630]  [<ffffffff81183ef8>] __vfs_write+0x28/0xe0
[   58.820630]  [<ffffffff81183e9a>] ? __vfs_read+0xaa/0xe0
[   58.820630]  [<ffffffff811847d5>] vfs_write+0xb5/0x1a0
[   58.820630]  [<ffffffff811a33be>] ? __fget_light+0x6e/0x90
[   58.820630]  [<ffffffff81185412>] SyS_write+0x52/0xc0
[   58.820630]  [<ffffffff816cff5b>] entry_SYSCALL_64_fastpath+0x16/0x73
[   58.820630] Code:  Bad RIP value.
[   58.820630] RIP  [<          (null)>]           (null)
[   58.820630]  RSP <ffff880079793dc8>
[   58.820630] CR2: 0000000000000000
[   58.876221] ---[ end trace 94c0c141f9b0ec02 ]---

> This patch also export efi_capsule_supported() function symbol for
> verifying the submitted capsule header in this kernel module.
> 
> Cc: Matt Fleming <matt.fleming@intel.com>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
> ---
>  drivers/firmware/efi/Kconfig              |   10
>  drivers/firmware/efi/Makefile             |    1
>  drivers/firmware/efi/capsule.c            |    1
>  drivers/firmware/efi/efi-capsule-loader.c |  356 +++++++++++++++++++++++++++++
>  4 files changed, 368 insertions(+)
>  create mode 100644 drivers/firmware/efi/efi-capsule-loader.c

Please integrate checkpatch into your workflow - it can be helpful
sometimes:

WARNING: 'OCCURED' may be misspelled - perhaps 'OCCURRED'?
#114: FILE: drivers/firmware/efi/efi-capsule-loader.c:22:
+#define ERR_OCCURED -2

WARNING: 'OCCURED' may be misspelled - perhaps 'OCCURRED'?
#132: FILE: drivers/firmware/efi/efi-capsule-loader.c:40:
+ *     Besides freeing the buffer pages, it also flagged an ERR_OCCURED

WARNING: 'OCCURED' may be misspelled - perhaps 'OCCURRED'?
#144: FILE: drivers/firmware/efi/efi-capsule-loader.c:52:
+       cap_info->index = ERR_OCCURED;

WARNING: Possible unnecessary 'out of memory' message
#399: FILE: drivers/firmware/efi/efi-capsule-loader.c:307:
+       if (!cap_info) {
+               pr_debug("%s: kzalloc() failed\n", __func__);


> 
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index f712d47..0be8ee3 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -60,6 +60,16 @@ config EFI_RUNTIME_WRAPPERS
>  config EFI_ARMSTUB
>  	bool
>  
> +config EFI_CAPSULE_LOADER
> +	tristate "EFI capsule loader"
> +	depends on EFI
> +	help
> +	  This option exposes a loader interface "/dev/efi_capsule_loader" for
> +	  user to load EFI capsule binary and update the EFI firmware through
> +	  system reboot.

Make this:

	... and update the EFI firmware. After a successful loading, a system
	reboot is required."

> +
> +	  If unsure, say N.
> +
>  endmenu
>  
>  config UEFI_CPER
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index 698846e..5ab031a 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_UEFI_CPER)			+= cper.o
>  obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
>  obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
>  obj-$(CONFIG_EFI_STUB)			+= libstub/
> +obj-$(CONFIG_EFI_CAPSULE_LOADER)	+= efi-capsule-loader.o
> diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
> index d8cd75c0..738d437 100644
> --- a/drivers/firmware/efi/capsule.c
> +++ b/drivers/firmware/efi/capsule.c
> @@ -101,6 +101,7 @@ out:
>  	kfree(capsule);
>  	return rv;
>  }
> +EXPORT_SYMBOL_GPL(efi_capsule_supported);
>  
>  /**
>   * efi_capsule_update - send a capsule to the firmware
> diff --git a/drivers/firmware/efi/efi-capsule-loader.c b/drivers/firmware/efi/efi-capsule-loader.c

All those files under drivers/firmware/efi/ are EFI stuff so this one
doesn't need the "efi-" name prefix either. efi-pstore.c I'm looking at
you too.

> new file mode 100644
> index 0000000..23f7618
> --- /dev/null
> +++ b/drivers/firmware/efi/efi-capsule-loader.c
> @@ -0,0 +1,356 @@
> +/*
> + * EFI capsule loader driver.
> + *
> + * Copyright 2015 Intel Corporation
> + *
> + * This file is part of the Linux kernel, and is made available under
> + * the terms of the GNU General Public License version 2.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

I think this should be

#define pr_fmt(fmt) "EFI: " fmt

or something that all EFI code uses.

> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/miscdevice.h>
> +#include <linux/highmem.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/efi.h>
> +
> +#define DEV_NAME "efi_capsule_loader"

Why a define if it is used only in one place? Just put the string there
instead.

> +#define UPLOAD_DONE -1

Isn't the fact that upload was finished a success message? If so, why is
it a negative value?

> +#define ERR_OCCURED -2

WARNING: 'OCCURED' may be misspelled - perhaps 'OCCURRED'?
#114: FILE: drivers/firmware/efi/efi-capsule-loader.c:22:
+#define ERR_OCCURED -2

Ok, that should be enough review for now - I'll take a look at the rest
once you've taken care of the splat above and those minor issues I
pointed out.

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
