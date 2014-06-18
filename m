From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v5 7/7] arch/x86: Comment out efi_set_rtc_mmss()
Date: Wed, 18 Jun 2014 15:08:21 +0100
Message-ID: <20140618140821.GK24049@console-pimps.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-8-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1402678823-24589-8-git-send-email-daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 13 Jun, at 07:00:23PM, Daniel Kiper wrote:
> efi_set_rtc_mmss() is never used to set RTC due to bugs found
> on many EFI platforms. It is set directly by mach_set_rtc_mmss().
> 
> Signed-off-by: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index deb4f05..bd3e080 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -244,6 +244,11 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
>  	return status;
>  }
>  
> +#if 0
> +/*
> + * efi_set_rtc_mmss() is never used to set RTC due to bugs found
> + * on many EFI platforms. It is set directly by mach_set_rtc_mmss().
> + */
>  int efi_set_rtc_mmss(const struct timespec *now)
>  {
>  	unsigned long nowtime = now->tv_sec;
> @@ -279,6 +284,7 @@ int efi_set_rtc_mmss(const struct timespec *now)
>  	}
>  	return 0;
>  }
> +#endif
>  
>  void efi_get_time(struct timespec *now)
>  {

As others have said in this thread - just delete this sucker.

I did make an attempt to get rid of all the time functions recently, but
chickened out at the last minute because we were nearing the merge
window,

  http://article.gmane.org/gmane.linux.kernel.janitors/30082

So yes, please go ahead and delete this function.

-- 
Matt Fleming, Intel Open Source Technology Center
