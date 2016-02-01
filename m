From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 13/14] efi: Add Persistent Memory type name
Date: Mon,  1 Feb 2016 22:07:07 +0000
Message-ID: <1454364428-494-14-git-send-email-matt@codeblueprint.co.uk>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Robert Elliott <elliott@hpe.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>, Laszlo Ersek <lersek@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Robert Elliott <elliott@hpe.com>

Add the "Persistent Memory" string for type 14 introduced in
UEFI 2.5.  This is used when printing the UEFI memory map.

old:
efi: mem61: [type=14            |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)

new:
efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)

Signed-off-by: Robert Elliott <elliott@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/efi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9c8c0747c8cd..05a3d69250d4 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -553,7 +553,8 @@ static __initdata char memory_type_name[][20] = {
 	"ACPI Memory NVS",
 	"Memory Mapped I/O",
 	"MMIO Port Space",
-	"PAL Code"
+	"PAL Code",
+	"Persistent Memory"
 };
 
 char * __init efi_md_typeattr_format(char *buf, size_t size,
-- 
2.6.2
