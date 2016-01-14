From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1 1/2] lib/string_helpers: export string_units_{2,10}
 for others
Date: Thu, 14 Jan 2016 11:45:05 +0200
Message-ID: <1452764705.2521.29.camel@linux.intel.com>
References: <1452604386-13673-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452604386-13673-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Elliott <elliott@hpe.com>, Matt Fleming <matt@codeblueprint.co.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2016-01-12 at 15:13 +0200, Andy Shevchenko wrote:
> There is one user coming which would like to use those string arrays.
> It might
> be useful for any other user in the future.

Please, comment on the idea, but discard both patches, I'm cooking
better approach.

>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> =C2=A0include/linux/string_helpers.h |=C2=A0=C2=A03 +++
> =C2=A0lib/string_helpers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0| 21 ++++++++++++---------
> =C2=A02 files changed, 15 insertions(+), 9 deletions(-)
>=20
> diff --git a/include/linux/string_helpers.h
> b/include/linux/string_helpers.h
> index dabe643..1d16240 100644
> --- a/include/linux/string_helpers.h
> +++ b/include/linux/string_helpers.h
> @@ -10,6 +10,9 @@ enum string_size_units {
> =C2=A0	STRING_UNITS_2,		/* use binary powers of 2^10
> */
> =C2=A0};
> =C2=A0
> +extern const char *const string_units_10[];
> +extern const char *const string_units_2[];
> +
> =C2=A0void string_get_size(u64 size, u64 blk_size, enum string_size_u=
nits
> units,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0char *buf, int len);
> =C2=A0
> diff --git a/lib/string_helpers.c b/lib/string_helpers.c
> index 5939f63..3a4c812 100644
> --- a/lib/string_helpers.c
> +++ b/lib/string_helpers.c
> @@ -13,6 +13,15 @@
> =C2=A0#include <linux/string.h>
> =C2=A0#include <linux/string_helpers.h>
> =C2=A0
> +const char * const string_units_10[] =3D {
> +	"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB",
> +};
> +EXPORT_SYMBOL(string_units_10);
> +const char * const string_units_2[] =3D {
> +	"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB",
> +};
> +EXPORT_SYMBOL(string_units_2);
> +
> =C2=A0/**
> =C2=A0 * string_get_size - get the size in the specified units
> =C2=A0 * @size:	The size to be converted in blocks
> @@ -29,15 +38,9 @@
> =C2=A0void string_get_size(u64 size, u64 blk_size, const enum
> string_size_units units,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0char *buf, int len)
> =C2=A0{
> -	static const char *const units_10[] =3D {
> -		"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
> -	};
> -	static const char *const units_2[] =3D {
> -		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB",
> "ZiB", "YiB"
> -	};
> =C2=A0	static const char *const *const units_str[] =3D {
> -		[STRING_UNITS_10] =3D units_10,
> -		[STRING_UNITS_2] =3D units_2,
> +		[STRING_UNITS_10] =3D string_units_10,
> +		[STRING_UNITS_2] =3D string_units_2,
> =C2=A0	};
> =C2=A0	static const unsigned int divisor[] =3D {
> =C2=A0		[STRING_UNITS_10] =3D 1000,
> @@ -92,7 +95,7 @@ void string_get_size(u64 size, u64 blk_size, const
> enum string_size_units units,
> =C2=A0	}
> =C2=A0
> =C2=A0 out:
> -	if (i >=3D ARRAY_SIZE(units_2))
> +	if (i >=3D ARRAY_SIZE(string_units_2))
> =C2=A0		unit =3D "UNK";
> =C2=A0	else
> =C2=A0		unit =3D units_str[units][i];

--=20
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
