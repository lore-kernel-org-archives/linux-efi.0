From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH V3 01/11] Add secure_modules() call
Date: Thu, 05 Sep 2013 10:14:18 +0800
Message-ID: <1378347258.6380.77.camel@linux-s257.site>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-2-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378252218-18798-2-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-09-03 =E6=96=BC 19:50 -0400=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> Provide a single call to allow kernel code to determine whether the s=
ystem
> has been configured to either disable module loading entirely or to l=
oad
> only modules signed with a trusted key.
>=20
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>

Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>

> ---
>  include/linux/module.h |  7 +++++++
>  kernel/module.c        | 10 ++++++++++
>  2 files changed, 17 insertions(+)
>=20
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 46f1ea0..0c266b2 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -509,6 +509,8 @@ int unregister_module_notifier(struct notifier_bl=
ock * nb);
> =20
>  extern void print_modules(void);
> =20
> +extern bool secure_modules(void);
> +
>  #else /* !CONFIG_MODULES... */
> =20
>  /* Given an address, look for it in the exception tables. */
> @@ -619,6 +621,11 @@ static inline int unregister_module_notifier(str=
uct notifier_block * nb)
>  static inline void print_modules(void)
>  {
>  }
> +
> +static inline bool secure_modules(void)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_MODULES */
> =20
>  #ifdef CONFIG_SYSFS
> diff --git a/kernel/module.c b/kernel/module.c
> index 2069158..0e94acf 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3852,3 +3852,13 @@ void module_layout(struct module *mod,
>  }
>  EXPORT_SYMBOL(module_layout);
>  #endif
> +
> +bool secure_modules(void)
> +{
> +#ifdef CONFIG_MODULE_SIG
> +	return (sig_enforce || modules_disabled);
> +#else
> +	return modules_disabled;
> +#endif
> +}
> +EXPORT_SYMBOL(secure_modules);
