From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 2/5] efibc: Fix excessive stack footprint warning
Date: Mon, 9 May 2016 23:41:01 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029639618A2@G4W3202.americas.hpqcorp.net>
References: <1462570771-13324-1-git-send-email-matt@codeblueprint.co.uk>
 <1462570771-13324-3-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462570771-13324-3-git-send-email-matt@codeblueprint.co.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Compostella <jeremy.compostella@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Matt Fleming
> Sent: Friday, May 06, 2016 4:39 PM
...
> Subject: [PATCH 2/5] efibc: Fix excessive stack footprint warning
> 
> From: Jeremy Compostella <jeremy.compostella@intel.com>
> 
...
> 
> -static void efibc_set_variable(const char *name, const char *value)
> +static int efibc_set_variable(const char *name, const char *value)
>  {
>  	int ret;
>  	efi_guid_t guid = LINUX_EFI_LOADER_ENTRY_GUID;
> -	struct efivar_entry entry;
> +	struct efivar_entry *entry;
>  	size_t size = (strlen(value) + 1) * sizeof(efi_char16_t);
> 
> -	if (size > sizeof(entry.var.Data))
> +	if (size > sizeof(entry->var.Data)) {
>  		pr_err("value is too large");

That pr_err is introduced by patch 25/40 of the first series.

How about including the name of the variable for which this is failing, 
like the final pr_err?

> +		return -EINVAL;
> +	}
> 
> -	efibc_str_to_str16(name, entry.var.VariableName);
> -	efibc_str_to_str16(value, (efi_char16_t *)entry.var.Data);
> -	memcpy(&entry.var.VendorGuid, &guid, sizeof(guid));
> +	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry) {
> +		pr_err("failed to allocate efivar entry");

How about including the name of the variable for which this
is failing, like the final pr_err?

> +		return -ENOMEM;
> +	}
> 
> -	ret = efivar_entry_set(&entry,
> +	efibc_str_to_str16(name, entry->var.VariableName);
> +	efibc_str_to_str16(value, (efi_char16_t *)entry->var.Data);
> +	memcpy(&entry->var.VendorGuid, &guid, sizeof(guid));
> +
> +	ret = efivar_entry_set(entry,
>  			       EFI_VARIABLE_NON_VOLATILE
>  			       | EFI_VARIABLE_BOOTSERVICE_ACCESS
>  			       | EFI_VARIABLE_RUNTIME_ACCESS,
> -			       size, entry.var.Data, NULL);
> +			       size, entry->var.Data, NULL);
>  	if (ret)
>  		pr_err("failed to set %s EFI variable: 0x%x\n",
>  		       name, ret);
> +
> +	kfree(entry);
> +	return ret;
>  }
