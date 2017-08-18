From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 01/14] efi: arm: Don't mark ACPI reclaim memory as MEMBLOCK_NOMAP
Date: Fri, 18 Aug 2017 20:49:34 +0100
Message-ID: <20170818194947.19347-2-ard.biesheuvel@linaro.org>
References: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On ARM, regions of memory that are described by UEFI as having special
significance to the firmware itself are omitted from the linear mapping.
This is necessary since we cannot guarantee that alternate mappings of
the same physical region will use attributes that are compatible with
the ones we use for the linear mapping, and aliases with mismatched
attributes are prohibited by the architecture.

The above does not apply to ACPI reclaim regions: such regions have no
special significance to the firmware, and it is up to the OS to decide
whether or not to preserve them after it has consumed their contents,
and for how long, after which time the OS can use the memory in any way
it likes. In the Linux case, such regions are preserved indefinitely,
and are simply treated the same way as other 'reserved' memory types.

Punching holes into the linear mapping causes page table fragmentation,
which increases TLB pressure, and so we should avoid doing so if we can.
So add a special case for regions of type EFI_ACPI_RECLAIM_MEMORY, and
memblock_reserve() them instead of marking them MEMBLOCK_NOMAP.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/arm-init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 1027d7b44358..0aa4ce7b4fbb 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -159,6 +159,7 @@ static __init int is_usable_memory(efi_memory_desc_t *md)
 	switch (md->type) {
 	case EFI_LOADER_CODE:
 	case EFI_LOADER_DATA:
+	case EFI_ACPI_RECLAIM_MEMORY:
 	case EFI_BOOT_SERVICES_CODE:
 	case EFI_BOOT_SERVICES_DATA:
 	case EFI_CONVENTIONAL_MEMORY:
@@ -211,6 +212,10 @@ static __init void reserve_regions(void)
 
 			if (!is_usable_memory(md))
 				memblock_mark_nomap(paddr, size);
+
+			/* keep ACPI reclaim memory intact for kexec etc. */
+			if (md->type == EFI_ACPI_RECLAIM_MEMORY)
+				memblock_reserve(paddr, size);
 		}
 	}
 }
-- 
2.11.0
