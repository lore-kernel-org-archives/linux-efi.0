From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 08 Feb 2013 11:17:24 -0800
Message-ID: <00780235-deac-4f80-b936-867834e05661@email.android.com>
References: <20130208191213.GA25081@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20130208191213.GA25081@www.outflux.net>
Sender: linux-security-module-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <matthew.garrett@nebula.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

We already have CAP_RAWIO for this in mainline; I am not sure if this should be harder than that...

Kees Cook <keescook@chromium.org> wrote:

>Writing to MSRs should not be allowed unless CAP_COMPROMISE_KERNEL is
>set since it could lead to execution of arbitrary code in kernel mode.
>
>Signed-off-by: Kees Cook <keescook@chromium.org>
>---
>This would be used on top of Matthew Garrett's existing "Secure boot
>policy support" patch series.
>---
> arch/x86/kernel/msr.c |    7 +++++++
> 1 file changed, 7 insertions(+)
>
>diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
>index 4929502..adaab3d 100644
>--- a/arch/x86/kernel/msr.c
>+++ b/arch/x86/kernel/msr.c
>@@ -103,6 +103,9 @@ static ssize_t msr_write(struct file *file, const
>char __user *buf,
> 	int err = 0;
> 	ssize_t bytes = 0;
> 
>+	if (!capable(CAP_COMPROMISE_KERNEL))
>+		return -EPERM;
>+
> 	if (count % 8)
> 		return -EINVAL;	/* Invalid chunk size */
> 
>@@ -150,6 +153,10 @@ static long msr_ioctl(struct file *file, unsigned
>int ioc, unsigned long arg)
> 			err = -EBADF;
> 			break;
> 		}
>+		if (!capable(CAP_COMPROMISE_KERNEL)) {
>+			err = -EPERM;
>+			break;
>+		}
> 		if (copy_from_user(&regs, uregs, sizeof regs)) {
> 			err = -EFAULT;
> 			break;

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
