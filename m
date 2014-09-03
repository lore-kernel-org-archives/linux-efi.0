From: Laszlo Ersek <lersek@redhat.com>
Subject: [PATCH v2 1/5] efi: add macro for EFI_MEMORY_UCE memory attribute
Date: Wed,  3 Sep 2014 13:32:19 +0200
Message-ID: <1409743943-16934-2-git-send-email-lersek@redhat.com>
References: <1409743943-16934-1-git-send-email-lersek@redhat.com>
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <1409743943-16934-1-git-send-email-lersek@redhat.com>
Sender: linux-ia64-owner@vger.kernel.org
To: mingo@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-ia64@vger.kernel.org, matt.fleming@intel.com, msalter@redhat.com, lersek@redhat.com
List-Id: linux-efi@vger.kernel.org

Add the following macro from the UEFI spec, for completeness:

  EFI_MEMORY_UCE  Memory cacheability attribute: The memory region
                  supports being configured as not cacheable, exported,
                  and supports the "fetch and add" semaphore mechanism.

Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 include/linux/efi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 45cb4ff..b4b1d8d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -92,6 +92,7 @@ typedef	struct {
 #define EFI_MEMORY_WC		((u64)0x0000000000000002ULL)	/* write-coalescing */
 #define EFI_MEMORY_WT		((u64)0x0000000000000004ULL)	/* write-through */
 #define EFI_MEMORY_WB		((u64)0x0000000000000008ULL)	/* write-back */
+#define EFI_MEMORY_UCE		((u64)0x0000000000000010ULL)	/* uncached, exported */
 #define EFI_MEMORY_WP		((u64)0x0000000000001000ULL)	/* write-protect */
 #define EFI_MEMORY_RP		((u64)0x0000000000002000ULL)	/* read-protect */
 #define EFI_MEMORY_XP		((u64)0x0000000000004000ULL)	/* execute-protect */
-- 
1.8.3.1


