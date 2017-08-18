From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 14/14] firmware: efi: esrt: constify attribute_group structures.
Date: Fri, 18 Aug 2017 20:49:47 +0100
Message-ID: <20170818194947.19347-15-ard.biesheuvel@linaro.org>
References: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Arvind Yadav <arvind.yadav.cs@gmail.com>

attribute_group are not supposed to change at runtime. All functions
working with attribute_group provided by <linux/sysfs.h> work with
const attribute_group. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/esrt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index 8554d7aec31c..bd7ed3c1148a 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -230,7 +230,7 @@ static umode_t esrt_attr_is_visible(struct kobject *kobj,
 	return attr->mode;
 }
 
-static struct attribute_group esrt_attr_group = {
+static const struct attribute_group esrt_attr_group = {
 	.attrs = esrt_attrs,
 	.is_visible = esrt_attr_is_visible,
 };
-- 
2.11.0
