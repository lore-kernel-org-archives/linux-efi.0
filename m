From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/27] x86/msr: Restrict MSR access when the kernel is locked down
Date: Mon, 23 Oct 2017 15:49:44 +0100
Message-ID: <21023.1508770184@warthog.procyon.org.uk>
References: <20171020190939.569cedd2@alans-desktop> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842472452.7923.2592278090192179002.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020190939.569cedd2@alans-desktop>
Content-ID: <21022.1508770184.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, jlee-IBi9RG/b67k@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org> wrote:

> There are a load of standard tools that use this so I think you are going
> to need a whitelist. Can you at least log *which* MSR in the failing case
> so a whitelist can be built over time ?

Will the attached change work for you?

David
---
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index a05a97863286..f18cadbc31ce 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -84,8 +84,10 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
 	int err = 0;
 	ssize_t bytes = 0;
 
-	if (kernel_is_locked_down("Direct MSR access"))
+	if (kernel_is_locked_down("Direct MSR access")) {
+		pr_info("Direct access to MSR %x\n", reg);
 		return -EPERM;
+	}
 
 	if (count % 8)
 		return -EINVAL;	/* Invalid chunk size */
@@ -135,6 +137,7 @@ static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
 			break;
 		}
 		if (kernel_is_locked_down("Direct MSR access")) {
+			pr_info("Direct access to MSR %x\n", reg[1]); /* Display %ecx */
 			err = -EPERM;
 			break;
 		}
