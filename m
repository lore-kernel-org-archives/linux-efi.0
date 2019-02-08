From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Fri, 8 Feb 2019 19:26:00 +0100
Message-ID: <20190208182600.GJ674@zn.tnic>
References: <20181025103345.GF14020@nazgul.tnic>
 <20181025134050.ggiir77ehntikbwg@gabell>
 <20181106184519.GA16391@zn.tnic>
 <20181106193636.svyjwuwrlgnpuyyf@gabell>
 <20181106204511.GO13712@zn.tnic>
 <20181106222133.lb7674yzszivzihd@gabell>
 <20181108105129.GA7543@zn.tnic>
 <20181110105422.GA20023@zn.tnic>
 <20181111134556.qxv2v4g7dl5irzo7@gabell>
 <20190205150514.fvztftk75swgfayd@gabell>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190205150514.fvztftk75swgfayd@gabell>
Sender: linux-kernel-owner@vger.kernel.org
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Chao Fan <fanc.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 05, 2019 at 10:05:16AM -0500, Masayoshi Mizuma wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> Date: Tue, 5 Feb 2019 10:00:59 -0500
> Subject: [PATCH] x86/mm: Introduce adjustment the padding size for KASLR

			"Adjust the padding size for KASLR"

> If the physical memory layout has huge space for hotplug, the padding
> used for the physical memory mapping section is not enough.
> So, such system may crash while memory hot-adding on KASLR enabled system.

Crash why?

Why is the padding not enough?

> For example, SRAT has the following layout, the maximum possible memory
> size is 32TB, and the memory is installed as 2TB actually, then the padding
> size should set 30TB (== possible memory size - actual memory size).
> 
>   SRAT: Node 3 PXM 7 [mem 0x1c0000000000-0x1fffffffffff] hotplug

What is that supposed to exemplify: that range is 3T not 2 and that
range start is not at 2T but 28T. So I have absolutely no clue what
you're trying to explain here.

Please go back, take your time and structure your commit message like
this:

Problem is A.

It happens because of B.

Fix it by doing C.

(Potentially do D).

For more detailed info, see
Documentation/process/submitting-patches.rst, Section "2) Describe your
changes".

> This patch introduces adjustment the padding size if the default

Avoid having "This patch" or "This commit" in the commit message. It is
tautologically useless.

Also, do

$ git grep 'This patch' Documentation/process

for more details.

> padding size isn't enough.
> 
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ---
>  Documentation/x86/zero-page.txt       |  1 +
>  arch/x86/boot/compressed/acpi.c       | 19 +++++++++++++++----
>  arch/x86/include/uapi/asm/bootparam.h |  2 +-
>  arch/x86/mm/kaslr.c                   | 26 +++++++++++++++++++++++++-
>  4 files changed, 42 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
> index 68aed077f..343fe1a90 100644
> --- a/Documentation/x86/zero-page.txt
> +++ b/Documentation/x86/zero-page.txt
> @@ -15,6 +15,7 @@ Offset	Proto	Name		Meaning
>  058/008	ALL	tboot_addr      Physical address of tboot shared page
>  060/010	ALL	ist_info	Intel SpeedStep (IST) BIOS support information
>  				(struct ist_info)
> +078/010	ALL	possible_mem_addr The possible maximum physical memory address.

Why isn't this called max_phys_addr then?

Also, please explain what it means at the end of this file.

