From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: ARM/arm64: fix boot crash with CONFIG_CPUMASK_OFFSTACK=y
Date: Thu, 23 Feb 2017 19:26:48 +0000
Message-ID: <1487878008-10413-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On ARM and arm64, we use a dedicated mm_struct to map the UEFI
Runtime Services regions, which allows us to map those regions
on demand, and in a way that is guaranteed to be compatible
with incoming kernels across kexec.

As it turns out, we don't fully initialize the mm_struct in the
same way as process mm_structs are initialized on fork(), which
results in the following crash if CONFIG_CPUMASK_OFFSTACK is
enabled:

  EFI Variables Facility v0.08 2004-May-17
  Unable to handle kernel NULL pointer dereference at virtual address 00000000
  pgd = c0204000
  [00000000] *pgd=00000000
  Internal error: Oops: 805 [#1] SMP ARM
  Modules linked in:
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.8.6-300.fc25.armv7hl #1
  Hardware name: Generic DT based system
  task: ee90d700 task.stack: ee904000
  PC is at __memzero+0x60/0x7c
  LR is at check_and_switch_context+0x22c/0x494
  pc : [<c0515a80>]    lr : [<c02234e0>]    psr: 000c0093
  sp : ee905e18  ip : 00000004  fp : 00000000
  r10: 00000000  r9 : c0e8e718  r8 : c0e38f70
  r7 : 00000000  r6 : 00000005  r5 : c0e390d8  r4 : c0d87098
  r3 : 00000000  r2 : 00000000  r1 : 00000004  r0 : 00000000
  Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
  Control: 10c5383d  Table: 4020406a  DAC: 00000051
  Process swapper/0 (pid: 1, stack limit = 0xee904220)
  Stack: (0xee905e18 to 0xee906000)
  ...
  [<c0515a80>] (__memzero) from [<c02234e0>] (check_and_switch_context+0x22c/0x494)
  [<c02234e0>] (check_and_switch_context) from [<c0770cc4>] (virt_efi_get_next_variable+0x28/0x8c)
  [<c0770cc4>] (virt_efi_get_next_variable) from [<c076dbac>] (efivar_init+0x94/0x2d4)
  [<c076dbac>] (efivar_init) from [<c076fa38>] (efivars_sysfs_init+0x8c/0x1e8)
  [<c076fa38>] (efivars_sysfs_init) from [<c0209d48>] (do_one_initcall+0x130/0x158)
  [<c0209d48>] (do_one_initcall) from [<c0c5bea8>] (kernel_init_freeable+0x210/0x25c)

This is due to a missing call to mm_init_cpumask(), so add it.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/arm-runtime.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index c394b81fe452..b4dd8b5ad516 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -45,6 +45,7 @@ static bool __init efi_virtmap_init(void)
 	bool systab_found;
 
 	efi_mm.pgd = pgd_alloc(&efi_mm);
+	mm_init_cpumask(&efi_mm);
 	init_new_context(NULL, &efi_mm);
 
 	systab_found = false;
-- 
2.7.4
