From: Alex Thorlton <athorlton@sgi.com>
Subject: [PATCH] Remove EFI memmap quirk for UV2+
Date: Fri, 11 Dec 2015 14:59:45 -0600
Message-ID: <1449867585-189233-2-git-send-email-athorlton@sgi.com>
References: <1449867585-189233-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449867585-189233-1-git-send-email-athorlton@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>, Mike Travis <travis@sgi.com>, Len Brown <len.brown@intel.com>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Commit a5d90c923bcf ("x86/efi: Quirk out SGI UV") added a quirk to
efi_apply_memmap_quirks to force SGI UV systems to fall back to the old
EFI memmap mechanism.  We have a BIOS fix for this issue on all systems
except for UV1.  This commit fixes up the EFI quirk/MMR mapping code so
that we only apply the special case to UV1 hardware.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Hedi Berriche <hedi@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Len Brown <len.brown@intel.com>
Cc: linux-efi@vger.kernel.org

---
 arch/x86/kernel/apic/x2apic_uv_x.c |  5 ++++-
 arch/x86/platform/efi/quirks.c     | 17 +++++++++++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 4a13946..96ba195 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -888,7 +888,10 @@ void __init uv_system_init(void)
 		return;
 	}
 	pr_info("UV: Found %s hub\n", hub);
-	map_low_mmrs();
+
+	/* We now only need to map the MMRs on UV1 */
+	if (is_uv1_hub())
+		map_low_mmrs();
 
 	m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
 	m_val = m_n_config.s.m_skt;
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 1c7380d..2d66db8 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -8,6 +8,7 @@
 #include <linux/memblock.h>
 #include <linux/bootmem.h>
 #include <linux/acpi.h>
+#include <linux/dmi.h>
 #include <asm/efi.h>
 #include <asm/uv/uv.h>
 
@@ -248,6 +249,16 @@ out:
 	return ret;
 }
 
+static const struct dmi_system_id sgi_uv1_dmi[] = {
+	{ NULL, "SGI UV1",
+		{	DMI_MATCH(DMI_PRODUCT_NAME,	"Stoutland Platform"),
+			DMI_MATCH(DMI_PRODUCT_VERSION,	"1.0"),
+			DMI_MATCH(DMI_BIOS_VENDOR,	"SGI.COM"),
+		}
+	},
+	{ } /* NULL entry stops DMI scanning */
+};
+
 void __init efi_apply_memmap_quirks(void)
 {
 	/*
@@ -260,10 +271,8 @@ void __init efi_apply_memmap_quirks(void)
 		efi_unmap_memmap();
 	}
 
-	/*
-	 * UV doesn't support the new EFI pagetable mapping yet.
-	 */
-	if (is_uv_system())
+	/* UV2+ BIOS has a fix for this issue.  UV1 still needs the quirk. */
+	if (dmi_check_system(sgi_uv1_dmi))
 		set_bit(EFI_OLD_MEMMAP, &efi.flags);
 }
 
-- 
1.8.5.6
