From: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0170/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:46:20 +0800
Message-ID: <20160802104620.25072-1-baolex.ni@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, lho-qTEPVZfXA3Y@public.gmane.org, dougthompson-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
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
 drivers/firmware/efi/efi-pstore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index eac76a7..5d29a4b 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -9,7 +9,7 @@
 static bool efivars_pstore_disable =
 	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
 
-module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
+module_param_named(pstore_disable, efivars_pstore_disable, bool, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
 #define PSTORE_EFI_ATTRIBUTES \
 	(EFI_VARIABLE_NON_VOLATILE | \
-- 
2.9.2
