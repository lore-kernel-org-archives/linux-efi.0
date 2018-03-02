From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 079/115] x86/efi: Fix kernel param add_efi_memmap regression
Date: Fri,  2 Mar 2018 09:51:22 +0100
Message-ID: <20180302084507.050323187@linuxfoundation.org>
References: <20180302084503.856536800@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180302084503.856536800@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Dave Young <dyoung@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Bryan ODonoghue <pure.logic@nexus-software.ie>, Ge Song <ge.song@hxt-semitech.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Sasha Levin <alexander.levin@verizon.com>
List-Id: linux-efi@vger.kernel.org

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Young <dyoung@redhat.com>


[ Upstream commit 835bcec5fdf3f9e880111b482177e7e70e3596da ]

'add_efi_memmap' is an early param, but do_add_efi_memmap() has no
chance to run because the code path is before parse_early_param().
I believe it worked when the param was introduced but probably later
some other changes caused the wrong order and nobody noticed it.

Move efi_memblock_x86_reserve_range() after parse_early_param()
to fix it.

Signed-off-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: Ge Song <ge.song@hxt-semitech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20180102172110.17018-2-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <alexander.levin@verizon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/setup.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -928,9 +928,6 @@ void __init setup_arch(char **cmdline_p)
 		set_bit(EFI_BOOT, &efi.flags);
 		set_bit(EFI_64BIT, &efi.flags);
 	}
-
-	if (efi_enabled(EFI_BOOT))
-		efi_memblock_x86_reserve_range();
 #endif
 
 	x86_init.oem.arch_setup();
@@ -984,6 +981,8 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+	if (efi_enabled(EFI_BOOT))
+		efi_memblock_x86_reserve_range();
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/*
 	 * Memory used by the kernel cannot be hot-removed because Linux
