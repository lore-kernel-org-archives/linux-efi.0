From: tip-bot for Hedi Berriche <tipbot@zytor.com>
Subject: [tip:x86/uv] x86/platform/UV: Remove uv_bios_call_reentrant()
Date: Fri, 15 Feb 2019 07:04:51 -0800
Message-ID: <tip-f816525d615fff0336d0c881e5d960bbec5ea016@git.kernel.org>
References: <20190213193413.25560-3-hedi.berriche@hpe.com>
Reply-To: bp@suse.de, hpa@zytor.com, x86@kernel.org,
          linux-kernel@vger.kernel.org, rja@hpe.com, mingo@kernel.org,
          andy@infradead.org, dvhart@infradead.org, tglx@linutronix.de,
          bhsharma@redhat.com, steve.wahl@hpe.com, hedi.berriche@hpe.com,
          linux-efi@vger.kernel.org, mike.travis@hpe.com, mingo@redhat.com,
          ard.biesheuvel@linaro.org, sivanich@hpe.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213193413.25560-3-hedi.berriche@hpe.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: linux-efi@vger.kernel.org, hedi.berriche@hpe.com, mingo@redhat.com, mike.travis@hpe.com, ard.biesheuvel@linaro.org, sivanich@hpe.com, dvhart@infradead.org, steve.wahl@hpe.com, bhsharma@redhat.com, tglx@linutronix.de, andy@infradead.org, bp@suse.de, hpa@zytor.com, rja@hpe.com, mingo@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Commit-ID:  f816525d615fff0336d0c881e5d960bbec5ea016
Gitweb:     https://git.kernel.org/tip/f816525d615fff0336d0c881e5d960bbec5ea016
Author:     Hedi Berriche <hedi.berriche@hpe.com>
AuthorDate: Wed, 13 Feb 2019 19:34:11 +0000
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Fri, 15 Feb 2019 15:13:48 +0100

x86/platform/UV: Remove uv_bios_call_reentrant()

uv_bios_call_reentrant() has no callers nor is it exported, remove it.

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
Link: https://lkml.kernel.org/r/20190213193413.25560-3-hedi.berriche@hpe.com
---
 arch/x86/include/asm/uv/bios.h |  1 -
 arch/x86/platform/uv/bios_uv.c | 12 ------------
 2 files changed, 13 deletions(-)

diff --git a/arch/x86/include/asm/uv/bios.h b/arch/x86/include/asm/uv/bios.h
index 00d862cfbcbe..8c6ac271b5b3 100644
--- a/arch/x86/include/asm/uv/bios.h
+++ b/arch/x86/include/asm/uv/bios.h
@@ -140,7 +140,6 @@ enum uv_memprotect {
  */
 extern s64 uv_bios_call(enum uv_bios_cmd, u64, u64, u64, u64, u64);
 extern s64 uv_bios_call_irqsave(enum uv_bios_cmd, u64, u64, u64, u64, u64);
-extern s64 uv_bios_call_reentrant(enum uv_bios_cmd, u64, u64, u64, u64, u64);
 
 extern s64 uv_bios_get_sn_info(int, int *, long *, long *, long *, long *);
 extern s64 uv_bios_freq_base(u64, u64 *);
diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
index 4a61ed2a7bb8..91e3d5285836 100644
--- a/arch/x86/platform/uv/bios_uv.c
+++ b/arch/x86/platform/uv/bios_uv.c
@@ -66,18 +66,6 @@ s64 uv_bios_call_irqsave(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
 	return ret;
 }
 
-s64 uv_bios_call_reentrant(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
-					u64 a4, u64 a5)
-{
-	s64 ret;
-
-	preempt_disable();
-	ret = uv_bios_call(which, a1, a2, a3, a4, a5);
-	preempt_enable();
-
-	return ret;
-}
-
 
 long sn_partition_id;
 EXPORT_SYMBOL_GPL(sn_partition_id);
