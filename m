From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v1 15/18] x86: Enable memory encryption on the APs
Date: Tue, 3 May 2016 10:59:51 -0500
Message-ID: <5728CAF7.7000007@amd.com>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
	<20160426225833.13567.55695.stgit@tlendack-t1.amdoffice.net>
	<f37dd7de-23ad-f70f-c32d-a32f116215ce@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <f37dd7de-23ad-f70f-c32d-a32f116215ce-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Huang, Kai" <kai.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 05/01/2016 05:10 PM, Huang, Kai wrote:
> 
> 
> On 4/27/2016 10:58 AM, Tom Lendacky wrote:
>> Add support to set the memory encryption enable flag on the APs during
>> realmode initialization. When an AP is started it checks this flag, and
>> if set, enables memory encryption on its core.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> ---
>>  arch/x86/include/asm/msr-index.h     |    2 ++
>>  arch/x86/include/asm/realmode.h      |   12 ++++++++++++
>>  arch/x86/realmode/init.c             |    4 ++++
>>  arch/x86/realmode/rm/trampoline_64.S |   14 ++++++++++++++
>>  4 files changed, 32 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/msr-index.h
>> b/arch/x86/include/asm/msr-index.h
>> index 94555b4..b73182b 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -349,6 +349,8 @@
>>  #define MSR_K8_TOP_MEM1            0xc001001a
>>  #define MSR_K8_TOP_MEM2            0xc001001d
>>  #define MSR_K8_SYSCFG            0xc0010010
>> +#define MSR_K8_SYSCFG_MEM_ENCRYPT_BIT    23
>> +#define MSR_K8_SYSCFG_MEM_ENCRYPT    (1ULL <<
>> MSR_K8_SYSCFG_MEM_ENCRYPT_BIT)
>>  #define MSR_K8_INT_PENDING_MSG        0xc0010055
>>  /* C1E active bits in int pending message */
>>  #define K8_INTP_C1E_ACTIVE_MASK        0x18000000
>> diff --git a/arch/x86/include/asm/realmode.h
>> b/arch/x86/include/asm/realmode.h
>> index 9c6b890..e24d2ec 100644
>> --- a/arch/x86/include/asm/realmode.h
>> +++ b/arch/x86/include/asm/realmode.h
>> @@ -1,6 +1,15 @@
>>  #ifndef _ARCH_X86_REALMODE_H
>>  #define _ARCH_X86_REALMODE_H
>>
>> +/*
>> + * Flag bit definitions for use with the flags field of the
>> trampoline header
>> + * when configured for X86_64
>> + */
>> +#define TH_FLAGS_MEM_ENCRYPT_BIT    0
>> +#define TH_FLAGS_MEM_ENCRYPT        (1ULL << TH_FLAGS_MEM_ENCRYPT_BIT)
> 
> Would mind change it to a more vendor specific name, such as
> AMD_MEM_ENCRYPT, or SME_MEM_ENCRYPT?

Yup, that can be done.

> 
>> +
>> +#ifndef __ASSEMBLY__
>> +
>>  #include <linux/types.h>
>>  #include <asm/io.h>
>>
>> @@ -38,6 +47,7 @@ struct trampoline_header {
>>      u64 start;
>>      u64 efer;
>>      u32 cr4;
>> +    u32 flags;
>>  #endif
>>  };
>>
>> @@ -61,4 +71,6 @@ extern unsigned char secondary_startup_64[];
>>  void reserve_real_mode(void);
>>  void setup_real_mode(void);
>>
>> +#endif /* __ASSEMBLY__ */
>> +
>>  #endif /* _ARCH_X86_REALMODE_H */
>> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
>> index 85b145c..657532b 100644
>> --- a/arch/x86/realmode/init.c
>> +++ b/arch/x86/realmode/init.c
>> @@ -84,6 +84,10 @@ void __init setup_real_mode(void)
>>      trampoline_cr4_features = &trampoline_header->cr4;
>>      *trampoline_cr4_features = __read_cr4();
>>
>> +    trampoline_header->flags = 0;
>> +    if (sme_me_mask)
>> +        trampoline_header->flags |= TH_FLAGS_MEM_ENCRYPT;
>> +
>>      trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
>>      trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
>>      trampoline_pgd[511] = init_level4_pgt[511].pgd;
>> diff --git a/arch/x86/realmode/rm/trampoline_64.S
>> b/arch/x86/realmode/rm/trampoline_64.S
>> index dac7b20..8d84167 100644
>> --- a/arch/x86/realmode/rm/trampoline_64.S
>> +++ b/arch/x86/realmode/rm/trampoline_64.S
>> @@ -30,6 +30,7 @@
>>  #include <asm/msr.h>
>>  #include <asm/segment.h>
>>  #include <asm/processor-flags.h>
>> +#include <asm/realmode.h>
>>  #include "realmode.h"
>>
>>      .text
>> @@ -109,6 +110,18 @@ ENTRY(startup_32)
>>      movl    $(X86_CR0_PG | X86_CR0_WP | X86_CR0_PE), %eax
>>      movl    %eax, %cr0
>>
>> +    # Check for and enable memory encryption support
>> +    movl    pa_tr_flags, %eax
>> +    bt    $TH_FLAGS_MEM_ENCRYPT_BIT, pa_tr_flags
> 
> pa_tr_flags -> %eax ? Otherwise looks the previous line is useless.

Yes, I overlooked that. I'll take care of it.

Thanks,
Tom

> 
> Thanks,
> -Kai
> 
>> +    jnc    .Ldone
>> +    movl    $MSR_K8_SYSCFG, %ecx
>> +    rdmsr
>> +    bt    $MSR_K8_SYSCFG_MEM_ENCRYPT_BIT, %eax
>> +    jc    .Ldone
>> +    bts    $MSR_K8_SYSCFG_MEM_ENCRYPT_BIT, %eax
>> +    wrmsr
>> +.Ldone:
>> +
>>      /*
>>       * At this point we're in long mode but in 32bit compatibility mode
>>       * with EFER.LME = 1, CS.L = 0, CS.D = 1 (and in turn
>> @@ -147,6 +160,7 @@ GLOBAL(trampoline_header)
>>      tr_start:        .space    8
>>      GLOBAL(tr_efer)        .space    8
>>      GLOBAL(tr_cr4)        .space    4
>> +    GLOBAL(tr_flags)    .space    4
>>  END(trampoline_header)
>>
>>  #include "trampoline_common.S"
>>
>>
