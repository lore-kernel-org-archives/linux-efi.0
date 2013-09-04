From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH V2 10/10] Add option to automatically enforce module
 signatures when in Secure Boot mode
Date: Wed, 04 Sep 2013 18:51:17 +0800
Message-ID: <1378291877.6380.74.camel@linux-s257.site>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
	 <1376933171-9854-11-git-send-email-matthew.garrett@nebula.com>
	 <20130829183713.GT20828@hansolo.jdub.homelinux.org>
	 <522104A6.5000700@zytor.com>
	 <20130830234133.GR20828@hansolo.jdub.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130830234133.GR20828-dHPIJuKSOV01V+h/cAXI7w8O6CCKKCg3HZ5vskTnxNA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=94=EF=BC=8C2013-08-30 =E6=96=BC 19:41 -0400=EF=BC=8CJo=
sh Boyer =E6=8F=90=E5=88=B0=EF=BC=9A
> On Fri, Aug 30, 2013 at 01:46:30PM -0700, H. Peter Anvin wrote:
> > On 08/29/2013 11:37 AM, Josh Boyer wrote:
> > >>  	setup_efi_pci(boot_params);
> > >> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/in=
clude/uapi/asm/bootparam.h
> > >> index c15ddaf..d35da96 100644
> > >> --- a/arch/x86/include/uapi/asm/bootparam.h
> > >> +++ b/arch/x86/include/uapi/asm/bootparam.h
> > >> @@ -131,7 +131,8 @@ struct boot_params {
> > >>  	__u8  eddbuf_entries;				/* 0x1e9 */
> > >>  	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
> > >>  	__u8  kbd_status;				/* 0x1eb */
> > >> -	__u8  _pad5[3];					/* 0x1ec */
> > >> +	__u8  secure_boot;				/* 0x1ec */
> > >> +	__u8  _pad5[2];					/* 0x1ec */
> > >>  	/*
> > >>  	 * The sentinel is set to a nonzero value (0xff) in header.S.
> > >>  	 *
> > >=20
> > > You need to include the following chunk of code with this, otherw=
ise the
> > > secure_boot variable gets cleared.
> > >=20
> >=20
> > Not really.
> >=20
> > There are three cases:
> >=20
> > 1. Boot stub only.  Here we do the right thing with the bootparams.
> > 2. Boot loader bypasses the boot stub completely.  Here we MUST NOT=
 do
> >    what you suggest above.
> > 3. Boot stub with a boot_params structure passed in.  Here we shoul=
d
> >    run sanitize_boot_params() (an inline for a reason) in the boot
> >    stub, before we set the secure_boot field.  Once that is done, w=
e
> >    again don't need that modification.
>=20
> OK.  If 3 works, then great.  All I know is that Fedora has been
> carrying the above hunk for months and it was missing in this patch s=
et.
> So when I went to test it, the patches didn't do anything because the
> secure_boot field was getting cleared.
>=20
> I'm more than happy to try option 3, and I'll poke at it next week
> unless someone beats me to it.
>=20
> josh

The secure_boot field cleaned by sanitize_boot_params() when using grub=
2
linuxefi to load efi stub kernel.
I printed the boot_params->sentinel value, confirm this value is NOT 0
when running grub2 linuxefi path, the entry point is efi_stub_entry.=20

On the other hand,
the sentinel value is 0 when direct run efi stub kernel in UEFI shell,
the secure_boot field can keep.

Does that mean grub2 should clean the sentinel value? or we move the ge=
t
secure_boot value to efi_init()?


Thanks a lot!
Joey Lee
