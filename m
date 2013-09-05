From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH V3 09/11] uswsusp: Disable when module loading is
 restricted
Date: Thu, 05 Sep 2013 11:20:26 +0800
Message-ID: <1378351226.6380.84.camel@linux-s257.site>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-10-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378252218-18798-10-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-09-03 =E6=96=BC 19:50 -0400=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> uswsusp allows a user process to dump and then restore kernel state, =
which
> makes it possible to avoid module loading restrictions. Prevent this =
when
> any restrictions have been imposed on loading modules.
>=20
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>

Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>

> ---
>  kernel/power/user.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index 4ed81e7..15cb72f 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -24,6 +24,7 @@
>  #include <linux/console.h>
>  #include <linux/cpu.h>
>  #include <linux/freezer.h>
> +#include <linux/module.h>
> =20
>  #include <asm/uaccess.h>
> =20
> @@ -48,6 +49,9 @@ static int snapshot_open(struct inode *inode, struc=
t file *filp)
>  	struct snapshot_data *data;
>  	int error;
> =20
> +	if (secure_modules())
> +		return -EPERM;
> +
>  	lock_system_sleep();
> =20
>  	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {

Thanks
Joey Lee
