From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Wed, 16 Sep 2015 13:25:06 +0200
Message-ID: <CAKv+Gu-Q_g4YtbZ7X1S1g3RaMZC6HQCVza+oqv26mXbrDjTc5w@mail.gmail.com>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
	<20150907040752.GW13182@linux-rxt1.site>
	<20150908204147.GC2854@codeblueprint.co.uk>
	<20150909003307.GJ2266@linux-rxt1.site>
	<20150909112123.GB4973@codeblueprint.co.uk>
	<20150916100820.GA7077@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150916100820.GA7077-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LeifLindholm-empE8CJ7fzk2xCFIczX1Fw@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-wo1vFcy6AUs@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 September 2015 at 12:08, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org> wrote:
> On Wed, Sep 09, 2015 at 12:21:23PM +0100, Matt Fleming wrote:
>> On Wed, 09 Sep, at 08:33:07AM, joeyli wrote:
>> >
>> > Yes, the machine on my hand has EFI_PROPERTIES_TABLE enabled, and =
it doesn't
>> > boot without your patch.
>>
>> Awesome. Could you test the following patch instead?
>>
>> ---
>>
>> From 24d324b781a3b688dcc265995949a9cf4e8af687 Mon Sep 17 00:00:00 20=
01
>> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Date: Thu, 3 Sep 2015 15:56:25 +0100
>> Subject: [PATCH v2] x86/efi: Map EFI memmap entries in-order at runt=
ime
>>
>> Beginning with UEFI v2.5 EFI_PROPERTIES_TABLE was introduced that
>> signals that the firmware PE/COFF loader supports splitting code and
>> data sections of PE/COFF images into separate EFI memory map entries=
=2E
>> This allows the kernel to map those regions with strict memory
>> protections, e.g. EFI_MEMORY_RO for code, EFI_MEMORY_XP for data, et=
c.
>>
>> Unfortunately, an unwritten requirement of this new feature is that
>> the regions need to be mapped with the same offsets relative to each
>> other as observed in the EFI memory map. If this is not done crashes
>
> Let me get this straight: this looks like the next EFI screwup which
> practically requires specific mapping placement in VA space just
> because it uses relative addresses?

Both relative and absolute references, currently. The latter are also
affected since the relocation offset that is applied to all PE/COFF
relocation entries is based on the displacement of ImageBase, and
absolute references to symbols in .data need to be treated specially
(since it may be shifted relative to the .text section containing
ImageBase). This could be worked around by converting each absolute
reference individually using ConvertPointer () [and I have a proof of
concept that actually makes the problem go away on x86] but it would
still be only a partial solution, since relative references are not
tracked in the PE/COFF metadata, so even if we wanted to, it would be
intractible to find each cross-section relative reference and do the
fixup.

> And since you say "unwritten" this
> practically a requirement is not even in the spec?
>

No, it seems nobody thought of this when designing the feature.

> Can we state explicitly in the spec NOT to rely on mapping VA placeme=
nt?
> I mean, this "unwritten" requirement is seriously screwed on soo many
> levels...
>

Several solutions and/or work arounds are currently under discussion

--=20
Ard.

> What else are we to expect? Spelled out virtual addresses which are
> going to be the EFI-allowed ones only??!
>
> --
> Regards/Gruss,
>     Boris.
>
> SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham No=
rton, HRB 21284 (AG N=C3=BCrnberg)
> --
