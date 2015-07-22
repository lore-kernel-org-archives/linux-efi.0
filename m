From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH V6 1/4] efi: x86: rearrange efi_mem_attributes()
Date: Wed, 22 Jul 2015 12:11:06 +0100
Message-ID: <20150722111106.GC2734@codeblueprint.co.uk>
References: <1437438759-3686-1-git-send-email-zjzhang@codeaurora.org>
 <1437438759-3686-2-git-send-email-zjzhang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437438759-3686-2-git-send-email-zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 20 Jul, at 05:32:36PM, Jonathan (Zhixiong) Zhang wrote:
> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> x86 and ia64 implement efi_mem_attributes() differently. This
> function needs to be available for other arch (such as arm64)
> as well, such as for the purpose of ACPI/APEI.
> 
> ia64 efi does not setup memmap variable and does not set
> EFI_MEMMAP flag, so it needs to have its unique implementation
> of efi_mem_attributes().
> 
> Move efi_mem_attributes() implementation from x86 to efi, and
> declare it with __weak. It is recommended that other archs
> should not override the default implementation.
> 
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 18 ------------------
>  drivers/firmware/efi/efi.c  | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+), 18 deletions(-)

Reviewed-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

-- 
Matt Fleming, Intel Open Source Technology Center
