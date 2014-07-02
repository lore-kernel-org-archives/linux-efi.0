From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 1/5] efi/arm64: Avoid EFI_ERROR as a generic return code
Date: Wed,  2 Jul 2014 14:54:39 +0200
Message-ID: <1404305683-26501-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1404305683-26501-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404305683-26501-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

As EFI_ERROR is not a UEFI result code but a local invention only
intended to allow get_dram_base() to signal failure, we should not use
it elsewhere.

Replace with EFI_LOAD_ERROR.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/arm64/kernel/efi-stub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index e786e6cdc400..7aa7155a9740 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -69,7 +69,7 @@ static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 		if (*image_addr != (dram_base + TEXT_OFFSET)) {
 			pr_efi_err(sys_table, "Failed to alloc kernel memory\n");
 			efi_free(sys_table, kernel_memsize, *image_addr);
-			return EFI_ERROR;
+			return EFI_LOAD_ERROR;
 		}
 		*image_size = kernel_memsize;
 	}
-- 
1.8.3.2
