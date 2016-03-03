From: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v13 3/6] of, numa: Add NUMA of binding implementation.
Date: Thu, 3 Mar 2016 09:33:38 -0800
Message-ID: <56D87572.3090002@caviumnetworks.com>
References: <1456959362-2036-1-git-send-email-ddaney.cavm@gmail.com> <1456959362-2036-4-git-send-email-ddaney.cavm@gmail.com> <CAL_JsqLRP6tmpY7cJ61Ybrrai4ctA7ezyUGmYwdbywe+-qBG5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqLRP6tmpY7cJ61Ybrrai4ctA7ezyUGmYwdbywe+-qBG5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/02/2016 07:34 PM, Rob Herring wrote:
> On Wed, Mar 2, 2016 at 4:55 PM, David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>>
>> Add device tree parsing for NUMA topology using device
>> "numa-node-id" property in distance-map and cpu nodes.
>>
>> This is a complete rewrite of a previous patch by:
>>     Ganapatrao Kulkarni<gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
>>
>> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>> ---
>>   drivers/of/Kconfig   |   3 +
>>   drivers/of/Makefile  |   1 +
>>   drivers/of/of_numa.c | 200 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/of.h   |   9 +++
>>   4 files changed, 213 insertions(+)
>>   create mode 100644 drivers/of/of_numa.c
>>
[...]
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

Yes.

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

OK, I will do that.

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

I will try to do something like that.

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

As Ganapatrao said in the other e-mail, all we are doing is discovering 
which nodes have a CPU here.  At this point we don't care about any 
other properties of the individual CPUs.

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

I thought about doing that.  It would make the code simpler.  I was 
concerned about the address translation that is done, but since these 
are at the root level there should be no translation.  I will change the 
code to do this.

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

I think we should start with specifying that all elements are a single 
cell.  In the future if this turns out to be insufficient, the binding 
could easily be extended to include a #node-id-size or something similar.

I will simplify the code to assume a single cell.


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

The number of elements in the array could be large.  We would have to do 
dynamic memory allocation to be able to use of_property_read_u32_array. 
  I would prefer to iterate through the array like this to avoid having 
to allocate memory.

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

Well, we need to match exactly the name "distance-map", 
of_find_compatible_node() doesn't match on the name, so I think we need 
two checks, one for name and one for compatible.

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

Yes, if the property doesn't exist, we need to check the parent. 
Otherwise, it indicates an error in the device tree, and we bail out 
with the warning message.

I will add a comment that explains what we are doing and the 
significance of -EINVAL

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

Good catch.  I will export it.

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
>>   }
>>   #endif
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
>>   static inline struct device_node *of_find_matching_node(
>>          struct device_node *from,
>>          const struct of_device_id *matches)
>> --
>> 1.8.3.1
>>
