From: Lenny Szubowicz <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/10] ACPI: Limit access to custom_method
Date: Thu, 29 Aug 2013 13:58:43 -0400 (EDT)
Message-ID: <359147196.9759429.1377799123451.JavaMail.root@redhat.com>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com> <1376928619-3775-4-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376928619-3775-4-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org


----- Original Message -----
> From: "Matthew Garrett" <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, "Matthew Garrett"
> <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> Sent: Monday, August 19, 2013 12:10:13 PM
> Subject: [PATCH 04/10] ACPI: Limit access to custom_method
> 
> custom_method effectively allows arbitrary access to system memory, making
> it possible for an attacker to circumvent restrictions on module loading.
> Disable it if any such restrictions have been enabled.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/acpi/custom_method.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
> index 12b62f2..55a013f 100644
> --- a/drivers/acpi/custom_method.c
> +++ b/drivers/acpi/custom_method.c
> @@ -7,6 +7,7 @@
>  #include <linux/kernel.h>
>  #include <linux/uaccess.h>
>  #include <linux/debugfs.h>
> +#include <linux/module.h>
>  #include <acpi/acpi_drivers.h>
>  
>  #include "internal.h"
> @@ -29,6 +30,9 @@ static ssize_t cm_write(struct file *file, const char
> __user * user_buf,
>  	struct acpi_table_header table;
>  	acpi_status status;
>  
> +	if (secure_modules())
> +		return -EPERM;
> +
>  	if (!(*ppos)) {
>  		/* parse the table header to get the table length */
>  		if (count <= sizeof(struct acpi_table_header))
> --
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Nit: Don't add a second include of linux/module.h.

                      -Lenny.
