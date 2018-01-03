From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: Remove Matt Fleming as EFI co-maintainer
Date: Wed, 3 Jan 2018 14:03:05 +0100
Message-ID: <20180103130305.uqpozy5j6yrrnedx@gmail.com>
References: <20180103094417.6353-1-matt@codeblueprint.co.uk>
 <CAKv+Gu88QfuAQbLFbijHk9yG6TnYtkKPUYQfwpcQMX9z-cXcdQ@mail.gmail.com>
 <20180103124304.GC3067@codeblueprint.co.uk>
 <20180103125010.clwc2eyhqmk3b5v2@gmail.com>
 <CAKv+Gu-Yv3J62jLsECodNJ2F2N2TFXpUbAkc8-O+FogoTYHTLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-Yv3J62jLsECodNJ2F2N2TFXpUbAkc8-O+FogoTYHTLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> On 3 January 2018 at 12:50, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> >
> >> On Wed, 03 Jan, at 10:13:55AM, Ard Biesheuvel wrote:
> >> > On 3 January 2018 at 09:44, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> >> > > Instate Ard Biesheuvel as the sole EFI maintainer and leave other folks
> >> > > as maintainers for the EFI test driver and efivarfs file system.
> >> > >
> >> > > Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> >> >
> >> > Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >> >
> >> > Thanks Matt
> >> >
> >> > > ---
> >> > >  MAINTAINERS | 5 +----
> >> > >  1 file changed, 1 insertion(+), 4 deletions(-)
> >> > >
> >> > > Ard, if you want to add yourself as co-maintainer of the EFI test
> >> > > driver or efivarfs, please go ahead. I'm sure no one would object.
> >> > >
> >> >
> >> > I guess that makes sense. Should we just fold that in?
> >>
> >> Sounds good to me.
> >
> > If any of you sends me a delta patch or an updated patch I'll apply the folded
> > version.
> >
> > Thanks,
> >
> >         Ingo
> 
> 
> Done.

Thanks guys, applied to tip:efi/urgent, together with the two pending EFI fixes.

	Ingo
