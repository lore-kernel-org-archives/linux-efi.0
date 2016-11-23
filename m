From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: use typed function pointers for runtime services table
Date: Wed, 23 Nov 2016 10:42:44 +0000
Message-ID: <1479897764-29871-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Instead of using void pointers, and casting them to correctly typed
function pointers upon use, declare the runtime services pointers
as function pointers using their respective prototypes, for which
typedefs are already available.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---

Build tested on arm64 only

 include/linux/efi.h | 36 ++++++++++----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2d089487d2da..8434be66daba 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -492,24 +492,6 @@ typedef struct {
 	u64 query_variable_info;
 } efi_runtime_services_64_t;
 
-typedef struct {
-	efi_table_hdr_t hdr;
-	void *get_time;
-	void *set_time;
-	void *get_wakeup_time;
-	void *set_wakeup_time;
-	void *set_virtual_address_map;
-	void *convert_pointer;
-	void *get_variable;
-	void *get_next_variable;
-	void *set_variable;
-	void *get_next_high_mono_count;
-	void *reset_system;
-	void *update_capsule;
-	void *query_capsule_caps;
-	void *query_variable_info;
-} efi_runtime_services_t;
-
 typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
 typedef efi_status_t efi_set_time_t (efi_time_t *tm);
 typedef efi_status_t efi_get_wakeup_time_t (efi_bool_t *enabled, efi_bool_t *pending,
@@ -544,6 +526,24 @@ typedef efi_status_t efi_query_variable_store_t(u32 attributes,
 						unsigned long size,
 						bool nonblocking);
 
+typedef struct {
+	efi_table_hdr_t			hdr;
+	efi_get_time_t			*get_time;
+	efi_set_time_t			*set_time;
+	efi_get_wakeup_time_t		*get_wakeup_time;
+	efi_set_wakeup_time_t		*set_wakeup_time;
+	efi_set_virtual_address_map_t	*set_virtual_address_map;
+	void				*convert_pointer;
+	efi_get_variable_t		*get_variable;
+	efi_get_next_variable_t		*get_next_variable;
+	efi_set_variable_t		*set_variable;
+	efi_get_next_high_mono_count_t	*get_next_high_mono_count;
+	efi_reset_system_t		*reset_system;
+	efi_update_capsule_t		*update_capsule;
+	efi_query_capsule_caps_t	*query_capsule_caps;
+	efi_query_variable_info_t	*query_variable_info;
+} efi_runtime_services_t;
+
 void efi_native_runtime_setup(void);
 
 /*
-- 
2.7.4
