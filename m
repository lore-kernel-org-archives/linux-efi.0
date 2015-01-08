From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: stub: call get_memory_map() to obtain map and desc sizes
Date: Thu,  8 Jan 2015 17:51:47 +0000
Message-ID: <1420739507-1708-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This fixes two minor issues in the implementation of get_memory_map():
- Currently, it assumes that sizeof(efi_memory_desc_t) == desc_size,
  which is usually true, but not mandated by the spec. (This was added
  intentionally to allow future additions to the definition of
  efi_memory_desc_t). The way the loop is implemented currently, the
  added slack space may be insufficient if desc_size is larger, which in
  some corner cases could result in the loop never terminating.
- It allocates 32 efi_memory_desc_t entries first (again, using the size
  of the struct instead of desc_size), and frees and reallocates if it
  turns out to be insufficient. Few implementations of UEFI have such small
  memory maps, which results in a unnecessary allocate/free pair on each
  invocation.

Fix this by calling the get_memory_map() boot service first with a '0'
input value for map size to retrieve the map size and desc size from the
firmware and only then perform the allocation, using desc_size rather
than sizeof(efi_memory_desc_t).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index e766df60fbfb..caf91eab0bfc 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -75,25 +75,29 @@ efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
 	unsigned long key;
 	u32 desc_version;
 
-	*map_size = sizeof(*m) * 32;
-again:
+	*map_size = 0;
+	*desc_size = 0;
+	key = 0;
+	status = efi_call_early(get_memory_map, map_size, NULL,
+				&key, desc_size, &desc_version);
+	if (status != EFI_BUFFER_TOO_SMALL)
+		return EFI_LOAD_ERROR;
+
 	/*
 	 * Add an additional efi_memory_desc_t because we're doing an
 	 * allocation which may be in a new descriptor region.
 	 */
-	*map_size += sizeof(*m);
+	*map_size += *desc_size;
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				*map_size, (void **)&m);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
-	*desc_size = 0;
-	key = 0;
 	status = efi_call_early(get_memory_map, map_size, m,
 				&key, desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
 		efi_call_early(free_pool, m);
-		goto again;
+		return EFI_LOAD_ERROR;
 	}
 
 	if (status != EFI_SUCCESS)
-- 
1.8.3.2
