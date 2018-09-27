From: Maksym Kokhan <maksym.kokhan@globallogic.com>
Subject: [PATCH 1/8] add generic builtin command line
Date: Thu, 27 Sep 2018 19:55:09 +0300
Message-ID: <1538067309-5711-2-git-send-email-maksym.kokhan@globallogic.com>
References: <1538067309-5711-1-git-send-email-maksym.kokhan@globallogic.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1538067309-5711-1-git-send-email-maksym.kokhan@globallogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ralf Baechle <ralf@linux-mips.org>, Paul Burton <paul.burton@mips.com>, James Hogan <jhogan@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>
Cc: Daniel Walker <dwalker@fifo99.com>, Daniel Walker <danielwa@cisco.com>, Andrii Bordunov <aborduno@cisco.com>, Ruslan Bilovol <rbilovol@cisco.com>, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-efi@vger.kernel.org

From: Daniel Walker <danielwa@cisco.com>

This code allows architectures to use a generic builtin command line.
The state of the builtin command line options across architecture is
diverse. On x86 and mips they have pretty much the same code and the
code prepends the builtin command line onto the boot loader provided
one. On powerpc there is only a builtin override and nothing else.

The code in this commit unifies the mips and x86 code into a generic
header file under the CONFIG_GENERIC_CMDLINE option. When this
option is enabled the architecture can call the cmdline_add_builtin()
to add the builtin command line.

[maksym.kokhan@globallogic.com: fix cmdline_add_builtin() macro]
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Daniel Walker <danielwa@cisco.com>
Signed-off-by: Daniel Walker <danielwa@cisco.com>
Signed-off-by: Maksym Kokhan <maksym.kokhan@globallogic.com>
---
 include/linux/cmdline.h | 70 +++++++++++++++++++++++++++++++++++++++++++++++++
 init/Kconfig            | 68 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 138 insertions(+)
 create mode 100644 include/linux/cmdline.h

diff --git a/include/linux/cmdline.h b/include/linux/cmdline.h
new file mode 100644
index 0000000..75ef278
--- /dev/null
+++ b/include/linux/cmdline.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CMDLINE_H
+#define _LINUX_CMDLINE_H
+
+/*
+ *
+ * Copyright (C) 2015. Cisco Systems, Inc.
+ *
+ * Generic Append/Prepend cmdline support.
+ */
+
+#if defined(CONFIG_GENERIC_CMDLINE) && defined(CONFIG_CMDLINE_BOOL)
+
+#ifndef CONFIG_CMDLINE_OVERRIDE
+/*
+ * This function will append or prepend a builtin command line to the command
+ * line provided by the bootloader. Kconfig options can be used to alter
+ * the behavior of this builtin command line.
+ * @dest: The destination of the final appended/prepended string
+ * @src: The starting string or NULL if there isn't one.
+ * @tmp: temporary space used for prepending
+ * @length: the maximum length of the strings above.
+ */
+static inline void
+_cmdline_add_builtin(char *dest, char *src, char *tmp, unsigned long length)
+{
+	if (src != dest && src != NULL) {
+		strlcpy(dest, " ", length);
+		strlcat(dest, src, length);
+	}
+
+	strlcat(dest, " ", length);
+
+	if (sizeof(CONFIG_CMDLINE_APPEND) > 1)
+		strlcat(dest, CONFIG_CMDLINE_APPEND, length);
+
+	if (sizeof(CONFIG_CMDLINE_PREPEND) > 1) {
+		strlcpy(tmp, CONFIG_CMDLINE_PREPEND, length);
+		strlcat(tmp, " ", length);
+		strlcat(tmp, dest, length);
+		strlcpy(dest, tmp, length);
+	}
+}
+
+#define cmdline_add_builtin(dest, src, length)				    \
+{									    \
+	if (sizeof(CONFIG_CMDLINE_PREPEND) > 1) {			    \
+		static char cmdline_tmp_space[length] __initdata;	    \
+		_cmdline_add_builtin(dest, src, cmdline_tmp_space, length); \
+	} else {							    \
+		_cmdline_add_builtin(dest, src, NULL, length);		    \
+	}								    \
+}
+#else
+#define cmdline_add_builtin(dest, src, length)				   \
+{									   \
+	strlcpy(dest, CONFIG_CMDLINE_PREPEND " " CONFIG_CMDLINE_APPEND,    \
+		length);						   \
+}
+#endif /* !CONFIG_CMDLINE_OVERRIDE */
+
+#else
+#define cmdline_add_builtin(dest, src, length) { \
+	if (src != NULL)						   \
+		strlcpy(dest, src, length);				   \
+}
+#endif /* CONFIG_GENERIC_CMDLINE */
+
+
+#endif /* _LINUX_CMDLINE_H */
diff --git a/init/Kconfig b/init/Kconfig
index 1e234e2..e5aa676 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1751,6 +1751,74 @@ config PROFILING
 config TRACEPOINTS
 	bool
 
+config GENERIC_CMDLINE
+	bool
+
+if GENERIC_CMDLINE
+
+config CMDLINE_BOOL
+	bool "Built-in kernel command line"
+	help
+	  Allow for specifying boot arguments to the kernel at
+	  build time.  On some systems (e.g. embedded ones), it is
+	  necessary or convenient to provide some or all of the
+	  kernel boot arguments with the kernel itself (that is,
+	  to not rely on the boot loader to provide them.)
+
+	  To compile command line arguments into the kernel,
+	  set this option to 'Y', then fill in the
+	  the boot arguments in CONFIG_CMDLINE.
+
+	  Systems with fully functional boot loaders (i.e. non-embedded)
+	  should leave this option set to 'N'.
+
+config CMDLINE_APPEND
+	string "Built-in kernel command string append"
+	depends on CMDLINE_BOOL
+	default ""
+	help
+	  Enter arguments here that should be compiled into the kernel
+	  image and used at boot time.  If the boot loader provides a
+	  command line at boot time, this string is appended to it to
+	  form the full kernel command line, when the system boots.
+
+	  However, you can use the CONFIG_CMDLINE_OVERRIDE option to
+	  change this behavior.
+
+	  In most cases, the command line (whether built-in or provided
+	  by the boot loader) should specify the device for the root
+	  file system.
+
+config CMDLINE_PREPEND
+	string "Built-in kernel command string prepend"
+	depends on CMDLINE_BOOL
+	default ""
+	help
+	  Enter arguments here that should be compiled into the kernel
+	  image and used at boot time.  If the boot loader provides a
+	  command line at boot time, this string is prepended to it to
+	  form the full kernel command line, when the system boots.
+
+	  However, you can use the CONFIG_CMDLINE_OVERRIDE option to
+	  change this behavior.
+
+	  In most cases, the command line (whether built-in or provided
+	  by the boot loader) should specify the device for the root
+	  file system.
+
+config CMDLINE_OVERRIDE
+	bool "Built-in command line overrides boot loader arguments"
+	depends on CMDLINE_BOOL
+	help
+	  Set this option to 'Y' to have the kernel ignore the boot loader
+	  command line, and use ONLY the built-in command line. In this case
+	  append and prepend strings are concatenated to form the full
+	  command line.
+
+	  This is used to work around broken boot loaders.  This should
+	  be set to 'N' under normal conditions.
+endif
+
 endmenu		# General setup
 
 source "arch/Kconfig"
-- 
2.7.4
