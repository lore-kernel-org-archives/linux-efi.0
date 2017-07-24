From: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Subject: [RFC Part1 PATCH v3 09/17] resource: Consolidate resource walking code
Date: Mon, 24 Jul 2017 14:07:49 -0500
Message-ID: <20170724190757.11278-10-brijesh.singh@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724190757.11278-1-brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>Paul Mackerras <p>
List-Id: linux-efi@vger.kernel.org

From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>

The walk_iomem_res_desc(), walk_system_ram_res() and walk_system_ram_range()
functions each have much of the same code.  Create a new function that
consolidates the common code from these functions in one place to reduce
the amount of duplicated code.

Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Signed-off-by: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
---
 kernel/resource.c | 53 ++++++++++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 9b5f044..7b20b3e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -397,9 +397,30 @@ static int find_next_iomem_res(struct resource *res, unsigned long desc,
 		res->start = p->start;
 	if (res->end > p->end)
 		res->end = p->end;
+	res->desc = p->desc;
 	return 0;
 }
 
+static int __walk_iomem_res_desc(struct resource *res, unsigned long desc,
+				 bool first_level_children_only,
+				 void *arg, int (*func)(u64, u64, void *))
+{
+	u64 orig_end = res->end;
+	int ret = -1;
+
+	while ((res->start < res->end) &&
+	       !find_next_iomem_res(res, desc, first_level_children_only)) {
+		ret = (*func)(res->start, res->end, arg);
+		if (ret)
+			break;
+
+		res->start = res->end + 1;
+		res->end = orig_end;
+	}
+
+	return ret;
+}
+
 /*
  * Walks through iomem resources and calls func() with matching resource
  * ranges. This walks through whole tree and not just first level children.
@@ -418,26 +439,12 @@ int walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start,
 		u64 end, void *arg, int (*func)(u64, u64, void *))
 {
 	struct resource res;
-	u64 orig_end;
-	int ret = -1;
 
 	res.start = start;
 	res.end = end;
 	res.flags = flags;
-	orig_end = res.end;
-
-	while ((res.start < res.end) &&
-		(!find_next_iomem_res(&res, desc, false))) {
-
-		ret = (*func)(res.start, res.end, arg);
-		if (ret)
-			break;
-
-		res.start = res.end + 1;
-		res.end = orig_end;
-	}
 
-	return ret;
+	return __walk_iomem_res_desc(&res, desc, false, arg, func);
 }
 
 /*
@@ -451,22 +458,13 @@ int walk_system_ram_res(u64 start, u64 end, void *arg,
 				int (*func)(u64, u64, void *))
 {
 	struct resource res;
-	u64 orig_end;
-	int ret = -1;
 
 	res.start = start;
 	res.end = end;
 	res.flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
-	orig_end = res.end;
-	while ((res.start < res.end) &&
-		(!find_next_iomem_res(&res, IORES_DESC_NONE, true))) {
-		ret = (*func)(res.start, res.end, arg);
-		if (ret)
-			break;
-		res.start = res.end + 1;
-		res.end = orig_end;
-	}
-	return ret;
+
+	return __walk_iomem_res_desc(&res, IORES_DESC_NONE, true,
+				     arg, func);
 }
 
 #if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
@@ -508,6 +506,7 @@ static int __is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
 {
 	return 1;
 }
+
 /*
  * This generic page_is_ram() returns true if specified address is
  * registered as System RAM in iomem_resource list.
-- 
2.9.4
