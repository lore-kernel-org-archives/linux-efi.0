From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/5] efi/arm: libstub: pack FDT after populating it
Date: Wed, 14 Nov 2018 09:55:42 -0800
Message-ID: <20181114175544.12860-4-ard.biesheuvel@linaro.org>
References: <20181114175544.12860-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181114175544.12860-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Commit 24d7c494ce46 ("efi/arm-stub: Round up FDT allocation to mapping
size") increased the allocation size for the FDT image created by the
stub to a fixed value of 2 MB, to simplify the former code that made
several attempts with increasing values for the size. This is reasonable
given that the allocation is of type EFI_LOADER_DATA, which is released
to the kernel unless it is explicitly memblock_reserve()d by the early
boot code.

However, this allocation size leaked into the 'size' field of the FDT
header metadata, and so the entire allocation remains occupied by the
device tree binary, even if most of it is not used to store device tree
information.

So call fdt_pack() to shrink the FDT data structure to its minimum size
after populating all the fields, so that the remaining memory is no
longer wasted.

Cc: <stable@vger.kernel.org> # v4.12+
Fixes: 24d7c494ce46 ("efi/arm-stub: Round up FDT allocation to mapping size")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/fdt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 8830fa601e45..0c0d2312f4a8 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -158,6 +158,10 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 			return efi_status;
 		}
 	}
+
+	/* shrink the FDT back to its minimum size */
+	fdt_pack(fdt);
+
 	return EFI_SUCCESS;
 
 fdt_set_fail:
-- 
2.17.1
