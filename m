From: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH 3/3 v2] xen: Implement EFI reset_system callback
Date: Mon, 24 Apr 2017 18:58:39 +0100
Message-ID: <20170424175839.5262-4-julien.grall@arm.com>
References: <20170424175839.5262-1-julien.grall@arm.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170424175839.5262-1-julien.grall-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org
Cc: sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

When rebooting DOM0 with ACPI on ARM64, the kernel is crashing with the stack
trace [1].

This is happening because when EFI runtimes are enabled, the reset code
(see machine_restart) will first try to use EFI restart method.

However, the EFI restart code is expecting the reset_system callback to
be always set. This is not the case for Xen and will lead to crash.

The EFI restart helper is used in multiple places and some of them don't
not have fallback (see machine_power_off). So implement reset_system
callback as a call to xen_reboot when using EFI Xen.

[   36.999270] reboot: Restarting system
[   37.002921] Internal error: Attempting to execute userspace memory: 86000004 [#1] PREEMPT SMP
[   37.011460] Modules linked in:
[   37.014598] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 4.11.0-rc1-00003-g1e248b60a39b-dirty #506
[   37.023903] Hardware name: (null) (DT)
[   37.027734] task: ffff800902068000 task.stack: ffff800902064000
[   37.033739] PC is at 0x0
[   37.036359] LR is at efi_reboot+0x94/0xd0
[   37.040438] pc : [<0000000000000000>] lr : [<ffff00000880f2c4>] pstate: 404001c5
[   37.047920] sp : ffff800902067cf0
[   37.051314] x29: ffff800902067cf0 x28: ffff800902068000
[   37.056709] x27: ffff000008992000 x26: 000000000000008e
[   37.062104] x25: 0000000000000123 x24: 0000000000000015
[   37.067499] x23: 0000000000000000 x22: ffff000008e6e250
[   37.072894] x21: ffff000008e6e000 x20: 0000000000000000
[   37.078289] x19: ffff000008e5d4c8 x18: 0000000000000010
[   37.083684] x17: 0000ffffa7c27470 x16: 00000000deadbeef
[   37.089079] x15: 0000000000000006 x14: ffff000088f42bef
[   37.094474] x13: ffff000008f42bfd x12: ffff000008e706c0
[   37.099870] x11: ffff000008e70000 x10: 0000000005f5e0ff
[   37.105265] x9 : ffff800902067a50 x8 : 6974726174736552
[   37.110660] x7 : ffff000008cc6fb8 x6 : ffff000008cc6fb0
[   37.116055] x5 : ffff000008c97dd8 x4 : 0000000000000000
[   37.121453] x3 : 0000000000000000 x2 : 0000000000000000
[   37.126845] x1 : 0000000000000000 x0 : 0000000000000000
[   37.132239]
[   37.133808] Process systemd-shutdow (pid: 1, stack limit = 0xffff800902064000)
[   37.141118] Stack: (0xffff800902067cf0 to 0xffff800902068000)
[   37.146949] 7ce0:                                   ffff800902067d40 ffff000008085334
[   37.154869] 7d00: 0000000000000000 ffff000008f3b000 ffff800902067d40 ffff0000080852e0
[   37.162787] 7d20: ffff000008cc6fb0 ffff000008cc6fb8 ffff000008c7f580 ffff000008c97dd8
[   37.170706] 7d40: ffff800902067d60 ffff0000080e2c2c 0000000000000000 0000000001234567
[   37.178624] 7d60: ffff800902067d80 ffff0000080e2ee8 0000000000000000 ffff0000080e2df4
[   37.186544] 7d80: 0000000000000000 ffff0000080830f0 0000000000000000 00008008ff1c1000
[   37.194462] 7da0: ffffffffffffffff 0000ffffa7c4b1cc 0000000000000000 0000000000000024
[   37.202380] 7dc0: ffff800902067dd0 0000000000000005 0000fffff24743c8 0000000000000004
[   37.210299] 7de0: 0000fffff2475f03 0000000000000010 0000fffff2474418 0000000000000005
[   37.218218] 7e00: 0000fffff2474578 000000000000000a 0000aaaad6b722c0 0000000000000001
[   37.226136] 7e20: 0000000000000123 0000000000000038 ffff800902067e50 ffff0000081e7294
[   37.234055] 7e40: ffff800902067e60 ffff0000081e935c ffff800902067e60 ffff0000081e9388
[   37.241973] 7e60: ffff800902067eb0 ffff0000081ea388 0000000000000000 00008008ff1c1000
[   37.249892] 7e80: ffffffffffffffff 0000ffffa7c4a79c 0000000000000000 ffff000000020000
[   37.257810] 7ea0: 0000010000000004 0000000000000000 0000000000000000 ffff0000080830f0
[   37.265729] 7ec0: fffffffffee1dead 0000000028121969 0000000001234567 0000000000000000
[   37.273651] 7ee0: ffffffffffffffff 8080000000800000 0000800000008080 feffa9a9d4ff2d66
[   37.281567] 7f00: 000000000000008e feffa9a9d5b60e0f 7f7fffffffff7f7f 0101010101010101
[   37.289485] 7f20: 0000000000000010 0000000000000008 000000000000003a 0000ffffa7ccf588
[   37.297404] 7f40: 0000aaaad6b87d00 0000ffffa7c4b1b0 0000fffff2474be0 0000aaaad6b88000
[   37.305326] 7f60: 0000fffff2474fb0 0000000001234567 0000000000000000 0000000000000000
[   37.313240] 7f80: 0000000000000000 0000000000000001 0000aaaad6b70d4d 0000000000000000
[   37.321159] 7fa0: 0000000000000001 0000fffff2474ea0 0000aaaad6b5e2e0 0000fffff2474e80
[   37.329078] 7fc0: 0000ffffa7c4b1cc 0000000000000000 fffffffffee1dead 000000000000008e
[   37.336997] 7fe0: 0000000000000000 0000000000000000 9ce839cffee77eab fafdbf9f7ed57f2f
[   37.344911] Call trace:
[   37.347437] Exception stack(0xffff800902067b20 to 0xffff800902067c50)
[   37.353970] 7b20: ffff000008e5d4c8 0001000000000000 0000000080f82000 0000000000000000
[   37.361883] 7b40: ffff800902067b60 ffff000008e17000 ffff000008f44c68 00000001081081b4
[   37.369802] 7b60: ffff800902067bf0 ffff000008108478 0000000000000000 ffff000008c235b0
[   37.377721] 7b80: ffff800902067ce0 0000000000000000 0000000000000000 0000000000000015
[   37.385643] 7ba0: 0000000000000123 000000000000008e ffff000008992000 ffff800902068000
[   37.393557] 7bc0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   37.401477] 7be0: 0000000000000000 ffff000008c97dd8 ffff000008cc6fb0 ffff000008cc6fb8
[   37.409396] 7c00: 6974726174736552 ffff800902067a50 0000000005f5e0ff ffff000008e70000
[   37.417318] 7c20: ffff000008e706c0 ffff000008f42bfd ffff000088f42bef 0000000000000006
[   37.425234] 7c40: 00000000deadbeef 0000ffffa7c27470
[   37.430190] [<          (null)>]           (null)
[   37.434982] [<ffff000008085334>] machine_restart+0x6c/0x70
[   37.440550] [<ffff0000080e2c2c>] kernel_restart+0x6c/0x78
[   37.446030] [<ffff0000080e2ee8>] SyS_reboot+0x130/0x228
[   37.451337] [<ffff0000080830f0>] el0_svc_naked+0x24/0x28
[   37.456737] Code: bad PC value
[   37.459891] ---[ end trace 76e2fc17e050aecd ]---

