From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: Distinguish between "remaining space" and
 actually used space
Date: Mon, 01 Apr 2013 16:50:46 +0100
Message-ID: <1364831446.3557.98.camel@deadeye.wl.decadent.org.uk>
References: <515150EC.7040203@redhat.com>
	 <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
	 <1364829240-26475-2-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JuGlKJRtdSSVii/R+sts"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364829240-26475-2-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--=-JuGlKJRtdSSVii/R+sts
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-04-01 at 11:14 -0400, Matthew Garrett wrote:
> EFI implementations distinguish between space that is actively used by a
> variable and space that merely hasn't been garbage collected yet. Space
> that hasn't yet been garbage collected isn't available for use and so isn=
't
> counted in the remaining_space field returned by QueryVariableInfo().
>=20
> Combined with commit 68d9298 this can cause problems. Some implementation=
s
> don't garbage collect until the remaining space is smaller than the maxim=
um
> variable size, and as a result check_var_size() will always fail once mor=
e
> than 50% of the variable store has been used even if most of that space i=
s
> marked as available for garbage collection. The user is unable to create
> new variables, and deleting variables doesn't increase the remaining spac=
e.
>=20
> The problem that 68d9298 was attempting to avoid was one where certain
> platforms fail if the actively used space is greater than 50% of the
> available storage space. We should be able to calculate that by simply
> summing the size of each available variable and subtracting that from
> the total storage space. With luck this will fix the problem described in
> https://bugzilla.kernel.org/show_bug.cgi?id=3D55471 without permitting
> damage to occur to the machines 68d9298 was attempting to fix.
>=20
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efivars.c | 41 ++++++++++++++++++++++++++++++++++++++--=
-
>  1 file changed, 38 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 60e7d8f..a6d8a58 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
[...]
> @@ -452,8 +462,33 @@ check_var_size_locked(struct efivars *efivars, u32 a=
ttributes,
>  	if (status !=3D EFI_SUCCESS)
>  		return status;
> =20
> -	if (!storage_size || size > remaining_size || size > max_size ||
> -	    (remaining_size - size) < (storage_size / 2))
> +	list_for_each_entry(entry, &efivars->list, list) {
> +		var =3D &entry->var;
> +		status =3D get_var_data_locked(efivars, var);
> +
> +		if (status || !(var->Attributes & EFI_VARIABLE_NON_VOLATILE))
> +			continue;
> +
> +		active_size +=3D var->DataSize;
> +		active_size +=3D utf16_strsize(var->VariableName, 1024);
> +		/*
> +		 * There's some additional metadata associated with each
> +		 * variable. Intel's reference implementation is 60 bytes -
> +		 * bump that to 128 to account for vendor additions and
> +		 * potential alignment constraints
> +		 */
> +		active_size +=3D 128;
> +	}
> +
> +	/*
> +	 * Add on the size of any boot services-only variables
> +	 */
> +	active_size +=3D boot_var_size;
> +
> +	active_available =3D storage_size - active_size;
> +
> +	if (!storage_size || size > remaining_size ||
> +	    (active_available - size) < (storage_size / 2))
>  		return EFI_OUT_OF_RESOURCES;

Both substractions here could quite possibly underflow due to
over-estimation of active_size.

We can rearrange the condition to be:

	active_size + size > storage_size / 2

and delete the active_available variable.  But I think metadata for the
new variable should be accounted as well:

	active_size + size + 128 > storage_size / 2

Since we'll now be using that magic number twice, it needs a name.

Ben.

>  	return status;

--=20
Ben Hutchings
DNRC Motto:  I can please only one person per day.
Today is not your day.  Tomorrow isn't looking good either.

--=-JuGlKJRtdSSVii/R+sts
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUVms1ue/yOyVhhEJAQqUMw/+PB2TyVlnZ5ItosMmxLrB+bOyJ4+i+FpE
oPONrawP48WLC2JDVofk6O8zO5NAWnHrATc9M3LUxu9QtXYUecg45/lsSTl/ta7d
qq5HVzy3gl7AD9myx8He3K9fMrGiWMAvTOmF/HDAvQHILqw+x3e7rb/K2DF9BYBC
cglHaPMOmUbjo59JcY6tMLejMIIrESmyAgtl2qJmjP7t3QS5ufeXxvCJ3GScnV+O
cB80Y1YYRhPja9WkBvOtmNeb5eTpYqd88t0il6RNJC1lPIAqkV36x6QMeFC2ebmL
gy0H7nF0SnPdsXI/eTCBJMPDdSNZJiTKEgXvLWVJ7g6ms/ivbJ1aZ5c3uUb+StvV
gfWUsegymGu0HJaDbXyFxBBFLr72f0MzjTN6CsQLaVDYn92f/+jqLZDX8DlRsVR+
4/LhOTPitwZgjKM9Cu8UnkL+g66KVrpybp8Tw5WVAh+91wAx6lmt4a1681sJU0dX
5dCjRS7Mi/yCQzYzOshSYLji7mC0D1fJ6maLCqzBmWz4Ta6LhZQGl9D7IahZrMTA
ygMXhUYQwuUjzLRB9vlznFwsGG/qclScZ1aDfkMQhD5xPYBdHTKecH/X1ENvvu1m
o9zdYb+rY5gkoSm6CuPjdXyEZz/kWVf0Utz8TCX0IvfW6j3N9NUIfjmzrifz3sJW
LP/Mjs8jNqU=
=eOag
-----END PGP SIGNATURE-----

--=-JuGlKJRtdSSVii/R+sts--
