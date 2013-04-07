From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] efivars: Implement no_storage_paranoia parameter
Date: Mon,  8 Apr 2013 00:32:18 +0200
Message-ID: <1365373938-25993-2-git-send-email-richard@nod.at>
References: <1365373938-25993-1-git-send-email-richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365373938-25993-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
To: matt.fleming@intel.com
Cc: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org, tony.luck@intel.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.garrett@nebula.com, Richard Weinberger <richard@nod.at>
List-Id: linux-efi@vger.kernel.org

Using this parameter one can disable the storage_size/2 check if
he is really sure that the UEFI does sane gc.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/firmware/efivars.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 60c9899..0926471 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -105,8 +105,10 @@ MODULE_VERSION(EFIVARS_VERSION);
 
 static bool efivars_pstore_disable =
 	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
+static bool efivars_no_storage_paranoia;
 
 module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
+module_param_named(no_storage_paranoia, efivars_no_storage_paranoia, bool, 0644);
 
 /*
  * The maximum size of VariableName + Data = 1024
@@ -453,7 +455,10 @@ check_var_size_locked(struct efivars *efivars, u32 attributes,
 		printk_once(KERN_ERR FW_BUG "Broken EFI implementation is returning MaxVariableSize=0\n");
 
 	if (!storage_size || size > remaining_size ||
-	    (max_size && size > max_size) ||
+	    (max_size && size > max_size))
+		return EFI_OUT_OF_RESOURCES;
+
+	if (!efivars_no_storage_paranoia &&
 	    (remaining_size - size) < (storage_size / 2))
 		return EFI_OUT_OF_RESOURCES;
 
-- 
1.8.1.4
