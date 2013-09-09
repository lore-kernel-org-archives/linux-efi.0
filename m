From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 08/12] kexec: Disable at runtime if securelevel has been set.
Date: Mon,  9 Sep 2013 11:49:42 -0400
Message-ID: <1378741786-18430-9-git-send-email-matthew.garrett@nebula.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org, jmorris@namei.org, linux-security-module@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

kexec permits the loading and execution of arbitrary code in ring 0, which
permits the modification of the running kernel. Prevent this if securelevel
has been set.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 kernel/kexec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 59f7b55..98db2a1 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -32,6 +32,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/syscore_ops.h>
+#include <linux/security.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -942,6 +943,9 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 	if (!capable(CAP_SYS_BOOT))
 		return -EPERM;
 
+	if (get_securelevel() > 0)
+		return -EPERM;
+
 	/*
 	 * Verify we have a legal set of flags
 	 * This leaves us room for future extensions.
-- 
1.8.3.1
