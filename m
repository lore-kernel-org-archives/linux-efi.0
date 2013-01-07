From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Fix efifb initialisation when the only GOP device
 implements ConOut.
Date: Mon, 07 Jan 2013 17:08:41 +0000
Message-ID: <1357578521.8203.68.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1357431222.9270.73.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357431222.9270.73.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 2013-01-06 at 00:13 +0000, David Woodhouse wrote:
> When booting under OVMF we have precisely one GOP device, and it
> implements the ConOut protocol.
> 
> We break out of the loop when we look at it... and then promptly abort
> because 'first_gop' never gets set. We should set first_gop *before*
> breaking out of the loop. Yes, it doesn't really mean "first" any more,
> but that doesn't matter. It's only a flag to indicate that a suitable
> GOP was found.
> 
> In fact, we'd do just as well to initialise 'width' to zero in this
> function, then just check *that* instead of first_gop. But I'll do the
> minimal fix for now (and for stable@).
> 
> Signed-off-by: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index c760e07..807330a 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -314,10 +314,9 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
>  			 * Once we've found a GOP supporting ConOut,
>  			 * don't bother looking any further.
>  			 */
> +			first_gop = gop;
>  			if (conout_found)
>  				break;
> -
> -			first_gop = gop;
>  		}
>  	}
>  
> 
> 

This looks good to me. Matthew?
