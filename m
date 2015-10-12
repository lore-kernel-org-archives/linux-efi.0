From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Mon, 12 Oct 2015 16:50:28 +0100
Message-ID: <20151012155028.GH2579@codeblueprint.co.uk>
References: <5612CBE8.2010504@tycho.nsa.gov>
 <20151006073205.GA11115@gmail.com>
 <5613EAD5.2070405@tycho.nsa.gov>
 <20151012113605.GB7384@pd.tnic>
 <20151012124113.GD2579@codeblueprint.co.uk>
 <20151012124936.GA6260@gmail.com>
 <20151012125548.GE2579@codeblueprint.co.uk>
 <20151012141754.GA6621@gmail.com>
 <20151012144928.GF2579@codeblueprint.co.uk>
 <CAKv+Gu95NoB5cPqZMeBLn7i0JWDDPKX63FuiMVD94HpbGhKrhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu95NoB5cPqZMeBLn7i0JWDDPKX63FuiMVD94HpbGhKrhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 12 Oct, at 05:34:53PM, Ard Biesheuvel wrote:
> 
> On arm64, we only map in all of the UEFI runtime services regions
> during the time any of these services are being invoked. I think this
> should be mostly feasible on x86 as well, although it would involve
> yet another rewrite of the EFI region mapping code, and most likely a
> long list of quirks for platforms that are not able to deal with it
> correctly for one reason or the other (but that all come down to: 'if
> you are not doing it like Windows does it, you must be doing it
> wrong').

Actually, we use separate page tables for mapping the EFI runtime
services on x86 right now. These tables are only used when making
runtime calls, just like on arm64.

So we've got a little bit of isolation right now.

> That would make the 'secure' way of mapping things an opt-in
> feature, which is generally not desirable for security features
> (since it will rarely be used in the real world then).

I'd like to think that we're coming to EFI_PROPERTIES_TABLE early
enough that we can work out all the kinks, get things working out of
the box in upstream tianocore, and have it be the standard way to
expose memory regions.

At least that's my hope.

> So enabling the Properties Table memprotect feature as soon as the
> spec defines it in a meaningful way is probably a better way to go,
> and our current involvement is focused on defining it such that it can
> be enabled by default by firmwares rather than ending up an obscure
> switch in the BIOS screen that only the paranoid ever turn on.

Indeed.

-- 
Matt Fleming, Intel Open Source Technology Center
