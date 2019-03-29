From: tip-bot for Matteo Croce <tipbot@zytor.com>
Subject: [tip:x86/urgent] x86/realmode: Make set_real_mode_mem() static
 inline
Date: Fri, 29 Mar 2019 03:10:05 -0700
Message-ID: <tip-f560bd19d2fe0e54851d706b72acbc6f2eed3567@git.kernel.org>
References: <20190328114233.27835-1-mcroce@redhat.com>
Reply-To: linux-kernel@vger.kernel.org, x86@kernel.org,
          linux-efi@vger.kernel.org, mojha@codeaurora.org,
          mcroce@redhat.com, ard.biesheuvel@linaro.org, hpa@zytor.com,
          bp@suse.de, tglx@linutronix.de, mingo@kernel.org,
          mingo@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190328114233.27835-1-mcroce@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: mcroce@redhat.com, ard.biesheuvel@linaro.org, hpa@zytor.com, bp@suse.de, tglx@linutronix.de, mingo@redhat.com, mingo@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, mojha@codeaurora.org
List-Id: linux-efi@vger.kernel.org

Commit-ID:  f560bd19d2fe0e54851d706b72acbc6f2eed3567
Gitweb:     https://git.kernel.org/tip/f560bd19d2fe0e54851d706b72acbc6f2eed3567
Author:     Matteo Croce <mcroce@redhat.com>
AuthorDate: Thu, 28 Mar 2019 12:42:33 +0100
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Fri, 29 Mar 2019 10:16:27 +0100

x86/realmode: Make set_real_mode_mem() static inline

Remove the unused @size argument and move it into a header file, so it
can be inlined.

 [ bp: Massage. ]

Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-efi <linux-efi@vger.kernel.org>
Cc: platform-driver-x86@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190328114233.27835-1-mcroce@redhat.com
---
 arch/x86/include/asm/realmode.h | 6 +++++-
 arch/x86/platform/efi/quirks.c  | 2 +-
 arch/x86/realmode/init.c        | 9 +--------
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index 63b3393bd98e..c53682303c9c 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -77,7 +77,11 @@ static inline size_t real_mode_size_needed(void)
 	return ALIGN(real_mode_blob_end - real_mode_blob, PAGE_SIZE);
 }
 
-void set_real_mode_mem(phys_addr_t mem, size_t size);
+static inline void set_real_mode_mem(phys_addr_t mem)
+{
+	real_mode_header = (struct real_mode_header *) __va(mem);
+}
+
 void reserve_real_mode(void);
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 458a0e2bcc57..a25a9fd987a9 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -449,7 +449,7 @@ void __init efi_free_boot_services(void)
 		 */
 		rm_size = real_mode_size_needed();
 		if (rm_size && (start + rm_size) < (1<<20) && size >= rm_size) {
-			set_real_mode_mem(start, rm_size);
+			set_real_mode_mem(start);
 			start += rm_size;
 			size -= rm_size;
 		}
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 47d097946872..7dce39c8c034 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -15,13 +15,6 @@ u32 *trampoline_cr4_features;
 /* Hold the pgd entry used on booting additional CPUs */
 pgd_t trampoline_pgd_entry;
 
-void __init set_real_mode_mem(phys_addr_t mem, size_t size)
-{
-	void *base = __va(mem);
-
-	real_mode_header = (struct real_mode_header *) base;
-}
-
 void __init reserve_real_mode(void)
 {
 	phys_addr_t mem;
@@ -40,7 +33,7 @@ void __init reserve_real_mode(void)
 	}
 
 	memblock_reserve(mem, size);
-	set_real_mode_mem(mem, size);
+	set_real_mode_mem(mem);
 }
 
 static void __init setup_real_mode(void)
