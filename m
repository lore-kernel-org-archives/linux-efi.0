From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] efi/libstub: Make efi_random_alloc() allocate below 4 GB on 32-bit
Date: Thu, 24 Nov 2016 18:02:23 +0000
Message-ID: <1480010543-25709-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1480010543-25709-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480010543-25709-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
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
that 'end' takes the desired size and alignment of the allocation into
account.

To clarify the code in this regard, rename start/end to 'first_slot' and
'last_slot', respectively, and introduce 'region_end' to describe the
last usable address of the current region.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/random.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 3a3feacc329f..63cd3f262b6e 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -45,19 +45,21 @@ static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
 					 unsigned long align_shift)
 {
 	unsigned long align = 1UL << align_shift;
-	u64 start, end;
+	u64 first_slot, last_slot, region_end;
 
 	if (md->type != EFI_CONVENTIONAL_MEMORY)
 		return 0;
 
-	start = round_up(md->phys_addr, align);
-	end = round_down(md->phys_addr + md->num_pages * EFI_PAGE_SIZE - size,
-			 align);
+	region_end = min((u64)ULONG_MAX,
+			 md->phys_addr + md->num_pages * EFI_PAGE_SIZE - 1);
 
-	if (start > end)
+	first_slot = round_up(md->phys_addr, align);
+	last_slot = round_down(region_end - size + 1, align);
+
+	if (first_slot > last_slot)
 		return 0;
 
-	return (end - start + 1) >> align_shift;
+	return ((unsigned long)(last_slot - first_slot) >> align_shift) + 1;
 }
 
 /*
-- 
2.7.4
