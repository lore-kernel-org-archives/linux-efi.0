From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] x86: setup: extend low identity map to cover whole kernel range
Date: Wed, 14 Oct 2015 13:30:45 +0200
Message-ID: <1444822245-6784-1-git-send-email-pbonzini@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, x86@kernel.org, stable@vger.kernel.org, lersek@redhat.com, matt.fleming@intel.com, bp@suse.de, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 32-bit systems, the initial_page_table is reused by
efi_call_phys_prolog as an identity map to call
SetVirtualAddressMap.  efi_call_phys_prolog takes care of
converting the current CPU's GDT to a physical address too.

For PAE kernels the identity mapping is achieved by aliasing the
first PDPE for the kernel memory mapping into the first PDPE
of initial_page_table.  This makes the EFI stub's trick "just work".

However, for non-PAE kernels there is no guarantee that the identity
mapping in the initial_page_table extends as far as the GDT; in this
case, accesses to the GDT will cause a page fault (which quickly becomes
a triple fault).  Fix this by copying the kernel mappings from
swapper_pg_dir to initial_page_table twice, both at PAGE_OFFSET and at
identity mapping.

For some reason, this is only reproducible with QEMU's dynamic translation
mode, and not for example with KVM.  However, even under KVM one can clearly
see that the page table is bogus:

    $ qemu-system-i386 -pflash OVMF.fd -M q35 vmlinuz0 -s -S -daemonize
    $ gdb
    (gdb) target remote localhost:1234
    (gdb) hb *0x02858f6f
    Hardware assisted breakpoint 1 at 0x2858f6f
    (gdb) c
    Continuing.

    Breakpoint 1, 0x02858f6f in ?? ()
    (gdb) monitor info registers
    ...
    GDT=     0724e000 000000ff
    IDT=     fffbb000 000007ff
    CR0=0005003b CR2=ff896000 CR3=032b7000 CR4=00000690
    ...

The page directory is sane:

    (gdb) x/4wx 0x32b7000
    0x32b7000:	0x03398063	0x03399063	0x0339a063	0x0339b063
    (gdb) x/4wx 0x3398000
    0x3398000:	0x00000163	0x00001163	0x00002163	0x00003163
    (gdb) x/4wx 0x3399000
    0x3399000:	0x00400003	0x00401003	0x00402003	0x00403003

but our particular page directory entry is empty:

    (gdb) x/1wx 0x32b7000 + (0x724e000 >> 22) * 4
    0x32b7070:	0x00000000

Reported-by: Laszlo Ersek <lersek@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/setup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 80f874bf999e..24154bd12307 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1198,6 +1198,14 @@ void __init setup_arch(char **cmdline_p)
 	clone_pgd_range(initial_page_table + KERNEL_PGD_BOUNDARY,
 			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
 			KERNEL_PGD_PTRS);
+
+	/*
+	 * sync back low identity map too.  It is used for example
+	 * in the 32-bit EFI stub.
+	 */
+	clone_pgd_range(initial_page_table,
+			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
+			KERNEL_PGD_PTRS);
 #endif
 
 	tboot_probe();
-- 
2.5.0
