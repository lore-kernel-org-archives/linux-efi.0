From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 8 Feb 2013 11:18:54 -0800
Message-ID: <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
References: <20130208191213.GA25081@www.outflux.net>
	<00780235-deac-4f80-b936-867834e05661@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00780235-deac-4f80-b936-867834e05661-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

No. CAP_RAWIO is for reading. Writing needs a much stronger check.

-Kees

On Fri, Feb 8, 2013 at 11:17 AM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
> We already have CAP_RAWIO for this in mainline; I am not sure if this should be harder than that...
>
> Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>
>>Writing to MSRs should not be allowed unless CAP_COMPROMISE_KERNEL is
>>set since it could lead to execution of arbitrary code in kernel mode.
>>
>>Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>---
>>This would be used on top of Matthew Garrett's existing "Secure boot
>>policy support" patch series.
>>---
>> arch/x86/kernel/msr.c |    7 +++++++
>> 1 file changed, 7 insertions(+)
>>
>>diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
>>index 4929502..adaab3d 100644
>>--- a/arch/x86/kernel/msr.c
>>+++ b/arch/x86/kernel/msr.c
>>@@ -103,6 +103,9 @@ static ssize_t msr_write(struct file *file, const
>>char __user *buf,
>>       int err = 0;
>>       ssize_t bytes = 0;
>>
>>+      if (!capable(CAP_COMPROMISE_KERNEL))
>>+              return -EPERM;
>>+
>>       if (count % 8)
>>               return -EINVAL; /* Invalid chunk size */
>>
>>@@ -150,6 +153,10 @@ static long msr_ioctl(struct file *file, unsigned
>>int ioc, unsigned long arg)
>>                       err = -EBADF;
>>                       break;
>>               }
>>+              if (!capable(CAP_COMPROMISE_KERNEL)) {
>>+                      err = -EPERM;
>>+                      break;
>>+              }
>>               if (copy_from_user(&regs, uregs, sizeof regs)) {
>>                       err = -EFAULT;
>>                       break;
>
> --
> Sent from my mobile phone. Please excuse brevity and lack of formatting.



--
Kees Cook
Chrome OS Security
