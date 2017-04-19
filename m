From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 16/69] x86/efi: Dont try to reserve runtime regions
Date: Wed, 19 Apr 2017 16:42:32 +0200
Message-ID: <20170419141617.630925177@linuxfoundation.org>
References: <20170419141616.919951169@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170419141616.919951169@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Young <dyoung@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Omar Sandoval <osandov@fb.com>

commit 6f6266a561306e206e0e31a5038f029b6a7b1d89 upstream.

Reserving a runtime region results in splitting the EFI memory
descriptors for the runtime region. This results in runtime region
descriptors with bogus memory mappings, leading to interesting crashes
like the following during a kexec:

  general protection fault: 0000 [#1] SMP
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.11.0-rc1 #53
  Hardware name: Wiwynn Leopard-Orv2/Leopard-DDR BW, BIOS LBM05   09/30/2016
  RIP: 0010:virt_efi_set_variable()
  ...
  Call Trace:
   efi_delete_dummy_variable()
   efi_enter_virtual_mode()
   start_kernel()
   ? set_init_arg()
   x86_64_start_reservations()
   x86_64_start_kernel()
   start_cpu()
  ...
  Kernel panic - not syncing: Fatal exception

Runtime regions will not be freed and do not need to be reserved, so
skip the memmap modification in this case.

Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Fixes: 8e80632fb23f ("efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()")
Link: http://lkml.kernel.org/r/20170412152719.9779-2-matt@codeblueprint.co.uk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -201,6 +201,10 @@ void __init efi_arch_mem_reserve(phys_ad
 		return;
 	}
 
+	/* No need to reserve regions that will never be freed. */
+	if (md.attribute & EFI_MEMORY_RUNTIME)
+		return;
+
 	size += addr % EFI_PAGE_SIZE;
 	size = round_up(size, EFI_PAGE_SIZE);
 	addr = round_down(addr, EFI_PAGE_SIZE);