>  080/010	ALL	hd0_info	hd0 disk parameter, OBSOLETE!!
>  090/010	ALL	hd1_info	hd1 disk parameter, OBSOLETE!!
>  0A0/010	ALL	sys_desc_table	System description table (struct sys_desc_table),
> diff --git a/arch/x86/boot/compressed/acpi.c b/arch/x86/boot/compressed/acpi.c
> index c5a949335..7dd61b943 100644
> --- a/arch/x86/boot/compressed/acpi.c
> +++ b/arch/x86/boot/compressed/acpi.c
> @@ -288,6 +288,7 @@ int count_immovable_mem_regions(void)
>  	struct acpi_subtable_header *sub_table;
>  	struct acpi_table_header *table_header;
>  	char arg[MAX_ACPI_ARG_LENGTH];
> +	unsigned long long possible_addr, max_possible_addr = 0;
>  	int num = 0;
>  
>  	if (cmdline_find_option("acpi", arg, sizeof(arg)) == 3 &&
> @@ -308,10 +309,19 @@ int count_immovable_mem_regions(void)
>  			struct acpi_srat_mem_affinity *ma;
>  
>  			ma = (struct acpi_srat_mem_affinity *)sub_table;
> -			if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && ma->length) {
> -				immovable_mem[num].start = ma->base_address;
> -				immovable_mem[num].size = ma->length;
> -				num++;
> +			if (ma->length) {
> +				if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
> +					possible_addr =
> +						ma->base_address + ma->length;
> +					if (possible_addr > max_possible_addr)
> +						max_possible_addr =
> +							possible_addr;
> +				} else {
> +					immovable_mem[num].start =
> +						ma->base_address;
> +					immovable_mem[num].size = ma->length;
> +					num++;
> +				}

This piece has some ugly linebreaks which makes it impossible to read.
Perhaps because the variable names you're adding are too long.

You can carve it out in a separate function, for example.

>  			if (num >= MAX_NUMNODES*2) {
> @@ -320,6 +330,7 @@ int count_immovable_mem_regions(void)
>  			}
>  		}
>  		table += sub_table->length;
> +		boot_params->possible_mem_addr = max_possible_addr;

This assignment is inside the loop and happens potentially a bunch of
times. Why?

>  	}
>  	return num;
>  }
> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
> index 60733f137..5b64b606e 100644
> --- a/arch/x86/include/uapi/asm/bootparam.h
> +++ b/arch/x86/include/uapi/asm/bootparam.h
> @@ -156,7 +156,7 @@ struct boot_params {
>  	__u64  tboot_addr;				/* 0x058 */
>  	struct ist_info ist_info;			/* 0x060 */
>  	__u64 acpi_rsdp_addr;				/* 0x070 */
> -	__u8  _pad3[8];					/* 0x078 */
> +	__u64  possible_mem_addr;			/* 0x078 */
>  	__u8  hd0_info[16];	/* obsolete! */		/* 0x080 */
>  	__u8  hd1_info[16];	/* obsolete! */		/* 0x090 */
>  	struct sys_desc_table sys_desc_table; /* obsolete! */	/* 0x0a0 */
> diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
> index 3f452ffed..71fc28570 100644
> --- a/arch/x86/mm/kaslr.c
> +++ b/arch/x86/mm/kaslr.c
> @@ -70,6 +70,30 @@ static inline bool kaslr_memory_enabled(void)
>  	return kaslr_enabled() && !IS_ENABLED(CONFIG_KASAN);
>  }
>  
> +static unsigned int __init kaslr_padding(void)
> +{
> +	unsigned int rand_mem_physical_padding =
> +				CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
> +#ifdef CONFIG_MEMORY_HOTPLUG
> +	unsigned long long max_possible_phys, max_actual_phys, threshold;
> +
> +	if (!boot_params.possible_mem_addr)
> +		goto out;
> +
> +	max_actual_phys = roundup(PFN_PHYS(max_pfn), 1ULL << TB_SHIFT);
> +	max_possible_phys = roundup(boot_params.possible_mem_addr,
> +					1ULL << TB_SHIFT);
> +	threshold = max_actual_phys +
> +		((unsigned long long)rand_mem_physical_padding << TB_SHIFT);
> +
> +	if (max_possible_phys > threshold)
> +		rand_mem_physical_padding =
> +			(max_possible_phys - max_actual_phys) >> TB_SHIFT;
> +out:
> +#endif
> +	return rand_mem_physical_padding;

Same problem: local variables with unnecessarily long names make the
code hard to read. Pls shorten.

Also, the types in that function are a total mess. An unsigned int which
you cast to unsigned long long and return an unsigned int again to add
into a sum with unsigned longs. Are you selecting the types randomly?
Why aren't you using plain unsigned longs like the rest of the file does
with memory addresses?

Also, this function could have a comment above it explaining what all
that threshold and actual and possible address arithmetic is supposed to
do.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
