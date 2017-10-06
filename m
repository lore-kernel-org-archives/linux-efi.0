From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 19/27] x86: assembly, make some functions local
Date: Fri, 6 Oct 2017 14:21:21 +0100
Message-ID: <20171006132121.GC14023@leverpostej>
References: <20171002091246.28432-1-jslaby@suse.cz>
 <20171002091246.28432-19-jslaby@suse.cz>
 <CAKv+Gu9C88ToAx+8KcGacUECo7ExnTTBmibEjpB2WkfFvjoZvw@mail.gmail.com>
 <5a3785ea-d2d8-dd51-4b02-12f4ca5507d7@suse.cz>
 <CAKv+Gu-7q_Pr5SoUY_kUstaVusUxvXt9e8xeChQySGZ6h+jdAg@mail.gmail.com>
 <9dfcee94-2058-8986-526c-f7ef9ebada66@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9dfcee94-2058-8986-526c-f7ef9ebada66-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Jiri,

I can see that these serve a useful purpose (as they are necessary for
asm validation encessary for livepatching), and I am not personally
averse to the new annotations.

However, I am concerned that as-is, this is going to create more
problems for !x86 architectures. More on that below.

On Fri, Oct 06, 2017 at 02:53:08PM +0200, Jiri Slaby wrote:
> On 10/04/2017, 09:33 AM, Ard Biesheuvel wrote:
> > On 4 October 2017 at 08:22, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org> wrote:
> >> On 10/02/2017, 02:48 PM, Ard Biesheuvel wrote:
> >>> On 2 October 2017 at 10:12, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org> wrote:
> >>>> There is a couple of assembly functions, which are invoked only locally
> >>>> in the file they are defined. In C, we mark them "static". In assembly,
> >>>> annotate them using SYM_{FUNC,CODE}_START_LOCAL (and switch their
> >>>> ENDPROC to SYM_{FUNC,CODE}_END too). Whether FUNC or CODE depends on
> >>>> ENDPROC/END for a particular function (C or non-C).
> >>>
> >>> I wasn't cc'ed on the cover letter, so I am missing the rationale of
> >>> replacing ENTRY/ENDPROC with other macros.
> >>
> >> There was no cover letter. I am attaching what is in PATCH 1/27 instead:
> >> Introduce new C macros for annotations of functions and data in
> >> assembly. There is a long-standing mess in macros like ENTRY, END,
> >> ENDPROC and similar. They are used in different manners and sometimes
> >> incorrectly.
> > 
> > I must say, I don't share this sentiment.
> > 
> > In arm64, we use ENTRY/ENDPROC for functions with external linkage,
> > and the bare symbol name/ENDPROC for functions with local linkage. I
> > guess we could add ENDOBJECT if we wanted to, but we never really felt
> > the need.
> 
> Yes and this is exactly the reason for the new macros. Now, it's a
> complete mess. One arch does this, another does that. 

If the aim of this series is to introduce something that architectures
use consistently, then can we please actually poke other architectures
about it? e.g. send this to linux-arch, with a cover letter explaining
the idea and asking maintainers to take a look.

I think one reason that ENTRY/END/ENDPROC are used inconsistently is
that they're insufficiently documented. So people assume (inconsistent)
semantics, and often cargo-cult usage without thinking. To avoid that,
could we please document how these new macros should (and should not) be
used?

That way, we have a much better chance of consistency, and it's easier
to figure out if the intended semantics are necessary/sufficient.

Otherwise, I'm worried that bits of this will be inconsistently and
incorrectly cargo-culted into other architectures, making matters worse.

Thanks,
Mark.
