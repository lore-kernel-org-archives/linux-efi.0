From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] efi/x86: make efi_memmap_reserve only insert into
 boot mem areas
Date: Fri, 27 Jan 2017 22:15:26 +0000
Message-ID: <CAKv+Gu_koToJSq1i2TG2bBrMzwHaLpva3GKAbD9jzNN99VfvYw@mail.gmail.com>
References: <20170112094118.815108042@redhat.com> <20170112094214.860924858@redhat.com>
 <87r348r0k9.fsf@gmail.com> <20170112212952.GB2709@dhcp-128-65.nay.redhat.com>
 <20170127144813.GE31613@codeblueprint.co.uk> <CAKv+Gu8oos1Ksp4fMXXn5ug4Gc-GS9KkbQNZb3A7__6wg5X5AQ@mail.gmail.com>
 <20170127221311.GH31613@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170127221311.GH31613-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 27 January 2017 at 22:13, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Fri, 27 Jan, at 05:04:50PM, Ard Biesheuvel wrote:
>> On 27 January 2017 at 14:48, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> > On Fri, 13 Jan, at 05:29:52AM, Dave Young wrote:
>> >>
>> >> It sounds reasonable though I'm still not sure about EFI_LOADER*.
>> >>
>> >> The main purpose of this patch is to address the invalid mem ranges
>> >> case. As Ard mentioned I will test with Peter's patch first, if it works
>> >> fine I would like to either drop this patch as a future improvement or add
>> >> it at the end of the next post.
>> >>
>> >> Matt, what's your opinion about the boot_only check and the EFI_LOADERS*
>> >> question?
>> >
>> > The main reason that efi_mem_reserve() isn't used for EFI_LOADER
>> > regions today is because we already have a mechanism for reserving it
>> > via memblock_reserve(), which we do during a very early stage of boot
>> > when parsing all the different types of SETUP_* objects.
>> >
>> > It's questionable whether it would make sense to switch to
>> > efi_mem_reserve() for EFI_LOADER regions because then you'd
>> > potentially have different APIs for different SETUP_* objects.
>> >
>> > As things stand today, I would suggest triggering a WARN_ON() if
>> > someone tries to efi_mem_reserve() an EFI_LOADER region, until/unless
>> > the day comes when a user exists in the kernel.
>>
>> Hmm, I just queued this. Should we drop it again?
>
> Does dropping it break the entire series?
>
> Having had some time to re-read Dave's commit log, it sounds like it
> just papers over a bug, which is that efi_memmap_insert() cannot deal
> with reserved entries, which all look like they describe the same
> region.
>

No, it cannot deal with bogus entries, and Peter already fixed that.
Dave confirmed that Peter's patch (the one we moved from next to
urgen) made the problem go away.

> So I guess my question is: Shouldn't you fix that instead of requiring
> the caller of efi_memmap_insert() to understand what type of entries
> it's mapping?

Indeed. So I don't think the patch is actually needed anymore
