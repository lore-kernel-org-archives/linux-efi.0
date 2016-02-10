From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: minor fixup in efivar_validate() declaration
Date: Wed, 10 Feb 2016 16:38:55 +0000
Message-ID: <20160210163855.GB2949@codeblueprint.co.uk>
References: <20160210132225.GA2949@codeblueprint.co.uk>
 <1455115862-2490-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455115862-2490-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 10 Feb, at 09:51:02AM, Peter Jones wrote:
> When I switched the function to data_size as the parameter name, I
> forgot to fix the header.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/efi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 1869d5c..47be3ad 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1200,7 +1200,7 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
>  				       struct list_head *head, bool remove);
>  
>  bool efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
> -		     unsigned long len);
> +		     unsigned long data_size);
>  bool efivar_variable_is_removable(efi_guid_t vendor, const char *name,
>  				  size_t len);

Thanks Peter, I folded this snippet into your patch that adds the
'vendor' argument to the efivar_validate() prototype. Let me know if
that's not OK.
