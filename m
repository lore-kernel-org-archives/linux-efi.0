From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] arm64/efi: efistub: don't abort if base of DRAM is occupied
Date: Tue, 29 Jul 2014 21:33:40 +0200
Message-ID: <CAKv+Gu_4HE8C80K=u4o3A90SvQAfVSTwdVXkXoAvDFkyuqNk+A@mail.gmail.com>
References: <1406630950-32432-1-git-send-email-ard.biesheuvel@linaro.org>
	<1406630950-32432-4-git-send-email-ard.biesheuvel@linaro.org>
	<1406647756.753.11.camel@deneb.redhat.com>
	<CAKv+Gu8Pwi6GuGq9jbGfHyALcJKtAG+KVDcVwpYVCG9ZKrhaPA@mail.gmail.com>
	<1406658428.753.22.camel@deneb.redhat.com>
	<CAKv+Gu-3J+1u1vcCAOgfq6JRfSc7_pykaV2OwGRNSOORTS1=1A@mail.gmail.com>
	<1406661621.753.34.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406661621.753.34.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 29 July 2014 21:20, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 2014-07-29 at 20:46 +0200, Ard Biesheuvel wrote:
>> On 29 July 2014 20:27, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Tue, 2014-07-29 at 20:17 +0200, Ard Biesheuvel wrote:
>> >> On 29 July 2014 17:29, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >> > On Tue, 2014-07-29 at 12:49 +0200, Ard Biesheuvel wrote:
>> >> >> If we cannot relocate the kernel Image to its preferred offset of base of DRAM
>> >> >> plus TEXT_OFFSET, instead relocate it to the lowest available 2 MB boundary plus
>> >> >> TEXT_OFFSET. We may lose a bit of memory at the low end, but we can still
>> >> >> proceed normally otherwise.
>> >> >>
>> >> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> >> >> ---
>> >> >>  arch/arm64/kernel/efi-stub.c | 16 ++++++----------
>> >> >>  1 file changed, 6 insertions(+), 10 deletions(-)
>> >> >
>> >> > Tested on Mustang (with loss of 2MB free memory).
>> >> >
>> >>
>> >> Great, thanks!
>> >>
>> >> >>
>> >> >> diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
>> >> >> index 60e98a639ac5..460c00c41e57 100644
>> >> >> --- a/arch/arm64/kernel/efi-stub.c
>> >> >> +++ b/arch/arm64/kernel/efi-stub.c
>> >> >> @@ -60,20 +60,16 @@ static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
>> >> >>       kernel_size = _edata - _text;
>> >> >>       if (*image_addr != (dram_base + TEXT_OFFSET)) {
>> >> >>               kernel_memsize = kernel_size + (_end - _edata);
>> >> >> -             status = efi_relocate_kernel(sys_table, image_addr,
>> >> >> -                                          kernel_size, kernel_memsize,
>> >> >> -                                          dram_base + TEXT_OFFSET,
>> >> >> -                                          PAGE_SIZE);
>> >> >
>> >> > Can we make efi_relocate_kernel static inline to get rid
>> >> > of the "defined but unused" warning?
>> >> >
>> >>
>> >> I have some patches pending in the EFI tree to turn the stub into a
>> >> static library, and that already takes care of this issue.
>> >
>> > That's fine if the static library stub patch goes in first. If this
>> > patch goes in first, then let's avoid the warning since it is easy
>> > to do.
>> >
>>
>> My idea was to ask Matt to take patches #2 and #3. I may have to fix
>> them up slightly to apply correctly, but that's fine. Changing
>> efi_relocate_kernel to static inline would need to go through Matt's
>> tree as well, so there's probably no point in doing that in any case.
>
> I'm not following. I would say there is no point in not doing that.
> You have a patch which causes a build warning. Let's avoid that
> unless there's a good reason not too. In this case, it seems easy
> enough to avoid unless I'm missing something.
>

Agreed.

The static library patches are already queued up in x86/tip, so if we
add a patch that changes efi_relocate_kernel() in
drivers/firmware/efi, it either goes through efi and comes after the
static lib patches, which makes it redundant, or it goes through arm64
and causes a conflict.

>>
>> Patch #1 needs to go through the arm64, I guess. This means UEFI boot
>> on APM Mustang will be broken during the short time between the
>> x86/tip tree and the arm64 tree being merged for 3.17 (assuming 3.17
>> is still open). I think we should be able to tolerate that, right?
>
> Breaking bisect would be really bad. I think all three should be
> pulled from the same tree. What's wrong with getting an ack from
> Catalin or Will on the first patch and having all three go through
> tip? Patch one is needed for EFI boot functionality even if it isn't
> specifically EFI code. This won't be the last time this sort of
> situation arises.
>

Ah, right, I forgot about bisect. So yes, patch #1 should definitely
go in before #2 and #3, which is indeed easiest if they get merged
through the same tree.
So yes, taking all of these through the EFI tree is indeed the way to go ...

-- 
Ard.


>>
>> >>
>> >> > Otherwise:
>> >> >
>> >> > Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> >
>> >>
>> >> Cheers,
>> >> Ard.
>> >>
>> >>
>> >>
>> >> >> +             status = efi_low_alloc(sys_table, kernel_memsize + TEXT_OFFSET,
>> >> >> +                                    SZ_2M, reserve_addr);
>> >> >>               if (status != EFI_SUCCESS) {
>> >> >>                       pr_efi_err(sys_table, "Failed to relocate kernel\n");
>> >> >>                       return status;
>> >> >>               }
>> >> >> -             if (*image_addr != (dram_base + TEXT_OFFSET)) {
>> >> >> -                     pr_efi_err(sys_table, "Failed to alloc kernel memory\n");
>> >> >> -                     efi_free(sys_table, kernel_memsize, *image_addr);
>> >> >> -                     return EFI_ERROR;
>> >> >> -             }
>> >> >> -             *image_size = kernel_memsize;
>> >> >> +             memcpy((void *)*reserve_addr + TEXT_OFFSET, (void *)*image_addr,
>> >> >> +                    kernel_size);
>> >> >> +             *image_addr = *reserve_addr + TEXT_OFFSET;
>> >> >> +             *reserve_size = kernel_memsize + TEXT_OFFSET;
>> >> >>       }
>> >> >>
>> >> >>
>> >> >
>> >> >
>> >
>> >
>
>
