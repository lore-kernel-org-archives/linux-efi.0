From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Wed, 16 Sep 2015 16:07:21 +0200
Message-ID: <CAKv+Gu_VhLFJrJRgh1TihEoCBHaH=UdntQyQrTHigO8kqKuOyw@mail.gmail.com>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
	<20150907040752.GW13182@linux-rxt1.site>
	<20150908204147.GC2854@codeblueprint.co.uk>
	<20150909003307.GJ2266@linux-rxt1.site>
	<20150909112123.GB4973@codeblueprint.co.uk>
	<20150916100820.GA7077@nazgul.tnic>
	<CAKv+Gu-Q_g4YtbZ7X1S1g3RaMZC6HQCVza+oqv26mXbrDjTc5w@mail.gmail.com>
	<1442410638.2234.8.camel@Odin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1442410638.2234.8.camel@Odin.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pjones@redhat.com" <pjones@redhat.com>, "jlee@suse.com" <jlee@suse.com>, "bp@suse.de" <bp@suse.de>, "dyoung@redhat.com" <dyoung@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "LeifLindholm@linux-rxt1.site" <LeifLindholm@linux-rxt1.site>, "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>
List-Id: linux-efi@vger.kernel.org

On 16 September 2015 at 15:37, James Bottomley <jbottomley@odin.com> wrote:
> On Wed, 2015-09-16 at 13:25 +0200, Ard Biesheuvel wrote:
>> On 16 September 2015 at 12:08, Borislav Petkov <bp@suse.de> wrote:
>> > On Wed, Sep 09, 2015 at 12:21:23PM +0100, Matt Fleming wrote:
>> >> On Wed, 09 Sep, at 08:33:07AM, joeyli wrote:
>> >> >
>> >> > Yes, the machine on my hand has EFI_PROPERTIES_TABLE enabled, and it doesn't
>> >> > boot without your patch.
>> >>
>> >> Awesome. Could you test the following patch instead?
>> >>
>> >> ---
>> >>
>> >> From 24d324b781a3b688dcc265995949a9cf4e8af687 Mon Sep 17 00:00:00 2001
>> >> From: Matt Fleming <matt.fleming@intel.com>
>> >> Date: Thu, 3 Sep 2015 15:56:25 +0100
>> >> Subject: [PATCH v2] x86/efi: Map EFI memmap entries in-order at runtime
>> >>
>> >> Beginning with UEFI v2.5 EFI_PROPERTIES_TABLE was introduced that
>> >> signals that the firmware PE/COFF loader supports splitting code and
>> >> data sections of PE/COFF images into separate EFI memory map entries.
>> >> This allows the kernel to map those regions with strict memory
>> >> protections, e.g. EFI_MEMORY_RO for code, EFI_MEMORY_XP for data, etc.
>> >>
>> >> Unfortunately, an unwritten requirement of this new feature is that
>> >> the regions need to be mapped with the same offsets relative to each
>> >> other as observed in the EFI memory map. If this is not done crashes
>> >
>> > Let me get this straight: this looks like the next EFI screwup which
>> > practically requires specific mapping placement in VA space just
>> > because it uses relative addresses?
>>
>> Both relative and absolute references, currently. The latter are also
>> affected since the relocation offset that is applied to all PE/COFF
>> relocation entries is based on the displacement of ImageBase, and
>> absolute references to symbols in .data need to be treated specially
>> (since it may be shifted relative to the .text section containing
>> ImageBase). This could be worked around by converting each absolute
>> reference individually using ConvertPointer () [and I have a proof of
>> concept that actually makes the problem go away on x86] but it would
>> still be only a partial solution, since relative references are not
>> tracked in the PE/COFF metadata, so even if we wanted to, it would be
>> intractible to find each cross-section relative reference and do the
>> fixup.
>>
>> > And since you say "unwritten" this
>> > practically a requirement is not even in the spec?
>> >
>>
>> No, it seems nobody thought of this when designing the feature.
>
> To add colour: our problem is section relative references (either loads
> or jumps).  The PE/COFF linker is allowed not to emit relocations for
> section relative references because it expects that the sections will
> always be loaded at the same relative offset.

The PE/COFF spec does not define any relative relocation types to be
used in the .reloc section (which is what is used for runtime
relocations). It does define such relocation types as COFF
relocations, which are more like static relocations in ELF, i.e., what
the linker uses at build time to combine object files into an
executable, but those cannot appear in an executable, only in object
files.

> It looks like it is
> possible to force them to have relocation entries, so it would be
> possible to add to the standard language requiring this for UEFI
> compatible binaries, but that won't help with any of the existing
> PE/COFF stuff in the field.
>

Sadly, no. The PE/COFF spec is clear about COFF relocations appearing
only in object files, and the .reloc section only tracks absolute
references.

> The problem is that to apply the various protections UEFI is
> introducing, we're trying to relocate the sections and that's what's
> causing the issue.  Before this, no-one really thought of mapping the
> sections at different relative addresses.  It's really an unexpected
> weakness in the PE/COFF spec that we can't fix, so we have to work
> around it.
>

To be honest, while I am not a big fan of PE/COFF, I don't think it is
reasonable to expect that an image can be simply split up and moved
apart. I think we (UEFI forum) have dropped the ball here.

I won't go into too much detail about how I think it should be
implemented instead, let's save that for the conf call. But splitting
memory regions that belong together without /any/ annotations
whatsoever in the memory map is just sloppy design.

-- 
Ard.
