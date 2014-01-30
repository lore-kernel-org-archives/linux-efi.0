From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [RFC][PATCH 01/11] x86/boot: Cleanup header.S by removing some
 #ifdefs
Date: Thu, 30 Jan 2014 16:54:38 +0100
Message-ID: <20140130155438.GD23342@pd.tnic>
References: <1391012637-4839-1-git-send-email-matt@console-pimps.org>
 <1391012637-4839-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1391012637-4839-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 29, 2014 at 04:23:47PM +0000, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> handover_offset is now filled out by build.c. Don't set a default value
> as it will be overwritten anyway.
> 
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

> ---
>  arch/x86/boot/header.S | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
> index ec3b8ba68096..d69d96653325 100644
> --- a/arch/x86/boot/header.S
> +++ b/arch/x86/boot/header.S
> @@ -426,13 +426,7 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
>  #define INIT_SIZE VO_INIT_SIZE
>  #endif
>  init_size:		.long INIT_SIZE		# kernel initialization size
> -handover_offset:
> -#ifdef CONFIG_EFI_STUB
> -  			.long 0x30		# offset to the handover
> -						# protocol entry point
> -#else
> -			.long 0
> -#endif
> +handover_offset:	.long 0			# Filled in by build.c

That's efi_stub_entry in there, right?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
