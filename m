From: Dmitry Skorodumov <sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v3] x86_64/efi: Use all 64 bit of efi_memmap in setup_e820()
Date: Tue, 28 Jul 2015 18:38:32 +0400
Message-ID: <1438094312-12833-1-git-send-email-sdmitry@parallels.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, "Denis V. Lunev" <den-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The efi_info structure stores low 32 bits of memory map
in efi_memmap and high 32 bits in efi_memmap_hi.

While constructing pointer in the setup_e820(), need
to take into account all 64 bit of the pointer.

It is because on 64bit machine the function
efi_get_memory_map() may return full 64bit pointer and before
the patch that pointer was truncated.

Signed-off-by: Dmitry Skorodumov <sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Denis V. Lunev <den-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

The issue is triggered on Parallles virtual machine and
fixed with this patch
---
 arch/x86/boot/compressed/eboot.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 2c82bd1..92ab209 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1192,6 +1192,9 @@ static efi_status_t setup_e820(struct boot_params *params,
 		efi_memory_desc_t *d;
 		unsigned int e820_type = 0;
 		unsigned long m = efi->efi_memmap;
+#ifdef CONFIG_X86_64
+		m |= (u64)efi->efi_memmap_hi << 32;
+#endif
 
 		d = (efi_memory_desc_t *)(m + (i * efi->efi_memdesc_size));
 		switch (d->type) {
-- 
1.7.9.1
