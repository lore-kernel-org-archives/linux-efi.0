From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 21/29] fs/efivarfs: Fix double kfree() in error path
Date: Fri,  9 Sep 2016 16:18:43 +0100
Message-ID: <20160909151851.27577-22-matt@codeblueprint.co.uk>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, Sylvain Chouleur <sylvain.chouleur@gmail.com>
List-Id: linux-efi@vger.kernel.org

Julia reported that we may double free 'name' in efivarfs_callback(),
and that this bug was introduced by commit 0d22f33bc37c ("efi: Don't
use spinlocks for efi vars").

Move one of the kfree()s until after the point at which we know we are
definitely on the success path.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Sylvain Chouleur <sylvain.chouleur@gmail.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 fs/efivarfs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 01e3d6e53944..d7a7c53803c1 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -157,14 +157,14 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 		goto fail_inode;
 	}
 
-	/* copied by the above to local storage in the dentry. */
-	kfree(name);
-
 	efivar_entry_size(entry, &size);
 	err = efivar_entry_add(entry, &efivarfs_list);
 	if (err)
 		goto fail_inode;
 
+	/* copied by the above to local storage in the dentry. */
+	kfree(name);
+
 	inode_lock(inode);
 	inode->i_private = entry;
 	i_size_write(inode, size + sizeof(entry->var.Attributes));
-- 
2.9.3
