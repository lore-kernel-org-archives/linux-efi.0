From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 11/15] arm64: add EFI stub
Date: Wed, 19 Mar 2014 10:57:06 +0000
Message-ID: <20140319105706.GE2214@arm.com>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
 <1394750828-16351-12-git-send-email-leif.lindholm@linaro.org>
 <20140318120919.GG13200@arm.com>
 <1395153629.2967.10.camel@deneb.redhat.com>
 <20140318182826.GC20497@arm.com>
 <1395178831.2967.29.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1395178831.2967.29.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 18, 2014 at 09:40:31PM +0000, Mark Salter wrote:
> On Tue, 2014-03-18 at 18:28 +0000, Catalin Marinas wrote:
> > If UEFI doesn't handle the caches, the only thing left to EFI_STUB is to
> > flush by MVA. We don't need to flush the whole DRAM (and I would even
> > recommend it) but at least the relevant kernel code/data touched with
> > the MMU disabled.
> 
> So, it goes like this:
> 
>   1) UEFI calls stub with MMU/Caches on. Stub/kernel can be anywhere.
>   2) Stub runs and relocates kernel to the desired runtime location
>      but continues to execute from wherever UEFI loaded it until just
>      after ExitBootServices().
>   3) After ExitBootServices, efi_entry() returns relocated entry point
>      for kernel to efi_stub_entry() in efi-entry.S where the Dcache and
>      MMU are turned off, the __flush_dcache_all is called, then the
>      code jumps to the kernel proper entry point.
> 
> It isn't clear to me if UEFI does cache flushing at ExitBootServices
> time, but even so, at least stack use will get cached between then and
> the kernel entry point. The stub could conceivably get its hands on the
> EFI memmap and invalidate dcache using address ranges from UEFI memory
> descriptors so maybe that is the way we should do it.

I think the stub just needs to flush the relocated kernel image, ensure
it is sync with the memory. Additional flushing can be done by the
kernel for bits it writes (like page tables, code patching etc). We can
enter the kernel with the SCTLR.I bit set, so it can allocate in an
unified cache already and D-cache maintenance would be needed anyway.

Another aspect in the booting document is that we require any external
cache to be disabled. I think on ARMv8 with a more transparent external
cache we can relax this (Applied's SoC already does this). Otherwise,
since external cache enabling is usually a secure operation, we would
need some SoC specific code just for this early during boot and I'd like
to avoid it.

-- 
Catalin
