From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 4/5] efi: Add shared printk wrapper for consistent
 prefixing
Date: Fri, 04 Apr 2014 07:31:49 -0700
Message-ID: <1396621909.2863.1.camel@joe-AO722>
References: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
	 <1396614350-20889-5-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1396614350-20889-5-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, matt.fleming@intel.com, linux-kernel@vger.kernel.org, Roy Franz <roy.franz@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2014-04-04 at 13:25 +0100, Leif Lindholm wrote:
> Add a wrapper for printk to standardize the prefix for informational and
> error messages from the EFI stub.
[]
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
[]
> @@ -33,6 +33,9 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
[]
> +#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
> +#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
[]
> @@ -486,7 +489,7 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
>  				       &new_addr);
>  	}
>  	if (status != EFI_SUCCESS) {
> -		efi_printk(sys_table_arg, "ERROR: Failed to allocate usable memory for kernel.\n");
> +		pr_efi_err(sys_table_arg, "ERROR: Failed to allocate usable memory for kernel.\n");

Author! Author! "ERROR: ERROR:"!

One too many "ERROR:" prefixes.
