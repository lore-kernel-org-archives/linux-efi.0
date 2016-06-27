From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/7] efi: Convert efi_call_virt to efi_call_virt_pointer
Date: Mon, 27 Jun 2016 13:00:50 +0200
Message-ID: <20160627110050.GB9099@gmail.com>
References: <1466839230-12781-1-git-send-email-matt@codeblueprint.co.uk>
 <1466839230-12781-5-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466839230-12781-5-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> +#define efi_call_virt_pointer(p, f, args...)				\
> +({									\
> +	efi_status_t __s;						\
> +	unsigned long flags;						\
> +									\
> +	arch_efi_call_virt_setup();					\
> +									\
> +	local_save_flags(flags);					\
> +	__s = arch_efi_call_virt(p, f, args);				\
> +	efi_call_virt_check_flags(flags, __stringify(f));		\
> +									\
> +	arch_efi_call_virt_teardown();					\
> +									\
> +	__s;								\
> +})
> +
> +#define __efi_call_virt_pointer(p, f, args...)				\
> +({									\
> +	unsigned long flags;						\
> +									\
> +	arch_efi_call_virt_setup();					\
> +									\
> +	local_save_flags(flags);					\
> +	arch_efi_call_virt(p, f, args);					\
> +	efi_call_virt_check_flags(flags, __stringify(f));		\
> +									\
> +	arch_efi_call_virt_teardown();					\
> +})

Note that while at it I renamed 'flags' to '__flags' because 'flags' is
a commonly used variable name and the 'efi_status_t __s' variable was
macro-prefixed already.

Any objections?

Thanks,

	Ingo
