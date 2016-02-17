From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 10/13] efi/arm*: Perform hardware compatibility check
Date: Wed, 17 Feb 2016 12:36:03 +0000
Message-ID: <1455712566-16727-11-git-send-email-matt@codeblueprint.co.uk>
References: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Jeremy Linton <jeremy.linton@arm.com>, Mark Rutland <mark.rutland@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Before proceeding with relocating the kernel and parsing the command line,
insert a call to check_platform_features() to allow an arch specific check
to be performed whether the current kernel can execute on the current
hardware.

Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>
Tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/libstub/arm-stub.c | 4 ++++
 drivers/firmware/efi/libstub/efistub.h  | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 3397902e4040..6086a874fa3c 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -190,6 +190,10 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 
 	pr_efi(sys_table, "Booting Linux Kernel...\n");
 
+	status = check_platform_features(sys_table);
+	if (status != EFI_SUCCESS)
+		goto fail;
+
 	/*
 	 * Get a handle to the loaded image protocol.  This is used to get
 	 * information about the running image, such as size and the command
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 86ff7bfa6ace..981c6035ce09 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -53,4 +53,6 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
 		     unsigned long desc_size, efi_memory_desc_t *runtime_map,
 		     int *count);
 
+efi_status_t check_platform_features(efi_system_table_t *sys_table_arg);
+
 #endif
-- 
2.6.2
