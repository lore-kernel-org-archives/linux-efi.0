From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/6] efi: Make for_each_efi_memory_desc_in_map() cope with running on Xen
Date: Fri, 19 Aug 2016 21:34:59 +0100
Message-ID: <1471638904-3494-2-git-send-email-matt@codeblueprint.co.uk>
References: <1471638904-3494-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1471638904-3494-1-git-send-email-matt@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <JBeulich@suse.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Jan Beulich <jbeulich@suse.com>, Jiri Slaby <jslaby@suse.cz>, lists@ssl-mail.com, Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
List-Id: linux-efi@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

While commit 55f1ea15216 ("efi: Fix for_each_efi_memory_desc_in_map()
for empty memmaps") made an attempt to deal with empty memory maps, it
didn't address the case where the map field never gets set, as is
apparently the case when running under Xen.

Reported-by: <lists@ssl-mail.com>
Tested-by: <lists@ssl-mail.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: <stable@vger.kernel.org> # v4.7+
Signed-off-by: Jan Beulich <jbeulich@suse.com>
[ Guard the loop with a NULL check instead of pointer underflow ]
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 include/linux/efi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 7f5a58225385..23cd3ced8c1a 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -946,7 +946,7 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
 	for ((md) = (m)->map;						   \
-	     ((void *)(md) + (m)->desc_size) <= (m)->map_end;		   \
+	     (md) && ((void *)(md) + (m)->desc_size) <= (m)->map_end;	   \
 	     (md) = (void *)(md) + (m)->desc_size)
 
 /**
-- 
2.7.3
