From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/3] efi/libstub: add random.c to ARM build
Date: Tue, 15 Nov 2016 15:19:58 +0000
Message-ID: <CAKv+Gu-=sdp6Mz75NpeAxmBnnHVtgT3waDTm7R=MdmKyqMr94g@mail.gmail.com>
References: <1476962486-18368-1-git-send-email-ard.biesheuvel@linaro.org>
 <1476962486-18368-3-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu_=et=2zHBTYOr9thz2kS0cXHHYg96oWGRdD3D10fqXtw@mail.gmail.com> <2189664.D28O3TYR8x@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2189664.D28O3TYR8x@wuerfel>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 15 November 2016 at 15:11, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> On Wednesday, November 2, 2016 9:37:13 AM CET Ard Biesheuvel wrote:
>> @@ -98,7 +100,7 @@
>>                 efi_memory_desc_t *md = (void *)memory_map + map_offset;
>>                 unsigned long slots;
>>
>> -               slots = get_entry_num_slots(md, size, align);
>> +               slots = get_entry_num_slots(md, size, ilog2(align));
>>                 MD_NUM_SLOTS(md) = slots;
>>                 total_slots += slots;
>>         }
>> """
>>
>> This is because ARM does not have a division routine in the
>> decompressor, and the fact that the division by 'align' should always
>> involve a power of 2 is not visible to the compiler.
>>
>> If nobody objects, I will fold this in when applying
>>
>>
>
> I'm getting a link error here when building with -Os:
>
> drivers/firmware/efi/libstub/random.stub.o: In function `efi_random_alloc':
> random.c:(.text.efi_random_alloc+0x264): undefined reference to `__aeabi_llsr'
>
> If I compile this with -O2, the ilog2 gets inlined and everything
> works.
>

This is caused by the fact that 'start' and 'end are u64 rather than
unsigned long, and the stub does not have the u64 logical shift right
routines.
But interestingly, it does cover another issue with this code, i.e.,
that you cannot do allocations over 4 GB in the ARM stub, even on LPAE
capable hardware.

I will send out a patch to fix this.

Thanks,
Ard.
