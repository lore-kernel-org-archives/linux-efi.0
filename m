From: Adam Borowski <kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org>
Subject: Re: [PATCH 09/17] Move unicode to ASCII conversion to shared
 function.
Date: Fri, 20 Sep 2013 01:02:41 +0200
Message-ID: <20130919230241.GA18666@angband.pl>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
 <1379391093-27948-10-git-send-email-roy.franz@linaro.org>
 <20130919034406.GA26385@angband.pl>
 <CAFECyb-tTaCEqUHUh23MaJf-P42ZpodFKeNG=kE+vmmi-gyKrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb-tTaCEqUHUh23MaJf-P42ZpodFKeNG=kE+vmmi-gyKrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Sep 18, 2013 at 09:48:44PM -0700, Roy Franz wrote:
> On Wed, Sep 18, 2013 at 8:44 PM, Adam Borowski <kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org> =
wrote:
> > [UCS2 truncation]
>=20
> I stuck to re-arranging the code that was there, as I don't know enou=
gh
> about character encodings to propose changes.

I on the other hand don't know the kernel (lurking because of my first
patch), but I'm on a crusade against mangled Unicode (so far in the
userland).  Can't let such a blatant error slip through on my watch :)

> Also, this code is running as part of the kernel decompressor, rather=
 than
> the kernel itself, so it doesn't have access to any kernel facilities=
, and
> it also needs to be position independent.

Ok, so it can't reuse common libraries.  No problem, a simplified, sani=
tized
and optimized copy of utf16s_to_utf8s() can be done in quite less code =
than
the original.

> It's running in a quite limited environment - the decompressor has
> its own copy of strstr(), and other string functions.

I'd need nothing but a way to alloc the new string.  And I see this is
already done (efi_{low,high_alloc()).

> I checked the UEFI specification, and it states that all 16 bit strin=
gs
> are UCS-2, unless otherwise noted.

=2E.. which means it will either get upgraded to UTF-16 in a subsequent
version, or some Unicode strings get mangled.  I'd ignore this bit and
implement full UTF-16 from the start: every legal UCS-2 string can be
decoded as UTF-16 so it's a strict superset.

> The load options that the command line is provided through a void poi=
nter
> specified as: [snip]

Either a null pointer or a 16-bit string, that sounds clear enough.

I see not a word about endianness (does anything do EFI on big endian?)=
,
but "same as host" seems to be a reasonable assumption.

> Would it be acceptable to fix the naming/comments, and convert values
> above 126 to '?' in the current patchset, and address a more thorough=
 fix
> in another patch set?  The ARM and ARM64 EFI stub patchsets that are
> mostly complete depend on this one, so getting this merged soon would=
 be
> helpful.

I don't want to hinder your work, so what about putting in your version
as-is and fixing it later?

> > There's just one problem: which encoding to use, but
> > these days, most distributions have either dropped non-UTF8 or hard=
ly pay
> > lip service, so we could get away with hard-coding UTF-8: those few=
 who
> > use ancient charsets can stick to ASCII.

Not being able to use regular kernel facilities makes supporting ancien=
t
charsets a lost cause.  I'm so weeping about them... not.

> I would certainly appreciate your help improving this

Are we on the same page so far?  If so, I can make a patch atop yours.

--=20
=E1=9B=8A=E1=9A=A8=E1=9A=BE=E1=9B=81=E1=9B=8F=E1=9A=A3=E1=9B=AB=E1=9B=81=
=E1=9B=8A=E1=9B=AB=E1=9A=A0=E1=9B=9F=E1=9A=B1=E1=9B=AB=E1=9A=A6=E1=9B=96=
=E1=9B=AB=E1=9A=B9=E1=9B=96=E1=9A=A8=E1=9A=B2
