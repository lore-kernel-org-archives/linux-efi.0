From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] efi/arm: enable CP15 DMB instructions before cleaning the
 cache
Date: Fri, 29 Mar 2019 19:24:18 +0100
Message-ID: <20190329182418.29592-1-ard.biesheuvel@linaro.org>
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
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, linux@armlinux.org.uk, leif.lindholm@linaro.org, steve.mcintyre@linaro.org
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

So set the bit explicitly in the EFI entry code.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/boot/compressed/head.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 6c7ccb428c07..62a49356fca3 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1438,6 +1438,16 @@ ENTRY(efi_stub_entry)
 
 		@ Preserve return value of efi_entry() in r4
 		mov	r4, r0
+
+		@ our cache maintenance code relies on CP15 barrier instructions
+		@ but since we arrived here with the MMU and caches configured
+		@ by UEFI, we must ensure that the use of those instructions is
+		@ enabled in the SCTLR register, since we never executed our own
+		@ cache enable routine, which is normally in charge of this.
+		mrc	p15, 0, r1, c1, c0, 0	@ read SCTLR
+		orr	r1, r1, #(1 << 5)	@ CP15 barrier instructions
+		mcr	p15, 0, r1, c1, c0, 0	@ write SCTLR
+
 		bl	cache_clean_flush
 		bl	cache_off
 
-- 
2.20.1
