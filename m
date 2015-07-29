From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCH] x86/mm, efi: Check for valid image type
Date: Tue, 28 Jul 2015 17:10:34 -0700
Message-ID: <20150729001034.GD8671@cloud>
References: <1437579164-20176-1-git-send-email-bigeasy@linutronix.de>
 <20150728205157.GD2773@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150728205157.GD2773-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 28, 2015 at 09:51:57PM +0100, Matt Fleming wrote:
> (Pulling in Josh)

Thanks, Matt.

> On Wed, 22 Jul, at 05:32:44PM, Sebastian Andrzej Siewior wrote:
> > I usually see
> > |Ignoring BGRT: failed to allocate memory for image (wanted 2643013=
14 bytes)
> > |Ignoring BGRT: failed to allocate memory for image (wanted 3925872=
891 bytes)

Yikes.  258MB or 3.9GB are completely bogus, yes.

> > sometimes I get
> >=20
> > |------------[ cut here ]------------
> > |WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:136 __early_ioremap.c=
onstprop.0+0x113/0x1d3()
> > =E2=80=A6
> > | [<ffffffff81b3de8c>] __early_ioremap.constprop.0+0x113/0x1d3
> > | [<ffffffff81b3e106>] early_ioremap+0x13/0x15
> > | [<ffffffff81b2c4a9>] efi_bgrt_init+0x1e2/0x27d
> > =E2=80=A6

That should definitely never happen.

> > now and then. The data behind that pointer changes on each boot bec=
ause
> > nobody preserves the content across kexec.

Right.  The kernel copies this image precisely because it may go away a=
t
ExitBootServices or similar, or when ACPI reclaim space is freed.  This
ties into the various work about trying to make kexec handle EFI and
ACPI.  Is there some way we can indicate to the kexec kernel that this
won't work?  (Or fix it so it will?)

> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> > ---
> >=20
> > I don't know much about the requirement of having the .bmp in memor=
y all the
> > time. Would it be a bad thing to compress the bmp and uncompress on=
 cat from
> > userland? In my case the bmp has 272 KiB and LZO gets it down to 12=
KiB,
> > XZ 7.4KiB.
>=20
> The usual use for BGRT is to display it during kernel boot, so
> interacting with userland doesn't help you there.

If we're going to be storing a large image, applying simple in-kernel
compression doesn't seem unreasonable, if we then decompress it when
read from the BGRT sysfs file.  That's entirely separate from this issu=
e
though.

> >  arch/x86/platform/efi/efi-bgrt.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >=20
> > diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/e=
fi/efi-bgrt.c
> > index d7f997f7c26d..59710f0875bb 100644
> > --- a/arch/x86/platform/efi/efi-bgrt.c
> > +++ b/arch/x86/platform/efi/efi-bgrt.c
> > @@ -79,6 +79,10 @@ void __init efi_bgrt_init(void)
> >  	memcpy_fromio(&bmp_header, image, sizeof(bmp_header));
> >  	if (ioremapped)
> >  		early_iounmap(image, sizeof(bmp_header));
> > +	if (bmp_header.id !=3D 0x4d42) {
> > +		pr_err("BGRT: Not a valid BMP file.\n");
> > +		return;
> > +	}

That's a good idea as an additional cross-check, but not a complete fix
for the problem.  As you pointed out above, a wild pointer could cause =
a
WARN from early_ioremap.  We need to never follow the pointer in the
first place after a kexec, unless we have some way to know that it's
actually valid.

- Josh Triplett
