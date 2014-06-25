From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [efi:next 6/7] drivers/firmware/efi/runtime.c:19:21: fatal error:
 asm/efi.h: No such file or directory
Date: Thu, 26 Jun 2014 00:04:34 +0200
Message-ID: <CAKv+Gu_1bOnagXAtEXv8r-O_eSQJZ2XLTVS7CiFNCO=Vn4FQrg@mail.gmail.com>
References: <53ab44e9.bu433Jx0VvWd/ozI%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53ab44e9.bu433Jx0VvWd/ozI%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 June 2014 23:53, kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next
> head:   8922cc07b558b167bc8f9e176c1a0b49acc5694f
> commit: 012e96bf2f05b3652ef02cf3df80b7a63cced0af [6/7] efi/x86: move UEFI Runtime Services wrappers to generic code
> config: make ARCH=ia64 allmodconfig
>
> All error/warnings:
>
>>> drivers/firmware/efi/runtime.c:19:21: fatal error: asm/efi.h: No such file or directory
>     #include <asm/efi.h>
>                         ^
>    compilation terminated.
>

Ahh, I wasn't prepared for that one ...
So runtime.o needs to be included conditionally: any suggestions for a
Kconfig symbol to recycle? Or invent a new one?

-- 
Ard.


> vim +19 drivers/firmware/efi/runtime.c
>
>     13   *
>     14   * This file is released under the GPLv2.
>     15   */
>     16
>     17  #include <linux/efi.h>
>     18  #include <linux/spinlock.h>             /* spinlock_t */
>   > 19  #include <asm/efi.h>
>     20
>     21  #ifndef efi_call_virt
>     22  #define efi_call_virt                   __efi_call_virt
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
