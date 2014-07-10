From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi: fdt: Do not report an error during boot if UEFI is
 not available
Date: Thu, 10 Jul 2014 11:04:26 +0100
Message-ID: <20140710100426.GD15932@console-pimps.org>
References: <1404834858-10706-1-git-send-email-catalin.marinas@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404834858-10706-1-git-send-email-catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <Leif.Lindholm-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 08 Jul, at 04:54:18PM, Catalin Marinas wrote:
> Currently, fdt_find_uefi_params() reports an error if no EFI parameters
> are found in the DT. This is however a valid case for non-UEFI kernel
> booting. This patch checks changes the error reporting to a
> pr_info("UEFI not found") when no EFI parameters are found in the DT.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Tested-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)

Thanks, applied to 'urgent' for v3.16.

-- 
Matt Fleming, Intel Open Source Technology Center
