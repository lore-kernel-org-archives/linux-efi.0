From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v2] efi, x86: Add a "debug" option to the efi= cmdline
Date: Fri, 6 Feb 2015 11:49:17 +0100
Message-ID: <20150206104917.GB3220@pd.tnic>
References: <20150121100633.GC12173@pd.tnic>
 <20150126104936.GB3320@codeblueprint.co.uk>
 <20150130164309.GG1451@pd.tnic>
 <20150205031846.GA1903@darkstar.redhat.com>
 <20150205081143.GA23980@pd.tnic>
 <20150205084139.GA23146@dhcp-16-198.nay.redhat.com>
 <20150205104441.GC23980@pd.tnic>
 <20150205124507.GB20082@linuxteamdev.amer.dell.com>
 <20150205142858.GH23980@pd.tnic>
 <20150206060007.GA26758@linuxteamdev.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150206060007.GA26758-uSknhY0EtF8ok8EplQz5xE1Vg53cnbg30E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jonathan-Zp4isUonpHBD60Wz+7aTrA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 06, 2015 at 01:00:12AM -0500, Parmeshwr Prasad wrote:
> I am really sorry that I could not mentioned for what purpose this pa=
tch is .
> I wanted this patch to be included along with your patch.  As your pa=
tch is=20
> To add =E2=80=9Cdebug=E2=80=9D cmdline in efi=3D=E2=80=9D<option>=E2=80=
=9D.
>=20
> There are some messages in efifb which appears while booting. I thoug=
ht of
> Putting that messages under efi=3D=E2=80=9Ddebug=E2=80=9D cmdline. Wh=
en efi=3Ddebug is given=20
> Then only efifb messages should appear.

This is not how we do patches. If you feel that those printks in efifb
are too verbose and should be behind a debug switch or, even removed
completely, you can do a separate patch as I explained to you and write
in that commit message what needs to be done and *why* you think it
should be done.

HTH.

--=20
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
