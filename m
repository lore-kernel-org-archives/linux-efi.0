From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 7/9] efi/arm*: libstub: wire up GOP protocol to struct screen_info
Date: Fri, 18 Mar 2016 17:47:39 +0100
Message-ID: <1458319661-19762-8-git-send-email-ard.biesheuvel@linaro.org>
References: <1458319661-19762-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458319661-19762-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, linux@arm.linux.org.uk, pjones@redhat.com, dh.herrmann@gmail.com
Cc: leif.lindholm@linaro.org, mark.rutland@arm.com, x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

This adds the code to the ARM and arm64 versions of the UEFI stub to
populate struct screen_info based on the information received from the
firmware via the GOP protocol.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/arm-stub.c | 23 ++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 4deb3e7faa0e..94bd51cfb71e 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -147,6 +147,25 @@ void efi_char16_printk(efi_system_table_t *sys_table_arg,
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
@@ -185,6 +204,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
 	unsigned long reserve_addr = 0;
 	unsigned long reserve_size = 0;
+	struct screen_info *si;
 
 	/* Check if we were booted by the EFI firmware */
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
@@ -233,6 +253,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 			__nokaslr = true;
 	}
 
+	si = setup_graphics(sys_table);
+
 	status = handle_kernel_image(sys_table, image_addr, &image_size,
 				     &reserve_addr,
 				     &reserve_size,
@@ -305,6 +327,7 @@ fail_free_image:
 	efi_free(sys_table, image_size, *image_addr);
 	efi_free(sys_table, reserve_size, reserve_addr);
 fail_free_cmdline:
+	free_screen_info(sys_table, si);
 	efi_free(sys_table, cmdline_size, (unsigned long)cmdline_ptr);
 fail:
 	return EFI_ERROR;
-- 
2.5.0
