From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 1/3] firmware: dcdbas: constify attribute_group structures.
Date: Thu,  3 Aug 2017 19:07:22 +0530
Message-ID: <1501767444-27873-2-git-send-email-arvind.yadav.cs@gmail.com>
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
 drivers/firmware/dcdbas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 2fe1a13..c16600f 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -534,7 +534,7 @@ static int dcdbas_reboot_notify(struct notifier_block *nb, unsigned long code,
 	NULL
 };
 
-static struct attribute_group dcdbas_attr_group = {
+static const struct attribute_group dcdbas_attr_group = {
 	.attrs = dcdbas_dev_attrs,
 	.bin_attrs = dcdbas_bin_attrs,
 };
-- 
1.9.1
