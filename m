From: Hedi Berriche <hedi.berriche@hpe.com>
Subject: [Patch v3 1/4] x86/platform/UV: remove unnecessary #ifdef CONFIG_EFI
Date: Wed, 13 Feb 2019 19:34:10 +0000
Message-ID: <20190213193413.25560-2-hedi.berriche@hpe.com>
References: <20190213193413.25560-1-hedi.berriche@hpe.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190213193413.25560-1-hedi.berriche@hpe.com>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Bhupesh Sharma <bhsharma@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, x86@kernel.org, Russ Anderson <rja@hpe.com>, Mike Travis <mike.travis@hpe.com>, Dimitri Sivanich <sivanich@hpe.com>, Steve Wahl <steve.wahl@hpe.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

CONFIG_EFI is implied by CONFIG_X86_UV and x86/platform/uv/bios_uv.c
requires the latter, get rid of the redundant #ifdef CONFIG_EFI directives.

Cleanup, no functional changes.

Cc: Russ Anderson <rja@hpe.com>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Dimitri Sivanich <sivanich@hpe.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: stable@vger.kernel.org # v4.9+
Signed-off-by: Hedi Berriche <hedi.berriche@hpe.com>
---
 arch/x86/include/asm/uv/bios.h | 4 ----
 arch/x86/platform/uv/bios_uv.c | 2 --
 2 files changed, 6 deletions(-)

diff --git a/arch/x86/include/asm/uv/bios.h b/arch/x86/include/asm/uv/bios.h
index e652a7cc6186..00d862cfbcbe 100644
--- a/arch/x86/include/asm/uv/bios.h
+++ b/arch/x86/include/asm/uv/bios.h
@@ -151,11 +151,7 @@ extern s64 uv_bios_change_memprotect(u64, u64, enum uv_memprotect);
 extern s64 uv_bios_reserved_page_pa(u64, u64 *, u64 *, u64 *);
 extern int uv_bios_set_legacy_vga_target(bool decode, int domain, int bus);
 
-#ifdef CONFIG_EFI
 extern void uv_bios_init(void);
-#else
-void uv_bios_init(void) { }
-#endif
 
 extern unsigned long sn_rtc_cycles_per_second;
 extern int uv_type;
diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
index 4a6a5a26c582..4a61ed2a7bb8 100644
--- a/arch/x86/platform/uv/bios_uv.c
+++ b/arch/x86/platform/uv/bios_uv.c
@@ -188,7 +188,6 @@ int uv_bios_set_legacy_vga_target(bool decode, int domain, int bus)
 }
 EXPORT_SYMBOL_GPL(uv_bios_set_legacy_vga_target);
 
-#ifdef CONFIG_EFI
 void uv_bios_init(void)
 {
 	uv_systab = NULL;
@@ -218,4 +217,3 @@ void uv_bios_init(void)
 	}
 	pr_info("UV: UVsystab: Revision:%x\n", uv_systab->revision);
 }
-#endif
-- 
2.20.1
