From: Saurabh Sengar <saurabh.truth@gmail.com>
Subject: [PATCH v2] efi: replace GFP_KERNEL with GFP_ATOMIC
Date: Wed, 28 Oct 2015 09:12:27 +0530
Message-ID: <1446003747-3760-1-git-send-email-saurabh.truth@gmail.com>
References: <saurabh.truth@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <saurabh.truth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: matt@codeblueprint.co.uk, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Saurabh Sengar <saurabh.truth@gmail.com>
List-Id: linux-efi@vger.kernel.org

replace GFP_KERNEL with GFP_ATOMIC, as code while holding a spinlock
should be atomic
GFP_KERNEL may sleep and can cause deadlock, where as GFP_ATOMIC may
fail but certainly avoids deadlock

Signed-off-by: Saurabh Sengar <saurabh.truth@gmail.com>
---
 drivers/firmware/efi/vars.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 70a0fb1..d4eeebf 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -322,10 +322,11 @@ static unsigned long var_name_strnsize(efi_char16_t *variable_name,
  * disable the sysfs workqueue since the firmware is buggy.
  */
 static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
-			     unsigned long len16)
+			     unsigned long len16, bool atomic)
 {
 	size_t i, len8 = len16 / sizeof(efi_char16_t);
 	char *str8;
+	int gfp_mask;
 
 	/*
 	 * Disable the workqueue since the algorithm it uses for
@@ -334,7 +335,12 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
 	 */
 	efivar_wq_enabled = false;
 
-	str8 = kzalloc(len8, GFP_KERNEL);
+	if (atomic)
+		gfp_mask = GFP_ATOMIC;
+	else
+		gfp_mask = GFP_KERNEL;
+
+	str8 = kzalloc(len8, gfp_mask);
 	if (!str8)
 		return;
 
@@ -408,7 +414,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 			if (duplicates &&
 			    variable_is_present(variable_name, &vendor_guid, head)) {
 				dup_variable_bug(variable_name, &vendor_guid,
-						 variable_name_size);
+						 variable_name_size, atomic);
 				if (!atomic)
 					spin_lock_irq(&__efivars->lock);
 
-- 
1.9.1
