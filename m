From: Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] Documentation/efi-stub.txt: Fix a typo
Date: Fri, 23 Oct 2015 09:08:15 +0300
Message-ID: <1445580495.4957.5.camel@linux.intel.com>
References: <1445430404-1908-1-git-send-email-joonas.lahtinen@linux.intel.com>
	 <CAFECyb__gq0mYpTGH8sapQxLr89hKFTL8zvrixdfaYjGshVAVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFECyb__gq0mYpTGH8sapQxLr89hKFTL8zvrixdfaYjGshVAVw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "Linux EFI (Extensible Firmware Interface) development" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On to, 2015-10-22 at 15:58 -0700, Roy Franz wrote:
> On Wed, Oct 21, 2015 at 5:26 AM, Joonas Lahtinen
> <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > In the command invocation "initrd=\Kernels\..." should really read
> > "initrd=\Ramdisks\..." instead.
> > 
> > Signed-off-by: Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  Documentation/efi-stub.txt | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/efi-stub.txt b/Documentation/efi
> > -stub.txt
> > index 7747024..e1ee764 100644
> > --- a/Documentation/efi-stub.txt
> > +++ b/Documentation/efi-stub.txt
> > @@ -68,7 +68,7 @@ fs0:>
> >  to boot with the initrd-large.img file if the current working
> >  directory is fs0:\Kernels, the following command must be used,
> > 
> > -       fs0:\Kernels> bzImage.efi initrd=\Kernels\initrd-large.img
> > +       fs0:\Kernels> bzImage.efi initrd=\Ramdisks\initrd-large.img
> > 
> 
> I don't think this change is correct.  From just above in efi
> -stub.txt:
> 
>  For example, given the following directory layout,
> 
> fs0:>
>         Kernels\
>                         bzImage.efi
>                         initrd-large.img
> 
>         Ramdisks\
>                         initrd-small.img
>                         initrd-medium.img
> 
> 
> The file initrd-large.img is in the Kernels directory, and the point
> of this section
> is to highlight that the path given to "initrd=" must be absolute.
> 

True so, I was skip reading it seems. Based on that, I'd consider the
example somewhat misleading (Ramdisks directory only add some
confusion).

Regards, Joonas

> Roy
> 
> 
> 
> >  Notice how bzImage.efi can be specified with a relative path.
> > That's
> >  because the image we're executing is interpreted by the EFI shell,
> > --
> > 2.4.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux
> > -efi" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Joonas Lahtinen
Open Source Technology Center
Intel Corporation
