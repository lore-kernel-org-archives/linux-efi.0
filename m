From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/27] Enforce module signatures if the kernel is locked down
Date: Thu, 02 Nov 2017 17:22:36 +0000
Message-ID: <20240.1509643356@warthog.procyon.org.uk>
References: <1509130095.3716.13.camel@linux.vnet.ibm.com> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842465546.7923.6762214527898273559.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509130095.3716.13.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-ID: <20239.1509643356.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Mimi,

I've altered this patch to allow for IMA appraisal on finit_module().  See the
attached.

David
---
commit c0d5336356004e7543314e388755a00e725521da
Author: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Wed May 24 14:56:01 2017 +0100

    Enforce module signatures if the kernel is locked down
    
    If the kernel is locked down, require that all modules have valid
    signatures that we can verify or that IMA can validate the file.
    
    Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Reviewed-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
    Reviewed-by: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/kernel/module.c b/kernel/module.c
index de66ec825992..0ce29c8aa75a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -64,6 +64,7 @@
 #include <linux/bsearch.h>
 #include <linux/dynamic_debug.h>
 #include <linux/audit.h>
+#include <linux/ima.h>
 #include <uapi/linux/module.h>
 #include "module-internal.h"
 
@@ -2757,7 +2758,8 @@ static inline void kmemleak_load_module(const struct module *mod,
 #endif
 
 #ifdef CONFIG_MODULE_SIG
-static int module_sig_check(struct load_info *info, int flags)
+static int module_sig_check(struct load_info *info, int flags,
+			    bool can_do_ima_check)
 {
 	int err = -ENOKEY;
 	const unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
@@ -2781,13 +2783,16 @@ static int module_sig_check(struct load_info *info, int flags)
 	}
 
 	/* Not having a signature is only an error if we're strict. */
-	if (err == -ENOKEY && !sig_enforce)
+	if (err == -ENOKEY && !sig_enforce &&
+	    (!can_do_ima_check || !is_ima_appraise_enabled()) &&
+	    !kernel_is_locked_down("Loading of unsigned modules"))
 		err = 0;
 
 	return err;
 }
 #else /* !CONFIG_MODULE_SIG */
-static int module_sig_check(struct load_info *info, int flags)
+static int module_sig_check(struct load_info *info, int flags,
+			    bool can_do_ima_check)
 {
 	return 0;
 }
@@ -3630,13 +3635,13 @@ static int unknown_module_param_cb(char *param, char *val, const char *modname,
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static int load_module(struct load_info *info, const char __user *uargs,
-		       int flags)
+		       int flags, bool can_do_ima_check)
 {
 	struct module *mod;
 	long err;
 	char *after_dashes;
 
-	err = module_sig_check(info, flags);
+	err = module_sig_check(info, flags, can_do_ima_check);
 	if (err)
 		goto free_copy;
 
@@ -3830,7 +3835,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	if (err)
 		return err;
 
-	return load_module(&info, uargs, 0);
+	return load_module(&info, uargs, 0, false);
 }
 
 SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
@@ -3857,7 +3862,7 @@ SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
 	info.hdr = hdr;
 	info.len = size;
 
-	return load_module(&info, uargs, flags);
+	return load_module(&info, uargs, flags, true);
 }
 
 static inline int within(unsigned long addr, void *start, unsigned long size)
