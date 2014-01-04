From: Joe Perches <joe@perches.com>
Subject: [PATCH 1/2] efi: Fix krealloc defect
Date: Fri,  3 Jan 2014 16:08:47 -0800
Message-ID: <9a8eb1c9478049318e834d5223053a5fb7484bff.1388793978.git.joe@perches.com>
References: <cover.1388793978.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1388793978.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Matthew Garrett <matthew.garrett@nebula.com>, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

krealloc should use a temporary pointer for allocations
and check the temporary pointer returned against NULL too.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/platform/efi/efi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index cceb813..ef7b7b4 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -798,6 +798,8 @@ void __init efi_enter_virtual_mode(void)
 	}
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		void *new_memmap2;
+
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
 #ifdef CONFIG_X86_64
@@ -834,9 +836,13 @@ void __init efi_enter_virtual_mode(void)
 			systab += md->virt_addr - md->phys_addr;
 			efi.systab = (efi_system_table_t *) (unsigned long) systab;
 		}
-		new_memmap = krealloc(new_memmap,
-				      (count + 1) * memmap.desc_size,
-				      GFP_KERNEL);
+		new_memmap2 = krealloc(new_memmap,
+				       (count + 1) * memmap.desc_size,
+				       GFP_KERNEL);
+		if (!new_memmap2)
+			continue;
+
+		new_memmap = new_memmap2;
 		memcpy(new_memmap + (count * memmap.desc_size), md,
 		       memmap.desc_size);
 		count++;
-- 
1.8.1.2.459.gbcd45b4.dirty
