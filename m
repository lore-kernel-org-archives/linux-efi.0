From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86, efi: remove duplicate code in setup_arch() by
 using, efi_is_native()
Date: Thu, 14 Feb 2013 10:36:01 +0000
Message-ID: <1360838161.24917.42.camel@mfleming-mobl1.ger.corp.intel.com>
References: <511C2AC7.1080105@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511C2AC7.1080105-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux x86 ml <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, linux EFI ml <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-02-14 at 09:07 +0900, Satoru Takeuchi wrote:
> From: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> 
> The check, "IS_ENABLED(CONFIG_X86_64) != efi_enabled(EFI_64BIT)",
> in setup_arch() can be replaced by efi_is_enabled(). This change
> remove duplicate code and improve readability.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h  |    9 ++++++++-
>  arch/x86/kernel/setup.c     |    3 +--
>  arch/x86/platform/efi/efi.c |    5 -----
>  3 files changed, 9 insertions(+), 8 deletions(-)

Applied, thanks!
