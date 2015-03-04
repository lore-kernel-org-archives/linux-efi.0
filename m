From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 04/15] x86, kaslr: get kaslr_enabled back correctly
Date: Wed, 4 Mar 2015 21:00:00 +0100
Message-ID: <20150304200000.GB6276@gmail.com>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
 <1425456048-16236-5-git-send-email-yinghai@kernel.org>
 <20150304101649.GA3663@pd.tnic>
 <CAE9FiQWKNDgzJtDVV34e7vWTu7LtqdDKB4KiN1RZwcZrX70zSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQWKNDgzJtDVV34e7vWTu7LtqdDKB4KiN1RZwcZrX70zSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> On Wed, Mar 4, 2015 at 2:16 AM, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
> > On Wed, Mar 04, 2015 at 12:00:37AM -0800, Yinghai Lu wrote:
> >> commit f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
> >> is using address as value for kaslr_enabled.
> >>
> >> That will random kaslr_enabled get that set or cleared.
> >> Will have problem for system really have kaslr enabled.
> >>
> >> -v2: update changelog.
> >
> > This is still not good enough. Please do this:
> >
> > In commit f47233c2d34f we did A. The problem with that is B. Change the
> > code to do C.
> >
> > Now you only have to fill out the A,B and C variables with the
> > respective text which is understandable even for people who don't know
> > this code.
> >
> 
> I don't know, that is trivial and obvious.

The fix might be obvious, the effects of the bug are not obvious at 
all, as you yourself show that you don't understand your own change, 
which is evident from the changelog you've written:

> Please check if it is ok:
> 
> Subject: [PATCH v3] x86, kaslr: get kaslr_enabled back correctly

Missing capitalization.

> 
> commit f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
> is using address as value for kaslr_enabled.

Missing capitalization. Do you really expect maintainers to fix up 
every single sentence of yours??

> That will get wrong value for kaslr_enabled, so have problem for 
> system really have kaslr enabled.

This sentence does not parse, nor is it correct: the bug isn't just 
triggering on systems that want to have kaslr enabled - but also on 
bootloaders that happen to pass in a kaslr boot parameter but have the 
switch value disabled...

You also need to point out the important fact that bootloaders that 
don't try to use the kaslr extension (i.e. that don't use SETUP_KASLR) 
work just fine - this is why the bug was not noticed to begin with, 
i.e. the overwhelming majority of systems out there.

> This patch change to using early map and accessing the value.

s/change to using/changes the code to use/

It is totally unacceptable that you don't do proper analysis of the 
patches you submit, and that you don't bother writing proper, readable 
changelogs.

Your flippant "that is trivial and obvious" attitude towards 
changelogs is unacceptable as well. And this is not about English 
knowledge: missing capitalization is a very simple concept any 
beginning coder should be able to graps the first time it's pointed 
out... yet for the past 3 years half of your patches had totally 
careless, often unreadable changelogs.

These subpar changelogs and patches show plain laziness, sloppiness 
and lack of care to write clean changelogs - and that sloppiness not 
only makes it much harder for maintainers to process your patches, but 
also tends to creep over into your patches as well, causing repeat 
problems again and again...

Thanks,

	Ingo
