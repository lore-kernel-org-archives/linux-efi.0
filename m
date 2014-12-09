From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: Shorten efi regions output
Date: Tue, 9 Dec 2014 13:48:46 +0100
Message-ID: <20141209124845.GB3990@pd.tnic>
References: <20141209095843.GA3990@pd.tnic>
 <CAKv+Gu_F+o6NKb5JJ8ZQ7AJbjvASeQF1YcuUXv8seOMa5oaxgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_F+o6NKb5JJ8ZQ7AJbjvASeQF1YcuUXv8seOMa5oaxgg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 09, 2014 at 01:42:44PM +0100, Ard Biesheuvel wrote:
> The |] thing is easily fixed, though.
> 
> [...]
> > diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> > index 8590099ac148..6734072980ee 100644
> > --- a/drivers/firmware/efi/efi.c
> > +++ b/drivers/firmware/efi/efi.c
> [...]
> > @@ -490,15 +490,15 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
> >                 snprintf(pos, size, "|attr=0x%016llx]",
> >                          (unsigned long long)attr);
> >         else
> > -               snprintf(pos, size, "|%3s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
> > -                        attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
> > -                        attr & EFI_MEMORY_XP      ? "XP"  : "",
> > -                        attr & EFI_MEMORY_RP      ? "RP"  : "",
> > -                        attr & EFI_MEMORY_WP      ? "WP"  : "",
> > -                        attr & EFI_MEMORY_UCE     ? "UCE" : "",
> > -                        attr & EFI_MEMORY_WB      ? "WB"  : "",
> > -                        attr & EFI_MEMORY_WT      ? "WT"  : "",
> > -                        attr & EFI_MEMORY_WC      ? "WC"  : "",
> > -                        attr & EFI_MEMORY_UC      ? "UC"  : "");
> > +               snprintf(pos, size, "|%s%s%s%s%s%s%s%s%s]",
> 
> Drop the leading | here
> 
> > +                        attr & EFI_MEMORY_RUNTIME ? "RT|"  : "",
> > +                        attr & EFI_MEMORY_XP      ? "XP|"  : "",
> > +                        attr & EFI_MEMORY_RP      ? "RP|"  : "",
> > +                        attr & EFI_MEMORY_WP      ? "WP|"  : "",
> > +                        attr & EFI_MEMORY_UCE     ? "UCE|" : "",
> > +                        attr & EFI_MEMORY_WB      ? "WB|"  : "",
> > +                        attr & EFI_MEMORY_WT      ? "WT|"  : "",
> > +                        attr & EFI_MEMORY_WC      ? "WC|"  : "",
> > +                        attr & EFI_MEMORY_UC      ? "UC"   : "");
> 
> and move all the | to the beginning of the string here, including "UC"

Haha, of course! :-)

/me slaps forehead.

Thanks!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
