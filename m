From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Determine how much space is used by boot
 services-only variables
Date: Mon, 01 Apr 2013 16:42:47 +0100
Message-ID: <1364830967.3557.90.camel@deadeye.wl.decadent.org.uk>
References: <515150EC.7040203@redhat.com>
	 <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Axxx66Hgs5PL/rHcoQYJ"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364829240-26475-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--=-Axxx66Hgs5PL/rHcoQYJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-04-01 at 11:13 -0400, Matthew Garrett wrote:
> EFI variables can be flagged as being accessible only within boot service=
s.
> This makes it awkward for us to figure out how much space they use at
> runtime. In theory we could figure this out by simply comparing the resul=
ts
> from QueryVariableInfo() to the space used by all of our variables, but
> that fails if the platform doesn't garbage collect on every boot. Thankfu=
lly,
> calling QueryVariableInfo() while still inside boot services gives a more
> reliable answer. This patch passes that information from the EFI boot stu=
b
> up to the efivars code, letting us calculate a reasonably accurate value.

Good thinking.

> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
[...]
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -71,6 +71,10 @@ static efi_system_table_t efi_systab __initdata;
> =20
>  unsigned long x86_efi_facility;
> =20
> +u64 efi_var_store_size;
> +u64 efi_var_remaining_size;
> +u64 efi_var_max_var_size;
[...]
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
[...]
> @@ -2133,6 +2158,10 @@ efivars_init(void)
>  	ops.get_next_variable =3D efi.get_next_variable;
>  	ops.query_variable_info =3D efi.query_variable_info;
> =20
> +#ifdef CONFIG_X86
> +	boot_used_size =3D efi_var_store_size - efi_var_remaining_size;
> +#endif

efivars can be built as a module, but these aren't exported.

Ben.

>  	error =3D register_efivars(&__efivars, &ops, efi_kobj);
>  	if (error)
>  		goto err_put;

--=20
Ben Hutchings
DNRC Motto:  I can please only one person per day.
Today is not your day.  Tomorrow isn't looking good either.

--=-Axxx66Hgs5PL/rHcoQYJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUVmq9+e/yOyVhhEJAQpZTg/+J0pfOg26xDd8udCaG3lzcp4ESRmdTImZ
YxCKkP24f1xnLSJWgB6THAmLSAnIFJAxm0hvt+pMo4vMCtaC/o1Or/Z3xzRdaqJo
nYzl8eY7U4cv4rMhwN/BvVCanJi4HqPlEA8fcB59kjeJMUpQkVW23MojsvuNEZ5S
T9UjLbtnxxcs8ZH0xNxgDCFyFWTzKL1wPHcUvLgpzA2RFz/72ikSKdUmAXvdzXZx
omMP9ogg4U+/WahFhNq8qTIAV+tGvu3YiVPoH+iwoZlgLwna9uTb3tOv1emkUReD
r2AcgW6W3FWgL/BvbAGaq8gtj0CW6xqqkcCVuTQt5NxEfs19oEM6/dUaLWFeWlcA
P4c6zwv2WQ8tIm3PqTuB4tHxOaDLnXJ8ajAn6WTxtnUkgxS+npM5sBBQayp4RcYV
P/ftjwszkm/3HVSRZOraIVJF4v8Gsx34lIe7BQZbd6XUSYvQ9jpDBnF4dKKSIvnm
ufnJrFqBjx9n/NHneBgyGiQvXj7rxBerd7qNxgS0H+PmYk+1W02/r5/t4zpXt1Of
p8sIsaht4c+bU5a91vgpb2kJwryovrJl5Pe+xUTEvYGSqNR8Lh+bbWv7ecR/OtDF
NQfoB6rw3LR6ZzFe+kpOmZfWwHQANzjnp4KBrWl5u3hBxtmzlZKKdC4S7NtfQcds
Abfn4W1764U=
=BTKV
-----END PGP SIGNATURE-----

--=-Axxx66Hgs5PL/rHcoQYJ--
