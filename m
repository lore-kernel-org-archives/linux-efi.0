From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 14/24] x86: Restrict MSR access when the kernel is locked down
Date: Wed, 5 Apr 2017 10:34:20 -0700
Message-ID: <CAGXu5jJoyPWnh6cu5D1xNjt8o3QTsYPJ5Z02U2t1NkmZf+7Yow@mail.gmail.com>
References: <149141219387.31282.6648284836568938717.stgit@warthog.procyon.org.uk>
 <149141232449.31282.15045536717220570492.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <149141232449.31282.15045536717220570492.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 5, 2017 at 10:12 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
>
> Writing to MSRs should not be allowed if the kernel is locked down, since
> it could lead to execution of arbitrary code in kernel mode.  Based on a
> patch by Kees Cook.
>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

-Kees

> ---
>
>  arch/x86/kernel/msr.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
> index ef688804f80d..fbcce028e502 100644
> --- a/arch/x86/kernel/msr.c
> +++ b/arch/x86/kernel/msr.c
> @@ -84,6 +84,9 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
>         int err = 0;
>         ssize_t bytes = 0;
>
> +       if (kernel_is_locked_down())
> +               return -EPERM;
> +
>         if (count % 8)
>                 return -EINVAL; /* Invalid chunk size */
>
> @@ -131,6 +134,10 @@ static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
>                         err = -EBADF;
>                         break;
>                 }
> +               if (kernel_is_locked_down()) {
> +                       err = -EPERM;
> +                       break;
> +               }
>                 if (copy_from_user(&regs, uregs, sizeof regs)) {
>                         err = -EFAULT;
>                         break;
>



-- 
Kees Cook
Pixel Security
