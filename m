From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/8] efi/arm*: libstub: wire up GOP handling into the ARM
 UEFI stub
Date: Thu, 10 Mar 2016 17:25:08 +0700
Message-ID: <CAKv+Gu9ephpDq_KE_xxV+dXSit+VgBxqgXyAeKt4eXpb5KRJnw@mail.gmail.com>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
	<1457588408-19309-7-git-send-email-ard.biesheuvel@linaro.org>
	<20160310082522.GB8618@gmail.com>
	<CAKv+Gu8hTSbZVgGj6epquwf6kkSJV+imAFvNobowFVtB5AUe2Q@mail.gmail.com>
	<20160310090345.GA19834@gmail.com>
	<CAKv+Gu_rtQjWJ-=Nf-dEYEHVB5dwKMA_Mv2rVujBz9t=3qnUrA@mail.gmail.com>
	<20160310092552.GA19588@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160310092552.GA19588-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10 March 2016 at 16:25, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> On 10 March 2016 at 16:03, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> >
>> > * Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> >
>> >> > So screen_info_guid should probably not be a 'const': you have to cast it away
>> >> > anyway, adding artificial linebreaks and uglifying the code. It's also a bad
>> >> > practice to cast away const-ness, it hinders move-consts-to-readonly-sections
>> >> > efforts.
>> >>
>> >> The problem here is that the UEFI spec never uses const qualifiers in
>> >> its APIs for by-ref parameters that are obviously never modified by
>> >> the caller, such as these GUIDs. [...]
>> >
>> > Ah, ok. Two related thoughts came up:
>> >
>> > 1)
>> >
>> > While I was looking at this code and was asking myself why the EFI runtime is
>> > generally invoked via a relatively fragile, non-type-checking vararg construct.
>> >
>> > Wouldn't you be better off by explicitly defining all the API variants, and then
>> > internally calling the EFI runtime?
>> >
>> > That would neatly solve such const artifacts as well.
>> >
>> > So instead of:
>> >
>> >
>> > +       status = efi_call_early(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
>> > +                               sizeof(*si), (void **)&si);
>> >
>> > we could have something like:
>> >
>> >         status = efi_early__allocate_pool(EFI_RUNTIME_SERVICES_DATA, sizeof(*si), &si);
>> >
>> >         ...
>> >
>> >         efi_early__free_pool(si);
>> >
>> >
>> > i.e. it would look a lot more like a properly distributed, typed, structured
>> > family of C function APIs, instead of this single central bastard of an ioctl()
>> > interface.
>> >
>> > There's over 100 invocations of the EFI runtime in the Linux kernel, I think it
>> > would be worth the effort. The wrapper inlines should be mostly trivial.
>> >
>> > That would also add an opportunity to actually document most of these calls.
>> >
>>
>> If only. The ARM and arm64 wrappers actually simply resolve to
>> correctly typed calls. While I am not an expert on the x86 side of
>> things, I think the vararg stuff is needed to be able to perform the
>> thunking required to do function calls using the MS ABI for x86_64.
>
> So at least the efi_early calls seem to just be using a function pointer:
>
>   arch/x86/include/asm/efi.h:     __efi_early()->call(__efi_early()->f, __VA_ARGS__);
>

Indeed. I think the efi_early struct is a separate structure that is
set up by the early boot code, and has a number of function pointers
of EFI boot services copied into it. Matt should know the details.

> Furthermore, my suggestion would work with arbitrarily structured thunking: my
> suggestion was to put a typed C layer in there - and the layer itself could then
> call the vararg construct internally. It's a C type demuxing, only a syntactic
> effort, it does not change any real call signature.
>

I would welcome any improvement in this regard. Happy to contribute as well.

>> As far as documentation is concerned, all of these functions and
>> protocol methods are documented in the UEFI spec, which is freely
>> accessible. It may be somewhat redundant to have our own documentation
>> for them.
>
> I mean a properly split up typed C interface 'documents itself' to a large degree
> - while with opaque varargs bugs can slip in more easily.
>
> This is really an obvious argument ... it's the well known 'why ioctl()s are bad'
> API argument.
>
> It has no bearing on this series obviously, it's a cleanup suggestion that could
> be done separately.
>

I will take this up with Matt. There is lots of room for improvement
and consolidation between x86 on the one hand and ARM/arm64 on the
other hand in other ways as well.

Thanks,
Ard.
