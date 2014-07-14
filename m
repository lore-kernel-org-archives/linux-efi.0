From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] arm64/efi: efistub: get text offset and image size
 from the Image header
Date: Mon, 14 Jul 2014 19:35:32 +0200
Message-ID: <CAKv+Gu_Pf8O92eAO5ENQJPJ6yWMP2U0M90Uc_CYW8MSU7cFWHw@mail.gmail.com>
References: <1405354671-14031-1-git-send-email-ard.biesheuvel@linaro.org>
	<1405354671-14031-3-git-send-email-ard.biesheuvel@linaro.org>
	<20140714165446.GN26465@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140714165446.GN26465@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 14 July 2014 18:54, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> Hi Ard,
>
> On Mon, Jul 14, 2014 at 05:17:51PM +0100, Ard Biesheuvel wrote:
>> The EFI stub for arm64 needs to behave like an ordinary bootloader in the sense
>> that it needs to use the EFI environment and the Image header at runtime and
>> not rely on the linker or preprocessor to produce values for text offset,
>> image size and kernel size.
>
> Could you elaborate on _why_ we can't do that, given it's linked into
> the kernel Image?
>
> Are we splitting the stub from the kernel? What's going on?
>

Perhaps Leif can chime in here? I was under the impression that you
were aligned in this regard.

>> This patch also fixes the corner case where Image happens to be loaded
>> at exactly the right offset, but the allocation is actually too small
>> to satisfy the requirement imposed by image_size as set in the header.
>
> It's not really imposed by image_size. While it's described by
> image_size it's imposed by the existence of the BSS section and the
> initial page tables.
>

Yes, that is true. But from stub POV, it doesn't matter /why/
image_size has a particular value.

>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/kernel/Makefile   |  2 --
>>  arch/arm64/kernel/efi-stub.c | 29 ++++++++++++++++-------------
>>  2 files changed, 16 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>> index cdaedad3afe5..99b676eeeb0f 100644
>> --- a/arch/arm64/kernel/Makefile
>> +++ b/arch/arm64/kernel/Makefile
>> @@ -4,8 +4,6 @@
>>
>>  CPPFLAGS_vmlinux.lds := -DTEXT_OFFSET=$(TEXT_OFFSET)
>>  AFLAGS_head.o                := -DTEXT_OFFSET=$(TEXT_OFFSET)
>> -CFLAGS_efi-stub.o    := -DTEXT_OFFSET=$(TEXT_OFFSET) \
>> -                        -I$(src)/../../../scripts/dtc/libfdt
>>
>>  CFLAGS_REMOVE_ftrace.o = -pg
>>  CFLAGS_REMOVE_insn.o = -pg
>> diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
>> index 9b61d66e2d20..4ba90b2ef677 100644
>> --- a/arch/arm64/kernel/efi-stub.c
>> +++ b/arch/arm64/kernel/efi-stub.c
>> @@ -11,8 +11,7 @@
>>   */
>>  #include <linux/efi.h>
>>  #include <asm/efi.h>
>> -#include <asm/sections.h>
>> -
>> +#include <asm/image_hdr.h>
>>
>>  efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
>>                                unsigned long *image_addr,
>> @@ -23,24 +22,28 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
>>                                efi_loaded_image_t *image)
>>  {
>>       efi_status_t status;
>> -     unsigned long kernel_size, kernel_memsize = 0;
>> +     struct arm64_image_hdr *hdr = (struct arm64_image_hdr *)*image_addr;
>> +
>> +     /* make sure image_addr points to an arm64 kernel Image */
>> +     if (!arm64_image_hdr_check(hdr)) {
>> +             pr_efi_err(sys_table, "Kernel Image header check failed\n");
>> +             return EFI_LOAD_ERROR;
>> +     }
>
> Surely this should always be the case if the stub is linked into the
> kernel?
>
> It would be nice to know the rationale for this.
>

Well, there is an actual issue addressed by this: the PE/COFF .text
section covers everything from stext to _edata, so it does not cover
the header itself. In fact, PE/COFF does not allow the headers
themselves to be covered by a section (or at least, the Tianocore/EDK2
UEFI implementation does not). So the pointer points *outside* of the
.text section, and we are assuming that whatever is at that [negative]
offset in the file was also copied to the same offset in memory.(For
instance, there is no reason to assume that all implementations of EFI
will copy data that is not part of any section to RAM when booting an
image located in NOR flash)

>>
>>       /* Relocate the image, if required. */
>> -     kernel_size = _edata - _text;
>> -     if (*image_addr != (dram_base + TEXT_OFFSET)) {
>> -             kernel_memsize = kernel_size + (_end - _edata) + TEXT_OFFSET;
>> -             status = efi_low_alloc(sys_table, kernel_memsize, SZ_2M,
>> +     if (*image_addr != (dram_base + hdr->text_offset) ||
>> +         image->image_size < hdr->image_size) {
>
> As far as I can tell the size of the Image (image->image_size) is always
> going to be less than the effective run time image size
> (hdr->image_size).
>

Currently, yes.

> The SizeOfImage field in head.S which I assume image->image_size is
> derived from (not having a UEFI spec in front of me) seems to cover
> everything up to _edata but skips the BSS, and initial page tables, but
> this is covered by the header's image_size field.
>
> Am I missing something? Surely we _always_ expect image->image_size to
> be smaller than hdr->image_size?
>

At some point, we may extend the virtual size of .text all the way to _end.
(Without growing the actual payload, the remainder will be zero
initialized by the loader)


-- 
Ard.


> Cheers,
> Mark.
>
>> +             *reserve_size = hdr->text_offset + hdr->image_size;
>> +             status = efi_low_alloc(sys_table, *reserve_size, SZ_2M,
>>                                      reserve_addr);
>>               if (status != EFI_SUCCESS) {
>>                       pr_efi_err(sys_table, "Failed to relocate kernel\n");
>> +                     *reserve_size = 0;
>>                       return status;
>>               }
>> -             memcpy((void *)*reserve_addr + TEXT_OFFSET, (void *)*image_addr,
>> -                    kernel_size);
>> -             *image_addr = *reserve_addr + TEXT_OFFSET;
>> -             *reserve_size = kernel_memsize;
>> +             memcpy((void *)*reserve_addr + hdr->text_offset,
>> +                    (void *)*image_addr, image->image_size);
>> +             *image_addr = *reserve_addr + hdr->text_offset;
>>       }
>> -
>> -
>>       return EFI_SUCCESS;
>>  }
>> --
>> 1.8.3.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
