From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v16 3/6] of, numa: Add NUMA of binding implementation.
Date: Fri,  8 Apr 2016 15:50:25 -0700
Message-ID: <1460155828-8690-4-git-send-email-ddaney.cavm@gmail.com>
References: <1460155828-8690-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460155828-8690-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Grant Likely <grant.likely@linaro.org>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Robert Richter <rrichter@cavium.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, David Daney <david.daney@cavium.com>
List-Id: linux-efi@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Add device tree parsing for NUMA topology using device
"numa-node-id" property in distance-map and cpu nodes.

This is a complete rewrite of a previous patch by:
   Ganapatrao Kulkarni<gkulkarni@caviumnetworks.com>

Signed-off-by: David Daney <david.daney@cavium.com>
Acked-by: Rob Herring <robh@kernel.org>
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
index 7fcb681..76f07c8 100644
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
