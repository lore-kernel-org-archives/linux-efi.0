From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Wed, 16 Sep 2015 15:38:45 +0200
Message-ID: <CAKv+Gu84SJiJH-orFBk-mW6CA7XA0yOiU7DhLzWVTAg=u-yMOg@mail.gmail.com>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
	<20150907040752.GW13182@linux-rxt1.site>
	<20150908204147.GC2854@codeblueprint.co.uk>
	<20150909003307.GJ2266@linux-rxt1.site>
	<20150909112123.GB4973@codeblueprint.co.uk>
	<20150916100820.GA7077@nazgul.tnic>
	<CAKv+Gu-Q_g4YtbZ7X1S1g3RaMZC6HQCVza+oqv26mXbrDjTc5w@mail.gmail.com>
	<20150916132822.GB9198@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150916132822.GB9198@nazgul.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, joeyli <jlee@suse.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 16 September 2015 at 15:28, Borislav Petkov <bp@suse.de> wrote:
> On Wed, Sep 16, 2015 at 01:25:06PM +0200, Ard Biesheuvel wrote:
>> ... so even if we wanted to, it would be intractible to find each
>> cross-section relative reference and do the fixup.
>
> Hmm, maybe we should go and patch EFI code segments and fixup all
> relative references after mapping. I mean, if you want something done
> right, you better do it yourself. :-\
>

That is a can of worms I'd rather keep closed, if you don't mind ...

>> No, it seems nobody thought of this when designing the feature.
>
> Not surprised at all, to be honest.
>
>> Several solutions and/or work arounds are currently under discussion.
>
> And requiring for code segments not to refer to each other with relative
> offsets and holding that down in the spec post-factum is not possible
> anymore...?
>
>  [ I can already imagine what the answer to that question would be though... ]
>

Fixing the spec is easy. Modifying all the toolchains out there to add
an option that inhibits cross-section relative references is the
problem. Note that, at the object level, it is not necessarily obvious
to the compiler whether a symbol reference will end up referring to
another section than its own. So this basically means 'no relative
references at all', and most compilers don't have that option yet.
[Note that GCC's large code model, which makes no assumption about the
proximity of external symbols, may still emit PC relative literals
(e.g., '.quad sym - .') on ARM. Not sure about X64)

But in general, since we are already violating the PE/COFF spec by
relocating each runtime image once, then invoke its entry point, then
fire an event which it should catch to manually update its pointers,
and then relocate it again into the OS VA space.