Signed-off-by: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>

--

Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

The x86 code has theoritically a similar issue, altought EFI does not
seem to be the preferred method. I have only built test it on x86.

This should also probably be fixed in stable tree.

    Changes in v2:
        - Implement xen_efi_reset_system using xen_reboot
        - Move xen_efi_reset_system in drivers/xen/efi.c
---
 arch/arm/xen/efi.c    |  2 +-
 arch/x86/xen/efi.c    |  2 +-
 drivers/xen/efi.c     | 18 ++++++++++++++++++
 include/xen/xen-ops.h |  3 +++
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/arm/xen/efi.c b/arch/arm/xen/efi.c
index 16db419f9e90..b4d78959cadf 100644
--- a/arch/arm/xen/efi.c
+++ b/arch/arm/xen/efi.c
@@ -35,6 +35,6 @@ void __init xen_efi_runtime_setup(void)
 	efi.update_capsule           = xen_efi_update_capsule;
 	efi.query_capsule_caps       = xen_efi_query_capsule_caps;
 	efi.get_next_high_mono_count = xen_efi_get_next_high_mono_count;
-	efi.reset_system             = NULL; /* Functionality provided by Xen. */
+	efi.reset_system             = xen_efi_reset_system;
 }
 EXPORT_SYMBOL_GPL(xen_efi_runtime_setup);
diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
index 3be012115853..30bb2e80cfe7 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -81,7 +81,7 @@ static const struct efi efi_xen __initconst = {
 	.update_capsule           = xen_efi_update_capsule,
 	.query_capsule_caps       = xen_efi_query_capsule_caps,
 	.get_next_high_mono_count = xen_efi_get_next_high_mono_count,
-	.reset_system             = NULL, /* Functionality provided by Xen. */
+	.reset_system             = xen_efi_reset_system,
 	.set_virtual_address_map  = NULL, /* Not used under Xen. */
 	.flags			  = 0     /* Initialized later. */
 };
diff --git a/drivers/xen/efi.c b/drivers/xen/efi.c
index 22f71ffd3406..9243a9051078 100644
--- a/drivers/xen/efi.c
+++ b/drivers/xen/efi.c
@@ -26,6 +26,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/platform.h>
 #include <xen/xen.h>
+#include <xen/xen-ops.h>
 
 #include <asm/page.h>
 
@@ -263,3 +264,20 @@ efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 	return efi_data(op).status;
 }
 EXPORT_SYMBOL_GPL(xen_efi_query_capsule_caps);
+
+void xen_efi_reset_system(int reset_type, efi_status_t status,
+			  unsigned long data_size, efi_char16_t *data)
+{
+	switch (reset_type) {
+	case EFI_RESET_COLD:
+	case EFI_RESET_WARM:
+		xen_reboot(SHUTDOWN_reboot);
+		break;
+	case EFI_RESET_SHUTDOWN:
+		xen_reboot(SHUTDOWN_poweroff);
+		break;
+	default:
+		BUG();
+	}
+}
+EXPORT_SYMBOL_GPL(xen_efi_reset_system);
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index fc5ddb472f86..197bb4866327 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -122,6 +122,9 @@ efi_status_t xen_efi_update_capsule(efi_capsule_header_t **capsules,
 efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 					unsigned long count, u64 *max_size,
 					int *reset_type);
+void xen_efi_reset_system(int reset_type, efi_status_t status,
+			  unsigned long data_size, efi_char16_t *data);
+
 
 #ifdef CONFIG_PREEMPT
 
-- 
2.11.0
