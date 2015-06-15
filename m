From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH V4 1/4] efi: x86: rearrange efi_mem_attributes()
Date: Mon, 15 Jun 2015 18:09:57 +0100
Message-ID: <20150615170957.GC17685@codeblueprint.co.uk>
References: <1434157307-32318-1-git-send-email-zjzhang@codeaurora.org>
 <1434157307-32318-2-git-send-email-zjzhang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434157307-32318-2-git-send-email-zjzhang@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, ying.huang@intel.com, fu.wei@linaro.org, al.stone@linaro.org, bp@alien8.de, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, 12 Jun, at 06:01:44PM, Jonathan (Zhixiong) Zhang wrote:
> From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
> 
> x86 and ia64 implement efi_mem_attributes() differently. This
> function needs to be available for other arch (such as arm64)
> as well, such as for the purpose of ACPI/APEI.
> 
> ia64 efi does not setup memmap variable and does not set
> EFI_MEMMAP flag, so it needs to have its unique implementation
> of efi_mem_attributes().

Something like the above paragraph...
 
> @@ -517,3 +517,21 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>  			 attr & EFI_MEMORY_UC      ? "UC"  : "");
>  	return buf;
>  }

needs to go here, i.e. as documentation for efi_mem_atributes(). You
need to explain why this function is marked as __weak at the function
definition site.

> +u64 __weak efi_mem_attributes(unsigned long phys_addr)
> +{
> +	efi_memory_desc_t *md;
> +	void *p;
> +
> +	if (!efi_enabled(EFI_MEMMAP))
> +		return 0;
> +
> +	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +		md = p;
> +		if ((md->phys_addr <= phys_addr) &&
> +		    (phys_addr < (md->phys_addr +
> +		    (md->num_pages << EFI_PAGE_SHIFT))))
> +			return md->attribute;
> +	}
> +	return 0;
> +}

because otherwise people are going to read this in the future and think,

 "efi_mem_attribute() doesn't quite work how I want it to for my arch,
 but it's __weak, so I'll override it"

which is absolutely not the practice we should be promoting.

How about something like this,

	/*
	 * efi_mem_attributes - lookup memmap attributes for physical address
	 * @phys_addr: the physical address to lookup
	 *
	 * Search in the EFI memory map for the region covering
	 * @phys_addr. Returns the EFI memory attributes if the region
	 * was found in the memory map, 0 otherwise.
	 *
	 * Despite being marked __weak most architectures should *not*
	 * override this function. It is __weak solely for the benefit
	 * of ia64 which has a funky EFI memory map that doesn't work
	 * the same way as other architectures.
	 */

-- 
Matt Fleming, Intel Open Source Technology Center
