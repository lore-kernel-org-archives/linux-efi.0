From: Eugene Korenevsky <ekorenevsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] EFI loader: remove redundant code
Date: Wed, 2 Nov 2016 16:56:03 +0300
Message-ID: <20161102135603.GA8090@vnote>
References: <20161102041855.GA4479@vnote>
 <CAKv+Gu8xkxPSkA+3Sqo-kcL=b6ex6MNQ7DrDV_sqcQrfmqkvCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8xkxPSkA+3Sqo-kcL=b6ex6MNQ7DrDV_sqcQrfmqkvCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Linn Crosetto <linn-ZPxbGqLxI0U@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> > *e820ext is always NULL in 'alloc_e820ext()' (see the code of 'exit_boot()').
> > Without loss of generality we can replace freeing with returning
> > EFI_INVALID_PARAMETER. So if the caller would ever incorrectly pass non-NULL
> > *e820ext, he will obtain a returned error code.
> >
> 
> What exactly are you trying to fix here? Adding new artificial failure
> modes is hardly worth it when all you are doing is cleaning up code
> that by itself is correct to begin with, but is simply never called.

This code (free_pool, assignments) is dead whether it is correct or
not. So it is to be removed.
The check gives some assurance that memory is not leaked if the calling
code is changed.


> > @@ -956,11 +956,8 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
> >         size = sizeof(struct setup_data) +
> >                 sizeof(struct e820entry) * nr_desc;
> >
> > -       if (*e820ext) {
> > -               efi_call_early(free_pool, *e820ext);
> > -               *e820ext = NULL;
> > -               *e820ext_size = 0;
> > -       }
> > +       if (*e820ext)
> > +               return EFI_INVALID_PARAMETER;
> >
> >         status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> >                                 size, (void **)e820ext);
> > --


-- 
Eugene
