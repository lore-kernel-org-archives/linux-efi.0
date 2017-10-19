From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 02/27] Add a SysRq option to lift kernel lockdown
Date: Thu, 19 Oct 2017 10:20:26 -0700
Message-ID: <97659d0c-6992-3025-0f85-819d23e954cc@infradead.org>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842464774.7923.7951986297563109339.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <150842464774.7923.7951986297563109339.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/19/17 07:50, David Howells wrote:
> From: Kyle McMartin <kyle-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Make an option to provide a sysrq key that will lift the kernel lockdown,
> thereby allowing the running kernel image to be accessed and modified.
> 
> On x86_64 this is triggered with SysRq+x, but this key may not be available
> on all arches, so it is set by setting LOCKDOWN_LIFT_KEY in asm/setup.h.
> 
> Signed-off-by: Kyle McMartin <kyle-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> ---
> 
>  arch/x86/include/asm/setup.h |    2 ++
>  drivers/input/misc/uinput.c  |    1 +
>  drivers/tty/sysrq.c          |   19 +++++++++++------
>  include/linux/input.h        |    5 ++++
>  include/linux/sysrq.h        |    8 ++++++-
>  kernel/debug/kdb/kdb_main.c  |    2 +-
>  security/Kconfig             |   15 +++++++++++++
>  security/lock_down.c         |   48 ++++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 92 insertions(+), 8 deletions(-)

> diff --git a/security/Kconfig b/security/Kconfig
> index 8e01fd59ae7e..4be6be71e075 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -213,6 +213,21 @@ config LOCK_DOWN_KERNEL
>  	  turns off various features that might otherwise allow access to the
>  	  kernel image (eg. setting MSR registers).
>  
> +config ALLOW_LOCKDOWN_LIFT
> +	bool
> +	help
> +	  Allow the lockdown on a kernel to be lifted, thereby restoring the
> +	  ability of userspace to access the kernel image (eg. by SysRq+x under

how about:                                                                on

> +	  x86).
> +
> +config ALLOW_LOCKDOWN_LIFT_BY_SYSRQ
> +	bool "Allow the kernel lockdown to be lifted by SysRq"
> +	depends on MAGIC_SYSRQ
> +	help
> +	  Allow the lockdown on a kernel to be lifted, by pressing a SysRq key
> +	  combination on a wired keyboard.
> +
> +
>  source security/selinux/Kconfig
>  source security/smack/Kconfig
>  source security/tomoyo/Kconfig
> diff --git a/security/lock_down.c b/security/lock_down.c
> index d8595c0e6673..f71118c340d2 100644
> --- a/security/lock_down.c
> +++ b/security/lock_down.c


> +
> +/*
> + * Allow lockdown to be lifted by pressing something like SysRq+x (and not by
> + * echoing the appropriate letter into the sysrq-trigger file).
> + */
> +#ifdef CONFIG_ALLOW_LOCKDOWN_LIFT_BY_KEY

is that the same as: CONFIG_ALLOW_LOCKDOWN_LIFT_BY_SYSRQ ?
tested?

> +
> +static void sysrq_handle_lockdown_lift(int key)
> +{
> +	if (kernel_locked_down)
> +		lift_kernel_lockdown();
> +}
> +
> +static struct sysrq_key_op lockdown_lift_sysrq_op = {
> +	.handler	= sysrq_handle_lockdown_lift,
> +	.help_msg	= "unSB(x)",
> +	.action_msg	= "Disabling Secure Boot restrictions",
> +	.enable_mask	= SYSRQ_DISABLE_USERSPACE,
> +};
> +
> +static int __init lockdown_lift_sysrq(void)
> +{
> +	if (kernel_locked_down) {
> +		lockdown_lift_sysrq_op.help_msg[5] = LOCKDOWN_LIFT_KEY;
> +		register_sysrq_key(LOCKDOWN_LIFT_KEY, &lockdown_lift_sysrq_op);
> +	}
> +	return 0;
> +}
> +
> +late_initcall(lockdown_lift_sysrq);
> +
> +#endif /* CONFIG_ALLOW_LOCKDOWN_LIFT_BY_KEY */

                                        BY_SYSRQ


-- 
~Randy
