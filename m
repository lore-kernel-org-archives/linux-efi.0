From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 3/4] efi: add Persistent Memory type name
Date: Thu, 17 Dec 2015 19:28:33 -0600
Message-ID: <1450402114-3606-4-git-send-email-elliott@hpe.com>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450402114-3606-1-git-send-email-elliott@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: matt@codeblueprint.co.uk, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Robert Elliott <elliott@hpe.com>
List-Id: linux-efi@vger.kernel.org

Add the "Persistent Memory" string for type 14 introduced in
UEFI 2.5.  This is used when printing the UEFI memory map.

old:
efi: mem61: [type=14            |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)

new:
efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)

Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 drivers/firmware/efi/efi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 4dd5464..0b16e88 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -584,7 +584,8 @@ static __initdata char memory_type_name[][20] = {
 	"ACPI Memory NVS",
 	"Memory Mapped I/O",
 	"MMIO Port Space",
-	"PAL Code"
+	"PAL Code",
+	"Persistent Memory"
 };
 
 char * __init efi_md_typeattr_format(char *buf, size_t size,
-- 
2.4.3
