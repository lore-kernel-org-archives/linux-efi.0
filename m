From: Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2] ia64/mm: fix a bad_page bug when crash kernel booting
Date: Thu, 7 Feb 2013 10:32:40 +0800
Message-ID: <51131248.3080203@huawei.com>
References: <51074786.5030007@huawei.com> <1359995565.7515.178.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359995565.7515.178.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Liujiang <jiang.liu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hanjun Guo <guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, WuJianguo <wujianguo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2013/2/5 0:32, Matt Fleming wrote:

> On Tue, 2013-01-29 at 11:52 +0800, Xishi Qiu wrote:
>> On ia64 platform, I set "crashkernel=1024M-:600M", and dmesg shows 128M-728M
>> memory is reserved for crash kernel. Then "echo c > /proc/sysrq-trigger" to
>> test kdump.
>>
>> When crash kernel booting, efi_init() will aligns the memory address in
>> IA64_GRANULE_SIZE(16M), so 720M-728M memory will be dropped, It means
>> crash kernel only manage 128M-720M memory.
>>
>> But initrd start and end are fixed in boot loader, it is before efi_init(),
>> so initrd size maybe overflow when free_initrd_mem().
> 
> [...]
> 
>> diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
>> index b755ea9..cfdb1eb 100644
>> --- a/arch/ia64/mm/init.c
>> +++ b/arch/ia64/mm/init.c
>> @@ -207,6 +207,17 @@ free_initrd_mem (unsigned long start, unsigned long end)
>>  	start = PAGE_ALIGN(start);
>>  	end = end & PAGE_MASK;
>>
>> +	/*
>> +	 * Initrd size is fixed in boot loader, but kernel parameter max_addr
>> +	 * which aligns in granules is fixed after boot loader, so initrd size
>> +	 * maybe overflow.
>> +	 */
>> +	if (max_addr != ~0UL) {
>> +		end = GRANULEROUNDDOWN(end);
>> +		if (start > end)
>> +			start = end;
>> +	}
>> +
>>  	if (start < end)
>>  		printk(KERN_INFO "Freeing initrd memory: %ldkB freed\n", (end - start) >> 10);
> 
> I don't think this is the correct fix.
> 
> Now, my ia64-fu is weak, but could it be that there's actually a bug in
> efi_init() and that the following patch would be the best way to fix
> this?
> 
> ---
> 
> diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
> index f034563..8d579f1 100644
> --- a/arch/ia64/kernel/efi.c
> +++ b/arch/ia64/kernel/efi.c
> @@ -482,7 +482,7 @@ efi_init (void)
>  		if (memcmp(cp, "mem=", 4) == 0) {
>  			mem_limit = memparse(cp + 4, &cp);
>  		} else if (memcmp(cp, "max_addr=", 9) == 0) {
> -			max_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
> +			max_addr = GRANULEROUNDUP(memparse(cp + 9, &cp));
>  		} else if (memcmp(cp, "min_addr=", 9) == 0) {
>  			min_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
>  		} else {
> 
> 

Sorry, this bug will be happen when use Sparse-Memory(section is valid, but last
several pages are invalid). If use Flat-Memory, crash kernel will boot successfully.
I think the following patch would be better.

Hi Andrew, will you just ignore the earlier patch and consider the following one? :>

Signed-off-by: Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 arch/ia64/mm/init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 082e383..23f2ee3 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -213,6 +213,8 @@ free_initrd_mem (unsigned long start, unsigned long end)
 	for (; start < end; start += PAGE_SIZE) {
 		if (!virt_addr_valid(start))
 			continue;
+		if ((start >> PAGE_SHIFT) >= max_low_pfn)
+			continue;
 		page = virt_to_page(start);
 		ClearPageReserved(page);
 		init_page_count(page);
-- 
1.7.6.1
