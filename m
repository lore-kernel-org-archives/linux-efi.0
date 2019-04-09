From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2] efi/arm: enable CP15 DMB instructions before cleaning the
 cache
Date: Tue,  9 Apr 2019 09:42:20 -0700
Message-ID: <20190409164220.5993-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, vladimir.murzin@arm.com, linux-efi@vger.kernel.org, linux@armlinux.org.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

The EFI stub is entered with the caches and MMU enabled by the
firmware, and once the stub is ready to hand over to the decompressor,
we clean and disable the caches.

The cache clean routines use CP15 barrier instructions, which can be
disabled via SCTLR. Normally, when using the provided cache handling
routines to enable the caches and MMU, this bit is enabled as well.
However, but since we entered the stub with the caches already enabled,
this routine is not executed before we call the cache clean routines,
resulting in undefined instruction exceptions if the firmware never
enabled this bit.

So set the bit explicitly in the EFI entry code, but do so in a way that
guarantees that the resulting code can still run on v6 cores as well
(which are guaranteed to have CP15 barriers enabled)

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/boot/compressed/head.S | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 6c7ccb428c07..c174098acdf1 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1438,7 +1438,21 @@ ENTRY(efi_stub_entry)
 
 		@ Preserve return value of efi_entry() in r4
 		mov	r4, r0
-		bl	cache_clean_flush
+
+		@ our cache maintenance code relies on CP15 barrier instructions
+		@ but since we arrived here with the MMU and caches configured
+		@ by UEFI, we must check that the CP15BEN bit is set in SCTLR.
+		@ Note that this bit is RAO/WI on v6 and earlier, so the ISB in
+		@ the enable path will be executed on v7+ only.
+		mrc	p15, 0, r1, c1, c0, 0	@ read SCTLR
+		tst	r1, #(1 << 5)		@ CP15BEN bit set?
+		bne	0f
+		orr	r1, r1, #(1 << 5)	@ CP15 barrier instructions
+		mcr	p15, 0, r1, c1, c0, 0	@ write SCTLR
+ ARM(		.inst	0xf57ff06f		@ isb		)
+ THUMB(		isb						)
+
+0:		bl	cache_clean_flush
 		bl	cache_off
 
 		@ Set parameters for booting zImage according to boot protocol
-- 
2.17.1
