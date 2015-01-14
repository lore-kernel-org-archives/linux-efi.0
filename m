From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: EFI mixed mode + perf = rampant triple faults
Date: Wed, 14 Jan 2015 19:47:14 +0100
Message-ID: <20150114184714.GD6902@pd.tnic>
References: <5491B4A8.905@amacapital.net>
 <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
 <20141231183739.GA28946@console-pimps.org>
 <20150114165151.GA3479@codeblueprint.co.uk>
 <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
 <20150114183546.GC6902@pd.tnic>
 <CALCETrUEfQY-hnmNV9-PfDbEYLa7bVoRcsZc2X0V+mEAbfNH2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUEfQY-hnmNV9-PfDbEYLa7bVoRcsZc2X0V+mEAbfNH2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 14, 2015 at 10:38:25AM -0800, Andy Lutomirski wrote:
> That's not a real MCE, though -- it happens synchronously instead of

MCE can be synchronous in a sense too, as a result of executing an insn,
for example, i.e., EIPV bit set.

> at MCE priority with all the associated messiness.  Or is the idea to
> just stick that in after switching to the 32-bit mode being tested?

Yes, the idea was to simply trigger a real exception after switching to
32-bit while still with 64-bit IDT handlers.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
