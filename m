From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v11 4/5] x86/boot: Dig out SRAT table from RSDP and find
 immovable memory
Date: Mon, 19 Nov 2018 10:08:11 +0800
Message-ID: <20181119020811.GC2336@localhost.localdomain>
References: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
 <20181112094645.4879-5-fanc.fnst@cn.fujitsu.com>
 <20181116111654.GC20313@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181116111654.GC20313@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 16, 2018 at 12:16:54PM +0100, Borislav Petkov wrote:
>On Mon, Nov 12, 2018 at 05:46:44PM +0800, Chao Fan wrote:
>> To avoid KASLR extracting kernel on movable memory, slove the
>						      ^^^^^
>
>Please introduce a spellchecker into your patch creation workflow.

OK.

>
>> conflict between KASLR and movable_node feature, dig the SRAT tables
>
>s/dig/determine/ or "compute SRAT table's address" or so.
>
>Also, replace "dig" with a more suitable verb in all your patches.

How about "search RSDP pointer"
>
>> from RSDP pointer. Walk the SRAT tables and store the immovable
>> memory regions in immovable_mem[].
>
>		"... in an array called immovable_mem[]."

Looks good.

>
>> There are three methods to get RSDP pointer: KEXEC condition,
>> EFI confition, BIOS condition.
>
>"condition" is not the right word here.
>
>> If KEXEC add 'acpi_rsdp' to cmdline, use it.
>> Otherwise, parse EFI table for RSDP.
>> Then, search memory for RSDP.
>> 
>> Imitate from ACPI code, based on acpi_os_get_root_pointer().
>> Process: RSDP->RSDT/XSDT->ACPI root table->SRAT.
>
>What?!
>
>This looks like a comment you've added as a note for yourself but not
>part of the final commit message. If you wanna explain the process, then
>write it out in plain english as if you're explaining it to someone who
>doesn't know what you're doing.

OK.

>
>> 
>> Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
>> ---
>>  arch/x86/boot/compressed/Makefile |   4 +
>>  arch/x86/boot/compressed/acpitb.c | 139 ++++++++++++++++++++++++++++++
>>  arch/x86/boot/compressed/kaslr.c  |   4 -
>>  arch/x86/boot/compressed/misc.h   |  15 ++++
>>  4 files changed, 158 insertions(+), 4 deletions(-)
>> 
>> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
>> index 466f66c8a7f8..b51f7629b8ef 100644
>> --- a/arch/x86/boot/compressed/Makefile
>> +++ b/arch/x86/boot/compressed/Makefile
>> @@ -84,6 +84,10 @@ ifdef CONFIG_X86_64
>>  	vmlinux-objs-y += $(obj)/pgtable_64.o
>>  endif
>>  
>> +#if (defined CONFIG_MEMORY_HOTREMOVE) && (defined CONFIG_RANDOMIZE_BASE)
>> +vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/acpitb.o
>> +#endif
>
>Right, as previously pointed out, this needs that CONFIG_ symbol and
>then you can save yourself most (if not all) of the ifdeffery in the
>rest of the patchset.

That makes sense, I will do that.

