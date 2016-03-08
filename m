From: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v15 3/6] of, numa: Add NUMA of binding implementation.
Date: Tue,  8 Mar 2016 15:59:44 -0800
Message-ID: <1457481587-8976-4-git-send-email-ddaney.cavm@gmail.com>
References: <1457481587-8976-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457481587-8976-1-git-send-email-ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

Add device tree parsing for NUMA topology using device
"numa-node-id" property in distance-map and cpu nodes.

This is a complete rewrite of a previous patch by:
   Ganapatrao Kulkarni<gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>

Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/of/Kconfig   |   3 +
 drivers/of/Makefile  |   1 +
 drivers/of/of_numa.c | 211 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of.h   |   9 +++
 4 files changed, 224 insertions(+)
 create mode 100644 drivers/of/of_numa.c

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index e2a4841..b3bec3a 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -112,4 +112,7 @@ config OF_OVERLAY
 	  While this option is selected automatically when needed, you can
 	  enable it manually to improve device tree unit test coverage.
 
+config OF_NUMA
+	bool
+
 endif # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index 156c072..bee3fa9 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -14,5 +14,6 @@ obj-$(CONFIG_OF_MTD)	+= of_mtd.o
 obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
 obj-$(CONFIG_OF_RESOLVE)  += resolver.o
 obj-$(CONFIG_OF_OVERLAY) += overlay.o
+obj-$(CONFIG_OF_NUMA) += of_numa.o
 
 obj-$(CONFIG_OF_UNITTEST) += unittest-data/
diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
new file mode 100644
index 0000000..0f2784b
--- /dev/null
+++ b/drivers/of/of_numa.c
@@ -0,0 +1,211 @@
+/*
+ * OF NUMA Parsing support.
+ *
+ * Copyright (C) 2015 - 2016 Cavium Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/nodemask.h>
+
+#include <asm/numa.h>
+
+/* define default numa node to 0 */
+#define DEFAULT_NODE 0
+
+/*
+ * Even though we connect cpus to numa domains later in SMP
+ * init, we need to know the node ids now for all cpus.
+*/
+static void __init of_numa_parse_cpu_nodes(void)
+{
+	u32 nid;
+	int r;
+	struct device_node *cpus;
+	struct device_node *np = NULL;
+
+	cpus = of_find_node_by_path("/cpus");
+	if (!cpus)
+		return;
+
+	for_each_child_of_node(cpus, np) {
+		/* Skip things that are not CPUs */
+		if (of_node_cmp(np->type, "cpu") != 0)
+			continue;
+
+		r = of_property_read_u32(np, "numa-node-id", &nid);
+		if (r)
+			continue;
+
+		pr_debug("NUMA: CPU on %u\n", nid);
+		if (nid >= MAX_NUMNODES)
+			pr_warn("NUMA: Node id %u exceeds maximum value\n",
+				nid);
+		else
+			node_set(nid, numa_nodes_parsed);
+	}
+}
+
+static int __init of_numa_parse_memory_nodes(void)
+{
+	struct device_node *np = NULL;
+	struct resource rsrc;
+	u32 nid;
+	int r = 0;
+
+	for (;;) {
+		np = of_find_node_by_type(np, "memory");
+		if (!np)
+			break;
+
+		r = of_property_read_u32(np, "numa-node-id", &nid);
+		if (r == -EINVAL)
+			/*
+			 * property doesn't exist if -EINVAL, continue
+			 * looking for more memory nodes with
+			 * "numa-node-id" property
+			 */
+			continue;
+		else if (r)
+			/* some other error */
+			break;
+
+		r = of_address_to_resource(np, 0, &rsrc);
+		if (r) {
+			pr_err("NUMA: bad reg property in memory node\n");
+			break;
+		}
+
+		pr_debug("NUMA:  base = %llx len = %llx, node = %u\n",
+			 rsrc.start, rsrc.end - rsrc.start + 1, nid);
+
+		r = numa_add_memblk(nid, rsrc.start,
+				    rsrc.end - rsrc.start + 1);
+		if (r)
+			break;
+	}
+	of_node_put(np);
+
+	return r;
+}
+
+static int __init of_numa_parse_distance_map_v1(struct device_node *map)
+{
+	const __be32 *matrix;
+	int entry_count;
+	int i;
+
+	pr_info("NUMA: parsing numa-distance-map-v1\n");
+
+	matrix = of_get_property(map, "distance-matrix", NULL);
+	if (!matrix) {
+		pr_err("NUMA: No distance-matrix property in distance-map\n");
+		return -EINVAL;
+	}
+
+	entry_count = of_property_count_u32_elems(map, "distance-matrix");
+	if (entry_count <= 0) {
+		pr_err("NUMA: Invalid distance-matrix\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i + 2 < entry_count; i += 3) {
+		u32 nodea, nodeb, distance;
+
+		nodea = of_read_number(matrix, 1);
+		matrix++;
+		nodeb = of_read_number(matrix, 1);
+		matrix++;
+		distance = of_read_number(matrix, 1);
+		matrix++;
+
+		numa_set_distance(nodea, nodeb, distance);
+		pr_debug("NUMA:  distance[node%d -> node%d] = %d\n",
+			 nodea, nodeb, distance);
+
+		/* Set default distance of node B->A same as A->B */
+		if (nodeb > nodea)
+			numa_set_distance(nodeb, nodea, distance);
+	}
+
+	return 0;
+}
+
+static int __init of_numa_parse_distance_map(void)
+{
+	int ret = 0;
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL,
+				     "numa-distance-map-v1");
+	if (np)
+		ret = of_numa_parse_distance_map_v1(np);
+
+	of_node_put(np);
+	return ret;
+}
+
+int of_node_to_nid(struct device_node *device)
+{
+	struct device_node *np;
+	u32 nid;
+	int r = -ENODATA;
+
+	np = of_node_get(device);
+
+	while (np) {
+		struct device_node *parent;
+
+		r = of_property_read_u32(np, "numa-node-id", &nid);
+		/*
+		 * -EINVAL indicates the property was not found, and
+		 *  we walk up the tree trying to find a parent with a
+		 *  "numa-node-id".  Any other type of error indicates
+		 *  a bad device tree and we give up.
+		 */
+		if (r != -EINVAL)
+			break;
+
+		parent = of_get_parent(np);
+		of_node_put(np);
+		np = parent;
+	}
+	if (np && r)
+		pr_warn("NUMA: Invalid \"numa-node-id\" property in node %s\n",
+			np->name);
+	of_node_put(np);
+
+	if (!r) {
+		if (nid >= MAX_NUMNODES)
+			pr_warn("NUMA: Node id %u exceeds maximum value\n",
+				nid);
+		else
+			return nid;
+	}
+
+	return NUMA_NO_NODE;
+}
+EXPORT_SYMBOL(of_node_to_nid);
+
+int __init of_numa_init(void)
+{
+	int r;
+
+	of_numa_parse_cpu_nodes();
+	r = of_numa_parse_memory_nodes();
+	if (r)
+		return r;
+	return of_numa_parse_distance_map();
+}
diff --git a/include/linux/of.h b/include/linux/of.h
index dc6e396..fe67a4c 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -685,6 +685,15 @@ static inline int of_node_to_nid(struct device_node *device)
 }
 #endif
 
+#ifdef CONFIG_OF_NUMA
+extern int of_numa_init(void);
+#else
+static inline int of_numa_init(void)
+{
+	return -ENOSYS;
+}
+#endif
+
 static inline struct device_node *of_find_matching_node(
 	struct device_node *from,
 	const struct of_device_id *matches)
-- 
1.8.3.1
