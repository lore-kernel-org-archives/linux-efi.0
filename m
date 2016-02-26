From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v12 4/5] arm64, numa: Add NUMA support for arm64
 platforms.
Date: Fri, 26 Feb 2016 18:53:41 +0000
Message-ID: <20160226185341.GN29125@arm.com>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
 <1456192703-2274-5-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456192703-2274-5-git-send-email-ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 22, 2016 at 05:58:22PM -0800, David Daney wrote:
> From: Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
> 
> Attempt to get the memory and CPU NUMA node via of_numa.  If that
> fails, default the dummy NUMA node and map all memory and CPUs to node
> 0.
> 
> Tested-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Reviewed-by: Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

[...]

> @@ -133,10 +151,15 @@ static void __init arm64_memory_present(void)
>  static void __init arm64_memory_present(void)
>  {
>  	struct memblock_region *reg;
> +	int nid = 0;
>  
> -	for_each_memblock(memory, reg)
> -		memory_present(0, memblock_region_memory_base_pfn(reg),
> -			       memblock_region_memory_end_pfn(reg));
> +	for_each_memblock(memory, reg) {
> +#ifdef CONFIG_NUMA
> +		nid = reg->nid;
> +#endif
> +		memory_present(nid, memblock_region_memory_base_pfn(reg),
> +				memblock_region_memory_end_pfn(reg));
> +	}
>  }
>  #endif
>  
> @@ -181,7 +204,6 @@ void __init arm64_memblock_init(void)
>  	dma_contiguous_reserve(arm64_dma_phys_limit);
>  
>  	memblock_allow_resize();
> -	memblock_dump_all();
>  }
>  
>  void __init bootmem_init(void)
> @@ -193,6 +215,9 @@ void __init bootmem_init(void)
>  
>  	early_memtest(min << PAGE_SHIFT, max << PAGE_SHIFT);
>  
> +	max_pfn = max_low_pfn = max;
> +
> +	arm64_numa_init();
>  	/*
>  	 * Sparsemem tries to allocate bootmem in memory_present(), so must be
>  	 * done after the fixed reservations.
> @@ -203,7 +228,6 @@ void __init bootmem_init(void)
>  	zone_sizes_init(min, max);
>  
>  	high_memory = __va((max << PAGE_SHIFT) - 1) + 1;
> -	max_pfn = max_low_pfn = max;
>  }
>  
>  #ifndef CONFIG_SPARSEMEM_VMEMMAP
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 58faeaa..44e3854 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -463,6 +463,7 @@ void __init paging_init(void)
>  	zero_page = early_alloc(PAGE_SIZE);
>  
>  	bootmem_init();
> +	memblock_dump_all();
>  
>  	empty_zero_page = virt_to_page(zero_page);
>  
> diff --git a/arch/arm64/mm/numa.c b/arch/arm64/mm/numa.c
> new file mode 100644
> index 0000000..604e886
> --- /dev/null
> +++ b/arch/arm64/mm/numa.c
> @@ -0,0 +1,403 @@
> +/*
> + * NUMA support, based on the x86 implementation.
> + *
> + * Copyright (C) 2015 Cavium Inc.
> + * Author: Ganapatrao Kulkarni <gkulkarni-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/bootmem.h>
> +#include <linux/memblock.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +
> +struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
> +EXPORT_SYMBOL(node_data);
> +nodemask_t numa_nodes_parsed __initdata;
> +static int cpu_to_node_map[NR_CPUS] = { [0 ... NR_CPUS-1] = NUMA_NO_NODE };
> +
> +static int numa_off;
> +static int numa_distance_cnt;
> +static u8 *numa_distance;
> +
> +static __init int numa_parse_early_param(char *opt)
> +{
> +	if (!opt)
> +		return -EINVAL;
> +	if (!strncmp(opt, "off", 3)) {
> +		pr_info("%s\n", "NUMA turned off");
> +		numa_off = 1;
> +	}
> +	return 0;
> +}
> +early_param("numa", numa_parse_early_param);

Curious, but when is this option actually useful?

> +
> +cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
> +EXPORT_SYMBOL(node_to_cpumask_map);
> +
> +#ifdef CONFIG_DEBUG_PER_CPU_MAPS
> +
> +/*
> + * Returns a pointer to the bitmask of CPUs on Node 'node'.
> + */
> +const struct cpumask *cpumask_of_node(int node)
> +{
> +	if (WARN_ON(node >= nr_node_ids))
> +		return cpu_none_mask;
> +
> +	if (WARN_ON(node_to_cpumask_map[node] == NULL))
> +		return cpu_online_mask;
> +
> +	return node_to_cpumask_map[node];
> +}
> +EXPORT_SYMBOL(cpumask_of_node);
> +
> +#endif
> +
> +static void map_cpu_to_node(unsigned int cpu, int nid)
> +{
> +	set_cpu_numa_node(cpu, nid);
> +	if (nid >= 0)
> +		cpumask_set_cpu(cpu, node_to_cpumask_map[nid]);
> +}
> +
> +static void unmap_cpu_to_node(unsigned int cpu)
> +{
> +	int nid = cpu_to_node(cpu);
> +
> +	if (nid >= 0)
> +		cpumask_clear_cpu(cpu, node_to_cpumask_map[nid]);
> +	set_cpu_numa_node(cpu, NUMA_NO_NODE);
> +}

