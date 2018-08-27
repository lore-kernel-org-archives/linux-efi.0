From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v5 2/4] x86/boot: Add acpitb.c to parse acpi tables
Date: Mon, 27 Aug 2018 17:32:20 +0800
Message-ID: <20180827093220.GF1748@MiWiFi-R3L-srv>
References: <20180807065000.30958-1-fanc.fnst@cn.fujitsu.com>
 <20180807065000.30958-3-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180807065000.30958-3-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org, keescook@chromium.org, n-horiguchi@ah.jp.nec.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com, douly.fnst@cn.fujitsu.com, rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi Chao,

On 08/07/18 at 02:49pm, Chao Fan wrote:

I think better add acpi/efi maintainers to CC when you post.


> +static acpi_physical_address get_rsdp_addr(void)
> +{
> +	acpi_physical_address pa = 0;
> +	bool status = false;


Here, I think you should make get_rsdp_addr() consistent with its
counterpart acpi_os_get_root_pointer(). In acpi_os_get_root_pointer(),
we take care of the case that acpi_rsdp passed in a value.
> +
> +	status = efi_get_rsdp_addr(&pa);
> +
> +	if (!status || pa == 0)
> +		bios_get_rsdp_addr(&pa);
> +
> +	return pa;
> +}
> +
> +struct acpi_table_header *get_acpi_srat_table(void)
> +{
> +	char *args = (char *)get_cmd_line_ptr();
> +	acpi_physical_address acpi_table;
> +	acpi_physical_address root_table;
> +	struct acpi_table_header *header;
> +	struct acpi_table_rsdp *rsdp;
> +	char *signature;
> +	u8 *entry;
> +	u32 count;
> +	u32 size;
> +	int i, j;
> +	u32 len;
> +
> +	rsdp = (struct acpi_table_rsdp *)get_rsdp_addr();
> +	if (!rsdp)
> +		return NULL;
> +
> +	/* Get rsdt or xsdt from rsdp. */
> +	if (!strstr(args, "acpi=rsdt") &&
> +	    rsdp->xsdt_physical_address && rsdp->revision > 1) {
> +		root_table = rsdp->xsdt_physical_address;
> +		size = ACPI_XSDT_ENTRY_SIZE;
> +	} else {
> +		root_table = rsdp->rsdt_physical_address;
> +		size = ACPI_RSDT_ENTRY_SIZE;
> +	}
> +
> +	/* Get ACPI root table from rsdt or xsdt.*/
> +	header = (struct acpi_table_header *)root_table;
> +	len = header->length;
> +	count = (u32)((len - sizeof(struct acpi_table_header)) / size);
> +	entry = ACPI_ADD_PTR(u8, header, sizeof(struct acpi_table_header));
> +
> +	for (i = 0; i < count; i++) {
> +		u64 address64;
> +
> +		if (size == ACPI_RSDT_ENTRY_SIZE)
> +			acpi_table = ((acpi_physical_address)
> +				      (*ACPI_CAST_PTR(u32, entry)));
> +		else {
> +			*(u64 *)(void *)&address64 = *(u64 *)(void *)entry;
> +			acpi_table = (acpi_physical_address) address64;
> +		}
> +
> +		if (acpi_table) {
> +			header = (struct acpi_table_header *)acpi_table;
> +			signature = header->signature;
> +
> +			if (!strncmp(signature, "SRAT", 4))
> +				return header;
> +		}
> +		entry += size;
> +	}
> +	return NULL;
> +}
> -- 
> 2.17.1
> 
> 
> 
