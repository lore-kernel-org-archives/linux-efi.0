From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2] efi: fix for_each_efi_memory_desc_in_map() for empty memmaps
Date: Thu, 26 May 2016 11:26:37 +0200
Message-ID: <1464254797-13737-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Mark Salter <msalter@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-efi@vger.kernel.org

Commit 78ce248faa3c ("efi: Iterate over efi.memmap in
for_each_efi_memory_desc()") introduced a regression for systems booted
with 'noefi' kernel option. In particular, I observe early kernel hang in
efi_find_mirror() on for_each_efi_memory_desc() call. As we don't have
efi memmap we enter this iterator with the following parameters:

efi.memmap.map = 0, efi.memmap.map_end = 0, efi.memmap.desc_size = 28

for_each_efi_memory_desc_in_map() does the following comparison:

(md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size);

where md = 0, (m)->map_end = 0 and (m)->desc_size = 28 but when we subtract
something from a NULL pointer wrap around happens and we end up returning
invalid pointer.

Fixes: 78ce248faa3c ("efi: Iterate over efi.memmap in for_each_efi_memory_desc()")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
Changes since v1: cast to (void *) instead of (efi_memory_desc_t *)
 [Matt Fleming]. It seems we're still exercising some sort of an
 undefined behavioir as C standard only allows us to compare pointers
 which point to the same object in memory (or one position past the end of
 the object) and I doubt NULL pointers are covered by this rule but gcc
 gives no warning, I think we're relatively safe. It may also make sense
 to write this comparison casting everything to something like unsigned
 long I guess...
---
 include/linux/efi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index c2db3ca..f196dd0 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1005,7 +1005,7 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
 	for ((md) = (m)->map;						   \
-	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
+	     ((void *)(md) + (m)->desc_size) <= (m)->map_end;		   \
 	     (md) = (void *)(md) + (m)->desc_size)
 
 /**
-- 
2.5.5
