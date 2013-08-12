From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 15/16] Add EFI stub for ARM
Date: Mon, 12 Aug 2013 10:51:53 -0400
Message-ID: <1376319113.32237.23.camel@t520.redhat.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	 <1376090777-20090-16-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376090777-20090-16-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> +static int relocate_kernel(efi_system_table_t *sys_table,
> +                          unsigned long *zimage_addr,
> +                          unsigned long zimage_size,
> +                          unsigned long min_addr, unsigned long max_addr)
> +{
> +       /* Get current address of kernel. */
> +       unsigned long cur_zimage_addr = *zimage_addr;
> +       unsigned long new_addr = 0;
> +
> +       efi_status_t status;
> +
> +       if (!zimage_addr || !zimage_size)
> +               return EFI_INVALID_PARAMETER;
> +

This parameter check is too late. You already used zimage_addr to
initialize cur_zimage_addr.

--Mark
