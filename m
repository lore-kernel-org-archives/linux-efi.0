From: Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Date: Sat, 29 Jun 2013 22:21:32 -0500
Message-ID: <1372562492.2776.163@driftwood>
References: <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372183863-11333-2-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
	(from leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org on Tue Jun 25 13:11:00 2013)
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 06/25/2013 01:11:00 PM, Leif Lindholm wrote:
> This patch provides documentation of the [U]EFI runtime services and
> configuration features.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  Documentation/arm/00-INDEX |    3 +++
>  Documentation/arm/uefi.txt |   39  
> +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
>  create mode 100644 Documentation/arm/uefi.txt
> 
> diff --git a/Documentation/arm/00-INDEX b/Documentation/arm/00-INDEX
> index 4978456..87e01d1 100644
> --- a/Documentation/arm/00-INDEX
> +++ b/Documentation/arm/00-INDEX
> @@ -36,3 +36,6 @@ nwfpe/
>  	- NWFPE floating point emulator documentation
>  swp_emulation
>  	- SWP/SWPB emulation handler/logging description
> +
> +uefi.txt
> +	- [U]EFI configuration and runtime services documentation
> diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
> new file mode 100644
> index 0000000..5c48271
> --- /dev/null
> +++ b/Documentation/arm/uefi.txt
> @@ -0,0 +1,39 @@
> +The nomenclature EFI and UEFI are used interchangeably in this  
> document.
> +

And the acronym expands to...?

> +The implementation depends on receiving pointers to the UEFI memory  
> map
> +and System Table in a Flattened Device Tree - so is only available  
> with
> +CONFIG_OF.
> +
> +It (early) parses the FDT for the following parameters:
> +- 'efi-system-table':
> +  Physical address of the system table. (required)
> +- 'efi-runtime-mmap':
> +  Physical address of an EFI memory map, containing at least
> +  the regions to be preserved. (required)
> +- 'efi-runtime-mmap-size':
> +  Size in bytes of the provided memory map. (required)
> +- 'efi-mmap-desc-size':
> +  Size of each descriptor in the memory map. (override default)
> +- 'efi-mmap-desc-ver':
> +  Memory descriptor format version. (override default)
> +
> +Since UEFI firmware on ARM systems are required to use a 1:1 memory  
> map
> +even on LPAE-capable systems, the above fields are 32-bit regardless.
> +
> +It also depends on early_ioremap to parse the memory map and preserve
> +the regions required for runtime services.
> +
> +For actually enabling [U]EFI support, enable:
> +- CONFIG_EFI=y
> +- CONFIG_EFI_VARS=y or m
> +
> +After the kernel has mapped the required regions into its address  
> space,
> +a SetVirtualAddressMap() call is made into UEFI in order to update
> +relocations. This call must be performed with all the code in a 1:1
> +mapping. This implementation achieves this by temporarily disabling  
> the
> +MMU for the duration of this call. This can only be done safely:
> +- before secondary CPUs are brought online.
> +- after early_initcalls have completed, sinze it uses  
> setup_mm_for_reboot().

Typo: since

> +
> +For verbose debug messages, specify 'uefi_debug' on the kernel  
> command
> +line.

At a wild guess, this parses a memory descriptor table to find out  
where the physical and device memory on an arm board live, according to  
some standard? I'm guessing because the file never quite says what this  
mechanism is _for_, just describes knobs on a black box...

(I can google, but it's a touch newbie-unfriendly. I tend to prefer  
documentation that's aimed at people who _don't_ already know whatever  
it is. Personal idiosyncrasy.)

Acked-by: Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>

Rob--
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
