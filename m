From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Split efi_enter_virtual_mode
Date: Mon, 20 Jan 2014 13:44:07 +0000
Message-ID: <20140120134407.GB684@console-pimps.org>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
 <1390045698-16882-6-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1390045698-16882-6-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 18 Jan, at 12:48:18PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> 
> ... into a kexec flavor for better code readability and simplicity. The
> original one was getting ugly with ifdeffery.
> 
> Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Tested-by: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 148 +++++++++++++++++++++++++++++---------------
>  include/linux/efi.h         |   1 +
>  2 files changed, 99 insertions(+), 50 deletions(-)

[...]

> @@ -1001,6 +986,72 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
>  	return new_memmap;
>  }
>  
> +void __init kexec_enter_virtual_mode(void)
> +{

Could this be static for now?

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 0a819e7a60c9..44ea66ce41e0 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -594,6 +594,7 @@ extern void efi_map_pal_code (void);
>  extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
>  extern void efi_gettimeofday (struct timespec *ts);
>  extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
> +extern void kexec_enter_virtual_mode(void);
>  #ifdef CONFIG_X86
>  extern void efi_late_init(void);
>  extern void efi_free_boot_services(void);

Which would allow us to drop this change.

-- 
Matt Fleming, Intel Open Source Technology Center