How do you end up with negative nids this late in the game?

> +
> +void numa_clear_node(unsigned int cpu)
> +{
> +	unmap_cpu_to_node(cpu);

Why don't you just inline this function?

> +}
> +
> +/*
> + * Allocate node_to_cpumask_map based on number of available nodes
> + * Requires node_possible_map to be valid.
> + *
> + * Note: cpumask_of_node() is not valid until after this is done.
> + * (Use CONFIG_DEBUG_PER_CPU_MAPS to check this.)
> + */
> +static void __init setup_node_to_cpumask_map(void)
> +{
> +	unsigned int cpu;
> +	int node;
> +
> +	/* setup nr_node_ids if not done yet */
> +	if (nr_node_ids == MAX_NUMNODES)
> +		setup_nr_node_ids();
> +
> +	/* allocate and clear the mapping */
> +	for (node = 0; node < nr_node_ids; node++) {
> +		alloc_bootmem_cpumask_var(&node_to_cpumask_map[node]);
> +		cpumask_clear(node_to_cpumask_map[node]);
> +	}
> +
> +	for_each_possible_cpu(cpu)
> +		set_cpu_numa_node(cpu, NUMA_NO_NODE);
> +
> +	/* cpumask_of_node() will now work */
> +	pr_debug("NUMA: Node to cpumask map for %d nodes\n", nr_node_ids);
> +}
> +
> +/*
> + *  Set the cpu to node and mem mapping
> + */
> +void numa_store_cpu_info(unsigned int cpu)
> +{
> +	map_cpu_to_node(cpu, numa_off ? 0 : cpu_to_node_map[cpu]);
> +}
> +
> +void __init early_map_cpu_to_node(unsigned int cpu, int nid)
> +{
> +	/* fallback to node 0 */
> +	if (nid < 0 || nid >= MAX_NUMNODES)
> +		nid = 0;
> +
> +	cpu_to_node_map[cpu] = nid;
> +}
> +
> +/**
> + * numa_add_memblk - Set node id to memblk
> + * @nid: NUMA node ID of the new memblk
> + * @start: Start address of the new memblk
> + * @size:  Size of the new memblk
> + *
> + * RETURNS:
> + * 0 on success, -errno on failure.
> + */
> +int __init numa_add_memblk(int nid, u64 start, u64 size)
> +{
> +	int ret;
> +
> +	ret = memblock_set_node(start, size, &memblock.memory, nid);
> +	if (ret < 0) {
> +		pr_err("NUMA: memblock [0x%llx - 0x%llx] failed to add on node %d\n",
> +			start, (start + size - 1), nid);
> +		return ret;
> +	}
> +
> +	node_set(nid, numa_nodes_parsed);
> +	pr_info("NUMA: Adding memblock [0x%llx - 0x%llx] on node %d\n",
> +			start, (start + size - 1), nid);
> +	return ret;
> +}
> +EXPORT_SYMBOL(numa_add_memblk);

But this is marked __init... (and you've done this elsewhere in the patch
too).

Will
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
