From: Ganapatrao Kulkarni <gpkulkarni-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v12 4/5] arm64, numa: Add NUMA support for arm64 platforms.
Date: Sat, 27 Feb 2016 09:43:49 +0530
Message-ID: <CAFpQJXURSKFw6RmNVLiB=YDcUiaaQLz3zMvM9gy=b1MobaCfgg@mail.gmail.com>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
	<1456192703-2274-5-git-send-email-ddaney.cavm@gmail.com>
	<20160226185341.GN29125@arm.com>
	<56D0ACC4.1060605@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D0ACC4.1060605-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Feb 27, 2016 at 1:21 AM, David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org> wrote:
> On 02/26/2016 10:53 AM, Will Deacon wrote:
> [...]
>>>
>>> diff --git a/arch/arm64/mm/numa.c b/arch/arm64/mm/numa.c
>>> new file mode 100644
>>> index 0000000..604e886
>>> --- /dev/null
>>> +++ b/arch/arm64/mm/numa.c
>>> @@ -0,0 +1,403 @@
>
> [...]
>>>
>>> +
>>> +static int numa_off;
>>> +static int numa_distance_cnt;
>>> +static u8 *numa_distance;
>>> +
>>> +static __init int numa_parse_early_param(char *opt)
>>> +{
>>> +       if (!opt)
>>> +               return -EINVAL;
>>> +       if (!strncmp(opt, "off", 3)) {
>>> +               pr_info("%s\n", "NUMA turned off");
>>> +               numa_off = 1;
>>> +       }
>>> +       return 0;
>>> +}
>>> +early_param("numa", numa_parse_early_param);
>>
>>
>> Curious, but when is this option actually useful?
>>
>
> Good point.  I will remove that bit, it was used as an aid in debugging
> while bringing up the patch set.

this is handy in debugging new platforms.
this boot argument option forces to boot as single node dummy system
adding all resources to node0.
>
>
>
>>> +
>>> +cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
>>> +EXPORT_SYMBOL(node_to_cpumask_map);
>>> +
>>> +#ifdef CONFIG_DEBUG_PER_CPU_MAPS
>>> +
>>> +/*
>>> + * Returns a pointer to the bitmask of CPUs on Node 'node'.
>>> + */
>>> +const struct cpumask *cpumask_of_node(int node)
>>> +{
>>> +       if (WARN_ON(node >= nr_node_ids))
>>> +               return cpu_none_mask;
>>> +
>>> +       if (WARN_ON(node_to_cpumask_map[node] == NULL))
>>> +               return cpu_online_mask;
>>> +
>>> +       return node_to_cpumask_map[node];
>>> +}
>>> +EXPORT_SYMBOL(cpumask_of_node);
>>> +
>>> +#endif
>>> +
>>> +static void map_cpu_to_node(unsigned int cpu, int nid)
>>> +{
>>> +       set_cpu_numa_node(cpu, nid);
>>> +       if (nid >= 0)
>>> +               cpumask_set_cpu(cpu, node_to_cpumask_map[nid]);
>>> +}
>>> +
>>> +static void unmap_cpu_to_node(unsigned int cpu)
>>> +{
>>> +       int nid = cpu_to_node(cpu);
>>> +
>>> +       if (nid >= 0)
>>> +               cpumask_clear_cpu(cpu, node_to_cpumask_map[nid]);
>>> +       set_cpu_numa_node(cpu, NUMA_NO_NODE);
>>> +}
>>
>>
>> How do you end up with negative nids this late in the game?
>>
>
> It might be possible with some of the hot plugging code.  It is a little
> paranoia programming.
>
> If you really don't like it, we can remove it.
>
>>> +
>>> +void numa_clear_node(unsigned int cpu)
>>> +{
>>> +       unmap_cpu_to_node(cpu);
>>
>>
>> Why don't you just inline this function?
>
>
> Good point, I will do that.
>
> [...]
>>>
>>> +int __init numa_add_memblk(int nid, u64 start, u64 size)
>>> +{
>>> +       int ret;
>>> +
>>> +       ret = memblock_set_node(start, size, &memblock.memory, nid);
>>> +       if (ret < 0) {
>>> +               pr_err("NUMA: memblock [0x%llx - 0x%llx] failed to add on
>>> node %d\n",
>>> +                       start, (start + size - 1), nid);
>>> +               return ret;
>>> +       }
>>> +
>>> +       node_set(nid, numa_nodes_parsed);
>>> +       pr_info("NUMA: Adding memblock [0x%llx - 0x%llx] on node %d\n",
>>> +                       start, (start + size - 1), nid);
>>> +       return ret;
>>> +}
>>> +EXPORT_SYMBOL(numa_add_memblk);
>>
>>
>> But this is marked __init... (and you've done this elsewhere in the patch
>> too).
>
>
> I will fix these.
>
>
>>
>> Will
>>
>

Ganapat
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
