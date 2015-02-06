From: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH v2] efi, x86: Add a "debug" option to the efi= cmdline
Date: Fri, 6 Feb 2015 01:00:12 -0500
Message-ID: <20150206060007.GA26758@linuxteamdev.amer.dell.com>
References: <54BF3DCA.4070708@jonmasters.org>
 <20150121100633.GC12173@pd.tnic>
 <20150126104936.GB3320@codeblueprint.co.uk>
 <20150130164309.GG1451@pd.tnic>
 <20150205031846.GA1903@darkstar.redhat.com>
 <20150205081143.GA23980@pd.tnic>
 <20150205084139.GA23146@dhcp-16-198.nay.redhat.com>
 <20150205104441.GC23980@pd.tnic>
 <20150205124507.GB20082@linuxteamdev.amer.dell.com>
 <20150205142858.GH23980@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150205142858.GH23980-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jonathan-Zp4isUonpHBD60Wz+7aTrA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 05, 2015 at 08:28:58AM -0600, Borislav Petkov wrote:
> On Thu, Feb 05, 2015 at 07:45:10AM -0500, Parmeshwr Prasad wrote:
> > It is better if we add some printk from efifb messages.
> > Please review the below patch.
>=20
> First of all, we saw you patch.
>=20
> Then,
>=20
> > From 7fbac896ab87f1b37646ac2f49bb8216ec330642 Mon Sep 17 00:00:00 2=
001
> > From: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
> > Date: Wed, 4 Feb 2015 06:50:32 -0500
> > Subject: [PATCH] efi, x86: Add a debug option to the efi=3D cmdline
>=20
> yours has the same Subject as mine. This is not how we do patches.
> Consult Documentation/SubmittingPatches about how to do them properly=
=2E
>=20
> What is more, your patch doesn't have a commit message. But it needs =
one.
>=20
> Fix all that, send it as a *separate* patch after mine has been appli=
ed
> and people will take a look then.

I am really sorry that I could not mentioned for what purpose this patc=
h is .
I wanted this patch to be included along with your patch.  As your patc=
h is=20
To add =E2=80=9Cdebug=E2=80=9D cmdline in efi=3D=E2=80=9D<option>=E2=80=
=9D.

There are some messages in efifb which appears while booting. I thought=
 of
Putting that messages under efi=3D=E2=80=9Ddebug=E2=80=9D cmdline. When=
 efi=3Ddebug is given=20
Then only efifb messages should appear.

>=20
> >=20
> > Signed-off-by: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
> > ---
> >  drivers/video/fbdev/efifb.c | 49 +++++++++++++++++++++++++--------=
------------
> >  1 file changed, 27 insertions(+), 22 deletions(-)
> >=20
> > diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efif=
b.c
> > index 4bfff34..505bc56 100644
> > --- a/drivers/video/fbdev/efifb.c
> > +++ b/drivers/video/fbdev/efifb.c
> > @@ -145,7 +145,8 @@ static int efifb_probe(struct platform_device *=
dev)
> >                 printk(KERN_DEBUG "efifb: invalid framebuffer addre=
ss\n");
> >                 return -ENODEV;
> >         }
> > -       printk(KERN_INFO "efifb: probing for efifb\n");
> > +       if (efi_enabled(EFI_DBG))
> > +               printk(KERN_INFO "efifb: probing for efifb\n");
>=20
> If we're going to use the "efifb" prefix, change those to pr_info and
> define pr_fmt - lotsa examples in the kernel sources.
>=20
> More importantly, you'd need a consensus from people that the printks=
 in
> efifb are really not interesting and should be behind efi=3Ddebug.
>=20
> HTH.
>=20
> --=20
> Regards/Gruss,
>     Boris.
>=20
> ECO tip #101: Trim your mails when you reply.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
