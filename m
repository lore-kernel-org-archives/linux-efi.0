From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/5] efi: use ucs2_as_utf8 in efivarfs instead of open
 coding a bad version (v2)
Date: Thu, 4 Feb 2016 22:06:48 +0000
Message-ID: <20160204220648.GG2586@codeblueprint.co.uk>
References: <1454600074-14854-1-git-send-email-pjones@redhat.com>
 <1454600074-14854-3-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454600074-14854-3-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 04 Feb, at 10:34:31AM, Peter Jones wrote:
> Translate EFI's UCS-2 variable names to UTF-8 instead of just assuming
> all variable names fit in ASCII.
> 
> v2: fix where I'd accidentally left some of the sizes off when
>     converting the variable name strings.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> Acked-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/efivars.c | 14 +++++---------
>  fs/efivarfs/super.c            |  7 +++----
>  2 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
> index 756eca8..cd53c4d 100644
> --- a/drivers/firmware/efi/efivars.c
> +++ b/drivers/firmware/efi/efivars.c
> @@ -540,7 +540,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
>  static int
>  efivar_create_sysfs_entry(struct efivar_entry *new_var)
>  {
> -	int i, short_name_size;
> +	int short_name_size;
>  	char *short_name;
>  	unsigned long variable_name_size;
>  	efi_char16_t *variable_name;
> @@ -553,22 +553,18 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
>  	 * Length of the variable bytes in ASCII, plus the '-' separator,
>  	 * plus the GUID, plus trailing NUL
>  	 */
> -	short_name_size = variable_name_size / sizeof(efi_char16_t)
> -				+ 1 + EFI_VARIABLE_GUID_LEN + 1;
> +	short_name_size = ucs2_utf8size(new_var->var.VariableName)
> +					+ 1 + EFI_VARIABLE_GUID_LEN + 1;
>  

'variable_name_size' is now unused, so you can delete it.
