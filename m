From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/5] arm64: clone early_init_dt_add_memory_arch() to
 override default
Date: Wed, 26 Aug 2015 17:00:28 +0200
Message-ID: <CAKv+Gu9roNfr8KPUJj_hhP6jw-Rz_CdcoT08vyxYDgW2AXpt4A@mail.gmail.com>
References: <1440576391-25725-1-git-send-email-ard.biesheuvel@linaro.org>
	<1440576391-25725-2-git-send-email-ard.biesheuvel@linaro.org>
	<20150826144325.GA10728@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150826144325.GA10728-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kulkarni, Ganapatrao" <Ganapatrao.Kulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Haojian Zhuang <haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leo Yan <leo.yan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 August 2015 at 16:43, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Aug 26, 2015 at 10:06:27AM +0200, Ard Biesheuvel wrote:
>> Override the __weak early_init_dt_add_memory_arch() with our own
>> version. We need this in a subsequent patch to make the handling of
>> the memory nodes conditional on whether we are booting via UEFI or
>> not.
>
> Worth clarifying that this is a direct copy?
> ("Our own version" can be read as there being modifications here.)
>

Yes. In fact, it wasn't before, so hence the choice of words here.

>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/mm/init.c | 41 ++++++++++++++++++++
>>  1 file changed, 41 insertions(+)
>>
>> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
>> index f5c0680d17d9..ab25fde7397c 100644
>> --- a/arch/arm64/mm/init.c
>> +++ b/arch/arm64/mm/init.c
>> @@ -374,3 +374,44 @@ static int __init keepinitrd_setup(char *__unused)
>>
>>  __setup("keepinitrd", keepinitrd_setup);
>>  #endif
>> +
>> +void __init early_init_dt_add_memory_arch(u64 base, u64 size)
>> +{
>> +     const u64 phys_offset = __pa(PAGE_OFFSET);
>> +
>> +     if (!PAGE_ALIGNED(base)) {
>> +             if (size < PAGE_SIZE - (base & ~PAGE_MASK)) {
>> +                     pr_warn("Ignoring memory block 0x%llx - 0x%llx\n",
>> +                             base, base + size);
>> +                     return;
>> +             }
>> +             size -= PAGE_SIZE - (base & ~PAGE_MASK);
>> +             base = PAGE_ALIGN(base);
>> +     }
>> +     size &= PAGE_MASK;
>> +
>> +     if (base > MAX_MEMBLOCK_ADDR) {
>> +             pr_warning("Ignoring memory block 0x%llx - 0x%llx\n",
>> +                             base, base + size);
>> +             return;
>> +     }
>> +
>> +     if (base + size - 1 > MAX_MEMBLOCK_ADDR) {
>> +             pr_warning("Ignoring memory range 0x%llx - 0x%llx\n",
>> +                             ((u64)MAX_MEMBLOCK_ADDR) + 1, base + size);
>> +             size = MAX_MEMBLOCK_ADDR - base + 1;
>> +     }
>> +
>> +     if (base + size < phys_offset) {
>> +             pr_warning("Ignoring memory block 0x%llx - 0x%llx\n",
>> +                        base, base + size);
>> +             return;
>> +     }
>> +     if (base < phys_offset) {
>> +             pr_warning("Ignoring memory range 0x%llx - 0x%llx\n",
>> +                        base, phys_offset);
>> +             size -= phys_offset - base;
>> +             base = phys_offset;
>> +     }
>> +     memblock_add(base, size);
>> +}
>> --
>> 1.9.1
>
> Would it be too crazy to do this via an added call to a weak
> memblock_use_dt() function in the original instead, to avoid
> duplicating this entire function?
>

This keeps coming up: I have a series in the freezer that decouples
the kernel mapping from the linear mapping, which makes another round
of changes to this function. So that is why I cloned the function in
the first place, only to reuse this patch for this series as well.

The following does the trick as well, but I am not sure if the alias
attribute is allowed in the kernel

"""
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index ad87ce826cce..af2f30cbf357 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -374,3 +374,8

 __setup("keepinitrd", keepinitrd_setup);
 #endif
+
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+       __early_init_dt_add_memory_arch(base, size);
+}
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 07496560e5b9..2da75619ed78 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1047,6 +1047,9
 }
 #endif

+void __early_init_dt_add_memory_arch(u64 base, u64 size)
+                       __attribute__((alias("early_init_dt_add_memory_arch")));
+
 bool __init early_init_dt_verify(void *params)
 {
        if (!params)
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index df9ef3801812..64fcb143f5f4 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -66,6 +66,7
 extern void early_init_fdt_scan_reserved_mem(void);
 extern void early_init_fdt_reserve_self(void);
 extern void early_init_dt_add_memory_arch(u64 base, u64 size);
+extern void __early_init_dt_add_memory_arch(u64 base, u64 size);
 extern int early_init_dt_reserve_memory_arch(phys_addr_t base,
phys_addr_t size,
                                             bool no_map);
 extern void * early_init_dt_alloc_memory_arch(u64 size, u64 align);
"""

> We need the functionality for 4/5 (nice cleanup) and 5/5 (bugfix), so
> happy with whatever works.
>

Indeed.
