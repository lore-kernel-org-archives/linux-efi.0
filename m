From: tip-bot for Hedi Berriche <tipbot@zytor.com>
Subject: [tip:x86/uv] x86/platform/UV: Use efi_enabled() instead of
 test_bit()
Date: Fri, 15 Feb 2019 07:05:32 -0800
Message-ID: <tip-8945d96f7b3ead56e053ac79b8f7b0de98a30bfe@git.kernel.org>
References: <20190213193413.25560-4-hedi.berriche@hpe.com>
Reply-To: mingo@kernel.org, bp@suse.de, x86@kernel.org, sivanich@hpe.com,
          hpa@zytor.com, linux-efi@vger.kernel.org,
          ard.biesheuvel@linaro.org, rja@hpe.com, mike.travis@hpe.com,
          bhsharma@redhat.com, mingo@redhat.com, steve.wahl@hpe.com,
          andy@infradead.org, hedi.berriche@hpe.com,
          linux-kernel@vger.kernel.org, dvhart@infradead.org,
          tglx@linutronix.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213193413.25560-4-hedi.berriche@hpe.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: linux-efi@vger.kernel.org, ard.biesheuvel@linaro.org, rja@hpe.com, mike.travis@hpe.com, bhsharma@redhat.com, mingo@redhat.com, mingo@kernel.org, bp@suse.de, x86@kernel.org, sivanich@hpe.com, hpa@zytor.com, tglx@linutronix.de, steve.wahl@hpe.com, linux-kernel@vger.kernel.org, andy@infradead.org, hedi.berriche@hpe.com, dvhart@infradead.org
List-Id: linux-efi@vger.kernel.org

Commit-ID:  8945d96f7b3ead56e053ac79b8f7b0de98a30bfe
Gitweb:     https://git.kernel.org/tip/8945d96f7b3ead56e053ac79b8f7b0de98a30bfe
Author:     Hedi Berriche <hedi.berriche@hpe.com>
AuthorDate: Wed, 13 Feb 2019 19:34:12 +0000
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Fri, 15 Feb 2019 15:15:18 +0100

x86/platform/UV: Use efi_enabled() instead of test_bit()

Use ad hoc efi_enabled() instead of fiddling with test_bit().

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
Link: https://lkml.kernel.org/r/20190213193413.25560-4-hedi.berriche@hpe.com
---
 arch/x86/platform/uv/bios_uv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
index 91e3d5285836..38a2e3431fc6 100644
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
