From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 22/40] efi/arm*: libstub: Wire up GOP protocol to struct screen_info
Date: Mon, 25 Apr 2016 21:06:54 +0100
Message-ID: <1461614832-17633-23-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, David Herrmann <dh.herrmann@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Peter Jones <pjones@redhat.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This adds the code to the ARM and arm64 versions of the UEFI stub to
populate struct screen_info based on the information received from the
firmware via the GOP protocol.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/libstub/arm-stub.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 128632508fc6..993aa56755f6 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -169,6 +169,25 @@ void efi_char16_printk(efi_system_table_t *sys_table_arg,
 	out->output_string(out, str);
 }
 
+static struct screen_info *setup_graphics(efi_system_table_t *sys_table_arg)
+{
+	efi_guid_t gop_proto = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
+	efi_status_t status;
+	unsigned long size;
+	void **gop_handle = NULL;
+	struct screen_info *si = NULL;
+
+	size = 0;
+	status = efi_call_early(locate_handle, EFI_LOCATE_BY_PROTOCOL,
+				&gop_proto, NULL, &size, gop_handle);
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		si = alloc_screen_info(sys_table_arg);
+		if (!si)
+			return NULL;
+		efi_setup_gop(sys_table_arg, si, &gop_proto, size);
+	}
+	return si;
+}
 
 /*
  * This function handles the architcture specific differences between arm and
@@ -208,6 +227,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	unsigned long reserve_addr = 0;
 	unsigned long reserve_size = 0;
 	int secure_boot = 0;
+	struct screen_info *si;
 
 	/* Check if we were booted by the EFI firmware */
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
@@ -260,6 +280,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 			__nokaslr = true;
 	}
 
+	si = setup_graphics(sys_table);
+
 	status = handle_kernel_image(sys_table, image_addr, &image_size,
 				     &reserve_addr,
 				     &reserve_size,
@@ -341,6 +363,7 @@ fail_free_image:
 	efi_free(sys_table, image_size, *image_addr);
 	efi_free(sys_table, reserve_size, reserve_addr);
 fail_free_cmdline:
+	free_screen_info(sys_table, si);
 	efi_free(sys_table, cmdline_size, (unsigned long)cmdline_ptr);
 fail:
 	return EFI_ERROR;
-- 
2.7.3
