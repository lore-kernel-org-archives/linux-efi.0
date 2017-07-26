From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC Part1 PATCH v3 13/17] x86/io: Unroll string I/O when SEV is
 active
Date: Wed, 26 Jul 2017 15:07:14 -0500
Message-ID: <589d65a4-eb09-bae9-e8b4-a2d78ca6b509@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-14-brijesh.singh@amd.com>
 <063D6719AE5E284EB5DD2968C1650D6DD003FB85@AcuExch.aculab.com>
 <CAK8P3a3h7JpmkW7W=HwqAuWWmro=ngj6HSeiiML_=T82x-FtZQ@mail.gmail.com>
 <ed6d4ce7-97a6-f664-d7d7-4ff48bc6f06a@amd.com>
 <201707261927.v6QJR228008075@mail.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201707261927.v6QJR228008075@mail.zytor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, David Laight <David.Laight@aculab.com>
Cc: brijesh.singh@amd.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Fenghua Yu <fenghua.yu@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>, Jonathan Corbet <corbet@lwn.net>, =?UTF-8?Q?Radim_Krcm=c3=a1r?= <rkrcmar@redhat.com>, Piotr Luc <piotr.luc@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Airlie <airlied@redhat.com>, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org



On 07/26/2017 02:26 PM, H. Peter Anvin wrote:
>>>>>                                                                     
>>    \
>>>>>    static inline void outs##bwl(int port, const void *addr, unsigned
>> long count) \
>>>>>    {
>>>
>>> This will clash with a fix I did to add a "memory" clobber
>>> for the traditional implementation, see
>>> https://patchwork.kernel.org/patch/9854573/
>>>
>>>> Is it even worth leaving these as inline functions?
>>>> Given the speed of IO cycles it is unlikely that the cost of calling
>> a real
>>>> function will be significant.
>>>> The code bloat reduction will be significant.
>>>
>>> I think the smallest code would be the original "rep insb" etc, which
>>> should be smaller than a function call, unlike the loop. Then again,
>>> there is a rather small number of affected device drivers, almost all
>>> of them for ancient hardware that you won't even build in a 64-bit
>>> x86 kernel, see the list below. The only user I found that is
>> actually
>>> still relevant is drivers/tty/hvc/hvc_xen.c, which uses it for the
>> early
>>> console.
>>
>>
>> There are some indirect user of string I/O functions. The following
>> functions
>> defined in lib/iomap.c calls rep version of ins and outs.
>>
>> - ioread8_rep, ioread16_rep, ioread32_rep
>> - iowrite8_rep, iowrite16_rep, iowrite32_rep
>>
>> I found that several drivers use above functions.
>>
>> Here is one approach to convert it into non-inline functions. In this
>> approach,
>> I have added a new file arch/x86/kernel/io.c which provides non rep
>> version of
>> string I/O routines. The file gets built and used only when
>> AMD_MEM_ENCRYPT is
>> enabled. On positive side, if we don't build kernel with
>> AMD_MEM_ENCRYPT support
>> then we use inline routines, when AMD_MEM_ENCRYPT is built then we make
>> a function
>> call. Inside the function we unroll only when SEV is active.
>>
>> Do you see any issue with this approach ? thanks
>>
>> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
>> index e080a39..104927d 100644
>> --- a/arch/x86/include/asm/io.h
>> +++ b/arch/x86/include/asm/io.h
>> @@ -323,8 +323,9 @@ static inline unsigned type in##bwl##_p(int port)
>>                 \
>>       unsigned type value = in##bwl(port);                            \
>>       slow_down_io();                                                 \
>>       return value;                                                   \
>> -}
>> \
>> -
>> \
>> +}
>> +
>> +#define BUILDIO_REP(bwl, bw, type)
>> \
>> static inline void outs##bwl(int port, const void *addr, unsigned long
>> count) \
>> {
>> \
>>       asm volatile("rep; outs" #bwl                                   \
>> @@ -335,12 +336,31 @@ static inline void ins##bwl(int port, void *addr,
>> unsigned long count)    \
>> {
>> \
>>       asm volatile("rep; ins" #bwl                                    \
>>                    : "+D"(addr), "+c"(count) : "d"(port));            \
>> -}
>> +}
>> \
>>   
>>   BUILDIO(b, b, char)
>>   BUILDIO(w, w, short)
>>   BUILDIO(l, , int)
>>   
>> +#ifdef CONFIG_AMD_MEM_ENCRYPT
>> +extern void outsb_try_rep(int port, const void *addr, unsigned long
>> count);
>> +extern void insb_try_rep(int port, void *addr, unsigned long count);
>> +extern void outsw_try_rep(int port, const void *addr, unsigned long
>> count);
>> +extern void insw_try_rep(int port, void *addr, unsigned long count);
>> +extern void outsl_try_rep(int port, const void *addr, unsigned long
>> count);
>> +extern void insl_try_rep(int port, void *addr, unsigned long count);
>> +#define outsb  outsb_try_rep
>> +#define insb   insb_try_rep
>> +#define outsw  outsw_try_rep
>> +#define insw   insw_try_rep
>> +#define outsl  outsl_try_rep
>> +#define insl   insl_try_rep
>> +#else
>> +BUILDIO_REP(b, b, char)
>> +BUILDIO_REP(w, w, short)
>> +BUILDIO_REP(l, , int)
>> +#endif
>> +
>>   extern void *xlate_dev_mem_ptr(phys_addr_t phys);
>>   extern void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr);
>>
>> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
>> index a01892b..3b6e2a3 100644
>> --- a/arch/x86/kernel/Makefile
>> +++ b/arch/x86/kernel/Makefile
>> @@ -42,6 +42,7 @@ CFLAGS_irq.o := -I$(src)/../include/asm/trace
>>   
>>   obj-y                  := process_$(BITS).o signal.o
>>   obj-$(CONFIG_COMPAT)   += signal_compat.o
>> +obj-$(CONFIG_AMD_MEM_ENCRYPT) += io.o
>> obj-y                  += traps.o irq.o irq_$(BITS).o
>> dumpstack_$(BITS).o
>>   obj-y                  += time.o ioport.o dumpstack.o nmi.o
>>   obj-$(CONFIG_MODIFY_LDT_SYSCALL)       += ldt.o
>> diff --git a/arch/x86/kernel/io.c b/arch/x86/kernel/io.c
>> new file mode 100644
>> index 0000000..f58afa9
>> --- /dev/null
>> +++ b/arch/x86/kernel/io.c
>> @@ -0,0 +1,87 @@
>> +#include <linux/types.h>
>> +#include <linux/io.h>
>> +#include <asm/io.h>
>> +
>> +void outsb_try_rep(int port, const void *addr, unsigned long count)
>> +{
>> +       if (sev_active()) {
>> +               unsigned char *value = (unsigned char *)addr;
>> +               while (count) {
>> +                       outb(*value, port);
>> +                       value++;
>> +                       count--;
>> +               }
>> +       } else {
>> +               asm volatile("rep; outsb" : "+S"(addr), "+c"(count) :
>> "d"(port));
>> +       }
>> +}
>> +
>> +void insb_try_rep(int port, void *addr, unsigned long count)
>> +{
>> +       if (sev_active()) {
>> +               unsigned char *value = (unsigned char *)addr;
>> +               while (count) {
>> +                       *value = inb(port);
>> +                       value++;
>> +                       count--;
>> +               }
>> +       } else {
>> +               asm volatile("rep; insb" : "+D"(addr), "+c"(count) :
>> "d"(port));
>> +       }
>> +}
>> +
>> +void outsw_try_rep(int port, const void *addr, unsigned long count)
>> +{
>> +       if (sev_active()) {
>> +               unsigned short *value = (unsigned short *)addr;
>> +               while (count) {
>> +                       outw(*value, port);
>> +                       value++;
>> +                       count--;
>> +               }
>> +       } else {
>> +               asm volatile("rep; outsw" : "+S"(addr), "+c"(count) :
>> "d"(port));
>> +       }
>> +}
>> +void insw_try_rep(int port, void *addr, unsigned long count)
>> +{
>> +       if (sev_active()) {
>> +               unsigned short *value = (unsigned short *)addr;
>> +               while (count) {
>> +                       *value = inw(port);
>> +                       value++;
>> +                       count--;
>> +               }
>> +       } else {
>> +               asm volatile("rep; insw" : "+D"(addr), "+c"(count) :
>> "d"(port));
>> +       }
>> +}
>> +
>> +void outsl_try_rep(int port, const void *addr, unsigned long count)
>> +{
>> +       if (sev_active()) {
>> +               unsigned int *value = (unsigned int *)addr;
>> +               while (count) {
>> +                       outl(*value, port);
>> +                       value++;
>> +                       count--;
>> +               }
>> +       } else {
>> +               asm volatile("rep; outsl" : "+S"(addr), "+c"(count) :
>> "d"(port));
>> +       }
>> +}
>> +
>> +void insl_try_rep(int port, void *addr, unsigned long count)
>> +{
>> +       if (sev_active()) {
>> +               unsigned int *value = (unsigned int *)addr;
>> +               while (count) {
>> +                       *value = inl(port);
>> +                       value++;
>> +                       count--;
>> +               }
>> +       } else {
>> +               asm volatile("rep; insl" : "+D"(addr), "+c"(count) :
>> "d"(port));
>> +       }
>> +}
> 
> What the heck?
> 

I am not sure if I understand your concern.

Are you commenting on amount of code duplication ? If so, I can certainly improve
and use the similar macro used into header file to generate the functions body.

Are you commenting that we should not attempt to make those functions non-inline
and you prefer them to stay inline ?

thanks
