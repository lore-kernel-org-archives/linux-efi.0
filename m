From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/2] x86/efi/64: Clean up code comment about efi region
Date: Wed, 8 Mar 2017 18:45:57 +0800
Message-ID: <20170308104557.GE6570@x1>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488959258-4731-1-git-send-email-bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

EFI allocates runtime services regions starting from EFI_VA_START, -4G,
decrement to EFI_VA_END. So remove the bottom-up term to avoid confusion.

Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 arch/x86/platform/efi/efi_64.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index a4695da..e941b29 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -47,8 +47,9 @@
 #include <asm/pgalloc.h>
 
 /*
- * We allocate runtime services regions bottom-up, starting from -4G, i.e.
- * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
+ * We allocate runtime services regions starting from -4G, i.e.
+ * 0xffff_ffff_0000_0000 and decrement as we go. The EFI VA mapping space
+ * is limited to 64G.
  */
 static u64 efi_va = EFI_VA_START;
 
-- 
2.5.5
