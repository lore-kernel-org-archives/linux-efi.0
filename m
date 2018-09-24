From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.18 167/235] efi/esrt: Only call efi_mem_reserve() for boot services memory
Date: Mon, 24 Sep 2018 13:52:33 +0200
Message-ID: <20180924113121.683622359@linuxfoundation.org>
References: <20180924113103.999624566@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180924113103.999624566@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Sasha Levin <alexander.levin@microsoft.com>
List-Id: linux-efi@vger.kernel.org

4.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit 61f0d55569463a1af897117ff47d202b0ccb2e24 ]

The following commit:

  7e1550b8f208 ("efi: Drop type and attribute checks in efi_mem_desc_lookup()")

refactored the implementation of efi_mem_desc_lookup() so that the type
check is moved to the callers, one of which is the x86 version of
efi_arch_mem_reserve(), where we added a modified check that only takes
EFI_BOOT_SERVICES_DATA regions into account.

This is reasonable, since it is the only memory type that requires this,
but doing so uncovered some unexpected behavior in the ESRT code, which
permits the ESRT table to reside in other types of memory than what the
UEFI spec mandates (i.e., EFI_BOOT_SERVICES_DATA), and unconditionally
calls efi_mem_reserve() on the region in question. This may result in
errors such as

  esrt: Reserving ESRT space from 0x000000009c810318 to 0x000000009c810350.
  efi: Failed to lookup EFI memory descriptor for 0x000000009c810318

when the ESRT table is not in EFI_BOOT_SERVICES_DATA memory, but we try
to reserve it nonetheless.

So make the call to efi_mem_reserve() conditional on the memory type.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/esrt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -326,7 +326,8 @@ void __init efi_esrt_init(void)
 
 	end = esrt_data + size;
 	pr_info("Reserving ESRT space from %pa to %pa.\n", &esrt_data, &end);
-	efi_mem_reserve(esrt_data, esrt_data_size);
+	if (md.type == EFI_BOOT_SERVICES_DATA)
+		efi_mem_reserve(esrt_data, esrt_data_size);
 
 	pr_debug("esrt-init: loaded.\n");
 }
