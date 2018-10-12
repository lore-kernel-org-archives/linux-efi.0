From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v8 1/3] x86/boot: Add acpitb.c to parse acpi tables
Date: Fri, 12 Oct 2018 17:36:38 +0800
Message-ID: <20181012093638.GA1898@localhost.localdomain>
References: <20181010084119.17539-1-fanc.fnst@cn.fujitsu.com>
 <20181010084119.17539-2-fanc.fnst@cn.fujitsu.com>
 <20181011105708.GB25435@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181011105708.GB25435@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 11, 2018 at 12:57:08PM +0200, Borislav Petkov wrote:
>On Wed, Oct 10, 2018 at 04:41:17PM +0800, Chao Fan wrote:
[...]
>> +		 * If ACPI20 table not found, but ACPI table found,
>> +		 * use the ACPI table and return true.
>> +		 * If neither ACPI table nor ACPI20 table found,
>> +		 * return false.
>> +		 */
>> +		if (!(efi_guidcmp(guid, ACPI_TABLE_GUID))) {
>> +			*rsdp_addr = (acpi_physical_address)table;
>> +			find_rsdp = true;
>> +		} else if (!(efi_guidcmp(guid, ACPI_20_TABLE_GUID))) {
>> +			*rsdp_addr = (acpi_physical_address)table;
>> +			return true;
>> +		}
>> +	}
>> +	return find_rsdp;
>> +}
>> +#else
>> +static bool efi_get_rsdp_addr(acpi_physical_address *rsdp_addr)
>> +{
>> +	return false;
>> +}
>> +#endif
>
>Instead of doing this, move the ifdef inside the function:
>
>static bool efi_get_rsdp_addr(acpi_physical_address *rsdp_addr)
>{
>#ifdef CONFIG_EFI
>
>	/* function body */
>#endif
>}
>

Hi Borislav,

Thank you for review the detail, but may I ask you why this style is better?

Since the Documentation/process/coding-style.rst said:
Instead,
use such conditionals in a header file defining functions for use in those .c
files, providing no-op stub versions in the #else case, and then call those
functions unconditionally from .c files.  The compiler will avoid generating
any code for the stub calls, producing identical results, but the logic will
remain easy to follow.

Prefer to compile out entire functions, rather than portions of functions or
portions of expressions.  Rather than putting an ifdef in an expression, factor
out part or all of the expression into a separate helper function and apply the
conditional to that function.

So I am puzzled. If my understanding is wrong, please let me know.

Thanks,
Chao Fan

