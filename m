From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH] x86/efi: Use early_memunmap() to squelch sparse errors
Date: Mon,  9 Jun 2014 14:41:12 +0100
Message-ID: <1402321272-18053-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Saurabh Tangri <saurabh.tangri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The kbuild reports the following sparse errors,

>> arch/x86/platform/efi/quirks.c:242:23: sparse: incorrect type in >> argument 1 (different address spaces)
   arch/x86/platform/efi/quirks.c:242:23:    expected void [noderef] <asn:2>*addr
   arch/x86/platform/efi/quirks.c:242:23:    got void *[assigned] tablep
>> arch/x86/platform/efi/quirks.c:245:23: sparse: incorrect type in >> argument 1 (different address spaces)
   arch/x86/platform/efi/quirks.c:245:23:    expected void [noderef] <asn:2>*addr
   arch/x86/platform/efi/quirks.c:245:23:    got struct efi_setup_data *[assigned] data

Dave Young had made previous attempts to convert the early_iounmap()
calls to early_memunmap() but ran into merge conflicts with commit
9e5c33d7aeee ("mm: create generic early_ioremap() support").

Now that we've got that commit in place we can switch to using
early_memunmap() since we're already using early_memremap() in
efi_reuse_config().

Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Saurabh Tangri <saurabh.tangri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/platform/efi/quirks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 7e3099c610dd..b4cb9182f155 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -239,10 +239,10 @@ int __init efi_reuse_config(u64 tables, int nr_tables)
 			((efi_config_table_64_t *)p)->table = data->smbios;
 		p += sz;
 	}
-	early_iounmap(tablep, nr_tables * sz);
+	early_memunmap(tablep, nr_tables * sz);
 
 out_memremap:
-	early_iounmap(data, sizeof(*data));
+	early_memunmap(data, sizeof(*data));
 out:
 	return ret;
 }
-- 
1.9.0
