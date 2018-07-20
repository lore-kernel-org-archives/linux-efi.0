From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 9/9] efivars: Call guid_parse() against guid_t type of variable
Date: Fri, 20 Jul 2018 10:47:26 +0900
Message-ID: <20180720014726.24031-10-ard.biesheuvel@linaro.org>
References: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

uuid_le_to_bin() is deprecated API and take into consideration that variable,
to where we store parsed data, is type of guid_t we switch to guid_parse()
for sake of consistency.

While here, add error checking to it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 fs/efivarfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index 71fccccf317e..8c6ab6c95727 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -86,7 +86,9 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	/* length of the variable name itself: remove GUID and separator */
 	namelen = dentry->d_name.len - EFI_VARIABLE_GUID_LEN - 1;
 
-	uuid_le_to_bin(dentry->d_name.name + namelen + 1, &var->var.VendorGuid);
+	err = guid_parse(dentry->d_name.name + namelen + 1, &var->var.VendorGuid);
+	if (err)
+		goto out;
 
 	if (efivar_variable_is_removable(var->var.VendorGuid,
 					 dentry->d_name.name, namelen))
-- 
2.17.1
