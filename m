From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/5] efifb: omit memory map check on legacy boot
Date: Thu, 28 Mar 2019 20:34:26 +0100
Message-ID: <20190328193429.21373-3-ard.biesheuvel@linaro.org>
References: <20190328193429.21373-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190328193429.21373-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>
List-Id: linux-efi@vger.kernel.org

Since 38ac0287b7f4 ("fbdev/efifb: Honour UEFI memory map attributes
when mapping the FB"), efifb_probe() checks its memory range via
efi_mem_desc_lookup(), and this leads to a spurious error message
"EFI_MEMMAP is not enabled" at every boot on KVM.  This is quite
annoying since the error message appears even if you set "quiet" boot
option.

Since this happens on legacy boot, which strangely enough exposes
a EFI framebuffer via screen_info, let's double check that we are
doing an EFI boot before attempting to access the EFI memory map.

Cc: Peter Jones <pjones@redhat.com>
Tested-by: Takashi Iwai <tiwai@suse.de>
Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/video/fbdev/efifb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index ba906876cc45..9e529cc2b4ff 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -464,7 +464,8 @@ static int efifb_probe(struct platform_device *dev)
 	info->apertures->ranges[0].base = efifb_fix.smem_start;
 	info->apertures->ranges[0].size = size_remap;
 
-	if (!efi_mem_desc_lookup(efifb_fix.smem_start, &md)) {
+	if (efi_enabled(EFI_BOOT) &&
+	    !efi_mem_desc_lookup(efifb_fix.smem_start, &md)) {
 		if ((efifb_fix.smem_start + efifb_fix.smem_len) >
 		    (md.phys_addr + (md.num_pages << EFI_PAGE_SHIFT))) {
 			pr_err("efifb: video memory @ 0x%lx spans multiple EFI memory regions\n",
-- 
2.20.1
