From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 RESEND 2/2] x86/efi: Clean up a minor mistake in code
 comment
Date: Fri, 24 Mar 2017 17:04:32 +0800
Message-ID: <20170324090432.GD30442@x1>
References: <1490239655-20902-1-git-send-email-bhe@redhat.com>
 <1490239655-20902-3-git-send-email-bhe@redhat.com>
 <CAKv+Gu9Dk22L+Jdw872zR8SgaXpHQNcyHvyX8F7ntMxm9aCduA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9Dk22L+Jdw872zR8SgaXpHQNcyHvyX8F7ntMxm9aCduA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/24/17 at 08:57am, Ard Biesheuvel wrote:
> On 23 March 2017 at 03:27, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > EFI allocate runtime services regions from EFI_VA_START, -4G, down
> > to -64G, EFI_VA_END.
> 
> OK, so is the size of the region 60 GB or 64 GB? This suggests 60 GB,
> but the comment you update suggests 64 GB.

Ah, sorry, here it should be -68G. The reserved EFI region is [-68G,
-4G), amount is 64G.

Thanks, will repost with updated log.

> 
> > The mechanism was introduced in
> > commit d2f7cbe7b26a7 ("x86/efi: Runtime services virtual mapping").
> >
> > Clean it up to avoid confusion.
> >
> > Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> > Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> > Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> > Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> > Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > ---
> >  arch/x86/platform/efi/efi_64.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > index a4695da..6cbf9e0 100644
> > --- a/arch/x86/platform/efi/efi_64.c
> > +++ b/arch/x86/platform/efi/efi_64.c
> > @@ -47,7 +47,7 @@
> >  #include <asm/pgalloc.h>
> >
> >  /*
> > - * We allocate runtime services regions bottom-up, starting from -4G, i.e.
> > + * We allocate runtime services regions top-down, starting from -4G, i.e.
> >   * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
> >   */
> >  static u64 efi_va = EFI_VA_START;
> > --
> > 2.5.5
> >
