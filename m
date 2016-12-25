From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 01/16] Add the ability to lock down access to the running
 kernel image
Date: Sun, 25 Dec 2016 22:20:24 +0100
Message-ID: <20161225212023.GB26891@amd>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <147933284407.19316.17886320817060158597.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147933284407.19316.17886320817060158597.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> allow the running kernel image to be changed including the loading of
> modules that aren't validly signed with a key we recognise, fiddling with
> MSR registers and disallowing hibernation,

"." at EOL.

> @@ -158,6 +158,21 @@ config HARDENED_USERCOPY_PAGESPAN
>  	  been removed. This config is intended to be used only while
>  	  trying to find such users.
> =20
> +config LOCK_DOWN_KERNEL
> +	bool "Allow the kernel to be 'locked down'"

Locked down, or 'locked down' ? :-).

> +	help
> +	  Allow the kernel to be locked down under certain circumstances, for
> +	  instance if UEFI secure boot is enabled.  Locking down the kernel
> +	  turns off various features that might otherwise allow access to the
> +	  kernel image (eg. setting MSR registers).

I'd add something that clarifies it is "running" kernel image.

> +config ALLOW_LOCKDOWN_LIFT
> +	bool

Don't you need to add 'bool "something"' so that user can actually
select this?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhgOBcACgkQMOfwapXb+vKUHwCcC/sI631Gn8yGMMSFBaAS98It
RCkAn2kNtLwn1E599rruRRMBGohOy7fM
=d8SE
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
