From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v9 7/8] x86/boot/KASLR: Walk srat tables to filter
 immovable memory
Date: Thu, 18 Oct 2018 13:56:23 +0800
Message-ID: <20181018055622.GF12871@localhost.localdomain>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
 <20181017102012.872-8-fanc.fnst@cn.fujitsu.com>
 <20181018042320.GE1885@192.168.1.4>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181018042320.GE1885@192.168.1.4>
Sender: linux-kernel-owner@vger.kernel.org
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, msys.mizuma@gmail.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 18, 2018 at 12:23:20PM +0800, Baoquan He wrote:
>On 10/17/18 at 06:20pm, Chao Fan wrote:
>> If CONFIG_MEMORY_HOTREMOVE enabled, walk through the acpi srat memory
>> tables and store those immovable memory regions so that kaslr can get
>> where to choose for randomization.
>
>This patch only adds invocation of get_immovable_mem() inside
>mem_avoid_init(). It's not doing what you said in patch log. Can it be
>merged with other patch, e.g patch 6 or 8?

Yes, in old version, this patch will do more job.
Later I move more functions to acpitb.c, just this left.
So I can move it to 8/8.

Thanks,
Chao Fan

>
>> 
>> Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
>> ---
>>  arch/x86/boot/compressed/kaslr.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>> 
>> diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
>> index 9ed9709d9947..0c3567bc231c 100644
>> --- a/arch/x86/boot/compressed/kaslr.c
>> +++ b/arch/x86/boot/compressed/kaslr.c
>> @@ -417,6 +417,11 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
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
>> -- 
>> 2.17.2
>> 
>> 
>> 
>
>
