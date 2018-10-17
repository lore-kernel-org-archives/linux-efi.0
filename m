From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: [PATCH v9 1/8] x86/boot: Introduce cmdline_find_option_arg()to detect if option=arg in cmdline
Date: Wed, 17 Oct 2018 18:20:05 +0800
Message-ID: <20181017102012.872-2-fanc.fnst@cn.fujitsu.com>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com
Cc: indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com, fanc.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

Introduce a new function cmdline_find_option_arg() to detect whether
option is in command line and the value is arg.

Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
---
 arch/x86/boot/compressed/cmdline.c | 15 +++++++++++++++
 arch/x86/boot/compressed/misc.h    |  1 +
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
index af6cda0b7900..61118c69feb8 100644
--- a/arch/x86/boot/compressed/cmdline.c
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "misc.h"
+#define STATIC
+#include <linux/decompress/mm.h>
 
 #if CONFIG_EARLY_PRINTK || CONFIG_RANDOMIZE_BASE || CONFIG_X86_5LEVEL
 
@@ -30,5 +32,18 @@ int cmdline_find_option_bool(const char *option)
 {
 	return __cmdline_find_option_bool(get_cmd_line_ptr(), option);
 }
+bool cmdline_find_option_arg(const char *option, const char *arg, int argsize)
+{
+	char *buffer = malloc(argsize+1);
+	bool find = false;
+	int ret;
+
+	ret = cmdline_find_option(option, buffer, argsize+1);
+	if (ret == argsize && !strncmp(buffer, arg, argsize))
+		find = true;
+
+	free(buffer);
+	return find;
+}
 
 #endif
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index a1d5918765f3..008fdc47a29c 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -67,6 +67,7 @@ static inline void debug_puthex(const char *s)
 /* cmdline.c */
 int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
+bool cmdline_find_option_arg(const char *option, const char *arg, int argsize);
 #endif
 
 
-- 
2.17.2
