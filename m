From: Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] EFI fix
Date: Sat, 10 Jun 2017 10:31:29 +0200
Message-ID: <20170610083128.fftovppe4zaq2uq4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-urgent-for-linus

   # HEAD: 792ef14df5c585c19b2831673a077504a09e5203 efi: Fix boot panic because of invalid BGRT image address

A boot crash fix for certain systems where the kernel would trust a piece of 
firmware data it should not have.

 Thanks,

	Ingo

------------------>
Dave Young (1):
      efi: Fix boot panic because of invalid BGRT image address


 drivers/firmware/efi/efi-bgrt.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
index 8bf27323f7a3..b58233e4ed71 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -27,6 +27,26 @@ struct bmp_header {
 	u32 size;
 } __packed;
 
+static bool efi_bgrt_addr_valid(u64 addr)
+{
+	efi_memory_desc_t *md;
+
+	for_each_efi_memory_desc(md) {
+		u64 size;
+		u64 end;
+
+		if (md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+
+		size = md->num_pages << EFI_PAGE_SHIFT;
+		end = md->phys_addr + size;
+		if (addr >= md->phys_addr && addr < end)
+			return true;
+	}
+
+	return false;
+}
+
 void __init efi_bgrt_init(struct acpi_table_header *table)
 {
 	void *image;
@@ -36,7 +56,7 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 	if (acpi_disabled)
 		return;
 
-	if (!efi_enabled(EFI_BOOT))
+	if (!efi_enabled(EFI_MEMMAP))
 		return;
 
 	if (table->length < sizeof(bgrt_tab)) {
@@ -65,6 +85,10 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 		goto out;
 	}
 
+	if (!efi_bgrt_addr_valid(bgrt->image_address)) {
+		pr_notice("Ignoring BGRT: invalid image address\n");
+		goto out;
+	}
 	image = early_memremap(bgrt->image_address, sizeof(bmp_header));
 	if (!image) {
 		pr_notice("Ignoring BGRT: failed to map image header memory\n");
