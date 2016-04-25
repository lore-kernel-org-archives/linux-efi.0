From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 08/40] efi: Check EFI_MEMORY_DESCRIPTOR version explicitly
Date: Mon, 25 Apr 2016 21:06:40 +0100
Message-ID: <1461614832-17633-9-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Our efi_memory_desc_t type is based on EFI_MEMORY_DESCRIPTOR version 1 in
the UEFI spec. No version updates are expected, but since we are about to
introduce support for new firmware tables that use the same descriptor
type, it makes sense to at least warn if we encounter other versions.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi.c     | 4 ++++
 drivers/firmware/efi/arm-init.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 88d2fb2cb3ef..dde46cd78b8f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -211,6 +211,10 @@ int __init efi_memblock_x86_reserve_range(void)
 	efi.memmap.desc_size	= e->efi_memdesc_size;
 	efi.memmap.desc_version	= e->efi_memdesc_version;
 
+	WARN(efi.memmap.desc_version != 1,
+	     "Unexpected EFI_MEMORY_DESCRIPTOR version %ld",
+	     efi.memmap.desc_version);
+
 	memblock_reserve(pmap, efi.memmap.nr_map * efi.memmap.desc_size);
 
 	return 0;
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 90a9b473e45c..a84dddb54c14 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -198,6 +198,10 @@ void __init efi_init(void)
 	efi.memmap.desc_size = params.desc_size;
 	efi.memmap.desc_version = params.desc_ver;
 
+	WARN(efi.memmap.desc_version != 1,
+	     "Unexpected EFI_MEMORY_DESCRIPTOR version %ld",
+	      efi.memmap.desc_version);
+
 	if (uefi_init() < 0)
 		return;
 
-- 
2.7.3