>> +
>> +static u8 checksum(u8 *buffer, u32 length)
>
>compute_checksum(...)
>
>> +{
>> +	u8 sum = 0;
>> +	u8 *end = buffer + length;
>> +
>> +	while (buffer < end)
>> +		sum = (u8)(sum + *(buffer++));
>> +
>> +	return sum;
>> +}
>> +
>> +/*
>> + * Used to search a block of memory for the RSDP signature.
>> + * Return Pointer to the RSDP if found, otherwise NULL.
>> + * Based on acpi_tb_scan_memory_for_rsdp().
>> + */
>> +static u8 *scan_mem_for_rsdp(u8 *start_address, u32 length)
>> +{
>> +	struct acpi_table_rsdp *rsdp;
>> +	u8 *end_address;
>> +	u8 *mem_rover;
>> +
>> +	end_address = start_address + length;
>> +
>> +	/* Search from given start address for the requested length */
>> +	for (mem_rover = start_address; mem_rover < end_address;
>> +	     mem_rover += ACPI_RSDP_SCAN_STEP) {
>
>Shorten those variable names so that the loop fits on one line.
>
>> +		/*
>> +		 * The RSDP signature and checksum must both be correct
>> +		 * Note: Sometimes there exists more than one RSDP in memory;
>> +		 * the valid RSDP has a valid checksum, all others have an
>> +		 * invalid checksum.
>> +		 */
>> +		rsdp = (struct acpi_table_rsdp *)mem_rover;
>> +
>> +		/* Nope, BAD Signature */
>> +		if (!ACPI_VALIDATE_RSDP_SIG(rsdp->signature))
>> +			continue;
>> +
>> +		/* Check the standard checksum */
>> +		if (checksum((u8 *) rsdp, ACPI_RSDP_CHECKSUM_LENGTH) != 0)
>
>No need for "!= 0" at the end. Fix all other tests too.
>
>> +			continue;
>> +
>> +		/* Check extended checksum if table version >= 2 */
>> +		if ((rsdp->revision >= 2) &&
>> +		    (checksum((u8 *) rsdp, ACPI_RSDP_XCHECKSUM_LENGTH) != 0))
>> +			continue;
>> +
>> +		/* Sig and checksum valid, we have found a real RSDP */
>> +		return mem_rover;
>> +	}
>> +	return NULL;
>> +}
>> +
>> +/*
>> + * Used to search RSDP physical address.
>> + * Based on acpi_find_root_pointer(). Since only use physical address
>> + * in this period, so there is no need to do the memory map jobs.
>> + */
>> +static void bios_get_rsdp_addr(acpi_physical_address *rsdp_addr)
>> +{
>> +	struct acpi_table_rsdp *rsdp;
>> +	u8 *table_ptr;
>> +	u8 *mem_rover;
>> +	u32 address;
>> +
>> +	/*
>> +	 * Get the location of the Extended BIOS Data Area (EBDA)
>> +	 * Since we use physical address directely, so
>> +	 * acpi_os_map_memory() and acpi_os_unmap_memory() are
>> +	 * not needed here.
>> +	 */
>> +	table_ptr = (u8 *)ACPI_EBDA_PTR_LOCATION;
>> +	*(u32 *)(void *)&address = *(u16 *)(void *)table_ptr;
>> +	address <<= 4;
>> +	table_ptr = (u8 *)address;
>> +
>> +	/*
>> +	 * Search EBDA paragraphs (EBDA is required to be a minimum of
>> +	 * 1K length)
>> +	 */
>> +	if (address > 0x400) {
>> +		mem_rover = scan_mem_for_rsdp(table_ptr, ACPI_EBDA_WINDOW_SIZE);
>> +
>> +		if (mem_rover) {
>> +			address += (u32)ACPI_PTR_DIFF(mem_rover, table_ptr);
>> +			*rsdp_addr = (acpi_physical_address)address;
>> +			return;
>> +		}
>> +	}
>> +
>> +	table_ptr = (u8 *)ACPI_HI_RSDP_WINDOW_BASE;
>> +	mem_rover = scan_mem_for_rsdp(table_ptr, ACPI_HI_RSDP_WINDOW_SIZE);
>> +
>> +	/*
>> +	 * Search upper memory: 16-byte boundaries in E0000h-FFFFFh
>> +	 * Since we use physical address directely, so
>> +	 * acpi_os_map_memory() and acpi_os_unmap_memory() are
>> +	 * not needed here.
>> +	 */
>> +	if (mem_rover) {
>> +		address = (u32)(ACPI_HI_RSDP_WINDOW_BASE +
>> +				ACPI_PTR_DIFF(mem_rover, table_ptr));
>> +		*rsdp_addr = (acpi_physical_address)address;
>> +		return;
>
>We will return anyway, without that statement. :)
>
>> +	}
>> +}
>> +
>> +#ifdef CONFIG_KEXEC
>> +static bool get_acpi_rsdp(acpi_physical_address *rsdp_addr)
>> +{
>> +	char *args = (char *)get_cmd_line_ptr();
>> +	size_t len = strlen((char *)args);
>> +	char *tmp_cmdline, *param, *val;
>> +	unsigned long long addr = 0;
>> +	char *endptr;
>> +
>> +	if (!strstr(args, "acpi_rsdp="))
>> +		return false;
>> +
>> +	tmp_cmdline = malloc(len+1);
>> +	if (!tmp_cmdline)
>> +		error("Failed to allocate space for tmp_cmdline");
>
>Why do you even need to allocate a tmp cmdline?
>
>Ah, I see what you've done - you've copied handle_mem_options() in
>kaslr.c. Well no, not really.
>
>That functionality needs to get extracted into a separate facility. Oh
>look, there's arch/x86/boot/compressed/cmdline.c which is begging to get
>extended.
>
>:-)
>
>> +
>> +	memcpy(tmp_cmdline, args, len);
>> +	tmp_cmdline[len] = 0;
>> +	args = tmp_cmdline;
>> +
>> +	args = skip_spaces(args);
>> +
>> +	while (*args) {
>> +		args = next_arg(args, &param, &val);
>> +
>> +		if (!val && strcmp(param, "--") == 0) {
>> +			warn("Only '--' specified in cmdline");
>> +			free(tmp_cmdline);
>> +			return false;
>> +		}
>> +
>> +		if (!strcmp(param, "acpi_rsdp")) {
>> +			addr = simple_strtoull(val, &endptr, 0);
>
>WARNING: simple_strtoull is obsolete, use kstrtoull instead
>#321: FILE: arch/x86/boot/compressed/acpitb.c:262:
>+                       addr = simple_strtoull(val, &endptr, 0);
>
>
>Please integrate scripts/checkpatch.pl into your patch creation
>workflow. Some of the warnings/errors *actually* make sense.
>
>> +
>> +			if (addr == 0)
>> +				return false;
>> +
>> +			*rsdp_addr = (acpi_physical_address)addr;
>> +			return true;
>> +		}
>> +	}
>> +	return false;
>> +}
>> +#else
>> +static bool get_acpi_rsdp(acpi_physical_address *rsdp_addr)
>> +{
>> +	return false;
>> +}
>> +#endif
>> +
>> +/*
>> + * Used to dig rsdp table from EFI table or BIOS.
>
>Write "rsdp" in all caps in all comments.
>
>> + * If rsdp table found in EFI table, use it. Or search BIOS.
>> + * Based on acpi_os_get_root_pointer().
>> + */
>> +static acpi_physical_address get_rsdp_addr(void)
>> +{
>> +	acpi_physical_address pa = 0;
>> +	bool status = false;
>> +
>> +	status = get_acpi_rsdp(&pa);
>
>Why does this function return bool if pa == 0 is already an invalid
>address. You don't need the initialization to 0 above either.
>
>> +
>> +	if (!status || pa == 0)
>
>	if (!status || !pa)
>
>Fix all other tests.
>
>> +		status = efi_get_rsdp_addr(&pa);
>> +
>> +	if (!status || pa == 0)
>> +		bios_get_rsdp_addr(&pa);
>> +
>> +	return pa;
>> +}
>> +
>> +static struct acpi_table_header *get_acpi_srat_table(void)
>> +{
>> +	char *args = (char *)get_cmd_line_ptr();
>> +	acpi_physical_address acpi_table;
>> +	acpi_physical_address root_table;
>> +	struct acpi_table_header *header;
>> +	struct acpi_table_rsdp *rsdp;
>> +	char *signature;
>> +	u8 *entry;
>> +	u32 count;
>> +	u32 size;
>> +	int i, j;
>> +	u32 len;
>> +
>> +	rsdp = (struct acpi_table_rsdp *)get_rsdp_addr();
>> +	if (!rsdp)
>> +		return NULL;
>> +
>> +	/* Get rsdt or xsdt from rsdp. */
>> +	if (!strstr(args, "acpi=rsdt") &&
>> +	    rsdp->xsdt_physical_address && rsdp->revision > 1) {
>> +		root_table = rsdp->xsdt_physical_address;
>> +		size = ACPI_XSDT_ENTRY_SIZE;
>> +	} else {
>> +		root_table = rsdp->rsdt_physical_address;
>> +		size = ACPI_RSDT_ENTRY_SIZE;
>> +	}
>
>Please rework the cmdline parsing so that the functions can call helpers
>only.
>
>> +
>> +	/* Get ACPI root table from rsdt or xsdt.*/
>> +	header = (struct acpi_table_header *)root_table;
>> +	len = header->length;
>> +	count = (u32)((len - sizeof(struct acpi_table_header)) / size);
>> +	entry = ACPI_ADD_PTR(u8, header, sizeof(struct acpi_table_header));
>> +
>> +	for (i = 0; i < count; i++) {
>> +		u64 address64;
>> +
>> +		if (size == ACPI_RSDT_ENTRY_SIZE)
>> +			acpi_table = ((acpi_physical_address)
>> +				      (*ACPI_CAST_PTR(u32, entry)));
>> +		else {
>> +			*(u64 *)(void *)&address64 = *(u64 *)(void *)entry;
>> +			acpi_table = (acpi_physical_address) address64;
>> +		}
>> +
>> +		if (acpi_table) {
>> +			header = (struct acpi_table_header *)acpi_table;
>> +			signature = header->signature;
>> +
>> +			if (!strncmp(signature, "SRAT", 4))
>> +				return header;
>> +		}
>> +		entry += size;
>> +	}
>> +	return NULL;
>> +}
>> +
>> +#ifdef CONFIG_MEMORY_HOTREMOVE
>> +/*
>> + * According to ACPI table, filter the immvoable memory regions
>> + * and store them in immovable_mem[].
>> + */
>> +void get_immovable_mem(void)
>> +{
>> +	char *args = (char *)get_cmd_line_ptr();
>> +	struct acpi_table_header *table_header;
>> +	struct acpi_subtable_header *table;
>> +	struct acpi_srat_mem_affinity *ma;
>> +	unsigned long table_end;
>> +	int i = 0;
>> +
>> +	if (!strstr(args, "movable_node") || strstr(args, "acpi=off"))
>> +		return;
>
>Ditto.
>
>> +
>> +	table_header = get_acpi_srat_table();
>> +	if (!table_header)
>> +		return;
>> +
>> +	table_end = (unsigned long)table_header + table_header->length;
>> +
>> +	table = (struct acpi_subtable_header *)
>> +		((unsigned long)table_header + sizeof(struct acpi_table_srat));
>> +
>> +	while (((unsigned long)table) + table->length < table_end) {
>> +		if (table->type == 1) {
>> +			ma = (struct acpi_srat_mem_affinity *)table;
>> +			if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)) {
>> +				immovable_mem[i].start = ma->base_address;
>> +				immovable_mem[i].size = ma->length;
>> +				i++;
>> +			}
>> +
>> +			if (i >= MAX_NUMNODES*2)
>> +				break;
>> +		}
>> +		table = (struct acpi_subtable_header *)
>> +			((unsigned long)table + table->length);
>> +	}
>> +	num_immovable_mem = i;
>> +}
>> +#else
>> +void get_immovable_mem(void)
>> +{
>> +}
>> +#endif
>
>This patch is a pain to review - pls split it into patches adding:
>
>* get_acpi_rsdp
>* efi_get_rsdp_addr
>* bios_get_rsdp_addr
>
>and the needed functionality.
>
>As a prepatch refactor the cmdline parsing pls.
>
>Thx.
>
>-- 
>Regards/Gruss,
>    Boris.
>
>Good mailing practices for 400: avoid top-posting and trim the reply.
>
>
