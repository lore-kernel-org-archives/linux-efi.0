From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/7] efi: use typed function pointers for runtime services
 table [ver #3]
Date: Wed, 23 Nov 2016 12:53:40 +0000
Message-ID: <147990562059.7576.2346857409853503447.stgit@warthog.procyon.org.uk>
References: <147990561294.7576.6464430479448167484.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <147990561294.7576.6464430479448167484.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Instead of using void pointers, and casting them to correctly typed
function pointers upon use, declare the runtime services pointers
as function pointers using their respective prototypes, for which
typedefs are already available.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 include/linux/efi.h |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index a07a476178cd..93a82de167eb 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -508,24 +508,6 @@ typedef struct {
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
@@ -560,6 +542,24 @@ typedef efi_status_t efi_query_variable_store_t(u32 attributes,
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
