From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 2/2] efilinux: set ext_ramdisk_* for huge initrd
Date: Wed, 25 Jun 2014 21:47:00 +0100
Message-ID: <20140625204700.GF15494@console-pimps.org>
References: <1403073669-6602-1-git-send-email-yinghai@kernel.org>
 <1403073669-6602-2-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1403073669-6602-2-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 17 Jun, at 11:41:09PM, Yinghai Lu wrote:
> We could load it high if it is more than 2G when kernel support
> LOAD_ABOVE_4G.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  loaders/bzimage/bzimage.c |    9 ++++++++-
>  loaders/bzimage/bzimage.h |    8 ++++++--
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> Index: efilinux/loaders/bzimage/bzimage.c
> ===================================================================
> --- efilinux.orig/loaders/bzimage/bzimage.c
> +++ efilinux/loaders/bzimage/bzimage.c
> @@ -130,7 +130,9 @@ static void parse_initrd(EFI_LOADED_IMAG
>  	if (err != EFI_SUCCESS)
>  		goto close_handles;
>  
> -	if ((UINTN)addr > boot_params->hdr.ramdisk_max) {
> +	if ((boot_params->hdr.version < 0x20c ||
> +	     !(boot_params->hdr.xloadflags & (1<<1))) &&
> +	    (UINTN)addr > boot_params->hdr.ramdisk_max) {

Could you please add a #define for the xloadflags bit?

-- 
Matt Fleming, Intel Open Source Technology Center
