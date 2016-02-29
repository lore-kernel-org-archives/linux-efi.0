From: Robert Richter <rric-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 4/5] arm64, numa: Add NUMA support for arm64
 platforms.
Date: Mon, 29 Feb 2016 18:34:46 +0100
Message-ID: <20160229173446.GG31343@rric.localdomain>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
 <1456192703-2274-5-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456192703-2274-5-git-send-email-ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 22.02.16 17:58:22, David Daney wrote:
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
> ---
>  arch/arm64/Kconfig                |  26 +++
>  arch/arm64/include/asm/mmzone.h   |  12 ++
>  arch/arm64/include/asm/numa.h     |  45 +++++
>  arch/arm64/include/asm/topology.h |  10 +
>  arch/arm64/kernel/pci.c           |  10 +
>  arch/arm64/kernel/setup.c         |   4 +
>  arch/arm64/kernel/smp.c           |   4 +
>  arch/arm64/mm/Makefile            |   1 +
>  arch/arm64/mm/init.c              |  34 +++-
>  arch/arm64/mm/mmu.c               |   1 +
>  arch/arm64/mm/numa.c              | 403 ++++++++++++++++++++++++++++++++++++++
>  11 files changed, 545 insertions(+), 5 deletions(-)
>  create mode 100644 arch/arm64/include/asm/mmzone.h
>  create mode 100644 arch/arm64/include/asm/numa.h
>  create mode 100644 arch/arm64/mm/numa.c

> +static int __init numa_init(int (*init_func)(void))
> +{
> +	int ret;
> +
> +	nodes_clear(numa_nodes_parsed);
> +	nodes_clear(node_possible_map);
> +	nodes_clear(node_online_map);
> +	numa_free_distance();
> +
> +	ret = numa_alloc_distance();
> +	if (ret < 0)
> +		return ret;

If you move this before the remaining initializers, you will need to
clean this up on error. So better move it back after
numa_register_nodes() as it was in v10. This should work since
distances are used not earlier than numa is enabled.

-Robert

> +
> +	ret = init_func();
> +	if (ret < 0)
> +		return ret;
> +
> +	if (nodes_empty(numa_nodes_parsed))
> +		return -EINVAL;
> +
> +	ret = numa_register_nodes();
> +	if (ret < 0)
> +		return ret;
> +
> +	setup_node_to_cpumask_map();
> +
> +	/* init boot processor */
> +	cpu_to_node_map[0] = 0;
> +	map_cpu_to_node(0, 0);
> +
> +	return 0;
> +}
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
