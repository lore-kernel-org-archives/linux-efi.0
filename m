From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: Use GFP_ATOMIC instead of GFP_KERNEL
Date: Thu, 14 Apr 2016 22:49:49 +0100
Message-ID: <20160414214949.GS2829@codeblueprint.co.uk>
References: <1460372009-10785-1-git-send-email-vaishali.thakkar@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460372009-10785-1-git-send-email-vaishali.thakkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vaishali Thakkar <vaishali.thakkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 11 Apr, at 04:23:29PM, Vaishali Thakkar wrote:
> Function dup_variable_bug is called inside the spinlock.
> This may lead to issues when kzalloc sleeps, so it is
> better to use GFP_ATOMIC in this spinlocked context.
> 
> Problem found using Coccinelle.
 
Dang it, I broke coccinelle ;)

> Signed-off-by: Vaishali Thakkar <vaishali.thakkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/vars.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index 0ac594c..d5e2f28 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -411,7 +411,7 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
>  	 */
>  	efivar_wq_enabled = false;
>  
> -	str8 = kzalloc(len8, GFP_KERNEL);
> +	str8 = kzalloc(len8, GFP_ATOMIC);
>  	if (!str8)
>  		return;
>  

This was brought up by Saurabh last year,

  https://lkml.kernel.org/r/1446003747-3760-1-git-send-email-saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

dup_variable_bug() is never called while holding the spinlock in
practice, and I'm guessing Coccinelle cannot understand that because
it'd need to look at program control flow, across multiple compilation
units.

If anyone wants to send a patch to clean up the EFI code so that it's
easier for coccinelle to check it, I'd be happy to review it.
