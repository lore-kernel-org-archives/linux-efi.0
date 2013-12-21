From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v7 09/12] efi: passing kexec necessary efi data via
 setup_data
Date: Sat, 21 Dec 2013 16:06:01 +0000
Message-ID: <20131221160416.GD29501@console-pimps.org>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <1387533742-18018-10-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1387533742-18018-10-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com, James.Bottomley@HansenPartnership.com, vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com, toshi.kani@hp.com, akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com, leif.lindholm@linaro.org
List-Id: linux-efi@vger.kernel.org

On Fri, 20 Dec, at 06:02:19PM, Dave Young wrote:
> @@ -133,6 +133,19 @@ extern void efi_sync_low_kernel_mappings(void);
>  extern void efi_setup_page_tables(void);
>  extern void __init old_map_region(efi_memory_desc_t *md);
>  
> +struct efi_setup_data {
> +	u64 fw_vendor;
> +	u64 runtime;
> +	u64 tables;
> +	u64 smbios;
> +	u64 reserved[8];
> +	efi_memory_desc_t map[0];
> +};

[...]

> +static void get_nr_runtime_map(void)
> +{
> +	if (!efi_setup)
> +		return;
> +
> +	nr_efi_runtime_map = (efi_data_len - sizeof(struct efi_setup_data)) /
> +			     sizeof(efi_memory_desc_t);
> +}

Do we actually need the 'map' entry in efi_setup_data now that you're
passing it via efi_info (which is much better approach!)? Also, we don't
need the global nr_efi_runtime_map or efi_runtime_map variables now,
right?

-- 
Matt Fleming, Intel Open Source Technology Center
