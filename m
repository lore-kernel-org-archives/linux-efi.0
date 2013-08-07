From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 12/17] Add proper definitions for some EFI function pointers.
Date: Tue,  6 Aug 2013 20:45:08 -0700
Message-ID: <1375847113-24884-13-git-send-email-roy.franz@linaro.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375847113-24884-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The x86/AMD64 EFI stubs must us a call wrapper to convert between
the Linux and EFI ABIs, so void pointers are sufficient.  For ARM,
the ABIs are compatible, so we can directly invoke the function
pointers.  The functions that are used by the ARM stub are updated
to match the EFI definitions.

Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/linux/efi.h |   42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 51f5641..96bb866 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -39,6 +39,8 @@
 typedef unsigned long efi_status_t;
 typedef u8 efi_bool_t;
 typedef u16 efi_char16_t;		/* UNICODE character */
+typedef u64 efi_physical_addr_t;
+typedef void *efi_handle_t;
 
 
 typedef struct {
@@ -96,6 +98,7 @@ typedef	struct {
 #define EFI_MEMORY_DESCRIPTOR_VERSION	1
 
 #define EFI_PAGE_SHIFT		12
+#define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
 
 typedef struct {
 	u32 type;
@@ -157,11 +160,12 @@ typedef struct {
 	efi_table_hdr_t hdr;
 	void *raise_tpl;
 	void *restore_tpl;
-	void *allocate_pages;
-	void *free_pages;
-	void *get_memory_map;
-	void *allocate_pool;
-	void *free_pool;
+	int (*allocate_pages)(int, int, unsigned long, efi_physical_addr_t *);
+	int (*free_pages)(efi_physical_addr_t, unsigned long);
+	int (*get_memory_map)(unsigned long *, void *, unsigned long *,
+			      unsigned long *, u32 *);
+	int (*allocate_pool)(int, unsigned long, void **);
+	int (*free_pool)(void *);
 	void *create_event;
 	void *set_timer;
 	void *wait_for_event;
@@ -171,7 +175,7 @@ typedef struct {
 	void *install_protocol_interface;
 	void *reinstall_protocol_interface;
 	void *uninstall_protocol_interface;
-	void *handle_protocol;
+	int (*handle_protocol)(efi_handle_t, efi_guid_t *, void **);
 	void *__reserved;
 	void *register_protocol_notify;
 	void *locate_handle;
@@ -181,7 +185,7 @@ typedef struct {
 	void *start_image;
 	void *exit;
 	void *unload_image;
-	void *exit_boot_services;
+	int (*exit_boot_services)(efi_handle_t, unsigned long);
 	void *get_next_monotonic_count;
 	void *stall;
 	void *set_watchdog_timer;
@@ -488,10 +492,6 @@ typedef struct {
 	unsigned long unload;
 } efi_loaded_image_t;
 
-typedef struct {
-	u64 revision;
-	void *open_volume;
-} efi_file_io_interface_t;
 
 typedef struct {
 	u64 size;
@@ -504,20 +504,28 @@ typedef struct {
 	efi_char16_t filename[1];
 } efi_file_info_t;
 
-typedef struct {
+typedef struct _efi_file_handle {
 	u64 revision;
-	void *open;
-	void *close;
+	int (*open)(struct _efi_file_handle *, struct _efi_file_handle **,
+		    efi_char16_t *, u64, u64);
+	int (*close)(struct _efi_file_handle *);
 	void *delete;
-	void *read;
+	int (*read)(struct _efi_file_handle *, unsigned long *, void *);
 	void *write;
 	void *get_position;
 	void *set_position;
-	void *get_info;
+	int (*get_info)(struct _efi_file_handle *, efi_guid_t *,
+			unsigned long *, void *);
 	void *set_info;
 	void *flush;
 } efi_file_handle_t;
 
+typedef struct _efi_file_io_interface {
+	u64 revision;
+	int (*open_volume)(struct _efi_file_io_interface *,
+			   efi_file_handle_t **);
+} efi_file_io_interface_t;
+
 #define EFI_FILE_MODE_READ	0x0000000000000001
 #define EFI_FILE_MODE_WRITE	0x0000000000000002
 #define EFI_FILE_MODE_CREATE	0x8000000000000000
@@ -787,7 +795,7 @@ struct efivar_entry {
 
 struct efi_simple_text_output_protocol {
 	void *reset;
-	void *output_string;
+	int (*output_string)(void *, void *);
 	void *test_string;
 };
 
-- 
1.7.10.4
