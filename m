From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 4/7] Add proper definitions for some EFI function
 pointers.
Date: Tue, 6 Aug 2013 14:19:42 +0100
Message-ID: <20130806131942.GW2515@console-pimps.org>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
 <1375478948-22562-5-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1375478948-22562-5-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 02 Aug, at 02:29:05PM, Roy Franz wrote:
> The x86/AMD64 EFI stubs must us a call wrapper to convert between
> the Linux and EFI ABIs, so void pointers are sufficient.  For ARM,
> the ABIs are compatible, so we can directly invoke the function
> pointers.  The functions that are used by the ARM stub are updated
> to match the EFI definitions.
> 
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  include/linux/efi.h |   61 +++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 44 insertions(+), 17 deletions(-)

[...]

> @@ -96,6 +98,26 @@ typedef	struct {
>  #define EFI_MEMORY_DESCRIPTOR_VERSION	1
>  
>  #define EFI_PAGE_SHIFT		12
> +#define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
> +
> +typedef enum {
> +	EfiReservedMemoryType,
> +	EfiLoaderCode,
> +	EfiLoaderData,
> +	EfiBootServicesCode,
> +	EfiBootServicesData,
> +	EfiRuntimeServicesCode,
> +	EfiRuntimeServicesData,
> +	EfiConventionalMemory,
> +	EfiUnusableMemory,
> +	EfiACPIReclaimMemory,
> +	EfiACPIMemoryNVS,
> +	EfiMemoryMappedIO,
> +	EfiMemoryMappedIOPortSpace,
> +	EfiPalCode,
> +	EfiMaxMemoryType
> +} EFI_MEMORY_TYPE;
> +

These enums aren't used anywhere in your patches from what I can see and
we already have #define's for all these values, e.g. EFI_RESERVED_TYPE.

-- 
Matt Fleming, Intel Open Source Technology Center
