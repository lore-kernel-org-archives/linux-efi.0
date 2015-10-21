From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Wed, 21 Oct 2015 11:46:53 -0700
Message-ID: <CALCETrWwHLnt6=MiyuQY48zEaOUMuFTg1oN3NDdEOxa6XYMgCw@mail.gmail.com>
References: <20151012125548.GE2579@codeblueprint.co.uk> <20151012141754.GA6621@gmail.com>
 <20151012144928.GF2579@codeblueprint.co.uk> <20151014151807.GA27013@gmail.com>
 <20151014210257.GF2782@codeblueprint.co.uk> <20151021094242.GA12155@gmail.com>
 <20151021124924.GA19262@gmail.com> <CAKv+Gu92iMzCq0zZfTBUVKfXQqDiVfO3WPiHVWNOYtGjTvOkmQ@mail.gmail.com>
 <20151021132430.GD3575@pd.tnic> <CAKv+Gu9GaLbexayuT81gM5=081a1gT57RaY_HiCzh9YYvy5SGg@mail.gmail.com>
 <20151021143651.GE3575@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151021143651.GE3575-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 21, 2015 at 7:36 AM, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
> On Wed, Oct 21, 2015 at 03:28:56PM +0200, Ard Biesheuvel wrote:
>> In theory, yes. In practice, since this is supposed to be a security
>> enhancement, we need some kind of ground truth to tell us which pages
>> can be legally modified *and* executed, so that we can detect the
>> illegal cases. My point was that, since a multitude of PE/COFF images
>> can be covered by a single EfiRuntimeServicesCode region, the UEFI
>> memory map does not give us enough information to make the distinction
>> between a page that sits on the text/data boundary of some PE/COFF
>> image and a page that sits wholly in either.
>
> Well, we're going to simply allow the accesses to in-kernel users which
> fault on those ranges, assuming that in-kernel modifiers are legit and
> DTRT. Which means, we don't really need to know which pages can be
> legally modified - we simply trust the in-kernel users.
>
> The moment you're able to load an evil kernel module, guarding against
> those writes is the last thing you need to worry about...

I don't think we can do a whole lot to help against broken UEFI code,
but having anything mapped RWX is a nice target for people trying to
exploit kernel bugs.  Hence my suggestion to clear W except when
actually running UEFI code.

If the UEFI stuff is mapped in its own PGD entry, we could just RO
that entire PGD entry everywhere except the UEFI pgd (and make sure to
clear G so that the TLB entries get zapped).

--Andy
