From: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH 2/2] efi-pstore: implement efivars_pstore_exit()
Date: Fri, 23 Oct 2015 22:56:23 +0800
Message-ID: <ac2cff56766dcd044563b5cc090198f0c50ec217.1445611895.git.geliangtang@163.com>
References: <ab909fa2d2e97904b4cf34df79998548a153dd9c.1445611895.git.geliangtang@163.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ab909fa2d2e97904b4cf34df79998548a153dd9c.1445611895.git.geliangtang-9Onoh4P/yGk@public.gmane.org>
In-Reply-To: <ab909fa2d2e97904b4cf34df79998548a153dd9c.1445611895.git.geliangtang-9Onoh4P/yGk@public.gmane.org>
References: <ab909fa2d2e97904b4cf34df79998548a153dd9c.1445611895.git.geliangtang-9Onoh4P/yGk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The original efivars_pstore_exit() is empty. I
 1) add a bufsize check statement.
 2) call pstore_unregister as it is defined now.
 3) free the memory and set bufsize to 0.

Signed-off-by: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
---
 drivers/firmware/efi/efi-pstore.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index c8d794c..453ac19 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -393,6 +393,13 @@ static __init int efivars_pstore_init(void)
 
 static __exit void efivars_pstore_exit(void)
 {
+	if (!efi_pstore_info.bufsize)
+		return;
+
+	pstore_unregister(&efi_pstore_info);
+	kfree(efi_pstore_info.buf);
+	efi_pstore_info.buf = NULL;
+	efi_pstore_info.bufsize = 0;
 }
 
 module_init(efivars_pstore_init);
-- 
2.5.0
