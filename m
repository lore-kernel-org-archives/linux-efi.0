From: Hedi Berriche <hedi.berriche@hpe.com>
Subject: [Patch v2 3/4] x86/platform/UV: use efi_enabled() instead of test_bit()
Date: Thu,  7 Feb 2019 04:22:33 +0000
Message-ID: <20190207042234.25109-4-hedi.berriche@hpe.com>
References: <20190207042234.25109-1-hedi.berriche@hpe.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190207042234.25109-1-hedi.berriche@hpe.com>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Bhupesh Sharma <bhsharma@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, x86@kernel.org, Hedi Berriche <hedi.berriche@hpe.com>, Russ Anderson <rja@hpe.com>, Mike Travis <mike.travis@hpe.com>, Dimitri Sivanich <sivanich@hpe.com>, Steve Wahl <steve.wahl@hpe.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Use ad hoc efi_enabled() instead of fiddling with test_bit().

Cleanup, no functional changes.

Cc: Russ Anderson <rja@hpe.com>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Dimitri Sivanich <sivanich@hpe.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hedi Berriche <hedi.berriche@hpe.com>
---
 arch/x86/platform/uv/bios_uv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
index cd05af157763..8bace0ca9e57 100644
--- a/arch/x86/platform/uv/bios_uv.c
+++ b/arch/x86/platform/uv/bios_uv.c
@@ -44,7 +44,7 @@ s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
 	 * If EFI_OLD_MEMMAP is set, we need to fall back to using our old EFI
 	 * callback method, which uses efi_call() directly, with the kernel page tables:
 	 */
-	if (unlikely(test_bit(EFI_OLD_MEMMAP, &efi.flags)))
+	if (unlikely(efi_enabled(EFI_OLD_MEMMAP)))
 		ret = efi_call((void *)__va(tab->function), (u64)which, a1, a2, a3, a4, a5);
 	else
 		ret = efi_call_virt_pointer(tab, function, (u64)which, a1, a2, a3, a4, a5);
-- 
2.20.1
