From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 3/5] efi: do variable name validation tests in utf8
Date: Thu, 4 Feb 2016 21:39:34 +0000
Message-ID: <20160204213934.GF2586@codeblueprint.co.uk>
References: <1454600074-14854-1-git-send-email-pjones@redhat.com>
 <1454600074-14854-4-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454600074-14854-4-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 04 Feb, at 10:34:32AM, Peter Jones wrote:
> Actually translate from ucs2 to utf8 before doing the test, and then
> test against our other utf8 data, instead of fudging it.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> Acked-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/vars.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index 70a0fb1..36c5a6e 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -192,7 +192,15 @@ bool
>  efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len)
>  {
>  	int i;
> -	u16 *unicode_name = var_name;
> +	unsigned long utf8_size;
> +	u8 *utf8_name;
> +
> +	utf8_size = ucs2_utf8size(var_name);
> +	utf8_name = kmalloc(utf8_size + 1, GFP_KERNEL);
> +	if (!utf8_name)
> +		return false;
> +
> +	ucs2_as_utf8(utf8_name, var_name, len);

The use of 'len' here is incorrect. 'len' is actually ->DataSize if
you follow the call stack down from efivar_create(). Yeah, it's poorly
named.

What you actually want to be using here is 'utf8_size'. Furthermore,
ucs2_as_utf8() doesn't guarantee NUL termination, so you need to
handle that.
