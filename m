From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 12/14] firmware: dcdbas: constify attribute_group structures.
Date: Fri, 18 Aug 2017 20:49:45 +0100
Message-ID: <20170818194947.19347-13-ard.biesheuvel@linaro.org>
References: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Douglas_Warzecha <douglas_warzecha@dell.com>
List-Id: linux-efi@vger.kernel.org

From: Arvind Yadav <arvind.yadav.cs@gmail.com>

attribute_group are not supposed to change at runtime. All functions
working with attribute_group provided by <linux/sysfs.h> work with
const attribute_group. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Douglas_Warzecha <douglas_warzecha@dell.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/dcdbas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 2fe1a130189f..c16600f30611 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -534,7 +534,7 @@ static struct attribute *dcdbas_dev_attrs[] = {
 	NULL
 };
 
-static struct attribute_group dcdbas_attr_group = {
+static const struct attribute_group dcdbas_attr_group = {
 	.attrs = dcdbas_dev_attrs,
 	.bin_attrs = dcdbas_bin_attrs,
 };
-- 
2.11.0
