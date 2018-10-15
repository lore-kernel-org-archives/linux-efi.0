From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v8 1/3] x86/boot: Add acpitb.c to parse acpi tables
Date: Mon, 15 Oct 2018 16:26:09 -0400
Message-ID: <20181015202609.gs6jownxbevs4vzr@gabell>
References: <20181010084119.17539-1-fanc.fnst@cn.fujitsu.com>
 <20181010084119.17539-2-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181010084119.17539-2-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

Hi Chao,

Let me add some suggestions.

On Wed, Oct 10, 2018 at 04:41:17PM +0800, Chao Fan wrote:
> There is a bug that kaslr may randomly chooses some positions
> which are located in movable memory regions. This will break memory
> hotplug feature and make the movable memory chosen by KASLR can't be
> removed. So dig SRAT table from ACPI tables to get memory information.
> 
> Imitate the ACPI code of parsing ACPI tables to dig and read ACPI
> tables. Since some operations are not needed here, functions are
> simplified. Functions will be used to dig only SRAT tables to get
> information of memory, so that KASLR can the memory in immovable node.
> 
> And also, these functions won't influence the initialization of
> ACPI after start_kernel().
> 
> Since use physical address directely, so acpi_os_map_memory()
> and acpi_os_unmap_memory() are not needed.
> 
> Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
> ---
>  arch/x86/boot/compressed/Makefile |   2 +
>  arch/x86/boot/compressed/acpitb.c | 405 ++++++++++++++++++++++++++++++
>  arch/x86/boot/compressed/misc.h   |   8 +
>  3 files changed, 415 insertions(+)
>  create mode 100644 arch/x86/boot/compressed/acpitb.c
> 
...cut...
> +static struct acpi_table_header *get_acpi_srat_table(void)
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

			if (ACPI_COMPARE_NAME(header->signature, ACPI_SIG_SRAT))

> +				return header;
> +		}
> +		entry += size;
> +	}
> +	return NULL;
> +}
> +
> +#ifdef CONFIG_MEMORY_HOTREMOVE
> +/*
> + * According to ACPI table, filter the immvoable memory regions
> + * and store them in immovable_mem[].
> + */
> +void get_immovable_mem(void)
> +{
> +	char *args = (char *)get_cmd_line_ptr();
> +	struct acpi_table_header *table_header;
> +	struct acpi_subtable_header *table;
> +	struct acpi_srat_mem_affinity *ma;
> +	unsigned long table_end;
> +	int i = 0;
> +
> +	if (!strstr(args, "movable_node") || strstr(args, "acpi=off"))
> +		return;
> +
> +	table_header = get_acpi_srat_table();
> +	if (!table_header)
> +		return;
> +
> +	table_end = (unsigned long)table_header + table_header->length;
> +
> +	table = (struct acpi_subtable_header *)
> +		((unsigned long)table_header + sizeof(struct acpi_table_srat));
> +

> +	while (((unsigned long)table) + table->length < table_end) {

	while (((unsigned long)table) +
			sizeof(struct acpi_subtable_header) < table_end) {

> +		if (table->type == 1) {

		if (table->type == ACPI_SRAT_TYPE_MEMORY_AFFINITY) {

> +			ma = (struct acpi_srat_mem_affinity *)table;
> +			if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)) {
> +				immovable_mem[i].start = ma->base_address;
> +				immovable_mem[i].size = ma->length;
> +				i++;
> +			}
> +
> +			if (i >= MAX_NUMNODES*2)
> +				break;
> +		}
> +		table = (struct acpi_subtable_header *)
> +			((unsigned long)table + table->length);
> +	}
> +	num_immovable_mem = i;
> +}

Thanks,
Masa
