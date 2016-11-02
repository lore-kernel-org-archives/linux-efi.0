From: Eugene Korenevsky <ekorenevsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] EFI loader: remove redundant code
Date: Wed, 2 Nov 2016 07:18:55 +0300
Message-ID: <20161102041855.GA4479@vnote>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Linn Crosetto <linn-ZPxbGqLxI0U@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

*e820ext is always NULL in 'alloc_e820ext()' (see the code of 'exit_boot()').
Without loss of generality we can replace freeing with returning
EFI_INVALID_PARAMETER. So if the caller would ever incorrectly pass non-NULL
*e820ext, he will obtain a returned error code.

---
 arch/x86/boot/compressed/eboot.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index cc69e37..6cc66c7 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -956,11 +956,8 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
 	size = sizeof(struct setup_data) +
 		sizeof(struct e820entry) * nr_desc;
 
-	if (*e820ext) {
-		efi_call_early(free_pool, *e820ext);
-		*e820ext = NULL;
-		*e820ext_size = 0;
-	}
+	if (*e820ext)
+		return EFI_INVALID_PARAMETER;
 
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				size, (void **)e820ext);
-- 
2.10.2
