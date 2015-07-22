From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] Don't print an error on unsupported BGRT version.
Date: Wed, 22 Jul 2015 09:53:57 -0700
Message-ID: <20150722165357.GC1203@jtriplet-mobl1>
References: <1437583253-29600-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437583253-29600-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 22, 2015 at 12:40:53PM -0400, Peter Jones wrote:
> BGRT can legitimately be a different version from what we support, and
> that's a problem with the driver not supporting something, not an error
> that needs to be surfaced to the user.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Are you actually seeing this error on a real system?  Or is this just a
theoretical concern with some future version?

While I agree that this doesn't need to be pr_err, I don't think
pr_debug is appropriate either.  It may mean the driver needs updating,
or it may mean that a system in the wild is actually broken and has an
invalid version number.  I'd prefer at least pr_warn so that people see
it and report it, but I could live with pr_notice; that should hide it
from systems booting in quiet mode, while still having it in the log
even on non-debug kernels.

- Josh Triplett

>  arch/x86/platform/efi/efi-bgrt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> index d7f997f..e568701 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -46,7 +46,7 @@ void __init efi_bgrt_init(void)
>  		return;
>  	}
>  	if (bgrt_tab->version != 1) {
> -		pr_err("Ignoring BGRT: invalid version %u (expected 1)\n",
> +		pr_debug("Ignoring BGRT: invalid version %u (expected 1)\n",
>  		       bgrt_tab->version);
>  		return;
>  	}
> -- 
> 2.4.3
> 
