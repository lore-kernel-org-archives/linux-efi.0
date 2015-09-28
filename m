From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Mon, 28 Sep 2015 07:49:41 +0100
Message-ID: <CAKv+Gu8M2pmzfeA=NT4c44E6-PQvRKHZjEJt78mryGcp6bBD8w@mail.gmail.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
	<1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
	<20150926055643.GA25877@gmail.com>
	<20150926134329.GA3144@codeblueprint.co.uk>
	<20150927070355.GB26125@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150927070355.GB26125@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Dave Young <dyoung@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

On 27 September 2015 at 08:03, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
>
[...]
>> [...] The actual virtual addresses we pick are exactly the same with the two
>> patches.
>
> So I'm NAK-ing this for now:
>
>  - The code is it reads today pretends to be an 'allocator'. It is _NOT_ an
>    allocator, because all the sections have already been determined by the
>    firmware, and, as we just learned the hard way, we do not want to deviate from
>    that! There's nothing to 'allocate'!
>
>    What these patches seem to implement is an elaborate 'allocator' that ends up
>    doing nothing on 'new 64-bit' ...
>
>  - The 32-bit and 64-bit and 'old_mmap' asymmetries:
>
>         if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
>
>    seem fragile and nonsensical. The question is: is it possible for the whole EFI
>    image to be larger than a couple of megabytes? If not then 32-bit should just
>    mirror the firmware layout as well, and if EFI_OLD_MEMMAP does anything
>    differently from this _obvious_ 1:1 mapping of the EFI memory offsets then it's
>    not worth keeping as a legacy, because there's just nothing better than
>    mirroring the firmware layout.
>
> My suggestion would be to just 1:1 map what the EFI tables describe, modulo the
> single absolute offset by which we shift the whole thing to a single base.
>
> Is there any technical reason why we'd want to deviate from that? Gigabytes of
> tables or gigabytes of holes that 32-bit cannot handle? Firmware that wants an OS
> layout that differs from the firmware layout?
>

The combined EFI_MEMORY_RUNTIME regions could span the entire 1:1
addressable PA space. They usually don't but it is a possibility,
which means 32-bit will not generally be able to support this
approach. For 64-bit ARM, there are some minor complications when the
base of RAM is up very high in physical memory, but we already fixed
that for the boot time ID map and for KVM.

> Also, nobody seems to be asking the obvious hardware compatibility question when
> trying to implement a standard influenced in great part by an entity that is
> partly ignorant of and partly hostile to Linux: how does Windows map the EFI
> sections, under what OSs are these firmware versions tested? I suspect no firmware
> is released that crashes on bootup on all OSs that can run on that hardware,
> right?
>

Interestingly, it was the other way around this time. The engineers
that implemented this feature for EDK2 could not boot Windows 8
anymore, because it supposedly maps the regions in reverse order as
well (and MS too will need to backport a fix that inverts the mapping
order). The engineers also tested Linux/x86, by means of a SUSE
installer image, which booted fine, most likely due to the fact that
it is an older version which still uses the old memmap layout.

My concern with all of this is that this security feature will become
an obscure opt-in feature rather than something UEFIv2.5 firmware
implementations can enable by default.
-- 
Ard.
