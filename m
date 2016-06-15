From: Alex Thorlton <athorlton@sgi.com>
Subject: [PATCH 2/3] Update uv_bios_call to use efi_call_virt_pointer
Date: Wed, 15 Jun 2016 14:04:14 -0500
Message-ID: <1466017455-236934-3-git-send-email-athorlton@sgi.com>
References: <1466017455-236934-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466017455-236934-1-git-send-email-athorlton@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Matt Fleming <matt@codeblueprint.co.uk>, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Roy Franz <roy.franz@linaro.org>, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

Now that the efi_call_virt macro has been generalized to be able to
use EFI system tables besides efi.systab, we are able to convert our
uv_bios_call wrapper to use this standard EFI callback mechanism.

This simple change is part of a much larger effort to recover from some
issues with the way we were mapping in some of our MMRs, and the way
that we were doing our BIOS callbacks, which were uncovered by commit
67a9108ed431 ("x86/efi: Build our own page table structures").

The first issue that this uncovered was that we were relying on the EFI
memory mapping mechanism to map in our MMR space for us, which, while
reliable, was technically a bug, as it relied on "undefined" behavior in
the mapping code.

The reason we were able to piggyback on the EFI memory mapping code to
map in our MMRs was because, previously, EFI code used the
trampoline_pgd, which shares a few entries with the main kernel pgd.  It
just so happened, that the memory range containing our MMRs was inside
one of those shared regions, which kept our code working without issue
for quite a while.

Anyways, once we discovered this problem, we brought back our original
code to map in the MMRs with commit 08914f436bdd ("x86/platform/UV:
Bring back the call to map_low_mmrs in uv_system_init").  This got our
systems a little further along, but we were still running into trouble
with our EFI callbacks, which prevented us from booting all the way up.

Our first step towards fixing the BIOS callbacks was to get our
uv_bios_call wrapper updated to use efi_call_virt instead of the plain
efi_call.  The previous patch took care of the effort needed to make
that possible.  Along the way, we hit a major issue with some confusion
about how to properly pull arguments higher than number 6 off the stack
in the efi_call code, which resulted in Linus's commit 683ad8092cd2
("x86/efi: Fix 7-parameter efi_call()s").

Now that all of those issues are out of the way, we're able to make this
simple change to use the new efi_call_virt_pointer in uv_bios_call which
gets our machines booting, running properly, and able to execute our
callbacks with 6+ arguments.

Note that, since we are now using the EFI page table when we make our
function call, we are no longer able to make the call using the __va()
of our function pointer, since the memory range containing that address
isn't mapped into the EFI page table.  For now, we will use the physical
address of the function directly, since that is mapped into the EFI page
table.  In the near future, we're going to get some code added in to
properly update our function pointer to its virtual address during
SetVirtualAddressMap.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Russ Anderson <rja@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Roy Franz <roy.franz@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/platform/uv/bios_uv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
index 815fec6..66b2166 100644
--- a/arch/x86/platform/uv/bios_uv.c
+++ b/arch/x86/platform/uv/bios_uv.c
@@ -40,8 +40,7 @@ s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
 		 */
 		return BIOS_STATUS_UNIMPLEMENTED;
 
-	ret = efi_call((void *)__va(tab->function), (u64)which,
-			a1, a2, a3, a4, a5);
+	ret = efi_call_virt_pointer(tab, function, (u64)which, a1, a2, a3, a4, a5);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(uv_bios_call);
-- 
1.8.5.6
