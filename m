From: Dave Young <dyoung@redhat.com>
Subject: [PATCH 5/7] arm64/efi: do not enter virtual mode in case booting with
 efi=noruntime or noefi
Date: Thu, 14 Aug 2014 17:15:30 +0800
Message-ID: <1408007731-15081-5-git-send-email-dyoung@redhat.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: Russ Anderson <rja@sgi.com>, Alessandro Zummo <a.zummo@towertech.it>, Randy Dunlap <rdunlap@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Daniel Kiper <daniel.kiper@oracle.com>, Mark Salter <msalter@redhat.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

In case efi runtime disabled via noefi kernel cmdline arm64_enter_virtual_mode
should error out.

At the same time move early_memunmap(memmap.map, mapsize) to the beginning of
the function or it will leak early mem.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/arm64/kernel/efi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 6ed0362..309fab1 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -392,11 +392,16 @@ static int __init arm64_enter_virtual_mode(void)
 		return -1;
 	}
 
+	mapsize = memmap.map_end - memmap.map;
+	if (efi_runtime_disabled()) {
+		early_memunmap(memmap.map, mapsize);
+		pr_info("EFI runtime services will be disabled.\n");
+		return -1;
+	}
+
 	pr_info("Remapping and enabling EFI services.\n");
 
 	/* replace early memmap mapping with permanent mapping */
-	mapsize = memmap.map_end - memmap.map;
-	early_memunmap(memmap.map, mapsize);
 	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
 						   mapsize);
 	memmap.map_end = memmap.map + mapsize;
-- 
1.8.3.1
