From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] efi/arm64: efistub: don't abort if base of DRAM is
 occupied
Date: Tue, 15 Jul 2014 12:00:26 +0100
Message-ID: <20140715110026.GW26465@leverpostej>
References: <1405351521-12010-1-git-send-email-ard.biesheuvel@linaro.org>
 <1405363248.25580.12.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1405363248.25580.12.camel@deneb.redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Salter <msalter@redhat.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "roy.franz@linaro.org" <roy.franz@linaro.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 14, 2014 at 07:40:48PM +0100, Mark Salter wrote:
> On Mon, 2014-07-14 at 17:25 +0200, Ard Biesheuvel wrote:
> > If we fail to relocate the kernel Image to its preferred offset of TEXT_OFFSET
> > bytes above the base of DRAM, accept the lowest alternative mapping available
> > instead of aborting. We may lose a bit of memory at the low end, but we can
> > still proceed normally otherwise.
> 
> This breaks APM Mustang because the spin-table holding pen for secondary
> CPUs is marked as reserved memory in the TEXT_OFFSET area and the kernel
> placement using your patch makes it unreachable by kernel. Here is a
> patch I've been working with to solve the same problem:

I'm not sure that this is strictly speaking an issue with UEFI or the
relocation strategy (which sounds sane to me). I believe we could easily
hit similar issues with spin-table elsewhere, and I think we can fix
this more generally without complicating the EFI stub.

As I see it, we have two issues here:

1) The linear mapping starts at VA:PAGE_OFFSET+TEXT_OFFSET /
   PA:PHYS_OFFSET+TEXT_OFFSET, and we cannot access memory below this
   start address. This seems like a general issue we need to address, as
   it forces bootloader code to go through a tricky/impossible dance to
   get the kernel as close to the start of RAM as possible.

2) We cannot access a given cpu-release-addr if it is not in the linear
   mapping. This is the problem we're encountering now.

We can solve (2) now by using a temporary mapping to write to the
cpu-release-addr. Does the below patch (untested) fix your issue with
spin-table?

For (1) we need to rework the arm64 VA layout to decouple the kernel
text mapping from the linear map, but that's a lot more work. 

Cheers,
Mark.

---->8----
>From 73812b654a07f497f71bd38dfb4a6753fb0ad23e Mon Sep 17 00:00:00 2001
From: Mark Rutland <mark.rutland@arm.com>
Date: Tue, 15 Jul 2014 11:32:53 +0100
Subject: [PATCH] arm64: spin-table: handle unmapped cpu-release-addrs

In certain cases the cpu-release-addr of a CPU may not fall in the
linear mapping (e.g. when the kernel is loaded above this address due to
the presence of other images in memory). This is problematic for the
spin-table code as it assumes that it can trivially convert a
cpu-release-addr to a valid VA in the linear map.

This patch modifies the spin-table code to use a temporary cached
mapping to write to a given cpu-release-addr, enabling us to support
addresses regardless of whether they are covered by the linear mapping.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/kernel/smp_spin_table.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/smp_spin_table.c b/arch/arm64/kernel/smp_spin_table.c
index 0347d38..70181c1 100644
--- a/arch/arm64/kernel/smp_spin_table.c
+++ b/arch/arm64/kernel/smp_spin_table.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/smp.h>
+#include <linux/types.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cpu_ops.h>
@@ -65,12 +66,21 @@ static int smp_spin_table_cpu_init(struct device_node *dn, unsigned int cpu)
 
 static int smp_spin_table_cpu_prepare(unsigned int cpu)
 {
-	void **release_addr;
+	__le64 __iomem *release_addr;
 
 	if (!cpu_release_addr[cpu])
 		return -ENODEV;
 
-	release_addr = __va(cpu_release_addr[cpu]);
+	/*
+	 * The cpu-release-addr may or may not be inside the linear mapping.
+	 * As ioremap_cache will either give us a new mapping or reuse the
+	 * existing linear mapping, we can use it to cover both cases. In
+	 * either case the memory will be MT_NORMAL.
+	 */
+	release_addr = ioremap_cache(cpu_release_addr[cpu],
+				     sizeof(*release_addr));
+	if (!release_addr)
+		return -ENOMEM;
 
 	/*
 	 * We write the release address as LE regardless of the native
@@ -79,15 +89,16 @@ static int smp_spin_table_cpu_prepare(unsigned int cpu)
 	 * boot-loader's endianess before jumping. This is mandated by
 	 * the boot protocol.
 	 */
-	release_addr[0] = (void *) cpu_to_le64(__pa(secondary_holding_pen));
-
-	__flush_dcache_area(release_addr, sizeof(release_addr[0]));
+	writeq_relaxed(__pa(secondary_holding_pen), release_addr);
+	__flush_dcache_area(release_addr, sizeof(*release_addr));
 
 	/*
 	 * Send an event to wake up the secondary CPU.
 	 */
 	sev();
 
+	iounmap(release_addr);
+
 	return 0;
 }
 
-- 
1.9.1
