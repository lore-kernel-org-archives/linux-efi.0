From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 12/14] efi: Add NV memory attribute
Date: Mon,  1 Feb 2016 22:07:06 +0000
Message-ID: <1454364428-494-13-git-send-email-matt@codeblueprint.co.uk>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Robert Elliott <elliott@hpe.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>, Laszlo Ersek <lersek@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Robert Elliott <elliott@hpe.com>

Add the NV memory attribute introduced in UEFI 2.5 and add a column
for it in the types and attributes string used when printing the UEFI
memory map.

old:
efi: mem61: [type=14            |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)

new:
efi: mem61: [type=14            |   |  |NV|  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)

Signed-off-by: Robert Elliott <elliott@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/efi.c | 5 ++++-
 include/linux/efi.h        | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0cd8f039602e..9c8c0747c8cd 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -580,13 +580,16 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
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
index f468f7c53236..99b88c5a6770 100644
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
2.6.2
