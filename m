From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v6 08/14] efi: export efi runtime memory mapping to sysfs
Date: Mon, 16 Dec 2013 15:09:29 +0000
Message-ID: <20131216150929.GA3873@console-pimps.org>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
 <1387186235-15972-9-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1387186235-15972-9-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 16 Dec, at 05:30:29PM, Dave Young wrote:
> @@ -899,6 +928,11 @@ void __init efi_enter_virtual_mode(void)
>  		return;
>  	}
>  
> +#ifdef CONFIG_EFI_RUNTIME_MAP
> +	efi_runtime_map_setup(efi_runtime_map, nr_efi_runtime_map,
> +			      boot_params.efi_info.efi_memdesc_size);
> +#endif

[...]

> @@ -167,6 +167,12 @@ static int __init efisubsys_init(void)
>  		goto err_unregister;
>  	}
>  
> +#ifdef CONFIG_EFI_RUNTIME_MAP
> +	error = efi_runtime_map_init(efi_kobj);
> +	if (error)
> +		goto err_remove_group;
> +#endif

[...]

> @@ -876,4 +876,9 @@ int efivars_sysfs_init(void);
>  
>  #endif /* CONFIG_EFI_VARS */
>  
> +#ifdef CONFIG_EFI_RUNTIME_MAP
> +int efi_runtime_map_init(struct kobject *);
> +void efi_runtime_map_setup(void *, int, u32);
> +#endif

I was thinking more along the lines of...

---

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 120086820654..fd5a0aad1fff 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -928,10 +928,8 @@ void __init efi_enter_virtual_mode(void)
 		return;
 	}
 
-#ifdef CONFIG_EFI_RUNTIME_MAP
 	efi_runtime_map_setup(efi_runtime_map, nr_efi_runtime_map,
 			      boot_params.efi_info.efi_memdesc_size);
-#endif
 
 	BUG_ON(!efi.systab);
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 4109dca787dc..4753bac65279 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -167,11 +167,9 @@ static int __init efisubsys_init(void)
 		goto err_unregister;
 	}
 
-#ifdef CONFIG_EFI_RUNTIME_MAP
 	error = efi_runtime_map_init(efi_kobj);
 	if (error)
 		goto err_remove_group;
-#endif
 
 	/* and the standard mountpoint for efivarfs */
 	efivars_kobj = kobject_create_and_add("efivars", efi_kobj);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index a98eb0621583..e64540746c63 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -875,6 +875,14 @@ int efivars_sysfs_init(void);
 #ifdef CONFIG_EFI_RUNTIME_MAP
 int efi_runtime_map_init(struct kobject *);
 void efi_runtime_map_setup(void *, int, u32);
+#else
+static inline int efi_runtime_map_init(struct kobject *kobj)
+{
+	return 0;
+}
+
+static inline void
+efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size) {}
 #endif
 
 #endif /* _LINUX_EFI_H */

-- 
Matt Fleming, Intel Open Source Technology Center
