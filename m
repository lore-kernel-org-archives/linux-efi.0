From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v8 RESEND 06/38] x86/mm: Add Secure Memory Encryption (SME)
	support
Date: Tue, 27 Jun 2017 10:08:24 -0500
Message-ID: <20170627150824.17428.98358.stgit@tlendack-t1.amdoffice.net>
References: <20170627150718.17428.81813.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170627150718.17428.81813.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add support for Secure Memory Encryption (SME). This initial support
provides a Kconfig entry to build the SME support into the kernel and
defines the memory encryption mask that will be used in subsequent
patches to mark pages as encrypted.

Reviewed-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/Kconfig                   |   25 +++++++++++++++++++++++++
 arch/x86/include/asm/mem_encrypt.h |   30 ++++++++++++++++++++++++++++++
 arch/x86/mm/Makefile               |    1 +
 arch/x86/mm/mem_encrypt.c          |   21 +++++++++++++++++++++
 include/linux/mem_encrypt.h        |   35 +++++++++++++++++++++++++++++++++++
 5 files changed, 112 insertions(+)
 create mode 100644 arch/x86/include/asm/mem_encrypt.h
 create mode 100644 arch/x86/mm/mem_encrypt.c
 create mode 100644 include/linux/mem_encrypt.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 72028a1..3a59e9c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1409,6 +1409,31 @@ config X86_DIRECT_GBPAGES
 	  supports them), so don't confuse the user by printing
 	  that we have them enabled.
 
+config ARCH_HAS_MEM_ENCRYPT
+	def_bool y
+
+config AMD_MEM_ENCRYPT
+	bool "AMD Secure Memory Encryption (SME) support"
+	depends on X86_64 && CPU_SUP_AMD
+	---help---
+	  Say yes to enable support for the encryption of system memory.
+	  This requires an AMD processor that supports Secure Memory
+	  Encryption (SME).
+
+config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
+	bool "Activate AMD Secure Memory Encryption (SME) by default"
+	default y
+	depends on AMD_MEM_ENCRYPT
+	---help---
+	  Say yes to have system memory encrypted by default if running on
+	  an AMD processor that supports Secure Memory Encryption (SME).
+
+	  If set to Y, then the encryption of system memory can be
+	  deactivated with the mem_encrypt=off command line option.
+
+	  If set to N, then the encryption of system memory can be
+	  activated with the mem_encrypt=on command line option.
+
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
new file mode 100644
index 0000000..a105796
--- /dev/null
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -0,0 +1,30 @@
+/*
+ * AMD Memory Encryption Support
+ *
+ * Copyright (C) 2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __X86_MEM_ENCRYPT_H__
+#define __X86_MEM_ENCRYPT_H__
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+
+extern unsigned long sme_me_mask;
+
+#else	/* !CONFIG_AMD_MEM_ENCRYPT */
+
+#define sme_me_mask	0UL
+
+#endif	/* CONFIG_AMD_MEM_ENCRYPT */
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* __X86_MEM_ENCRYPT_H__ */
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 0fbdcb6..a94a7b6 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -39,3 +39,4 @@ obj-$(CONFIG_X86_INTEL_MPX)	+= mpx.o
 obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS) += pkeys.o
 obj-$(CONFIG_RANDOMIZE_MEMORY) += kaslr.o
 
+obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt.o
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
new file mode 100644
index 0000000..b99d469
--- /dev/null
+++ b/arch/x86/mm/mem_encrypt.c
@@ -0,0 +1,21 @@
+/*
+ * AMD Memory Encryption Support
+ *
+ * Copyright (C) 2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+
+/*
+ * Since SME related variables are set early in the boot process they must
+ * reside in the .data section so as not to be zeroed out when the .bss
+ * section is later cleared.
+ */
+unsigned long sme_me_mask __section(.data) = 0;
+EXPORT_SYMBOL_GPL(sme_me_mask);
diff --git a/include/linux/mem_encrypt.h b/include/linux/mem_encrypt.h
new file mode 100644
index 0000000..59769f7
--- /dev/null
+++ b/include/linux/mem_encrypt.h
@@ -0,0 +1,35 @@
+/*
+ * AMD Memory Encryption Support
+ *
+ * Copyright (C) 2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MEM_ENCRYPT_H__
+#define __MEM_ENCRYPT_H__
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
+
+#include <asm/mem_encrypt.h>
+
+#else	/* !CONFIG_ARCH_HAS_MEM_ENCRYPT */
+
+#define sme_me_mask	0UL
+
+#endif	/* CONFIG_ARCH_HAS_MEM_ENCRYPT */
+
+static inline bool sme_active(void)
+{
+	return !!sme_me_mask;
+}
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* __MEM_ENCRYPT_H__ */
