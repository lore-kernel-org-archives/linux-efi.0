From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 07/10] dmi: add support for SMBIOS 3.0 64-bit entry
 point
Date: Tue, 4 Nov 2014 17:39:11 +0000
Message-ID: <20141104173911.GC3592@console-pimps.org>
References: <1414513123-20400-1-git-send-email-ard.biesheuvel@linaro.org>
 <1414513123-20400-8-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414513123-20400-8-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 28 Oct, at 05:18:40PM, Ard Biesheuvel wrote:
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index 17afc51f3054..4139ef0bd51d 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -93,6 +93,12 @@ static void dmi_table(u8 *buf, int len, int num,
>  		const struct dmi_header *dm = (const struct dmi_header *)data;
>  
>  		/*
> +		 * 7.45 End-of-Table (Type 127) [SMBIOS reference spec v3.0.0]
> +		 */
> +		if (dm->type == 127)
> +			break;
> +
> +		/*

Hmm.. tiny nit, but s/127/DMI_ENTRY_END_OF_TABLE/ we already have a
symbol for this constant.

But other than that,

Acked-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

-- 
Matt Fleming, Intel Open Source Technology Center
