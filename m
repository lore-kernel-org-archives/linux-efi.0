From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 0/2] x86/boot/KASLR: Restrict kernel to be randomized
 in mirror regions
Date: Fri, 4 Aug 2017 17:22:41 +0800
Message-ID: <20170804092241.GH1874@x1>
References: <1501831607-6776-1-git-send-email-bhe@redhat.com>
 <20170804075228.GA29975@x1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170804075228.GA29975@x1>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org, fanc.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 08/04/17 at 03:52pm, Baoquan He wrote:
> Sorry, NACK this series, there's error to hang system. Before I just
> halt system intentionally with error() to check the efi memmap printing,
> didn't notice this. Checking the cause.

I rebuilt the code or change the one of the replacement back, hang never
seen again. Not sure if I copied the wrong kernel or any other mistakes.
Have got a hardware system with efi enabled to try again, see if
anything wrong will happen. It's really weird. And Chao also is helping
to try on his side.

> 
> On 08/04/17 at 03:26pm, Baoquan He wrote:
> > Patch 1/2 is newly added to add efi_memdesc_ptr helper to wrap the
> > open code which gets the start of efi memmap descriptor and also
> > explain why it need be done like that, Ingo suggested it. 
> > 
> > And also replace several places of the open code with efi_memdesc_ptr
> > helper.
> > 
> > And also use efi_memdesc_ptr in process_efi_entries() which handle efi
> > mirror issue during KASLR.
> > 
> > 
> > Change:
> > v7->v8:
> >     Add efi_memdesc_ptr helper to wrap the open code which gets the
> >     start of map descriptor according to Ingo's suggestion.
> > 
> > v6->v7:
> >   Ingo pointed out several incorrect line break issues and unclear
> >   description of patch log. Correct them and rewrite patch log.
> > 
> >   And also rewrite the EFI warning message that if EFI memmap is above
> >   4G in 32bit system since 32bit system can not handle data above 4G at
> >   kernel decompression stage. This is suggested by Ingo too.
> > 
> > v5->v6:
> >   Code style issue fix according to Kees's comment.
> > 
> >   This is based on tip/x86/boot, patch 1,2,3/4 in v5 post has
> >   been put into tip/x86/boot now.
> > 
> > 
> > 
> > Baoquan He (2):
> >   efi: Introduce efi_memdesc_ptr to get pointer to memmap descriptor
> >   x86/boot/KASLR: Restrict kernel to be randomized in mirror regions
> > 
> >  arch/x86/boot/compressed/eboot.c               |  2 +-
> >  arch/x86/boot/compressed/kaslr.c               | 68 +++++++++++++++++++++++++-
> >  drivers/firmware/efi/libstub/efi-stub-helper.c |  4 +-
> >  include/linux/efi.h                            | 19 +++++++
> >  4 files changed, 88 insertions(+), 5 deletions(-)
> > 
> > -- 
> > 2.5.5
> > 
