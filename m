From: Adam Borowski <kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org>
Subject: Re: [PATCH 09/17] Move unicode to ASCII conversion to shared
 function.
Date: Thu, 19 Sep 2013 05:44:06 +0200
Message-ID: <20130919034406.GA26385@angband.pl>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
 <1379391093-27948-10-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1379391093-27948-10-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 16, 2013 at 09:11:25PM -0700, Roy Franz wrote:
> +/* Convert the unicode UEFI command line to ASCII to pass to kernel.
> + * Size of memory allocated return in *cmd_line_len.
> + * Returns NULL on error.
> + */
> +static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_ta=
ble_arg,

> +       int load_options_size =3D image->load_options_size / 2; /* AS=
CII */

> +	for (i =3D 0; i < options_size - 1; i++)
> +		*s1++ =3D *s2++;

I'm afraid both this commit and comments inside are misnamed.  What you=
're
changing here is the encoding rather than character set.

In fact, these days it's 8-bit encodings that are more likely to be Uni=
code
than 16-bit ones: UTF-8 is ubiquitous, while you usually get UCS2 at mo=
st.
In either case, though, we have here is a 7-bit charset encoded as eith=
er
8-bit or 16-bit units.  What this function does is blindly truncating u=
pper
byte.  The supported payload is in both cases ASCII.

I'd thus rename the function to what it already does: truncating u16 to=
 u8,
and adjust comments accordingly.

Replacing values above 126 with a token character like '?' would be goo=
d
too: that'd avoid producing corrupted characters and/or random ASCII ch=
ars.

Your commit only moves things around, so it might be out of scope for n=
ow,
but I wonder: what if the kernel actually supported Unicode here?  Few
cmdline arguments take values where non-ASCII makes sense, but at least=
 some
do: for example, a Russian guy is not unlikely to name subvolumes using
cyrillic.  Supporting that would be easy (estimating the length then
utf16s_to_utf8s()).  There's just one problem: which encoding to use, b=
ut
these days, most distributions have either dropped non-UTF8 or hardly p=
ay
lip service, so we could get away with hard-coding UTF-8: those few who
use ancient charsets can stick to ASCII.  Would this be ok?  If so, sho=
ut,
I can code this if you don't care enough.

--=20
=E1=9B=8A=E1=9A=A8=E1=9A=BE=E1=9B=81=E1=9B=8F=E1=9A=A3=E1=9B=AB=E1=9B=81=
=E1=9B=8A=E1=9B=AB=E1=9A=A0=E1=9B=9F=E1=9A=B1=E1=9B=AB=E1=9A=A6=E1=9B=96=
=E1=9B=AB=E1=9A=B9=E1=9B=96=E1=9A=A8=E1=9A=B2
