From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH 1/2] efi: add a function for transferring status to string
Date: Fri, 22 Mar 2019 18:33:49 +0800
Message-ID: <20190322103350.27764-1-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@fedoraproject.org>, Nayna Jain <nayna@linux.ibm.com>, Mimi Zohar <zohar@linux.ibm.com>
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Kees Cook <keescook@chromium.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-Id: linux-efi@vger.kernel.org

This function can be used to transfer EFI status code to string
for printing out debug message. Using this function can improve
the readability of log.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
---
 include/linux/efi.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 54357a258b35..a43cb0dc37af 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1768,4 +1768,32 @@ struct linux_efi_memreserve {
 #define EFI_MEMRESERVE_COUNT(size) (((size) - sizeof(struct linux_efi_memreserve)) \
 	/ sizeof(((struct linux_efi_memreserve *)0)->entry[0]))
 
+#define EFI_STATUS_STR(_status) \
+case EFI_##_status: \
+	return "EFI_" __stringify(_status);
+
+static inline char *
+efi_status_to_str(efi_status_t status)
+{
+	switch (status) {
+	EFI_STATUS_STR(SUCCESS)
+	EFI_STATUS_STR(LOAD_ERROR)
+	EFI_STATUS_STR(INVALID_PARAMETER)
+	EFI_STATUS_STR(UNSUPPORTED)
+	EFI_STATUS_STR(BAD_BUFFER_SIZE)
+	EFI_STATUS_STR(BUFFER_TOO_SMALL)
+	EFI_STATUS_STR(NOT_READY)
+	EFI_STATUS_STR(DEVICE_ERROR)
+	EFI_STATUS_STR(WRITE_PROTECTED)
+	EFI_STATUS_STR(OUT_OF_RESOURCES)
+	EFI_STATUS_STR(NOT_FOUND)
+	EFI_STATUS_STR(ABORTED)
+	EFI_STATUS_STR(SECURITY_VIOLATION)
+	default:
+		pr_warn("Unknown efi status: 0x%lx", status);
+	}
+
+	return "Unknown efi status";
+}
+
 #endif /* _LINUX_EFI_H */
-- 
2.16.4
