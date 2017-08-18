From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 13/14] firmware: efi: constify attribute_group structures.
Date: Fri, 18 Aug 2017 20:49:46 +0100
Message-ID: <20170818194947.19347-14-ard.biesheuvel@linaro.org>
References: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170818194947.19347-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

attribute_group are not supposed to change at runtime. All functions
working with attribute_group provided by <linux/sysfs.h> work with
const attribute_group. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 045d6d311bde..6519be44387c 100644
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
2.11.0
