From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/8] efi: make install_configuration_table() boot service usable
Date: Thu, 10 Mar 2016 12:40:01 +0700
Message-ID: <1457588408-19309-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457588408-19309-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This patch redeclares efi_boot_services_t::install_configuration_table
as a function pointer so that the boot service is callable as a function.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/linux/efi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index e747eb08b2be..8ba6eb7863aa 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -283,7 +283,7 @@ typedef struct {
 	void *register_protocol_notify;
 	void *locate_handle;
 	void *locate_device_path;
-	void *install_configuration_table;
+	efi_status_t (*install_configuration_table)(efi_guid_t *, void *);
 	void *load_image;
 	void *start_image;
 	void *exit;
-- 
1.9.1
