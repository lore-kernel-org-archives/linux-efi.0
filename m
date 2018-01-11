From: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 08a/30] kexec_file: split KEXEC_VERIFY_SIG into KEXEC_SIG and
 KEXEC_SIG_FORCE
Date: Thu, 11 Jan 2018 13:01:57 +0100
Message-ID: <20180111120157.23qceywzi6omvvkb@dwarf.suse.cz>
References: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
 <151024869793.28329.4817577607302613028.stgit@warthog.procyon.org.uk>
 <20180111115915.dejachty3l7fwpmf@dwarf.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180111115915.dejachty3l7fwpmf-Q+Z4OdfSLAKN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is a preparatory patch for kexec lockdown. A locked down kernel needs to
prevent unsigned kernel images to be loaded with kexec_file_load. Currently,
the only way to force the signature verification is compiling with
KEXEC_VERIFY_SIG. This prevents loading usigned images even when the kernel is
not locked down at runtime.

This patch spilts KEXEC_VERIFY_SIG into KEXEC_SIG and KEXEC_SIG_FORCE.
Analogous to the MODULE_SIG and MODULE_SIG_FORCE for modules, KEXEC_SIG turns
on the signature verification but allows unsigned images to be loaded.
KEXEC_SIG_FORCE disallows images without a valid signature.

Signed-off-by: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8eed3f94bfc7..f25facb0df96 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1951,20 +1951,28 @@ config KEXEC_FILE
 	  for kernel and initramfs as opposed to list of segments as
 	  accepted by previous system call.
 
-config KEXEC_VERIFY_SIG
+config KEXEC_SIG
 	bool "Verify kernel signature during kexec_file_load() syscall"
 	depends on KEXEC_FILE
 	---help---
-	  This option makes kernel signature verification mandatory for
-	  the kexec_file_load() syscall.
+	  This option makes the kexec_file_load() syscall check for a valid
+	  signature of the kernel image. The image can still be loaded without
+	  a valid signature unless you also enable KEXEC_SIG_FORCE.
 
-	  In addition to that option, you need to enable signature
+	  In addition to this option, you need to enable signature
 	  verification for the corresponding kernel image type being
 	  loaded in order for this to work.
 
+config KEXEC_SIG_FORCE
+	bool "Require a valid signature in kexec_file_load() syscall"
+	depends on KEXEC_SIG
+	---help---
+	  This option makes kernel signature verification mandatory for
+	  the kexec_file_load() syscall.
+
 config KEXEC_BZIMAGE_VERIFY_SIG
 	bool "Enable bzImage signature verification support"
-	depends on KEXEC_VERIFY_SIG
+	depends on KEXEC_SIG
 	depends on SIGNED_PE_FILE_VERIFICATION
 	select SYSTEM_TRUSTED_KEYRING
 	---help---
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 1f790cf9d38f..3fbe35b923ef 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -406,7 +406,7 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 	return image->fops->cleanup(image->image_loader_data);
 }
 
-#ifdef CONFIG_KEXEC_VERIFY_SIG
+#ifdef CONFIG_KEXEC_SIG
 int arch_kexec_kernel_verify_sig(struct kimage *image, void *kernel,
 				 unsigned long kernel_len)
 {
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index f16f6ceb3875..19652372f3ee 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -121,7 +121,7 @@ typedef void *(kexec_load_t)(struct kimage *image, char *kernel_buf,
 			     unsigned long cmdline_len);
 typedef int (kexec_cleanup_t)(void *loader_data);
 
-#ifdef CONFIG_KEXEC_VERIFY_SIG
+#ifdef CONFIG_KEXEC_SIG
 typedef int (kexec_verify_sig_t)(const char *kernel_buf,
 				 unsigned long kernel_len);
 #endif
@@ -130,7 +130,7 @@ struct kexec_file_ops {
 	kexec_probe_t *probe;
 	kexec_load_t *load;
 	kexec_cleanup_t *cleanup;
-#ifdef CONFIG_KEXEC_VERIFY_SIG
+#ifdef CONFIG_KEXEC_SIG
 	kexec_verify_sig_t *verify_sig;
 #endif
 };
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -45,7 +45,7 @@ int __weak arch_kimage_file_post_load_cleanup(struct kimage *image)
 	return -EINVAL;
 }
 
-#ifdef CONFIG_KEXEC_VERIFY_SIG
+#ifdef CONFIG_KEXEC_SIG
 int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 					unsigned long buf_len)
 {
@@ -116,7 +116,7 @@ kimage_file_prepare_segments(struct kimage *image, int kernel_fd, int initrd_fd,
 			     const char __user *cmdline_ptr,
 			     unsigned long cmdline_len, unsigned flags)
 {
-	int ret = 0;
+	int ret = 0, sig_err = -EPERM;
 	void *ldata;
 	loff_t size;
 
@@ -135,15 +135,20 @@ kimage_file_prepare_segments(struct kimage *image, int kernel_fd, int initrd_fd,
 	if (ret)
 		goto out;
 
-#ifdef CONFIG_KEXEC_VERIFY_SIG
-	ret = arch_kexec_kernel_verify_sig(image, image->kernel_buf,
+#ifdef CONFIG_KEXEC_SIG
+	sig_err = arch_kexec_kernel_verify_sig(image, image->kernel_buf,
 					   image->kernel_buf_len);
-	if (ret) {
+	if (sig_err)
 		pr_debug("kernel signature verification failed.\n");
+	else
+		pr_debug("kernel signature verification successful.\n");
+#endif
+
+	if (sig_err && IS_ENABLED(CONFIG_KEXEC_SIG_FORCE)) {
+		ret = sig_err;
 		goto out;
 	}
-	pr_debug("kernel signature verification successful.\n");
-#endif
+
 	/* It is possible that there no initramfs is being loaded */
 	if (!(flags & KEXEC_FILE_NO_INITRAMFS)) {
 		ret = kernel_read_file_from_fd(initrd_fd, &image->initrd_buf,
-- 
Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, Prague, Czechia
