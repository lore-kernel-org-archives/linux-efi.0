From: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 01/10] Add secure_modules() call
Date: Thu, 29 Aug 2013 11:01:46 -0400
Message-ID: <20130829150146.GR20828@hansolo.jdub.homelinux.org>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
 <1376933171-9854-2-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1376933171-9854-2-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 19, 2013 at 01:26:02PM -0400, Matthew Garrett wrote:
> Provide a single call to allow kernel code to determine whether the system
> has been configured to either disable module loading entirely or to load
> only modules signed with a trusted key.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/module.h | 7 +++++++
>  kernel/module.c        | 9 +++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 46f1ea0..0c266b2 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -509,6 +509,8 @@ int unregister_module_notifier(struct notifier_block * nb);
>  
>  extern void print_modules(void);
>  
> +extern bool secure_modules(void);
> +
>  #else /* !CONFIG_MODULES... */
>  
>  /* Given an address, look for it in the exception tables. */
> @@ -619,6 +621,11 @@ static inline int unregister_module_notifier(struct notifier_block * nb)
>  static inline void print_modules(void)
>  {
>  }
> +
> +static inline bool secure_modules(void)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_MODULES */
>  
>  #ifdef CONFIG_SYSFS
> diff --git a/kernel/module.c b/kernel/module.c
> index 2069158..801021e 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3852,3 +3852,12 @@ void module_layout(struct module *mod,
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

Needs an EXPORT_SYMBOL/EXPORT_SYMBOL_GPL here, or the patches to drivers
later in the series will fail to link.

josh
