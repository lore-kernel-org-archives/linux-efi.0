From: guomin chen <guomin.chen@suse.com>
Subject: [PATCH 1/1] resource: Fixed iomem resource release failed on release_mem_region_adjustable() when memory node or cpu node hot-remove.
Date: Fri, 22 Jun 2018 19:52:52 +0800
Message-ID: <20180622115252.5174-1-guomin.chen@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Brijesh Singh <brijesh.singh@amd.com>, Borislav Petkov <bp@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, Lee Chun-Yi <JLee@suse.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, guomin chen <guomin.chen@suse.com>, Tom Lendacky <thomas.lendacky@amd.com>, Bjorn Helgaas <bhelgaas@google.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.orgyour.patch
List-Id: linux-efi@vger.kernel.org

We've got a bug report indicating the hot-remove node resource
release failed,when the memory on this node is divided into
several sections.because the release_mem_region_adjustable()
can only release one resource that must be [start,end].

In my case, the BIOS supports faulty memory isolation. if BIOS
detected bad memory block, the BIOS will isolates this badblock.
And set this badblock memory to EfiUnusableMemory in EFI memory map
base on UEFI 2.7 spec.For example in my system, the memory range on
node2 is [mem 0x0000080000000000-0x00000807ffffffff].but the BIOS
detected the [8004e000000-8004e0fffff] is a badblock memory.
So the memory on node2 seem like this:
   		80000000000-8004dffffff : System RAM
		8004e000000-8004e0fffff : Unusable memory
		8004e100000-807ffffffff : System RAM

Now, when offline the cpu node2,the kernel will try to release
ioresource [mem 0x0000080000000000-0x00000807ffffffff]. at this
time, the kernel will release failed,and output error message:
"Unable to release resource <0x0000080000000000-0x00000807ffffffff>
(-22)".
Because the release_mem_region_adjustable() can only release one
resource that must be [0x0000080000000000 , 0x00000807ffffffff].
but now,the iomem resource on node2 [0x0000080000000000,
0x00000807ffffffff] are divided into three resources [80000000000-
8004dffffff],[8004e000000-8004e0fffff]and[8004e100000-807ffffffff].

This patch help to Release multiple iomem resources at once when
node hot-remove. Such as in above case, when hot-remove the cpu
node2,the kernel will try to release resource [0x0000080000000000-
0x00000807ffffffff].And this patch will release three resources
[80000000000-8004dffffff],[8004e000000-8004e0fffff] and
[8004e100000-807ffffffff].

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org your.patch
Cc: Lee Chun-Yi <JLee@suse.com>
Signed-off-by: guomin chen <guomin.chen@suse.com>
---
 kernel/resource.c | 73 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 30 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 30e1bc68503b..959bcce4c405 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1240,6 +1240,7 @@ int release_mem_region_adjustable(struct resource *parent,
 	struct resource *res;
 	struct resource *new_res;
 	resource_size_t end;
+	resource_size_t new_start = start;
 	int ret = -EINVAL;
 
 	end = start + size - 1;
@@ -1257,7 +1258,7 @@ int release_mem_region_adjustable(struct resource *parent,
 			break;
 
 		/* look for the next resource if it does not fit into */
-		if (res->start > start || res->end < end) {
+		if (res->end < new_start) {
 			p = &res->sibling;
 			continue;
 		}
@@ -1271,42 +1272,54 @@ int release_mem_region_adjustable(struct resource *parent,
 		}
 
 		/* found the target resource; let's adjust accordingly */
-		if (res->start == start && res->end == end) {
+		if (res->start == new_start && res->end == end) {
 			/* free the whole entry */
 			*p = res->sibling;
 			free_resource(res);
 			ret = 0;
-		} else if (res->start == start && res->end != end) {
-			/* adjust the start */
-			ret = __adjust_resource(res, end + 1,
-						res->end - end);
-		} else if (res->start != start && res->end == end) {
-			/* adjust the end */
-			ret = __adjust_resource(res, res->start,
-						start - res->start);
+		} else if (res->end > end) {
+			if (res->start >= new_start) {
+				/* adjust the start */
+				ret = __adjust_resource(res, end + 1,
+							res->end - end);
+			} else {
+				/* split into two entries */
+				if (!new_res) {
+					ret = -ENOMEM;
+					break;
+				}
+				new_res->name = res->name;
+				new_res->start = end + 1;
+				new_res->end = res->end;
+				new_res->flags = res->flags;
+				new_res->desc = res->desc;
+				new_res->parent = res->parent;
+				new_res->sibling = res->sibling;
+				new_res->child = NULL;
+
+				ret = __adjust_resource(res, res->start,
+							new_start - res->start);
+				if (ret)
+					break;
+				res->sibling = new_res;
+				new_res = NULL;
+			}
 		} else {
-			/* split into two entries */
-			if (!new_res) {
-				ret = -ENOMEM;
-				break;
+			if (res->start < new_start) {
+				/* adjust the end */
+				ret = __adjust_resource(res, res->start,
+							new_start - res->start);
+				new_start = res->end+1;
+				p = &res->sibling;
+			} else {
+				new_start = res->end+1;
+				*p = res->sibling;
+				free_resource(res);
+				ret = 0;
 			}
-			new_res->name = res->name;
-			new_res->start = end + 1;
-			new_res->end = res->end;
-			new_res->flags = res->flags;
-			new_res->desc = res->desc;
-			new_res->parent = res->parent;
-			new_res->sibling = res->sibling;
-			new_res->child = NULL;
-
-			ret = __adjust_resource(res, res->start,
-						start - res->start);
-			if (ret)
-				break;
-			res->sibling = new_res;
-			new_res = NULL;
+			if (res->end < end)
+				continue;
 		}
-
 		break;
 	}
 
-- 
2.12.3
