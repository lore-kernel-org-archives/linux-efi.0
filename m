From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 05/14] efi/capsule: Move 'capsule' to the stack in efi_capsule_supported()
Date: Wed, 30 Aug 2017 21:13:47 +0200
Message-ID: <40745c1b71f7fbebd2db1ee464ce1bb78fdc6f7f.1504120436.git.jan.kiszka@siemens.com>
References: <cover.1504120436.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
References: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
Cc: cip-dev-Y7OTERR3vatcpJa9FCkz6gFcV7zePqp5@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

commit fb7a84cac03541f4da18dfa25b3f4767d4efc6fc upstream.

Dan Carpenter reports that passing the address of the pointer to the
kmalloc()'d memory for 'capsule' is dangerous:

 "drivers/firmware/efi/capsule.c:109 efi_capsule_supported()
  warn: did you mean to pass the address of 'capsule'

   108
   109          status = efi.query_capsule_caps(&capsule, 1, &max_size, reset);
                                                ^^^^^^^^
  If we modify capsule inside this function call then at the end of the
  function we aren't freeing the original pointer that we allocated."

Ard Biesheuvel noted that we don't even need to call kmalloc() since the
object we allocate isn't very big and doesn't need to persist after the
function returns.

Place 'capsule' on the stack instead.

Suggested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Cc: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Link: http://lkml.kernel.org/r/1462570771-13324-4-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/capsule.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 0de55944ac0b..61e51249ef40 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -90,33 +90,26 @@ out:
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
2.12.3
