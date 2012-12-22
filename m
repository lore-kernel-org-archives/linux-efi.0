From: Stefan Hasko <hasko.stevo@gmail.com>
Subject: [PATCH] arch: x86: boot: compressed: eboot: fix cast warnings on 32b platforms
Date: Sat, 22 Dec 2012 11:23:25 +0100
Message-ID: <1356171805-16930-1-git-send-email-hasko.stevo@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Stefan Hasko <hasko.stevo@gmail.com>
List-Id: linux-efi@vger.kernel.org

Fixed different size cast warnings in function setup_efi_pci

Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
---
 arch/x86/boot/compressed/eboot.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b1942e2..dd99fca 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -256,10 +256,10 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 	int i;
 	struct setup_data *data;
 
-	data = (struct setup_data *)params->hdr.setup_data;
+	data = (struct setup_data *)(uintptr_t)params->hdr.setup_data;
 
 	while (data && data->next)
-		data = (struct setup_data *)data->next;
+		data = (struct setup_data *)(uintptr_t)data->next;
 
 	status = efi_call_phys5(sys_table->boottime->locate_handle,
 				EFI_LOCATE_BY_PROTOCOL, &pci_proto,
@@ -345,9 +345,9 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		memcpy(rom->romdata, pci->romimage, pci->romsize);
 
 		if (data)
-			data->next = (uint64_t)rom;
+			data->next = (uintptr_t)rom;
 		else
-			params->hdr.setup_data = (uint64_t)rom;
+			params->hdr.setup_data = (uintptr_t)rom;
 
 		data = (struct setup_data *)rom;
 
-- 
1.7.10.4
