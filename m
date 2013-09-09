From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/12] Add BSD-style securelevel support
Date: Mon, 09 Sep 2013 09:27:08 -0700
Message-ID: <522DF6DC.1050303@zytor.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com> <1378741786-18430-2-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378741786-18430-2-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 09/09/2013 08:49 AM, Matthew Garrett wrote:
> Provide a coarse-grained runtime configuration option for restricting
> userspace's ability to modify the running kernel.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/security/securelevel.txt |  23 +++++++
>  include/linux/security.h               |   8 +++
>  security/Kconfig                       |   8 +++
>  security/Makefile                      |   1 +
>  security/securelevel.c                 | 116 +++++++++++++++++++++++++++++++++
>  5 files changed, 156 insertions(+)
>  create mode 100644 Documentation/security/securelevel.txt
>  create mode 100644 security/securelevel.c
> 
> diff --git a/Documentation/security/securelevel.txt b/Documentation/security/securelevel.txt
> new file mode 100644
> index 0000000..a1355a0
> --- /dev/null
> +++ b/Documentation/security/securelevel.txt
> @@ -0,0 +1,23 @@
> +Linux securelevel interface
> +---------------------------
> +
> +The Linux securelevel interface (inspired by the BSD securelevel interface)
> +is a runtime mechanism for configuring coarse-grained kernel-level security
> +restrictions. It provides a runtime configuration variable at
> +/sys/kernel/security/securelevel which can be written to by root. The
> +following values are supported:
> +
> +-1: Permanently insecure mode. This level is equivalent to level 0, but once
> +    set cannot be changed.
> +
> +0:  Insecure mode (default). This level imposes no additional kernel
> +    restrictions.
> +
> +1:  Secure mode. If set, userspace will be unable to perform direct access
> +    to PCI devices, port IO access, access system memory directly via
> +    /dev/mem and /dev/kmem, perform kexec_load(), use the userspace
> +    software suspend mechanism, insert new ACPI code at runtime via the
> +    custom_method interface or modify CPU MSRs (on x86). Certain drivers
> +    may also limit additional interfaces.
> +

This will break or have to be redefined once you have signed kexec.

	-hpa
