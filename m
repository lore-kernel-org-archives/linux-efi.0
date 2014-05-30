From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH]x86 efi: do not export efi runtime map in case old map
Date: Fri, 30 May 2014 11:20:10 +0800
Message-ID: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


For ioremapped efi memory aka old_map the virt addresses are not persistant
across kexec reboot. kexec-tools will read the runtime maps from sysfs then
pass them to 2nd kernel and assuming kexec efi boot is ok. This will cause
kexec boot failure.

To address this issue do not export runtime maps in case efi old_map so
userspace can use no efi boot instead.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3781dd3..4d36932 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -919,6 +919,9 @@ static void __init save_runtime_map(void)
 	void *tmp, *p, *q = NULL;
 	int count = 0;
 
+	if (efi_enabled(EFI_OLD_MEMMAP))
+		return;
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 
-- 
1.8.3.1
