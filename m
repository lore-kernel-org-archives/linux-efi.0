From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi/libstub: Make efi_random_alloc() allocate below 4 GB on 32-bit
Date: Tue, 15 Nov 2016 15:53:45 +0000
Message-ID: <1479225225-21170-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The UEFI stub executes in the context of the firmware, which identity
maps the available system RAM, which implies that only memory below
4 GB can be used for allocations on 32-bit architectures, even on [L]PAE
capable hardware.

So ignore any reported memory above 4 GB in efi_random_alloc(). This
also fixes a reported build problem on ARM under -Os, where the 64-bit
logical shift relies on a software routine that the ARM decompressor does
not provide.

A second [minor] issue is also fixed, where the '+ 1' is moved out of
the shift, where it belongs: the reason for its presence is that a
memory region where start == end should count as a single slot, given
that end takes the the desired size and alignment of the allocation into
account.

Reported-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/random.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 3a3feacc329f..c95f1f65d0ed 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -54,10 +54,13 @@ static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
 	end = round_down(md->phys_addr + md->num_pages * EFI_PAGE_SIZE - size,
 			 align);
 
+	if (end > ULONG_MAX)
+		end = ULONG_MAX + 1;
+
 	if (start > end)
 		return 0;
 
-	return (end - start + 1) >> align_shift;
+	return ((unsigned long)(end - start) >> align_shift) + 1;
 }
 
 /*
-- 
2.7.4
