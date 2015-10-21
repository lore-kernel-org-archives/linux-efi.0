From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Wed, 21 Oct 2015 21:45:22 +0100
Message-ID: <20151021204522.GB20338@codeblueprint.co.uk>
References: <20151012144928.GF2579@codeblueprint.co.uk>
 <20151014151807.GA27013@gmail.com>
 <20151014210257.GF2782@codeblueprint.co.uk>
 <20151021094242.GA12155@gmail.com>
 <20151021124924.GA19262@gmail.com>
 <CAKv+Gu92iMzCq0zZfTBUVKfXQqDiVfO3WPiHVWNOYtGjTvOkmQ@mail.gmail.com>
 <20151021132430.GD3575@pd.tnic>
 <CAKv+Gu9GaLbexayuT81gM5=081a1gT57RaY_HiCzh9YYvy5SGg@mail.gmail.com>
 <20151021143651.GE3575@pd.tnic>
 <CALCETrWwHLnt6=MiyuQY48zEaOUMuFTg1oN3NDdEOxa6XYMgCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWwHLnt6=MiyuQY48zEaOUMuFTg1oN3NDdEOxa6XYMgCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 21 Oct, at 11:46:53AM, Andy Lutomirski wrote:
>
> If the UEFI stuff is mapped in its own PGD entry, we could just RO
> that entire PGD entry everywhere except the UEFI pgd (and make sure to
> clear G so that the TLB entries get zapped).

What would be the benefit of making it RO as opposed to not having it
mapped at all? The mappings only exist in the trampoline_pgd right now
for x86 which minimizes the potentially vulnerable code paths to the
EFI runtime calls and the suspend/resume code.
