From: Jerry Hoemann <jerry.hoemann@hp.com>
Subject: [RFC v2 1/2] efi: Early use of boot service memory
Date: Thu, 21 Nov 2013 14:01:25 -0700
Message-ID: <1385067686-73500-2-git-send-email-jerry.hoemann@hp.com>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
Sender: linux-doc-owner@vger.kernel.org
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org, akpm@linux-foundation.org, bp@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Cc: penberg@kernel.org, mingo.kernel.org@gmail.com, vgoyal@redhat.com, jerry.hoemann@hp.com
List-Id: linux-efi@vger.kernel.org

Add #define to allow for specifying that firmware doesn't reuse
boot service code or data after Exit Boot Service.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hp.com>
---
 include/linux/efi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5f8f176..af085cf 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -568,6 +568,7 @@ efi_guid_unparse(efi_guid_t *guid, char *out)
 }
 
 extern void efi_init (void);
+extern void efi_quirks(void);
 extern void *efi_get_pal_addr (void);
 extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
@@ -634,6 +635,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
+#define EFI_QUIRK_RESERVE_BSCD	6	/* Reserve Boot Service Data/Code */
 
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
-- 
1.7.11.3

