From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 1/2] arm64: don't make early_*map() calls post paging_init()
Date: Mon,  5 Jan 2015 18:33:54 +0000
Message-ID: <1420482835-6444-2-git-send-email-leif.lindholm@linaro.org>
References: <1420482835-6444-1-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1420482835-6444-1-git-send-email-leif.lindholm@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: msalter@redhat.com, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, will.deacon@arm.com, catalin.marinas@arm.com
Cc: ard.biesheuvel@linaro.org
List-Id: linux-efi@vger.kernel.org

arm64 early_ioremap/iounmap/memremap/memunmap are not supported beyond
the call to paging_init(), but arm64_enter_virtual_mode() (an early
initcall) makes one call to unmap the UEFI memory map.

Rearrange the code to unmap this region before paging_init().

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 arch/arm64/kernel/efi.c   | 12 +++---------
 arch/arm64/kernel/setup.c |  2 --
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 6fac253..790adb5 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -317,15 +317,8 @@ void __init efi_init(void)
 		return;
 
 	reserve_regions();
-}
-
-void __init efi_idmap_init(void)
-{
-	if (!efi_enabled(EFI_BOOT))
-		return;
 
-	/* boot time idmap_pg_dir is incomplete, so fill in missing parts */
-	efi_setup_idmap();
+	early_memunmap(memmap.map, params.mmap_size);
 }
 
 static int __init remap_region(efi_memory_desc_t *md, void **new)
@@ -380,7 +373,6 @@ static int __init arm64_enter_virtual_mode(void)
 	}
 
 	mapsize = memmap.map_end - memmap.map;
-	early_memunmap(memmap.map, mapsize);
 
 	if (efi_runtime_disabled()) {
 		pr_info("EFI runtime services will be disabled.\n");
@@ -393,6 +385,8 @@ static int __init arm64_enter_virtual_mode(void)
 						   mapsize);
 	memmap.map_end = memmap.map + mapsize;
 
+	efi_setup_idmap();
+
 	efi.memmap = &memmap;
 
 	/* Map the runtime regions */
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index b809911..c7eb3c5 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -401,8 +401,6 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 	request_standard_resources();
 
-	efi_idmap_init();
-
 	unflatten_device_tree();
 
 	psci_init();
-- 
2.1.3
