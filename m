From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/16] kexec: Disable at runtime if the kernel is locked down
Date: Wed, 16 Nov 2016 21:48:07 +0000
Message-ID: <147933288742.19316.17308231278815492742.stgit@warthog.procyon.org.uk>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Matthew Garrett <matthew.garrett@nebula.com>

kexec permits the loading and execution of arbitrary code in ring 0, which
is something that lock-down is meant to prevent. It makes sense to disable
kexec in this situation.

This does not affect kexec_file_load() which can check for a signature on the
image to be booted.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/kexec.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 980936a90ee6..c6aa4620d1bf 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/file.h>
 #include <linux/kexec.h>
+#include <linux/security.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/syscalls.h>
@@ -194,6 +195,13 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 		return -EPERM;
 
 	/*
+	 * kexec can be used to circumvent module loading restrictions, so
+	 * prevent loading in that case
+	 */
+	if (kernel_is_locked_down())
+		return -EPERM;
+
+	/*
 	 * Verify we have a legal set of flags
 	 * This leaves us room for future extensions.
 	 */
