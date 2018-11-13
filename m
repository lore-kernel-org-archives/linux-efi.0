From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v11 4/5] x86/boot: Dig out SRAT table from RSDP and find
 immovable memory
Date: Tue, 13 Nov 2018 10:43:21 +0800
Message-ID: <20181113024321.GE7453@localhost.localdomain>
References: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
 <20181112094645.4879-5-fanc.fnst@cn.fujitsu.com>
 <20181112205253.ji3fm37haferjpqa@gabell>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181112205253.ji3fm37haferjpqa@gabell>
Sender: linux-kernel-owner@vger.kernel.org
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 12, 2018 at 03:52:54PM -0500, Masayoshi Mizuma wrote:
[...]
>
>> +
>> +	ret = cmdline_find_option("acpi", arg, sizeof(arg));
>> +	if (ret == 4 && !strncmp(arg, "rsdt", 4))
>> +		acpi_use_rsdt = true;
>
>All have to do for ret is checking whether it's above 0, right?
>So how about the following?
>
>	if ((cmdline_find_option("acpi", arg, sizeof(arg)) > 0) &&
>		!strncmp(arg, "rsdt", 4))
>		acpi_use_rsdt = true;

Maybe:
>	if ((cmdline_find_option("acpi", arg, sizeof(arg)) == 4) &&
>		!strncmp(arg, "rsdt", 4))
>		acpi_use_rsdt = true;
looks better. Thanks for your suggestion.

>
>> +
>> +	/* Get RSDT or XSDT from RSDP. */
>> +	if (!acpi_use_rsdt &&
>> +	    rsdp->xsdt_physical_address && rsdp->revision > 1) {
>> +		root_table = rsdp->xsdt_physical_address;
>> +		size = ACPI_XSDT_ENTRY_SIZE;
>> +	} else {
>> +		root_table = rsdp->rsdt_physical_address;
>> +		size = ACPI_RSDT_ENTRY_SIZE;
>> +	}
>> +
>> +	/* Get ACPI root table from RSDT or XSDT.*/
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
>
>> +			signature = header->signature;
>
>this isn't needed.

Yes, will change it.

>
>> +
>> +			if (ACPI_COMPARE_NAME(header->signature, ACPI_SIG_SRAT))
>> +				return header;
>> +		}
>> +		entry += size;
>> +	}
>> +	return NULL;
>> +}
>> +
>> +/*
>> + * According to ACPI table, filter the immvoable memory regions
>> + * and store them in immovable_mem[].
>> + */
>> +void get_immovable_mem(void)
>> +{
>> +	struct acpi_table_header *table_header;
>> +	struct acpi_subtable_header *table;
>> +	struct acpi_srat_mem_affinity *ma;
>> +	unsigned long table_end;
>> +	char arg[10];
>> +	int i = 0;
>> +	int ret;
>> +
>
>> +	ret = cmdline_find_option("acpi", arg, sizeof(arg));
>> +	if (ret == 3 && !strncmp(arg, "off", 3))
>> +		return;
>
>Same as above.
>
>	if ((cmdline_find_option("acpi", arg, sizeof(arg)) > 0) &&
>		!strncmp(arg, "off", 3))
>		return;
>> +
>> +	if (!cmdline_find_option_bool("movable_node"))
>> +		return;
>
>I think this check isn't needed.
>The SRAT parsing is needed to the kaslr issue which I'm trying
>to fix. The issue may happen even if movable_node isn't set.

Got it.

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
>> +	while (((unsigned long)table) +
>> +		       sizeof(struct acpi_subtable_header) < table_end) {
>> +		if (table->type == ACPI_SRAT_TYPE_MEMORY_AFFINITY) {
>> +			ma = (struct acpi_srat_mem_affinity *)table;
>> +			if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)) {
>> +				immovable_mem[i].start = ma->base_address;
>> +				immovable_mem[i].size = ma->length;
>> +				i++;
>> +			}
>> +
>> +			if (i >= MAX_NUMNODES*2) {
>> +				debug_putstr("Too many immovable memory regions, aborted.\n");
>
>I'm not sure this statement gets true actually,
>but if so, should it be set 0 to fallback in process_mem_region()?

That's a good problem.
Well, I don't know what will cause "i >= MAX_NUMNODES*2", maybe some
error in SRAT table or failed to parse table.
Anyway, it's a good idea to set it 0.

Thanks,
Chao Fan

>
>Thanks,
>Masa
>
>> +				break;
>> +			}
>> +		}
>> +		table = (struct acpi_subtable_header *)
>> +			((unsigned long)table + table->length);
>> +	}
>> +	num_immovable_mem = i;
>> +}
>> diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
>> index 9ed9709d9947..b251572e77af 100644
>> --- a/arch/x86/boot/compressed/kaslr.c
>> +++ b/arch/x86/boot/compressed/kaslr.c
>> @@ -87,10 +87,6 @@ static unsigned long get_boot_seed(void)
>>  #define KASLR_COMPRESSED_BOOT
>>  #include "../../lib/kaslr.c"
>>  
>> -struct mem_vector {
>> -	unsigned long long start;
>> -	unsigned long long size;
>> -};
>>  
>>  /* Only supporting at most 4 unusable memmap regions with kaslr */
>>  #define MAX_MEMMAP_REGIONS	4
>> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
>> index a1d5918765f3..4a3645fda0ed 100644
>> --- a/arch/x86/boot/compressed/misc.h
>> +++ b/arch/x86/boot/compressed/misc.h
>> @@ -77,6 +77,11 @@ void choose_random_location(unsigned long input,
>>  			    unsigned long *output,
>>  			    unsigned long output_size,
>>  			    unsigned long *virt_addr);
>> +struct mem_vector {
>> +	unsigned long long start;
>> +	unsigned long long size;
>> +};
>> +
>>  /* cpuflags.c */
>>  bool has_cpuflag(int flag);
>>  #else
>> @@ -116,3 +121,13 @@ static inline void console_init(void)
>>  void set_sev_encryption_mask(void);
>>  
>>  #endif
>> +
>> +/* acpitb.c */
>> +#ifdef CONFIG_RANDOMIZE_BASE
>> +int num_immovable_mem;
>> +#ifdef CONFIG_MEMORY_HOTREMOVE
>> +/* Store the amount of immovable memory regions */
>> +#define ACPI_MAX_TABLES                128
>> +void get_immovable_mem(void);
>> +#endif
>> +#endif
>> -- 
>> 2.19.1
>> 
>> 
>> 
>
>
