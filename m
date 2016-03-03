From: Ganapatrao Kulkarni <gpkulkarni@gmail.com>
Subject: Re: [PATCH v13 3/6] of, numa: Add NUMA of binding implementation.
Date: Thu, 3 Mar 2016 09:55:08 +0530
Message-ID: <CAFpQJXWXegmedu_TU4T6W6BkEZeqnZvUC0+qCO9anxDLKeqWYg@mail.gmail.com>
References: <1456959362-2036-1-git-send-email-ddaney.cavm@gmail.com>
	<1456959362-2036-4-git-send-email-ddaney.cavm@gmail.com>
	<CAL_JsqLRP6tmpY7cJ61Ybrrai4ctA7ezyUGmYwdbywe+-qBG5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqLRP6tmpY7cJ61Ybrrai4ctA7ezyUGmYwdbywe+-qBG5A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh+dt@kernel.org>
Cc: David Daney <ddaney.cavm@gmail.com>, Mark Rutland <mark.rutland@arm.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, David Daney <david.daney@cavium.com>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Robert Richter <rrichter@cavium.com>, Kumar Gala <galak@codeaurora.org>, Grant Likely <grant.likely@linaro.org>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Frank Rowand <frowand.list@gmail.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 3, 2016 at 9:04 AM, Rob Herring <robh+dt@kernel.org> wrote:
> On Wed, Mar 2, 2016 at 4:55 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> Add device tree parsing for NUMA topology using device
>> "numa-node-id" property in distance-map and cpu nodes.
>>
>> This is a complete rewrite of a previous patch by:
>>    Ganapatrao Kulkarni<gkulkarni@caviumnetworks.com>
>>
>> Signed-off-by: David Daney <david.daney@cavium.com>
>> ---
>>  drivers/of/Kconfig   |   3 +
>>  drivers/of/Makefile  |   1 +
>>  drivers/of/of_numa.c | 200 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/of.h   |   9 +++
>>  4 files changed, 213 insertions(+)
>>  create mode 100644 drivers/of/of_numa.c
>>
>> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
>> index e2a4841..b3bec3a 100644
>> --- a/drivers/of/Kconfig
>> +++ b/drivers/of/Kconfig
>> @@ -112,4 +112,7 @@ config OF_OVERLAY
>>           While this option is selected automatically when needed, you can
>>           enable it manually to improve device tree unit test coverage.
>>
>> +config OF_NUMA
>> +       bool
>> +
>>  endif # OF
>> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
>> index 156c072..bee3fa9 100644
>> --- a/drivers/of/Makefile
>> +++ b/drivers/of/Makefile
>> @@ -14,5 +14,6 @@ obj-$(CONFIG_OF_MTD)  += of_mtd.o
>>  obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
>>  obj-$(CONFIG_OF_RESOLVE)  += resolver.o
>>  obj-$(CONFIG_OF_OVERLAY) += overlay.o
>> +obj-$(CONFIG_OF_NUMA) += of_numa.o
>>
>>  obj-$(CONFIG_OF_UNITTEST) += unittest-data/
>> diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
>> new file mode 100644
>> index 0000000..9727b60
>> --- /dev/null
>> +++ b/drivers/of/of_numa.c
>> @@ -0,0 +1,200 @@
>> +/*
>> + * OF NUMA Parsing support.
>> + *
>> + * Copyright (C) 2015 - 2016 Cavium Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/of.h>
>> +#include <linux/of_fdt.h>
>
> This can be dropped now.
>
>> +#include <linux/nodemask.h>
>> +
>> +#include <asm/numa.h>
>> +
>> +/* define default numa node to 0 */
>> +#define DEFAULT_NODE 0
>> +
>> +/*
>> + * Even though we connect cpus to numa domains later in SMP
>> + * init, we need to know the node ids now for all cpus.
>> +*/
>> +static void __init of_find_cpu_nodes(void)
>
> Perhaps of_parse_cpu_nodes for consistency.
>
> Actually, if all the functions were prefixed with "of_numa_" that
> would be better.
>
>> +{
>> +       u32 nid;
>> +       int r;
>> +       struct device_node *np = NULL;
>> +
>> +       for (;;) {
>> +               np = of_find_node_by_type(np, "cpu");
>> +               if (!np)
>> +                       break;
>
> Can't we use the child node iterator for /cpus here?
>
>> +
>> +               r = of_property_read_u32(np, "numa-node-id", &nid);
>> +               if (r)
>> +                       continue;
>> +
>> +               pr_debug("NUMA: CPU on %u\n", nid);
>> +               if (nid >= MAX_NUMNODES)
>> +                       pr_warn("NUMA: Node id %u exceeds maximum value\n",
>> +                               nid);
>> +               else
>> +                       node_set(nid, numa_nodes_parsed);
>
> I'm not sure how this works, but don't you need to match this up with
> MPIDR of the cpu here?
>
>> +       }
>> +}
>> +
>> +static void __init of_parse_memory_nodes(void)
>> +{
>> +       struct device_node *np = NULL;
>> +       int na, ns;
>> +       const __be32 *prop;
>> +       unsigned int psize;
>> +       u32 nid;
>> +       u64 base, size;
>> +       int r;
>> +
>> +       for (;;) {
>> +               np = of_find_node_by_type(np, "memory");
>> +               if (!np)
>> +                       break;
>> +
>> +               r = of_property_read_u32(np, "numa-node-id", &nid);
>> +               if (r)
>> +                       continue;
>> +
>
>> +               prop = of_get_property(np, "reg", &psize);
>> +               if (!prop)
>> +                       continue;
>> +
>> +               psize /= sizeof(__be32);
>> +               na = of_n_addr_cells(np);
>> +               ns = of_n_size_cells(np);
>> +
>> +               if (psize < na + ns) {
>> +                       pr_err("NUMA: memory reg property too small\n");
>> +                       continue;
>> +               }
>> +               base = of_read_number(prop, na);
>> +               size = of_read_number(prop + na, ns);
>
> You should be able to use of_address_to_resource for all this.
>
>> +
>> +               pr_debug("NUMA:  base = %llx len = %llx, node = %u\n",
>> +                        base, size, nid);
>> +
>> +               if (numa_add_memblk(nid, base, size) < 0)
>> +                       break;
>> +       }
>> +
>> +       of_node_put(np);
>> +}
>> +
>> +static int __init parse_distance_map_v1(struct device_node *map)
>> +{
>> +       const __be32 *matrix;
>> +       unsigned int matrix_size;
>> +       int entry_count;
>> +       int i;
>> +       int nr_size_cells = OF_ROOT_NODE_SIZE_CELLS_DEFAULT;
>
> I believe the defaults are for some old DT files. As this is new, it
> should rely on explicit #size-cells in the DT.
>
> OTOH, what is point of using #size-cells at all versus fixing the
> sizes to 1 cell. The documentation doesn't indicate that it uses
> #size-cells. That also means that the sizes basically follow the cell
> size for the memory given that this is at the top-level.

This property needs only size-cell of 1 (32 bit is sufficient to
define numa node id and their relative distance)
adding note about cell size of this property in binding will clear the doubt.
>
>> +
>> +       pr_info("NUMA: parsing numa-distance-map-v1\n");
>> +
>> +       matrix = of_get_property(map, "distance-matrix", &matrix_size);
>> +       if (!matrix) {
>> +               pr_err("NUMA: No distance-matrix property in distance-map\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       entry_count = matrix_size / (sizeof(__be32) * 3 * nr_size_cells);
>> +
>> +       for (i = 0; i < entry_count; i++) {
>> +               u32 nodea, nodeb, distance;
>> +
>> +               nodea = of_read_number(matrix, nr_size_cells);
>> +               matrix += nr_size_cells;
>> +               nodeb = of_read_number(matrix, nr_size_cells);
>> +               matrix += nr_size_cells;
>> +               distance = of_read_number(matrix, nr_size_cells);
>> +               matrix += nr_size_cells;
>
> Assuming you fix this to 1 cell, you can use
> of_property_count_u32_elems and of_property_read_u32_array.
>
>> +
>> +               numa_set_distance(nodea, nodeb, distance);
>> +               pr_debug("NUMA:  distance[node%d -> node%d] = %d\n",
>> +                        nodea, nodeb, distance);
>> +
>> +               /* Set default distance of node B->A same as A->B */
>> +               if (nodeb > nodea)
>> +                       numa_set_distance(nodeb, nodea, distance);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int __init of_parse_distance_map(void)
>> +{
>> +       int ret = -EINVAL;
>> +       struct device_node *np = of_find_node_by_name(NULL, "distance-map");
>> +
>> +       if (!np)
>> +               return ret;
>> +
>> +       if (of_device_is_compatible(np, "numa-distance-map-v1")) {
>
> You can use of_find_compatible_node() instead of these 2 calls.
>
>> +               ret = parse_distance_map_v1(np);
>> +               goto out;
>> +       }
>> +
>> +       pr_err("NUMA: invalid distance-map device node\n");
>> +out:
>> +       of_node_put(np);
>> +       return ret;
>> +}
>> +
>> +int of_node_to_nid(struct device_node *device)
>> +{
>> +       struct device_node *np;
>> +       u32 nid;
>> +       int r = -ENODATA;
>> +
>> +       np = of_node_get(device);
>> +
>> +       while (np) {
>> +               struct device_node *parent;
>> +
>> +               r = of_property_read_u32(np, "numa-node-id", &nid);
>> +               if (r != -EINVAL)
>
> You want to break for other err values?
>
>> +                       break;
>> +
>> +               /* property doesn't exist in this node, look in parent */
>> +               parent = of_get_parent(np);
>> +               of_node_put(np);
>> +               np = parent;
>> +       }
>> +       if (np && r)
>> +               pr_warn("NUMA: Invalid \"numa-node-id\" property in node %s\n",
>> +                       np->name);
>> +       of_node_put(np);
>> +
>> +       if (!r) {
>> +               if (nid >= MAX_NUMNODES)
>> +                       pr_warn("NUMA: Node id %u exceeds maximum value\n",
>> +                               nid);
>> +               else
>> +                       return nid;
>> +       }
>> +
>> +       return NUMA_NO_NODE;
>> +}
>
> Needs to be exported?
>
>> +
>> +int __init of_numa_init(void)
>> +{
>> +       of_find_cpu_nodes();
>> +       of_parse_memory_nodes();
>> +       return of_parse_distance_map();
>> +}
>> diff --git a/include/linux/of.h b/include/linux/of.h
>> index dc6e396..fe67a4c 100644
>> --- a/include/linux/of.h
>> +++ b/include/linux/of.h
>> @@ -685,6 +685,15 @@ static inline int of_node_to_nid(struct device_node *device)
>>  }
>>  #endif
>>
>> +#ifdef CONFIG_OF_NUMA
>> +extern int of_numa_init(void);
>> +#else
>> +static inline int of_numa_init(void)
>> +{
>> +       return -ENOSYS;
>> +}
>> +#endif
>> +
>>  static inline struct device_node *of_find_matching_node(
>>         struct device_node *from,
>>         const struct of_device_id *matches)
>> --
>> 1.8.3.1
>>
>

thanks
Ganapat

> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
