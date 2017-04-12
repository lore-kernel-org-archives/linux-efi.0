From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH] x86/efi: Don't try to reserve runtime regions
Date: Wed, 12 Apr 2017 16:27:19 +0100
Message-ID: <20170412152719.9779-2-matt@codeblueprint.co.uk>
References: <20170412152719.9779-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170412152719.9779-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Omar Sandoval <osandov@fb.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Dave Young <dyoung@redhat.com>, Peter Jones <pjones@redhat.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Reserving a runtime region results in splitting the efi memory
descriptors for the runtime region. This results in runtime region
descriptors with bogus memory mappings, leading to interesting crashes
like the following during a kexec:

[    0.001000] general protection fault: 0000 [#1] SMP
[    0.001000] Modules linked in:
[    0.001000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.11.0-rc1 #53
[    0.001000] Hardware name: Wiwynn Leopard-Orv2/Leopard-DDR BW, BIOS LBM05   09/30/2016
[    0.001000] task: ffffffff81e0e4c0 task.stack: ffffffff81e00000
[    0.001000] RIP: 0010:virt_efi_set_variable+0x85/0x1a0
[    0.001000] RSP: 0000:ffffffff81e03e18 EFLAGS: 00010202
[    0.001000] RAX: afafafafafafafaf RBX: ffffffff81e3a4e0 RCX: 0000000000000007
[    0.001000] RDX: ffffffff81e03e70 RSI: ffffffff81e3a4e0 RDI: ffff88407f8c2de0
[    0.001000] RBP: ffffffff81e03e60 R08: 0000000000000000 R09: 0000000000000000
[    0.001000] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81e03e70
[    0.001000] R13: 0000000000000007 R14: 0000000000000000 R15: 0000000000000000
[    0.001000] FS:  0000000000000000(0000) GS:ffff881fff600000(0000) knlGS:0000000000000000
[    0.001000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.001000] CR2: ffff88407f30f000 CR3: 0000001fff102000 CR4: 00000000000406b0
[    0.001000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.001000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    0.001000] Call Trace:
[    0.001000]  efi_delete_dummy_variable+0x7a/0x80
[    0.001000]  efi_enter_virtual_mode+0x3e2/0x494
[    0.001000]  start_kernel+0x392/0x418
[    0.001000]  ? set_init_arg+0x55/0x55
[    0.001000]  x86_64_start_reservations+0x2a/0x2c
[    0.001000]  x86_64_start_kernel+0xea/0xed
[    0.001000]  start_cpu+0x14/0x14
[    0.001000] Code: 42 25 8d ff 80 3d 43 77 95 00 00 75 68 9c 8f 04 24 48 8b 05 3e 7d 7e 00 48 89 de 4d 89 f9 4d 89 f0 44 89 e9 4c 89 e2 48 8b 40 58 <48> 8b 78 58 31 c0 e8 90 e4 92 ff 48 8b 3c 24 48 c7 c6 2b 0a ca
[    0.001000] RIP: virt_efi_set_variable+0x85/0x1a0 RSP: ffffffff81e03e18
[    0.001000] ---[ end trace 0bd213e540e9b19f ]---
[    0.001000] Kernel panic - not syncing: Fatal exception
[    0.001000] ---[ end Kernel panic - not syncing: Fatal exception

Runtime regions will not be freed and do not need to be reserved, so
skip the memmap modification in this case.

Fixes: 8e80632fb23f ("efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()")
Signed-off-by: Omar Sandoval <osandov@fb.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 30031d5293c4..cdfe8c628959 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -201,6 +201,10 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 		return;
 	}
 
+	/* No need to reserve regions that will never be freed. */
+	if (md.attribute & EFI_MEMORY_RUNTIME)
+		return;
+
 	size += addr % EFI_PAGE_SIZE;
 	size = round_up(size, EFI_PAGE_SIZE);
 	addr = round_down(addr, EFI_PAGE_SIZE);
-- 
2.10.0
