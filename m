From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 07/10] efi: dmi: add support for SMBIOS 3.0 UEFI
 configuration table
Date: Mon, 27 Oct 2014 15:26:11 +0000
Message-ID: <20141027152611.GN12020@console-pimps.org>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
 <1413987713-30528-8-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1413987713-30528-8-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 22 Oct, at 04:21:50PM, Ard Biesheuvel wrote:
> This adds support to the UEFI side for detecting the presence of
> a SMBIOS 3.0 64-bit entry point. This allows the actual SMBIOS
> structure table to reside at a physical offset over 4 GB, which
> cannot be supported by the legacy SMBIOS 32-bit entry point.
> 
> Since the firmware can legally provide both entry points, store
> the SMBIOS 3.0 entry point in a separate variable, and let the
> DMI decoding layer decide which one will be used.
> 
> Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org>
> Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 4 ++++
>  include/linux/efi.h        | 6 +++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)

Looks like you might also need to change driver/xen/efi.c to set
EFI_INVALID_TABLE_ADDR for the new table address?

-- 
Matt Fleming, Intel Open Source Technology Center
