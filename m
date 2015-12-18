From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 2/4] efi: add NV memory attribute
Date: Thu, 17 Dec 2015 19:28:32 -0600
Message-ID: <1450402114-3606-3-git-send-email-elliott@hpe.com>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450402114-3606-1-git-send-email-elliott@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: matt@codeblueprint.co.uk, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Robert Elliott <elliott@hpe.com>
List-Id: linux-efi@vger.kernel.org

Add the NV memory attribute introduced in UEFI 2.5 and add a column
for it in the types and attributes string used when printing the UEFI
memory map.

old:
efi: mem61: [type=14            |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)

new:
efi: mem61: [type=14            |   |  |NV|  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)

Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 drivers/firmware/efi/efi.c | 5 ++++-
 include/linux/efi.h        | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 027ca21..4dd5464 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -611,13 +611,16 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
 	if (attr & ~(EFI_MEMORY_UC | EFI_MEMORY_WC | EFI_MEMORY_WT |
 		     EFI_MEMORY_WB | EFI_MEMORY_UCE | EFI_MEMORY_RO |
 		     EFI_MEMORY_WP | EFI_MEMORY_RP | EFI_MEMORY_XP |
+		     EFI_MEMORY_NV |
 		     EFI_MEMORY_RUNTIME | EFI_MEMORY_MORE_RELIABLE))
 		snprintf(pos, size, "|attr=0x%016llx]",
 			 (unsigned long long)attr);
 	else
-		snprintf(pos, size, "|%3s|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
+		snprintf(pos, size,
+			 "|%3s|%2s|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
 			 attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
 			 attr & EFI_MEMORY_MORE_RELIABLE ? "MR" : "",
+			 attr & EFI_MEMORY_NV      ? "NV"  : "",
 			 attr & EFI_MEMORY_XP      ? "XP"  : "",
 			 attr & EFI_MEMORY_RP      ? "RP"  : "",
 			 attr & EFI_MEMORY_WP      ? "WP"  : "",
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 569b5a8..9ce9e9e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -97,6 +97,7 @@ typedef	struct {
 #define EFI_MEMORY_WP		((u64)0x0000000000001000ULL)	/* write-protect */
 #define EFI_MEMORY_RP		((u64)0x0000000000002000ULL)	/* read-protect */
 #define EFI_MEMORY_XP		((u64)0x0000000000004000ULL)	/* execute-protect */
+#define EFI_MEMORY_NV		((u64)0x0000000000008000ULL)	/* non-volatile */
 #define EFI_MEMORY_MORE_RELIABLE \
 				((u64)0x0000000000010000ULL)	/* higher reliability */
 #define EFI_MEMORY_RO		((u64)0x0000000000020000ULL)	/* read-only */
-- 
2.4.3
