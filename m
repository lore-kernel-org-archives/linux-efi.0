From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 06/18] Enforce minimum alignment of 1 page on allocations.
Date: Wed, 25 Sep 2013 13:01:18 +0100
Message-ID: <20130925120118.GE21381@console-pimps.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
 <1379889942-3135-7-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1379889942-3135-7-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, matt.fleming@intel.com, leif.lindholm@linaro.org, grant.likely@linaro.org, msalter@redhat.com
List-Id: linux-efi@vger.kernel.org

On Sun, 22 Sep, at 03:45:30PM, Roy Franz wrote:
> The efi_high_alloc() and efi_low_alloc() functions
> use the EFI_ALLOCATE_ADDRESS option to the EFI
> function allocate_pages(), which requires a minimum
> of page alignment, and rejects all other requests.
> The existing code could fail to allocate depending
> on allocation size, as although repeated allocation
> attempts were made, none were guaranteed to be page
> aligned.
> 
> 
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> Acked-by: Mark Salter <msalter@redhat.com>
> Reviewed-by: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/firmware/efi/efi-stub-helper.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)

[...]

> +	/* Enforce minimum alignment that EFI requires when requesting
> +	 * a specific address.  We are doing page-based allocations,
> +	 * so we must be aligned to a page.
> +	 */
> +	if (align < EFI_PAGE_SIZE)
> +		align = EFI_PAGE_SIZE;
> +

FYI I manually fixed up these comments to use the multi-line form, e.g.

	/*
	 * Enforce minimum alignment that EFI requires when requesting
	 * a specific address.  We are doing page-based allocations,
	 * so we must be aligned to a page.
	 */

so that they match the rest of the comments in the file.

-- 
Matt Fleming, Intel Open Source Technology Center
