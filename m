From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] Print the actual UEFI error name, not just the error
 code.
Date: Thu, 23 May 2013 12:06:53 -0700
Message-ID: <1369336013.2075.47.camel@joe-AO722>
References: <1369334231-11100-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369334231-11100-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-05-23 at 14:37 -0400, Peter Jones wrote:
> EFI error numbers are useful, but symbol names are way easier to
> understand when you're reading bug reports.  And since, for the most
> part, we know the names, we should show them.
[]
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
[]
> +#define efi_pr_warn(status, fmt, ...) ({				\
> +		typeof(status) __status = EFI_REVERSE_ERROR(status);	\
> +		if (__status >= 0 &&					\
> +				__status <= EFI_REVERSE_ERROR(EFI_MAX_ERROR))\
> +			pr_warn(fmt ": %s (0x%lx)\n", ## __VA_ARGS__,	\
> +				efi_error_strings[__status], __status);	\
> +		else							\
> +			pr_warn(fmt ": 0x%lx\n", ## __VA_ARGS__, __status);\
> +	})

This doubles the number of formats (and code size text) used.

Please don't remove trailing newlines from these sorts
of messages.  

I think a function to return "unknown efi error" would be
acceptable and these should become something like:

const char *efi_error_string(unsigned long status)
{
	if (status <= EFI_REVERSE_ERROR(EFI_MAX_ERROR))
		return efi_error_strings[status];
	return "unknown efi error";
}

and the uses something like:

> -		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
> -			status);
--
	pr_warn("set_variable() failed: %s (%lx)\n",
		efi_error_string(status), status);

(with #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt)
