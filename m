From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Mon, 28 Sep 2015 10:51:44 +0100
Message-ID: <CAKv+Gu-e5CRrJ1S7phXyWCUZ10ptukn0zr0wDGyX14H_SpEp1Q@mail.gmail.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
	<1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
	<20150926055643.GA25877@gmail.com>
	<20150926134329.GA3144@codeblueprint.co.uk>
	<20150927070355.GB26125@gmail.com>
	<CAKv+Gu8M2pmzfeA=NT4c44E6-PQvRKHZjEJt78mryGcp6bBD8w@mail.gmail.com>
	<20150928082245.GA28796@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928082245.GA28796-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-wo1vFcy6AUs@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 28 September 2015 at 09:22, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> On 27 September 2015 at 08:03, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> >
>> > * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> >
>> [...]
>> >> [...] The actual virtual addresses we pick are exactly the same with the two
>> >> patches.
>> >
>> > So I'm NAK-ing this for now:
>> >
>> >  - The code is it reads today pretends to be an 'allocator'. It is _NOT_ an
>> >    allocator, because all the sections have already been determined by the
>> >    firmware, and, as we just learned the hard way, we do not want to deviate from
>> >    that! There's nothing to 'allocate'!
>> >
>> >    What these patches seem to implement is an elaborate 'allocator' that ends up
>> >    doing nothing on 'new 64-bit' ...
>> >
>> >  - The 32-bit and 64-bit and 'old_mmap' asymmetries:
>> >
>> >         if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
>> >
>> >    seem fragile and nonsensical. The question is: is it possible for the whole EFI
>> >    image to be larger than a couple of megabytes? If not then 32-bit should just
>> >    mirror the firmware layout as well, and if EFI_OLD_MEMMAP does anything
>> >    differently from this _obvious_ 1:1 mapping of the EFI memory offsets then it's
>> >    not worth keeping as a legacy, because there's just nothing better than
>> >    mirroring the firmware layout.
>> >
>> > My suggestion would be to just 1:1 map what the EFI tables describe, modulo the
>> > single absolute offset by which we shift the whole thing to a single base.
>> >
>> > Is there any technical reason why we'd want to deviate from that? Gigabytes of
>> > tables or gigabytes of holes that 32-bit cannot handle? Firmware that wants an OS
>> > layout that differs from the firmware layout?
>> >
>>
>> The combined EFI_MEMORY_RUNTIME regions could span the entire 1:1 addressable PA
>> space. They usually don't but it is a possibility, which means 32-bit will not
>> generally be able to support this approach. [...]
>
> Ok, that's a good argument which invalidates my NAK.
>
>> [...] For 64-bit ARM, there are some minor complications when the base of RAM is
>> up very high in physical memory, but we already fixed that for the boot time ID
>> map and for KVM.
>>
>> > Also, nobody seems to be asking the obvious hardware compatibility question
>> > when trying to implement a standard influenced in great part by an entity that
>> > is partly ignorant of and partly hostile to Linux: how does Windows map the
>> > EFI sections, under what OSs are these firmware versions tested? I suspect no
>> > firmware is released that crashes on bootup on all OSs that can run on that
>> > hardware, right?
>>
>> Interestingly, it was the other way around this time. The engineers that
>> implemented this feature for EDK2 could not boot Windows 8 anymore, because it
>> supposedly maps the regions in reverse order as well (and MS too will need to
>> backport a fix that inverts the mapping order). The engineers also tested
>> Linux/x86, by means of a SUSE installer image, which booted fine, most likely
>> due to the fact that it is an older version which still uses the old memmap
>> layout.
>
> That's nice to hear!
>
>> My concern with all of this is that this security feature will become an obscure
>> opt-in feature rather than something UEFIv2.5 firmware implementations can
>> enable by default.
>
> Ok, so I think the patches are mostly fine after all,

That is good to hear.

> except that I don't think
> the condition on 64-bit makes any sense:
>
> +       if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
>
> I can see us being nervous wrt. backported patches, but is there any strong reason
> to not follow this up with a third (non-backported) patch that changes this to:
>
> +       if (!efi_enabled(EFI_OLD_MEMMAP)) {
>
> for v4.4?
>

The 32-bit side essentially implements the old memmap only, which is
the the bottom-up version. So old memmap will be implied by 32-bit but
not set in the EFI flags, resulting in the reverse enumeration being
used with the bottom-up mapping logic. The net result of that is that
we create the same problem for 32-bit that we are trying to solve for
64-bit, i.e., the regions will end up in reverse order in the VA
mapping.

To deobfuscate this particular conditional, we could set
EFI_OLD_MEMMAP unconditionally on 32-bit x86. Or we could reshuffle
variables and conditionals in various other way. I am not convinced
that the overall end result will be any better though.

-- 
Ard.
