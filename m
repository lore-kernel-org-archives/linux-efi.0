From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2] efi/arm64: fix fdt-related memory reservation
Date: Mon, 8 Sep 2014 20:58:09 +0100
Message-ID: <20140908195809.GB18582@console-pimps.org>
References: <1410183102-6969-1-git-send-email-msalter@redhat.com>
 <1410195668-9975-1-git-send-email-msalter@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1410195668-9975-1-git-send-email-msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 08 Sep, at 01:01:08PM, Mark Salter wrote:
> Commit 86c8b27a01cf:
>  "arm64: ignore DT memreserve entries when booting in UEFI mode
> 
> prevents early_init_fdt_scan_reserved_mem() from being called for
> arm64 kernels booting via UEFI. This was done because the kernel
> will use the UEFI memory map to determine reserved memory regions.
> That approach has problems in that early_init_fdt_scan_reserved_mem()
> also reserves the FDT itself and any node-specific reserved memory.
> By chance of some kernel configs, the FDT may be overwritten before
> it can be unflattened and the kernel will fail to boot. More subtle
> problems will result if the FDT has node specific reserved memory
> which is not really reserved.
> 
> This patch has the UEFI stub remove the memory reserve map entries
> from the FDT as it does with the memory nodes. This allows
> early_init_fdt_scan_reserved_mem() to be called unconditionally
> so that the other needed reservations are made.
> 
> Change from v1:
>   * Acks added
>   * Fixed loop logic to remove reserved regions
> 
> Signed-off-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> ---
>  arch/arm64/mm/init.c               |  3 +--
>  drivers/firmware/efi/libstub/fdt.c | 10 +++++++++-
>  2 files changed, 10 insertions(+), 3 deletions(-)

Thanks Mark, queued up in 'urgent'.

-- 
Matt Fleming, Intel Open Source Technology Center
