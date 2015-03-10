From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 7/7] x86, kaslr, 64bit: Set new or extra ident_mapping
Date: Mon, 9 Mar 2015 18:14:18 -0700
Message-ID: <CAE9FiQX=b38-mseWWeGg=eTFfbe1sH61PvXJYJYrsAF6Uxn8ow@mail.gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
	<1425766041-6551-8-git-send-email-yinghai@kernel.org>
	<CAGXu5j+REYpi=hnf3s+F1Dd9nkXkvQ5w7wO_j_emmAM226VrGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+REYpi=hnf3s+F1Dd9nkXkvQ5w7wO_j_emmAM226VrGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 9, 2015 at 6:09 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Sat, Mar 7, 2015 at 2:07 PM, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> First, aslr will support to put random VO above 4G, so we must set ident
>> mapping for the range even we come from startup_32 path.
>>
>> Second, when boot from 64bit bootloader, bootloader set ident mapping,
>> and boot via ZO (arch/x86/boot/compressed/vmlinux) startup_64.
>> Those pages for pagetable need to be avoided when we select new random
>> VO (vmlinux) base. Otherwise decompressor would overwrite them during
>> decompressing.
>>
>> One solution: go through pagetable and find out every page is used by
>> pagetable for every mem_aovid checking but we will need extra code.
>>
>> Other solution: create new ident mapping instead, and pages for pagetable
>> will sit in _pagetable section of ZO, and they are in mem_avoid array already.
>> In this way, we can reuse the code for setting ident mapping.
>>
>> The _pgtable will be shared 32bit and 64bit path to reduce init_size,
>> as now ZO _rodata to _end will contribute init_size.
>>
>> Need to increase pgt buffer size.
>> When boot via startup_64, as we need to cover old VO, params, cmdline
>> and new VO, in extreme case we could have them all cross 512G boundary,
>> will need (2+2)*4 pages with 2M mapping. And need 2 for first 2M for vga ram.
>> Plus one for level4. Total will be 19 pages.
>> When boot via startup_32, aslr would move new VO above 4G, we need set extra
>> ident mapping for new VO, pgt buffer come from _pgtable offset 6 pages.
>> should only need (2+2) pages at most when it cross 512G boundary.
>> So 19 pages could make both pathes happy.
>>
>>
>> -v3: add mapping for first 2M with video ram when X86_VERBOSE_BOOTUP is set.
>>      Don't need to set mapping for setup_data, as it is already late
>>      in boot/ZO stage, will not access it until VO stage, and VO stage
>>      will use early_memmap or kernel address to access them.
>>
>> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
>> Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
>> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/x86/boot/compressed/aslr.c     | 21 ++++++++
>>  arch/x86/boot/compressed/head_64.S  |  4 +-
>>  arch/x86/boot/compressed/misc_pgt.c | 98 +++++++++++++++++++++++++++++++++++++
>>  arch/x86/include/asm/boot.h         | 19 +++++++
>>  4 files changed, 140 insertions(+), 2 deletions(-)
>>  create mode 100644 arch/x86/boot/compressed/misc_pgt.c
>>
>> diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
>> index a279514..34eb652 100644
>> --- a/arch/x86/boot/compressed/aslr.c
>> +++ b/arch/x86/boot/compressed/aslr.c
>> @@ -1,3 +1,8 @@
>> +#ifdef CONFIG_X86_64
>> +#define __pa(x)  ((unsigned long)(x))
>> +#define __va(x)  ((void *)((unsigned long)(x)))
>> +#endif
>> +
>>  #include "misc.h"
>>
>>  #include <asm/msr.h>
>> @@ -21,6 +26,8 @@ struct kaslr_setup_data {
>>         __u8 data[1];
>>  } kaslr_setup_data;
>>
>> +#include "misc_pgt.c"
>
> Shouldn't this just be a normal built .o file that is linked together
> in the Makefile, specifically tracking CONFIG_RANDOMIZE_BASE as aslr.o
> already is?

Yes, we could go that way.

Thanks

Yinghai
