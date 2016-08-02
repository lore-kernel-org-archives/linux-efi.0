From: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0171/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:46:25 +0800
Message-ID: <20160802104625.25138-1-baolex.ni@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, lho-qTEPVZfXA3Y@public.gmane.org, dougthompson-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/efivars.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 116b244..0510433 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -390,11 +390,11 @@ static void efivar_release(struct kobject *kobj)
 	kfree(var);
 }
 
-static EFIVAR_ATTR(guid, 0400, efivar_guid_read, NULL);
-static EFIVAR_ATTR(attributes, 0400, efivar_attr_read, NULL);
-static EFIVAR_ATTR(size, 0400, efivar_size_read, NULL);
-static EFIVAR_ATTR(data, 0400, efivar_data_read, NULL);
-static EFIVAR_ATTR(raw_var, 0600, efivar_show_raw, efivar_store_raw);
+static EFIVAR_ATTR(guid, S_IRUSR, efivar_guid_read, NULL);
+static EFIVAR_ATTR(attributes, S_IRUSR, efivar_attr_read, NULL);
+static EFIVAR_ATTR(size, S_IRUSR, efivar_size_read, NULL);
+static EFIVAR_ATTR(data, S_IRUSR, efivar_data_read, NULL);
+static EFIVAR_ATTR(raw_var, S_IRUSR | S_IWUSR, efivar_show_raw, efivar_store_raw);
 
 static struct attribute *def_attrs[] = {
 	&efivar_attr_guid.attr,
-- 
2.9.2
