From: Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Mon, 09 Sep 2013 13:18:44 -0400
Message-ID: <19562.1378747124@turing-police.cc.vt.edu>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1378747124_1775P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Your message of "Mon, 09 Sep 2013 11:49:34 -0400."
             <1378741786-18430-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

--==_Exmh_1378747124_1775P
Content-Type: text/plain; charset=us-ascii

On Mon, 09 Sep 2013 11:49:34 -0400, Matthew Garrett said:

> So, this is my final attempt at providing the functionality I'm interested
> in without inherently tying it to Secure Boot. There's strong parallels
> between the functionality that I'm interested in and the BSD securelevel
> interface, so here's a trivial implementation.

Although all the individual patches look like sane and reasonable things
to do, I'm not at all convinced that sticking them all under control of one
flag is really the right way to do it.  In particular, there probably needs
to be some re-thinking of the kexec, signed-module, and secure-boot stuff,
as it's still a moving target.

> So, this is my final attempt at providing the functionality I'm interested
> in without inherently tying it to Secure Boot.

You may as well bite the bullet on this one, and tie it together.  Without
Secure Boot, by the time your code runs it's already too late.  That's the
whole point of Secure Boot, after all.

--==_Exmh_1378747124_1775P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUi4C8wdmEQWDXROgAQLVEBAAtkNSnNCYkHDRZJYPQGPLfT89WkYWZweL
S36AojErYjA5uRhro8JxWthZ2tt2LoB+1EDwyhPmAVxsr40z48tehtpqfMpzIABN
A+GDtdudo2kB5HS9LzTuO2N9f03Vert1/mbF7th9XfoSde2iQpPap3jYvLS5bkBA
Wn29EsRQ/Er3rN5+TKRbUjNjlZJz8vuqBEh7vwnvV9VCox3L/bmAwYfM22pMrP7j
rQfpyNq0bR7IxJPxapFuB6ispdwgBiHB+XMgJoSi17FGei9BilpSCVVXcEdD+YVJ
dfCQItk9gK7IZ+/M+mHqWgVQI/ISakWD2AKMPtUVa+cXDne9kRYRGC4YifOVvTyA
kpTXBd37RWvInK+l+LAxyOkko3nps0UfuShbA7W19IYqOGbh1aDQ3zAV5gKaP1Xy
qK6Jvmhc4JLMp9v5Gj1zFXHV3+1DyGLciPgYvC3lXgmXsA0duZAx1bE3ovVm9uu8
/nQ1wbFmMzrssMgK2A4vyqqPWMsyzA1IGH/eU6N5Mp7i1HYw4jhthdiD+SPCOG/D
uQh/xMTRk+hqqOxfCqohhyHoKz3SfRni1Ka5xhf8+IU++wgBSDLlS0D8DZU1jfx3
ZPrwJHLsRqkYdgxifRIS+aTgjQY2+7V2jUHGQPV6uShv69JtWw76DAPsWCGcTPT1
zzuXcyuUuTY=
=bWJx
-----END PGP SIGNATURE-----

--==_Exmh_1378747124_1775P--
