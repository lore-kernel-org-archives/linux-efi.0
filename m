From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 18/44] efi/arm: Fix boot crash with CONFIG_CPUMASK_OFFSTACK=y
Date: Thu, 16 Mar 2017 23:29:43 +0900
Message-ID: <20170316142926.742649860@linuxfoundation.org>
References: <20170316142925.994282609@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170316142925.994282609@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit d1eb98143c56f24fef125f5bbed49ae0b52fb7d6 upstream.

On ARM and arm64, we use a dedicated mm_struct to map the UEFI
Runtime Services regions, which allows us to map those regions
on demand, and in a way that is guaranteed to be compatible
with incoming kernels across kexec.

As it turns out, we don't fully initialize the mm_struct in the
same way as process mm_structs are initialized on fork(), which
results in the following crash on ARM if CONFIG_CPUMASK_OFFSTACK=y
is enabled:

  ...
  EFI Variables Facility v0.08 2004-May-17
  Unable to handle kernel NULL pointer dereference at virtual address 00000000
  [...]
  Process swapper/0 (pid: 1)
  ...
  __memzero()
  check_and_switch_context()
  virt_efi_get_next_variable()
  efivar_init()
  efivars_sysfs_init()
  do_one_initcall()
  ...

This is due to a missing call to mm_init_cpumask(), so add it.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/1488395154-29786-1-git-send-email-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/arm-runtime.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -65,6 +65,7 @@ static bool __init efi_virtmap_init(void
 	bool systab_found;
 
 	efi_mm.pgd = pgd_alloc(&efi_mm);
+	mm_init_cpumask(&efi_mm);
 	init_new_context(NULL, &efi_mm);
 
 	systab_found = false;
