From: Dmitry Skorodumov <sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH] [v2] x86_64/efi: Use all 64 bit of efi_memmap in setup_e820()
Date: Wed, 22 Jul 2015 19:31:08 +0400
Message-ID: <1437579068-14982-1-git-send-email-sdmitry@parallels.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The efi_info structure stores low 32 bits of memory map
in efi_memmap and high 32 bits in efi_memmap_hi.

While constructing pointer in the setup_e820(), need
to take into account all 64 bits of the pointer.

It is because on 64bit machine the function
efi_get_memory_map() may return full 64bit pointer and before
the patch that pointer was truncated.

Signed-off-by: Dmitry Skorodumov <sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

tested in Parallels virtual machine with more then 3GB of memory
---
 arch/x86/boot/compressed/eboot.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 2c82bd1..9108fe5 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1184,6 +1184,12 @@ static efi_status_t setup_e820(struct boot_params *params,
 	u32 nr_entries;
 	u32 nr_desc;
 	int i;
+	unsigned long m;
+
+	m = efi->efi_memmap;
+#ifdef CONFIG_X86_64
+	m |= (u64)efi->efi_memmap_hi << 32;
+#endif
 
 	nr_entries = 0;
 	nr_desc = efi->efi_memmap_size / efi->efi_memdesc_size;
@@ -1191,7 +1197,6 @@ static efi_status_t setup_e820(struct boot_params *params,
 	for (i = 0; i < nr_desc; i++) {
 		efi_memory_desc_t *d;
 		unsigned int e820_type = 0;
-		unsigned long m = efi->efi_memmap;
 
 		d = (efi_memory_desc_t *)(m + (i * efi->efi_memdesc_size));
 		switch (d->type) {
-- 
1.7.9.1
