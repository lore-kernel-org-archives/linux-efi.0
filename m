From: tip-bot for Hedi Berriche <tipbot@zytor.com>
Subject: [tip:x86/uv] x86/platform/UV: Remove unnecessary #ifdef CONFIG_EFI
Date: Fri, 15 Feb 2019 07:04:11 -0800
Message-ID: <tip-30ad3e031d2feae075cd5fd2c443baa2d86c0195@git.kernel.org>
References: <20190213193413.25560-2-hedi.berriche@hpe.com>
Reply-To: andy@infradead.org, hedi.berriche@hpe.com, bhsharma@redhat.com,
          tglx@linutronix.de, mike.travis@hpe.com, steve.wahl@hpe.com,
          linux-kernel@vger.kernel.org, sivanich@hpe.com, mingo@kernel.org,
          dvhart@infradead.org, mingo@redhat.com, hpa@zytor.com,
          linux-efi@vger.kernel.org, rja@hpe.com, x86@kernel.org,
          bp@suse.de, ard.biesheuvel@linaro.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213193413.25560-2-hedi.berriche@hpe.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: linux-efi@vger.kernel.org, rja@hpe.com, x86@kernel.org, bp@suse.de, ard.biesheuvel@linaro.org, sivanich@hpe.com, mingo@kernel.org, mingo@redhat.com, dvhart@infradead.org, hpa@zytor.com, tglx@linutronix.de, bhsharma@redhat.com, mike.travis@hpe.com, steve.wahl@hpe.com, linux-kernel@vger.kernel.org, andy@infradead.org, hedi.berriche@hpe.com
List-Id: linux-efi@vger.kernel.org

Commit-ID:  30ad3e031d2feae075cd5fd2c443baa2d86c0195
Gitweb:     https://git.kernel.org/tip/30ad3e031d2feae075cd5fd2c443baa2d86c0195
Author:     Hedi Berriche <hedi.berriche@hpe.com>
AuthorDate: Wed, 13 Feb 2019 19:34:10 +0000
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Fri, 15 Feb 2019 15:05:15 +0100

x86/platform/UV: Remove unnecessary #ifdef CONFIG_EFI

CONFIG_EFI is implied by CONFIG_X86_UV and x86/platform/uv/bios_uv.c
requires the latter, get rid of the redundant #ifdef CONFIG_EFI
directives.

Cleanup, no functional changes.

Signed-off-by: Hedi Berriche <hedi.berriche@hpe.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Russ Anderson <rja@hpe.com>
Reviewed-by: Dimitri Sivanich <sivanich@hpe.com>
Reviewed-by: Mike Travis <mike.travis@hpe.com>
Cc: Andy Shevchenko <andy@infradead.org>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-efi <linux-efi@vger.kernel.org>
Cc: platform-driver-x86@vger.kernel.org
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190213193413.25560-2-hedi.berriche@hpe.com
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
