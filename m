From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v7 3/3] x86: Make the GDT remapping read-only on 64-bit
Date: Tue, 14 Mar 2017 22:04:24 +0100
Message-ID: <20170314210424.GA5023@amd>
References: <20170314170508.100882-1-thgarnie@google.com>
 <20170314170508.100882-3-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170314170508.100882-3-thgarnie@google.com>
Sender: owner-linux-mm@kvack.org
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Lorenzo Stoakes <lstoakes@gmail.com>, Kees Cook <keescook@chromium.org>, Juergen Gross <jgross@suse.com>, Andy Lutomirski <luto@kernel.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, zijun_hu <zijun_hu@htc.com>, Chris Wilson <chris@chris-wilson.co.uk>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rusty
List-Id: linux-efi@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-03-14 10:05:08, Thomas Garnier wrote:
> This patch makes the GDT remapped pages read-only to prevent corruption.
> This change is done only on 64-bit.
>=20
> The native_load_tr_desc function was adapted to correctly handle a
> read-only GDT. The LTR instruction always writes to the GDT TSS entry.
> This generates a page fault if the GDT is read-only. This change checks
> if the current GDT is a remap and swap GDTs as needed. This function was
> tested by booting multiple machines and checking hibernation works
> properly.
>=20
> KVM SVM and VMX were adapted to use the writeable GDT. On VMX, the
> per-cpu variable was removed for functions to fetch the original GDT.
> Instead of reloading the previous GDT, VMX will reload the fixmap GDT as
> expected. For testing, VMs were started and restored on multiple
> configurations.
>=20
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Can we get the same change for 32-bit, too? Growing differences
between 32 and 64 bit are a bit of a problem...
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljIWtgACgkQMOfwapXb+vIlbQCgw3SF2oZqnpnzX74DsEZIUg8l
i4AAn0LNA1S1APtp1QrB07wudB48v9VL
=mc0C
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
