From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efivars: allow module autoloading when mounting efivarfs
Date: Fri, 25 Jan 2013 11:52:50 +0000
Message-ID: <1359114770.2496.143.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1359037734-2551-1-git-send-email-teg@jklm.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359037734-2551-1-git-send-email-teg-B22kvLQNl6c@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, jlee-IBi9RG/b67k@public.gmane.org, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-01-24 at 15:28 +0100, Tom Gundersen wrote:
> When built with CONFIG_EFI_VARS=m, normal auotloading of the module when
> attempting to mount the fs does not work. Add a modalias to fix this.
> 
> Before:
>  # mount -t efivarfs none /mnt
>  mount: unknown filesystem type 'efivarfs'
> 
> After
>  # mount -t efivarfs none /mnt
> Success!
> 
> The problem still remains that /sys/firmware/efi/efivars does not exist before
> the module is loaded, so the mounting of the fs in its correct place still fails,
> but that's a problem for a separate patch.
> 
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
> Signed-off-by: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
> ---
>  drivers/firmware/efivars.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 7b1c374..b7cff5c 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -92,6 +92,7 @@
>  MODULE_AUTHOR("Matt Domsch <Matt_Domsch-DYMqY+WieiM@public.gmane.org>");
>  MODULE_DESCRIPTION("sysfs interface to EFI Variables");
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS("efivarfs");
>  MODULE_VERSION(EFIVARS_VERSION);
>  
>  #define DUMP_NAME_LEN 52

Looks fine to me. Jeremy?
