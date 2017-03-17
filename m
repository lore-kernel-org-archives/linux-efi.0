From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi/esrt: Cleanup bad memory map log messages
Date: Fri, 17 Mar 2017 19:06:45 +0000
Message-ID: <1489777605-8363-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1489777605-8363-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489777605-8363-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>

The Intel Compute Stick STCK1A8LFC and Weibu F3C platforms both
log 2 error messages during boot:

   efi: requested map not found.
   esrt: ESRT header is not in the memory map.

Searching the web, this seems to affect many other platforms too.
Since these messages are logged as errors, they appear on-screen during
the boot process even when using the "quiet" boot parameter used by
distros.

Demote the ESRT error to a warning so that it does not appear on-screen,
and delete the error logging from efi_mem_desc_lookup; both callsites
of that function log more specific messages upon failure.

Out of curiosity I looked closer at the Weibu F3C. There is no entry in
the UEFI-provided memory map which corresponds to the ESRT pointer, but
hacking the code to map it anyway, the ESRT does appear to be valid with
2 entries.

Signed-off-by: Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Acked-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c  | 1 -
 drivers/firmware/efi/esrt.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index e7d404059b73..b372aad3b449 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -389,7 +389,6 @@ int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
 			return 0;
 		}
 	}
-	pr_err_once("requested map not found.\n");
 	return -ENOENT;
 }
 
diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index 08b026864d4e..8554d7aec31c 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -254,7 +254,7 @@ void __init efi_esrt_init(void)
 
 	rc = efi_mem_desc_lookup(efi.esrt, &md);
 	if (rc < 0) {
-		pr_err("ESRT header is not in the memory map.\n");
+		pr_warn("ESRT header is not in the memory map.\n");
 		return;
 	}
 
-- 
2.7.4
