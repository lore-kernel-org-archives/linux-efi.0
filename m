From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] UEFI: Don't use UEFI time services on 32-bit
Date: Fri, 29 Nov 2013 17:45:08 -0800
Message-ID: <52994324.4000404@zytor.com>
References: <1385754283-2464-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385754283-2464-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/29/2013 11:44 AM, Matthew Garrett wrote:
> UEFI time services are often broken once we're in virtual mode. We were
> already refusing to use them on 64-bit systems, but it turns out that
> they're also broken on some 32-bit firmware, including the Dell Venue.
> Disable them for now, we can revisit once we have the 1:1 mappings code
> incorporated.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> ---
>  arch/x86/platform/efi/efi.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 92c0234..cceb813 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -690,13 +690,6 @@ void __init efi_init(void)
>  
>  	set_bit(EFI_MEMMAP, &x86_efi_facility);
>  
> -#ifdef CONFIG_X86_32
> -	if (efi_is_native()) {
> -		x86_platform.get_wallclock = efi_get_time;
> -		x86_platform.set_wallclock = efi_set_rtc_mmss;
> -	}
> -#endif
> -

Does the Dell Venue have either an ACPI TAD or one of the PNP0B0x
devices exposed?

	-hpa
