From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] efi/arm64: fix potential NULL dereference of efi.systab
Date: Thu, 3 Jul 2014 18:04:02 +0200
Message-ID: <CAKv+Gu_RAFFfsX75mdTZ06q7fUrOzD+auFj6uo1sx6Rj=x7Qbw@mail.gmail.com>
References: <1404295802-28030-1-git-send-email-ard.biesheuvel@linaro.org>
	<CAKv+Gu-SLQC82q7Rj5ZusbFxwysy7KpRhZ=vw1ipXu9kvq46aQ@mail.gmail.com>
	<1404311385.19665.15.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404311385.19665.15.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2 July 2014 16:29, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2014-07-02 at 12:13 +0200, Ard Biesheuvel wrote:
>> > On 2 July 2014 12:10, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> > We assign efi.systab using efi_lookup_mapped_addr(), and test for !NULL, but
>> > then go on an dereference it anyway.
>> >
>> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> > ---
>> >  arch/arm64/kernel/efi.c | 7 +++++--
>> >  1 file changed, 5 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> > index 56c3327bbf79..e785f93f17cb 100644
>> > --- a/arch/arm64/kernel/efi.c
>> > +++ b/arch/arm64/kernel/efi.c
>> > @@ -419,8 +419,11 @@ static int __init arm64_enter_virtual_mode(void)
>> >         }
>> >
>> >         efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
>> > -       if (efi.systab)
>> > -               set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>> > +       if (!efi.systab) {
>> > +               pr_err("Failed to remap EFI System Table!\n");
>>
>> ... this needs a kfree(virtmap) as well.
>>
>
> And probably should unmap all the remapped regions in virtmap first.

Yes.

> Presumably the systab will be in a runtime memory region which gets
> virtual mapping from remap_region(). If that succeeds, then the
> efi_lookup_mapped_addr should always succeed. But to be careful,
> we should probably bail out earlier if remap_region() ever returns
> zero. If all remaps work and efi_lookup_mapped_addr() fails, then
> we should try ioremap_cache() directly. Or do what x86 does and make
> a local copy of the table earlier when we early_memremap() it in
> uefi_init().
>

Bailing early (and cleaning up) if any remap_region() call fails seems
like a wise thing to do.
But if they all succeed, and efi_lookup_mapped_addr() then fails to
resolve efi_system_table, it means it lives in a region which will
become inaccessible to the runtime services themselves after
set_virtual_address_map() has been called. So doing any kind of
fallback masks a severe firmware bug, which makes me think we should
just complain loudly and not enable UEFI bits any further

-- 
Ard.
