From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 0/2] efi: preserve NEON registers on UEFI services
 calls
Date: Tue, 1 Jul 2014 14:26:38 +0100
Message-ID: <20140701132638.GC7539@console-pimps.org>
References: <1403777346-28629-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1403777346-28629-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, olivier.martin-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 26 Jun, at 12:09:04PM, Ard Biesheuvel wrote:
> The current UEFI implementation for arm64 fails to preserve/restore the contents
> of the NEON register file, which may result in data corruption, especially now
> that those contents are lazily restored for user processes.
> 
> This series proposes to fix this by wrapping all runtime services calls, and
> adding kernel_neon_begin()/kernel_neon_end() pairs to the wrappers.
> 
> The first patch moves the existing x86 versions of those wrappers to generic
> code, so that the second patch can easily enable them by supplying a definition
> for efi_call_virt and adding a call to efi_native_runtime_setup().
> 
> Changes since v1:
> - rename runtime.c -> runtime-wrappers.c
> - make build depend on new Kconfig symbol EFI_RUNTIME_WRAPPERS to fix ia64
>   breakage
> - remove default #defines for efi_call_virt()/__efi_call_virt(), they are not
>   needed anymore now that it is built conditionally
> - add references to applicable UEFI/AAPCS spec sections
> 
> Ard Biesheuvel (2):
>   efi/x86: move UEFI Runtime Services wrappers to generic code
>   efi/arm64: preserve FP/SIMD registers on UEFI runtime services calls

Thanks Ard. These patches look OK to me, and I've now pulled them into
my 'next' branch.

It'd be nice if we could get some ACKs from other people since this is
an ABI issue.

-- 
Matt Fleming, Intel Open Source Technology Center
