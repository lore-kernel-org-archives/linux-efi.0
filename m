From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Tue, 8 Sep 2015 15:21:17 +0200
Message-ID: <CAKv+Gu_us3Nu_gMd4GxPe7z0eqtMfM4DM_UEmGW2MTqVDxg5vA@mail.gmail.com>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
	<CAKv+Gu9bGcSVWuMkPVJGDkCPmWvFpjhh4odLWPBZ-wX3=LgGaw@mail.gmail.com>
	<20150904182307.GE2737@codeblueprint.co.uk>
	<CAKv+Gu-AQdgJNOtrgtEtqxsaSC_L=EANpC3pT8b6X2jmZ5qO_Q@mail.gmail.com>
	<20150908131622.GA2854@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150908131622.GA2854@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 8 September 2015 at 15:16, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> On Fri, 04 Sep, at 08:53:36PM, Ard Biesheuvel wrote:
>> On 4 September 2015 at 20:23, Matt Fleming <matt@codeblueprint.co.uk> wrote:
>> > On Fri, 04 Sep, at 03:24:21PM, Ard Biesheuvel wrote:
>> >>
>> >> Since the UEFI spec does not mandate an enumeration order for
>> >> GetMemoryMap(), it seems to me that you still need to sort its output
>> >> before laying out the VA space. Since you need to sort it anyway, why
>> >> not simply sort it in reverse order and keep all the original code?
>> >> Considering that this is meant for stable, that would keep the delta
>> >> *much* smaller.
>> >
>> > Hmm... that'd be a neat trick and while it would save on the diff
>> > size, I don't think it would be smaller in terms of change complexity.
>> >
>> > EDK2 sorts the memory map when EFI_PROPERTIES_TABLE is enabled, so we
>> > can be reasonably sure the entry order returned by GetMemoryMap() is
>> > compatible with the split regions, even if it's not mandated by the
>> > spec.
>> >
>>
>> EDK2 does sort it, but the spec does not mandate it so another
>> implementation may do something different entirely.
>
> Yeah, we should get that requirement added to the spec.
>
>> > For the non-EFI_PROPERTIES_TABLE case, things have been working fine
>> > without the sorting, so I'm reluctant to introduce it now (it's also
>> > much less of an issue there).
>> >
>>
>> I see. I do wonder, since the VA mapping preserves the modulo 2 MB
>> alignment of each region, aren't you using much more VA space when
>> mapping in reverse order as you are doing now?
>
> It doesn't enforce a 2MB alignment for every entry, just those that
> are actually 2MB aligned. This should be exactly what was done in the
> previous version of the code. Do you see a bug?
>

I noticed that the 64-bit version of efi_map_region() preserves the
relative alignment with respect to a 2 MB boundary for /each/ region.
Since the regions are mapped in reverse order, it is highly unlikely
that each region starts at the same 2 MB relative alignment that the
previous region ended at, so you are likely wasting quite a bit of VA
space.

I don't think it is a bug, though, but it does not seem intentional.

-- 
Ard.
