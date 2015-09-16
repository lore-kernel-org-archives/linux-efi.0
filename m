From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Wed, 16 Sep 2015 15:28:22 +0200
Message-ID: <20150916132822.GB9198@nazgul.tnic>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
 <20150907040752.GW13182@linux-rxt1.site>
 <20150908204147.GC2854@codeblueprint.co.uk>
 <20150909003307.GJ2266@linux-rxt1.site>
 <20150909112123.GB4973@codeblueprint.co.uk>
 <20150916100820.GA7077@nazgul.tnic>
 <CAKv+Gu-Q_g4YtbZ7X1S1g3RaMZC6HQCVza+oqv26mXbrDjTc5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-Q_g4YtbZ7X1S1g3RaMZC6HQCVza+oqv26mXbrDjTc5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-wo1vFcy6AUs@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Sep 16, 2015 at 01:25:06PM +0200, Ard Biesheuvel wrote:
> ... so even if we wanted to, it would be intractible to find each
> cross-section relative reference and do the fixup.

Hmm, maybe we should go and patch EFI code segments and fixup all
relative references after mapping. I mean, if you want something done
right, you better do it yourself. :-\

> No, it seems nobody thought of this when designing the feature.

Not surprised at all, to be honest.

> Several solutions and/or work arounds are currently under discussion.

And requiring for code segments not to refer to each other with relativ=
e
offsets and holding that down in the spec post-factum is not possible
anymore...?

 [ I can already imagine what the answer to that question would be thou=
gh... ]

Thanks.

--=20
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Nort=
on, HRB 21284 (AG N=C3=BCrnberg)
--
