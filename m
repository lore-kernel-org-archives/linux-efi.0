From: Semen Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2] efi/arm64: store Runtime Services revision
Date: Fri, 15 Aug 2014 16:22:44 +0300
Message-ID: <1408108964-28650-1-git-send-email-semen.protsenko@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

"efi" global data structure contains "runtime_version" field which must
be assigned in order to use it later in Runtime Services virtual calls
(virt_efi_* functions).

Before this patch "runtime_version" was unassigned (0), so each
Runtime Service virtual call that checks revision would fail.

Signed-off-by: Semen Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e72f310..5dbb7bd 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -463,6 +463,8 @@ static int __init arm64_enter_virtual_mode(void)
 	efi_native_runtime_setup();
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
+	efi.runtime_version = efi.systab->hdr.revision;
+
 	return 0;
 
 err_unmap:
-- 
2.0.1
