From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 01/10] x86/efi: Mark can_free_region() as an __init function
Date: Sat,  2 Feb 2019 10:41:10 +0100
Message-ID: <20190202094119.13230-2-ard.biesheuvel@linaro.org>
References: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, Alexander Graf <agraf@suse.de>, Bjorn Andersson <bjorn.andersson@linaro.org>, Borislav Petkov <bp@alien8.de>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jeffrey Hugo <jhugo@codeaurora.org>, Lee Jones <lee.jones@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>

can_free_region() is called only once during _boot_ by
efi_reserve_boot_services(). Hence, mark it as __init function.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/platform/efi/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 17456a1d3f04..9ce85e605052 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -304,7 +304,7 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
  * - Not within any part of the kernel
  * - Not the BIOS reserved area (E820_TYPE_RESERVED, E820_TYPE_NVS, etc)
  */
-static bool can_free_region(u64 start, u64 size)
+static __init bool can_free_region(u64 start, u64 size)
 {
 	if (start + size > __pa_symbol(_text) && start <= __pa_symbol(_end))
 		return false;
-- 
2.17.1