>
>> +
>>  $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
>>  
>>  vmlinux-objs-$(CONFIG_EFI_STUB) += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
>> diff --git a/arch/x86/boot/compressed/acpitb.c b/arch/x86/boot/compressed/acpitb.c
>> index 5cfb4efa5a19..161f21a7fb3b 100644
>> --- a/arch/x86/boot/compressed/acpitb.c
>> +++ b/arch/x86/boot/compressed/acpitb.c
>> @@ -14,6 +14,11 @@
>>  #define BOOT_STRING
>>  #include "../string.h"
>>  
>> +#ifdef CONFIG_MEMORY_HOTREMOVE
>> +/* Store the immovable memory regions */
>> +struct mem_vector immovable_mem[MAX_NUMNODES*2];
>> +#endif
>> +
>>  /* Search EFI table for RSDP table. */
>>  static void efi_get_rsdp_addr(acpi_physical_address *rsdp_addr)
>>  {
>> @@ -226,3 +231,137 @@ static void get_acpi_rsdp(acpi_physical_address *rsdp_addr)
>>  	}
>>  #endif
>>  }
>> +
>> +/*
>> + * Used to dig RSDP table from EFI table or BIOS.
>> + * If RSDP table found in EFI table, use it. Or search BIOS.
>> + * Based on acpi_os_get_root_pointer().
>> + */
>> +static acpi_physical_address get_rsdp_addr(void)
>> +{
>> +	acpi_physical_address pa = 0;
>> +
>> +	get_acpi_rsdp(&pa);
>> +
>> +	if (!pa)
>> +		efi_get_rsdp_addr(&pa);
>> +
>> +	if (!pa)
>> +		bios_get_rsdp_addr(&pa);
>> +
>> +	return pa;
>> +}
>> +
>> +static struct acpi_table_header *get_acpi_srat_table(void)
>> +{
>> +	acpi_physical_address acpi_table;
>> +	acpi_physical_address root_table;
>> +	struct acpi_table_header *header;
>> +	struct acpi_table_rsdp *rsdp;
>> +	bool acpi_use_rsdt = false;
>> +	char *signature;
>> +	char arg[10];
>> +	u8 *entry;
>> +	u32 count;
>> +	u32 size;
>> +	int i, j;
>> +	int ret;
>> +	u32 len;
>> +
>> +	rsdp = (struct acpi_table_rsdp *)get_rsdp_addr();
>> +	if (!rsdp)
>> +		return NULL;
>> +
>> +	ret = cmdline_find_option("acpi", arg, sizeof(arg));
>> +	if (ret == 4 && !strncmp(arg, "rsdt", 4))
>> +		acpi_use_rsdt = true;
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
>
>Reorganize that code here to get rid of acpi_use_rsdt.

OK.

>
>> +
>> +	/* Get ACPI root table from RSDT or XSDT.*/
>> +	header = (struct acpi_table_header *)root_table;
>> +	len = header->length;
>
>No checking of that header pointer before dereffing it?
>
>If it is NUL, that gives you a very nasty bug to try to debug in the
>early code.
>
>> +	count = (u32)((len - sizeof(struct acpi_table_header)) / size);
>
>Uuh, no checking for count wrapping around here due to wrong len? That
>would give you a *lot* of looping below if it wraps.
>
>IOW, you need to verify all those values before doing arithmetic with
>them - it is early code and it is BIOS - there's no trusting it.

I will add the check.

>
>Also, it is not "count" but "num_entries" or so.
>
>> +	entry = ACPI_ADD_PTR(u8, header, sizeof(struct acpi_table_header));
>> +
>> +	for (i = 0; i < count; i++) {
>
>That variable i is not needed, right?
>
>	while (num_entries--)
>
>?

Yes

>
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
>
>Now can acpi_table be NUL here?
>

Thank you,
I will change all of these.

Thanks,
Chao Fan

>> +			header = (struct acpi_table_header *)acpi_table;
>> +			signature = header->signature;
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
>					  ^^^^^^^^^
>Typo.
>
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
>> +	ret = cmdline_find_option("acpi", arg, sizeof(arg));
>> +	if (ret == 3 && !strncmp(arg, "off", 3))
>> +		return;
>> +
>> +	if (!cmdline_find_option_bool("movable_node"))
>> +		return;
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
>"..., aborting."
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
>
>Above says "regions" but define below is "TABLES". Hmmm?
>
>> +#define ACPI_MAX_TABLES                128
>> +void get_immovable_mem(void);
>> +#endif
>> +#endif
>> -- 
>
>-- 
>Regards/Gruss,
>    Boris.
>
>Good mailing practices for 400: avoid top-posting and trim the reply.
>
>
