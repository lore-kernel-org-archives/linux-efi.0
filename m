From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCH] Don't print an error on unsupported BGRT version.
Date: Wed, 22 Jul 2015 11:26:48 -0700
Message-ID: <20150722182648.GC26620@cloud>
References: <20150722165357.GC1203@jtriplet-mobl1>
 <1437585207-32516-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437585207-32516-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 22, 2015 at 01:13:27PM -0400, Peter Jones wrote:
> BGRT can legitimately be a different version from what we support, and
> that's a problem with the driver not supporting something, not an error
> that needs to be surfaced to the user.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

As mentioned in my previous mail, please consider adding support for
version 0 instead, which would fix this issue in a better way.

If that's not possible, then sure, this patch is fine.  But ideally this
warning should tend to lead to a patch to the bgrt driver adding support
for the new version (or in this case the old version), rather than just
silencing the warning.

>  arch/x86/platform/efi/efi-bgrt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> index d7f997f..e369162 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -46,7 +46,7 @@ void __init efi_bgrt_init(void)
>  		return;
>  	}
>  	if (bgrt_tab->version != 1) {
> -		pr_err("Ignoring BGRT: invalid version %u (expected 1)\n",
> +		pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
>  		       bgrt_tab->version);
>  		return;
>  	}
> -- 
> 2.4.3
> 
