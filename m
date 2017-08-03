From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 2/3] firmware: efi: constify attribute_group structures.
Date: Thu,  3 Aug 2017 19:07:23 +0530
Message-ID: <1501767444-27873-3-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501767444-27873-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501767444-27873-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas_Warzecha@dell.com, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

attribute_group are not supposed to change at runtime. All functions
working with attribute_group provided by <linux/sysfs.h> work with
const attribute_group. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/firmware/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 045d6d3..6519be44 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -179,7 +179,7 @@ static umode_t efi_attr_is_visible(struct kobject *kobj,
 	return attr->mode;
 }
 
-static struct attribute_group efi_subsys_attr_group = {
+static const struct attribute_group efi_subsys_attr_group = {
 	.attrs = efi_subsys_attrs,
 	.is_visible = efi_attr_is_visible,
 };
-- 
1.9.1
