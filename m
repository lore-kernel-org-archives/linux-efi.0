From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/27] Restrict /dev/mem and /dev/kmem when the kernel is locked down
Date: Mon, 23 Oct 2017 15:34:18 +0100
Message-ID: <18778.1508769258@warthog.procyon.org.uk>
References: <150842466261.7923.14359746674406637357.stgit@warthog.procyon.org.uk> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <150842466261.7923.14359746674406637357.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Content-ID: <18777.1508769258.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

I think I should replace this patch with the attached.  This will prevent
/dev/mem, /dev/kmem and /dev/port from being *opened*, and thereby preventing
read, write and ioctl.

David
---
commit e68daa2256986932b9a7d6709cf9e24b30d93583
Author: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Date:   Wed May 24 14:56:02 2017 +0100

    Restrict /dev/{mem,kmem,port} when the kernel is locked down
    
    Allowing users to read and write to core kernel memory makes it possible
    for the kernel to be subverted, avoiding module loading restrictions, and
    also to steal cryptographic information.
    
    Disallow /dev/mem and /dev/kmem from being opened this when the kernel has
    been locked down to prevent this.
    
    Also disallow /dev/port from being opened to prevent raw ioport access and
    thus DMA from being used to accomplish the same thing.
    
    Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Reviewed-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 593a8818aca9..0ce5ac0a5c6b 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -762,6 +762,8 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
 
 static int open_port(struct inode *inode, struct file *filp)
 {
+	if (kernel_is_locked_down("/dev/mem,kmem,port"))
+		return -EPERM;
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
 }
 
