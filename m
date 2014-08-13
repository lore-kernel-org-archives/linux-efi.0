From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] firmware: Do not use WARN_ON(!spin_is_locked())
Date: Wed, 13 Aug 2014 16:44:58 +0200
Message-ID: <20140813144458.GS9918@twins.programming.kicks-ass.net>
References: <1407729253-31341-1-git-send-email-linux@roeck-us.net>
 <20140813141836.GQ15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j6qW74gxMbs4kZr8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140813141836.GQ15082-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--j6qW74gxMbs4kZr8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 03:18:36PM +0100, Matt Fleming wrote:
> On Sun, 10 Aug, at 08:54:13PM, Guenter Roeck wrote:
> > spin_is_locked() always returns false for uniprocessor configurations,
> > so do not use WARN_ON with it. WARN_ON_SMP() exists for that very
> > purpose and must be used instead.
> =20
>=20
> How about lockdep_assert_held()? That seems to be much more popular.

lockdep_assert_held() not only checks if the lock is taken, it also
verifies its taken by the current context, so its a stronger assertion.

And, as a bonus, it doesn't emit _any_ code on a !DEBUG build ;-)

--j6qW74gxMbs4kZr8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT63nqAAoJEHZH4aRLwOS61CUP/jfEpSu6EkWaeDTUPnXCr0Gz
yohcSD0bISzfQgI0kA39hQCPwCDoe5lxz/u1Rgu7zOucltZTUfzqJR3JbsVQGlJa
rHV7fgkvw9RHERwzaAYEgYl1TDmT3W38v6haeVIt5r32B/E1CATuddvp72kB6M25
G0UQugAYEfcrw684Co6EtfehGvdz5t+sK5sFp5B5hD6NptA5tH5vI5TTw3puQ6jH
Th3FI894CD68WkJStKsgb0faXz3zx6OfJEU75rA76u9Y/EHzSK7y3T2Pv2msW7cF
bVtDa4C0/wRv4lWwjOtGXs7GSxSEzya+ErpXV6O+1+eqdBHGiSFEMbH1bTt5/TNu
zuHzCTbjtJodD6IxtEDhL6oSz+cArsqMxvtOoRpGaN8Mb2/b46SFsSETBWhe8O6S
YCVpDFuIzvuEnsMu6PVLxEpCsx0iISbXjaBbJf5/pOcDZPIiHZysXw+yx8+cwtSo
JNI30QnGWHl/9XcwkZ4Mxi8op0P1DlvItV4rW5Uz3c87NDAB31MFCGMIoag0aDXY
rn5NiIbgO9EaojCJ1nUzQwzVuqpTaFMe+WK7bHivs3ALaJmKlerRsCG9THiZ8QnP
35lyIZ66qoiDF/2oYorXJJD6kXyvoiGScpLb3X1GG6D8TVmcjO7VeWJitRGoIfN0
Qnffsp6nrEAv4SYzbfYu
=pzKI
-----END PGP SIGNATURE-----

--j6qW74gxMbs4kZr8--
