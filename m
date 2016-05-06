From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 3/5] efi/capsule: Move 'capsule' to the stack in efi_capsule_supported()
Date: Fri,  6 May 2016 22:39:29 +0100
Message-ID: <1462570771-13324-4-git-send-email-matt@codeblueprint.co.uk>
References: <1462570771-13324-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462570771-13324-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Bryan O'Donoghue <pure.logic@nexus-software.ie>, Dan Carpenter <dan.carpenter@oracle.com>, joeyli <jlee@suse.com>, Kweh Hock Leong <hock.leong.kweh@intel.com>
List-Id: linux-efi@vger.kernel.org

Dan reports that passing the address of the pointer to the kmalloc()'d
memory for 'capsule' is dangerous,

 "drivers/firmware/efi/capsule.c:109 efi_capsule_supported()
  warn: did you mean to pass the address of 'capsule'

   108
   109          status = efi.query_capsule_caps(&capsule, 1, &max_size, reset);
                                                ^^^^^^^^
  If we modify capsule inside this function call then at the end of the
  function we aren't freeing the original pointer that we allocated."

Ard noted that we don't even need to call kmalloc() since the object
we allocate isn't very big and doesn't need to persist after the
function returns.

Place 'capsule' on the stack instead.

Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: joeyli <jlee@suse.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/capsule.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 4703dc9b8fbd..7593108f5402 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -86,33 +86,26 @@ bool efi_capsule_pending(int *reset_type)
  */
 int efi_capsule_supported(efi_guid_t guid, u32 flags, size_t size, int *reset)
 {
-	efi_capsule_header_t *capsule;
+	efi_capsule_header_t capsule;
+	efi_capsule_header_t *cap_list[] = { &capsule };
 	efi_status_t status;
 	u64 max_size;
-	int rv = 0;
 
 	if (flags & ~EFI_CAPSULE_SUPPORTED_FLAG_MASK)
 		return -EINVAL;
 
-	capsule = kmalloc(sizeof(*capsule), GFP_KERNEL);
-	if (!capsule)
-		return -ENOMEM;
-
-	capsule->headersize = capsule->imagesize = sizeof(*capsule);
-	memcpy(&capsule->guid, &guid, sizeof(efi_guid_t));
-	capsule->flags = flags;
+	capsule.headersize = capsule.imagesize = sizeof(capsule);
+	memcpy(&capsule.guid, &guid, sizeof(efi_guid_t));
+	capsule.flags = flags;
 
-	status = efi.query_capsule_caps(&capsule, 1, &max_size, reset);
-	if (status != EFI_SUCCESS) {
-		rv = efi_status_to_err(status);
-		goto out;
-	}
+	status = efi.query_capsule_caps(cap_list, 1, &max_size, reset);
+	if (status != EFI_SUCCESS)
+		return efi_status_to_err(status);
 
 	if (size > max_size)
-		rv = -ENOSPC;
-out:
-	kfree(capsule);
-	return rv;
+		return -ENOSPC;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(efi_capsule_supported);
 
-- 
2.7.3
