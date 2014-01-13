From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH V6 3/8] Add helper function to get and convert EFI
 command line
Date: Mon, 13 Jan 2014 15:04:06 +0000
Message-ID: <20140113150406.GE3256@console-pimps.org>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
 <1389371417-379-4-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1389371417-379-4-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 10 Jan, at 08:30:12AM, Roy Franz wrote:
> Add an EFI stub helper function to retrieve the EFI command line using
> the LOADED_IMAGE_PROTOCOL, and convert it to ASCII.  This function will
> be shared by the various EFI stub implementations.
> 
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi-stub-helper.c |   30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> index eb5d2eb..f657456 100644
> --- a/drivers/firmware/efi/efi-stub-helper.c
> +++ b/drivers/firmware/efi/efi-stub-helper.c
> @@ -637,3 +637,33 @@ static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
>  	*cmd_line_len = options_size;
>  	return (char *)cmdline_addr;
>  }
> +
> +/*
> + * get the command line from EFI, using the LOADED_IMAGE
> + * protocol, and convert to ASCII.
> + *
> + */
> +static void efi_get_cmdline(efi_system_table_t *sys_table,
> +			      efi_loaded_image_t **image,
> +			      void *handle, char **cmdline_ptr)
> +{

Wouldn't this prototype make more sense?

static char *efi_get_cmdline(efi_system_table_t *sys_table,
			     efi_loaded_image_t **image,
			     void *handle);

Is this function really worth implementing at all? Certainly on x86, we
lookup the loaded image protocol for reasons other than parsing the
command line, and so would need to do it in the caller anyway.

-- 
Matt Fleming, Intel Open Source Technology Center
