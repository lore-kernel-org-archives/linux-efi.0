From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Thu, 17 Sep 2015 10:05:12 +0200
Message-ID: <20150917080511.GG12379@nazgul.tnic>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
 <20150907040752.GW13182@linux-rxt1.site>
 <20150908204147.GC2854@codeblueprint.co.uk>
 <20150909003307.GJ2266@linux-rxt1.site>
 <20150909112123.GB4973@codeblueprint.co.uk>
 <20150916100820.GA7077@nazgul.tnic>
 <CAKv+Gu-Q_g4YtbZ7X1S1g3RaMZC6HQCVza+oqv26mXbrDjTc5w@mail.gmail.com>
 <20150916132822.GB9198@nazgul.tnic>
 <CAKv+Gu84SJiJH-orFBk-mW6CA7XA0yOiU7DhLzWVTAg=u-yMOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu84SJiJH-orFBk-mW6CA7XA0yOiU7DhLzWVTAg=u-yMOg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, joeyli <jlee@suse.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Sep 16, 2015 at 03:38:45PM +0200, Ard Biesheuvel wrote:
> That is a can of worms I'd rather keep closed, if you don't mind ...

Same here.

> But in general, since we are already violating the PE/COFF spec by
> relocating each runtime image once, then invoke its entry point, then
> fire an event which it should catch to manually update its pointers,
> and then relocate it again into the OS VA space.

Yeah, I vaguely remember at the time hpa proposing an EFI-specific
page fault handler or so. I guess we should consider such or similar
technique as it should be most flexible to deal with such screwups. And
with whatever funky fw stuff comes our way in the future...

Thanks.

--=20
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Nort=
on, HRB 21284 (AG N=C3=BCrnberg)
--
