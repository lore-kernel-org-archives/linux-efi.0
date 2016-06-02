From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/3] Convert efi_call_virt to efi_call_virt_generic
Date: Thu, 2 Jun 2016 16:41:14 +0100
Message-ID: <20160602154114.GI2658@codeblueprint.co.uk>
References: <1463598701-178201-1-git-send-email-athorlton@sgi.com>
 <1463598701-178201-2-git-send-email-athorlton@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463598701-178201-2-git-send-email-athorlton@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, x86@kernel.org, linux-efi@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 18 May, at 02:11:39PM, Alex Thorlton wrote:
> This commit makes a few slight modifications to the efi_call_virt mac=
ro
> to get it to work with function pointers that are stored in locations
> other than efi.systab->runtime, and renames the macro to
> efi_call_virt_generic.  The majority of the changes here are to pull
> these macros up into header files so that they can be accessed from
> outside of drivers/firmware/efi/runtime-wrappers.c.
>=20
> The most significant change not directly related to the code move is =
to
> add an extra "p" argument into the appropriate efi_call macros, and u=
se
> that new argument in place of the, formerly hard-coded,
> efi.systab->runtime pointer.
>=20
> The last piece of the puzzle was to add an efi_call_virt macro back i=
nto
> drivers/firmware/efi/runtime-wrappers.c to wrap around the new
> efi_call_virt_generic macro - this was mainly to keep the code from
> looking too cluttered by adding a bunch of extra references to
> efi.systab->runtime everywhere.
>=20
> Note that I also broke up the code in the efi_call_virt_generic macro=
 a
> bit in the process of moving it.
>=20
> Signed-off-by: Alex Thorlton <athorlton@sgi.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Mike Travis <travis@sgi.com>
> Cc: Russ Anderson <rja@sgi.com>
> Cc: Dimitri Sivanich <sivanich@sgi.com>
> Cc: x86@kernel.org
> Cc: linux-efi@vger.kernel.org
> ---
>  arch/x86/include/asm/efi.h              |  4 +--
>  drivers/firmware/efi/runtime-wrappers.c | 53 +++++++----------------=
----------
>  include/linux/efi.h                     | 51 +++++++++++++++++++++++=
++++++++
>  3 files changed, 63 insertions(+), 45 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 78d1e74..f310f0b 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -81,8 +81,8 @@ struct efi_scratch {
>  	}								\
>  })
> =20
> -#define arch_efi_call_virt(f, args...)					\
> -	efi_call((void *)efi.systab->runtime->f, args)			\
> +#define arch_efi_call_virt(p, f, args...)					\
> +	efi_call((void *)p->f, args)			\
> =20
>  #define arch_efi_call_virt_teardown()					\
>  ({									\

Oops, you're missing updates to the 32-bit version and ARM/arm64,
which results in this,

drivers/firmware/efi/runtime-wrappers.c: In function =E2=80=98virt_efi_=
get_time=E2=80=99:
arch/x86/include/asm/efi.h:46:4: error: =E2=80=98efi_efi=E2=80=99 undec=
lared (first use in this function)
  ((efi_##f##_t __attribute__((regparm(0)))*)   \
    ^

but that's easily fixed up.

> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmwa=
re/efi/runtime-wrappers.c
> index 23bef6b..e8bc493 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -22,7 +22,16 @@
>  #include <linux/stringify.h>
>  #include <asm/efi.h>
> =20
> -static void efi_call_virt_check_flags(unsigned long flags, const cha=
r *call)
> +/*
> + * Wrap around the new efi_call_virt_generic macros so that the
> + * code doesn't get too cluttered
> + */
> +#define efi_call_virt(f, args...)   \
> +	efi_call_virt_generic(efi.systab->runtime, f, args)
> +#define __efi_call_virt(f, args...) \
> +	__efi_call_virt_generic(efi.systab->runtime, f, args)
> +
> +void efi_call_virt_check_flags(unsigned long flags, const char *call=
)
>  {
>  	unsigned long cur_flags, mismatch;
> =20

I'm not crazy about using "generic" in the name. How about
efi_call_virt_function() or efi_call_virt_pointer()?
