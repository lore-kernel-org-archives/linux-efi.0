From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH] arm64/efi: remove spurious WARN_ON for !4K kernels
Date: Wed, 25 May 2016 16:11:56 +0100
Message-ID: <1464189116-30898-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Since commit 1fd55a9a09b0293a ("arm64/efi: Apply strict permissions to
UEFI Runtime Services regions"), booting a !4K page kernel results in a
boot-time splat on some systems, due to to a WARN_ONCE added in that
commit which fires if the base address of an EFI memory descriptor is
not aligned to the kernel page size (which might be 4K, 16K, or 64K).

On page 38 of the UEFI 2.6 specification it is stated:

	If a 64KiB physical page contains any 4KiB page with any of the
	following types listed below, then all 4KiB pages in the 64KiB
	page must use identical ARM Memory Page Attributes (as described
	in Table 8):
	=E2=80=94 EfiRuntimeServicesCode
	=E2=80=94 EfiRuntimeServicesData
	=E2=80=94 EfiReserved
	=E2=80=94 EfiACPIMemoryNVS
	Mixed attribute mappings within a larger page are not allowed.

On page 158 of the UEFI 2.6 specification, in the description of a
memory descriptor, the PhysicalStart and VirtualStart fields are
mandated as being 4K aligned, with NumberOfPages describing the number
of 4K pages in the region.

No further restriction on alignment is provided in the UEFI
specification, neither generically nor in a rule specific to AArch64.

So while attributes within a naturally-aligned 64K region must be
consistent across memory descriptors, the regions described by those
descriptors are not mandated to be 64K aligned.

Not being able to apply strict permissions is sub-optimal, and worthy o=
f
some notice, but it is not helpful to erroneously suggest that firmware
is buggy, nor is it beneficial to have a noisy backtrace at boot time.

This patch downgrades the WARN_ONCE to a pr_warn_once, and re-words the
message to also describe the implication of the insufficient alignment.

Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>=20
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 arch/arm64/kernel/efi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 78f5248..95e748e 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -30,14 +30,15 @@ static __init pteval_t create_mapping_protection(ef=
i_memory_desc_t *md)
 	if (type =3D=3D EFI_MEMORY_MAPPED_IO)
 		return PROT_DEVICE_nGnRE;
=20
-	if (WARN_ONCE(!PAGE_ALIGNED(md->phys_addr),
-		      "UEFI Runtime regions are not aligned to 64 KB -- buggy firmwa=
re?"))
+	if (!PAGE_ALIGNED(md->phys_addr)) {
+		pr_warn_once("UEFI Runtime regions insufficiently aligned for strict=
 permissions\n");
 		/*
 		 * If the region is not aligned to the page size of the OS, we
 		 * can not use strict permissions, since that would also affect
 		 * the mapping attributes of the adjacent regions.
 		 */
 		return pgprot_val(PAGE_KERNEL_EXEC);
+	}
=20
 	/* R-- */
 	if ((attr & (EFI_MEMORY_XP | EFI_MEMORY_RO)) =3D=3D
--=20
1.9.1
