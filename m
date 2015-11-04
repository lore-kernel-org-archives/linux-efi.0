From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH] x86/setup: Fix recent boot crash on 32-bit SMP machines
Date: Wed,  4 Nov 2015 10:47:17 +0000
Message-ID: <1446634037-10251-2-git-send-email-matt@codeblueprint.co.uk>
References: <1446634037-10251-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446634037-10251-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>, "Huang, Ying" <ying.huang@intel.com>
List-Id: linux-efi@vger.kernel.org

The LKP test robot reported that the bug fix in commit f5f3497cad8c
("x86/setup: Extend low identity map to cover whole kernel range")
causes CONFIG_X86_32 SMP machines to crash on boot when trying to
bring AP cpus online.

The above commit erroneously copies too many of the PGD entries to the
low memory region of 'identity_page_table', resulting in some of the
kernel mappings for PAGE_OFFSET being trashed because,

  KERNEL_PGD_PTRS > KERNEL_PGD_BOUNDARY

The maximum number of PGD entries we can copy without corrupting the
kernel mapping is KERNEL_PGD_BOUNDARY or pgd_index(PAGE_OFFSET).

Reported-by: Huang, Ying <ying.huang@intel.com>
Tested-by: Huang, Ying <ying.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Laszlo Ersek <lersek@redhat.com>
Cc: <stable@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a3cccbfc5f77..2b8cbd693da8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1180,7 +1180,7 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	clone_pgd_range(initial_page_table,
 			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
-			KERNEL_PGD_PTRS);
+			KERNEL_PGD_BOUNDARY);
 #endif
 
 	tboot_probe();
-- 
2.6.2
