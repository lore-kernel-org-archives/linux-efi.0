From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 01/15] Secure boot: Add new capability
Date: Mon, 28 Jan 2013 11:42:25 -0500
Message-ID: <1359391359-25783-2-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

Secure boot adds certain policy requirements, including that root must not
be able to do anything that could cause the kernel to execute arbitrary code.
The simplest way to handle this would seem to be to add a new capability
and gate various functionality on that. We'll then strip it from the initial
capability set if required.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 include/uapi/linux/capability.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index ba478fa..7109e650 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -343,7 +343,11 @@ struct vfs_cap_data {
 
 #define CAP_BLOCK_SUSPEND    36
 
-#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
+/* Allow things that trivially permit root to modify the running kernel */
+
+#define CAP_COMPROMISE_KERNEL  37
+
+#define CAP_LAST_CAP         CAP_COMPROMISE_KERNEL
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
-- 
1.8.0.2

