From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v11 5/5] x86/boot/KASLR: Walk srat tables to filter
 immovable memory
Date: Mon, 19 Nov 2018 09:31:23 +0800
Message-ID: <20181119013123.GB2336@localhost.localdomain>
References: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
 <20181112094645.4879-6-fanc.fnst@cn.fujitsu.com>
 <20181116135039.GE20313@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181116135039.GE20313@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 16, 2018 at 02:50:39PM +0100, Borislav Petkov wrote:
> Subject: Re: [PATCH v11 5/5] x86/boot/KASLR: Walk srat tables to filter immovable memory
>
>s/srat/SRAT/g
>
>On Mon, Nov 12, 2018 at 05:46:45PM +0800, Chao Fan wrote:
>> KASLR may randomly chooses some positions which are located in movable
>
>		    choose
>
>> memory regions. This will break memory hotplug feature and make the
>> movable memory chosen by KASLR can't be removed.
>
>			by KASLR practically immovable.

Thanks,

>
>:)
>
>> The solution is limite KASLR to choose memory regions in immovable
>
>limite?
>
>"to limit"
>
>> node according to SRAT tables.
>> 
>> If CONFIG_MEMORY_HOTREMOVE enabled, walk through the SRAT memory
>
>			   *is* enabled,
>
>> tables and store those immovable memory regions so that KASLR can get
>> where to choose for randomization.
>> 
>> If the amount of immovable memory regions is not zero, which
>> means the immovable memory regions existing. Calculate the intersection
>> between memory regions from e820/efi memory table and immovable memory
>> regions.
>
>This is explaining *what* the patch does and generally doesn't need to
>be in the commit messge as people can read it in the patch itself.

OK,

>
>> Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
>> ---
>>  arch/x86/boot/compressed/kaslr.c | 77 +++++++++++++++++++++++++++-----
>>  1 file changed, 66 insertions(+), 11 deletions(-)
>> 
>> diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
>> index b251572e77af..174d2114045e 100644
>> --- a/arch/x86/boot/compressed/kaslr.c
>> +++ b/arch/x86/boot/compressed/kaslr.c
>> @@ -97,6 +97,11 @@ static bool memmap_too_large;
>>  /* Store memory limit specified by "mem=nn[KMG]" or "memmap=nn[KMG]" */
>>  static unsigned long long mem_limit = ULLONG_MAX;
>>  
>> +#ifdef CONFIG_MEMORY_HOTREMOVE
>> +/* Store the immovable memory regions */
>> +extern struct mem_vector immovable_mem[MAX_NUMNODES*2];
>> +#endif
>
>For this and the other occurrences of ifdef CONFIG_MEMORY_HOTREMOVE,
>define empty stubs for those functions in a header and remove the
>ifdeffery at the call sites.

OK,

>
>> +
>>  
>>  enum mem_avoid_index {
>>  	MEM_AVOID_ZO_RANGE = 0,
>> @@ -413,6 +418,11 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
>>  	/* Mark the memmap regions we need to avoid */
>>  	handle_mem_options();
>>  
>> +#ifdef CONFIG_MEMORY_HOTREMOVE
>> +	/* Mark the immovable regions we need to choose */
>> +	get_immovable_mem();
>> +#endif
>> +
>>  #ifdef CONFIG_X86_VERBOSE_BOOTUP
>>  	/* Make sure video RAM can be used. */
>>  	add_identity_map(0, PMD_SIZE);
>> @@ -568,9 +578,9 @@ static unsigned long slots_fetch_random(void)
>>  	return 0;
>>  }
>>  
>> -static void process_mem_region(struct mem_vector *entry,
>> -			       unsigned long minimum,
>> -			       unsigned long image_size)
>> +static void slots_count(struct mem_vector *entry,
>
>That's a strange rename.
>
I will change it.

Thanks,
Chao Fan

>__process_mem_region() makes more sense to me.
>
>> +			unsigned long minimum,
>> +			unsigned long image_size)
>>  {
>>  	struct mem_vector region, overlap;
>>  	unsigned long start_orig, end;
>> @@ -646,6 +656,57 @@ static void process_mem_region(struct mem_vector *entry,
>>  	}
>>  }
>>  
>> +static bool process_mem_region(struct mem_vector *region,
>> +			       unsigned long long minimum,
>> +			       unsigned long long image_size)
>> +{
>> +	int i;
>> +	/*
>> +	 * If no immovable memory found, or MEMORY_HOTREMOVE disabled,
>> +	 * walk all the regions, so use region directely.
>
>"directly"
>
>> +	 */
>> +	if (num_immovable_mem == 0) {
>
>	if (!...
>
>> +		slots_count(region, minimum, image_size);
>> +
>> +		if (slot_area_index == MAX_SLOT_AREA) {
>> +			debug_putstr("Aborted e820/efi memmap scan (slot_areas full)!\n");
>> +			return 1;
>> +		}
>> +		return 0;
>> +	}
>> +
>
>-- 
>Regards/Gruss,
>    Boris.
>
>Good mailing practices for 400: avoid top-posting and trim the reply.
>
>
