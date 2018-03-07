From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: Re: [PATCH 0/2] ESRT fixes for relocatable kexec'd kernel
Date: Wed, 7 Mar 2018 14:01:23 -0500
Message-ID: <59562439-f1ad-c280-8261-96a8bcda2aaa@codeaurora.org>
References: <1519414953-5478-1-git-send-email-tbaicar@codeaurora.org>
 <20180228061901.GJ6019@linaro.org>
 <1f03865f-2d22-8ba1-a276-a6b49d7c14de@codeaurora.org>
 <20180301025026.GK6019@linaro.org>
 <7cd3f462-c619-9d82-73a0-2f3bc9de095e@codeaurora.org>
 <20180302055325.GQ6019@linaro.org>
 <4d21342c-a81e-c3ef-8c5f-9d952c7d8fac@codeaurora.org>
 <20180306090015.GA25863@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180306090015.GA25863@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Jeffrey Hugo <jhugo@codeaurora.org>, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, sgoel@codeaurora.org, timur@codeaurora.org
List-Id: linux-efi@vger.kernel.org

Hello Akashi,


On 3/6/2018 4:00 AM, AKASHI Takahiro wrote:
> Tyler, Jeffrey,
>
> On Fri, Mar 02, 2018 at 08:27:11AM -0500, Tyler Baicar wrote:
>> On 3/2/2018 12:53 AM, AKASHI Takahiro wrote:
>>> Tyler, Jeffrey,
>>>
>>> [Note: This issue takes place in kexec, not kdump. So to be precise,
>>> it is not the same phenomenon as what I addressed in [1],[2]:
>>>    [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-February/557254.html
>>>    [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-January/553098.html
>>> ]
>>>
>>> On Thu, Mar 01, 2018 at 12:56:38PM -0500, Tyler Baicar wrote:
>>>> Hello,
>>>>
>>>> On 2/28/2018 9:50 PM, AKASHI Takahiro wrote:
>>>>> Hi,
>>>>>
>>>>> On Wed, Feb 28, 2018 at 08:39:42AM -0700, Jeffrey Hugo wrote:
>>>>>> On 2/27/2018 11:19 PM, AKASHI Takahiro wrote:
>>>>>>> Tyler,
>>>>>>>
>>>>>>> # I missed catching your patch as its subject doesn't contain arm64.
>>>>>>>
>>>>>>> On Fri, Feb 23, 2018 at 12:42:31PM -0700, Tyler Baicar wrote:
>>>>>>>> Currently on arm64 ESRT memory does not appear to be properly blocked off.
>>>>>>>> Upon successful initialization, ESRT prints out the memory region that it
>>>>>>>> exists in like:
>>>>>>>>
>>>>>>>> esrt: Reserving ESRT space from 0x000000000a4c1c18 to 0x000000000a4c1cf0.
>>>>>>>>
>>>>>>>> But then by dumping /proc/iomem this region appears as part of System RAM
>>>>>>>> rather than being reserved:
>>>>>>>>
>>>>>>>> 08f10000-0deeffff : System RAM
>>>>>>>>
>>>>>>>> This causes issues when trying to kexec if the kernel is relocatable. When
>>>>>>>> kexec tries to execute, this memory can be selected to relocate the kernel to
>>>>>>>> which then overwrites all the ESRT information. Then when the kexec'd kernel
>>>>>>>> tries to initialize ESRT, it doesn't recognize the ESRT version number and
>>>>>>>> just returns from efi_esrt_init().
>>>>>>> I'm not sure what is the root cause of your problem.
>>>>>>> Do you have good confidence that the kernel (2nd kernel image in this case?)
>>>>>>> really overwrite ESRT region?
>>>>>> According to my debug, yes.
>>>>>> Using JTAG, I was able to determine that the ESRT memory region was getting
>>>>>> overwritten by the secondary kernel in
>>>>>> kernel/arch/arm64/kernel/relocate_kernel.S - specifically the "copy_page"
>>>>>> line of arm64_relocate_new_kernel()
>>>>>>
>>>>>>> To my best knowledge, kexec is carefully designed not to do such a thing
>>>>>>> as it allocates a temporary buffer for kernel image and copies it to the
>>>>>>> final destination at the very end of the 1st kernel.
>>>>>>>
>>>>>>> My guess is that kexec, or rather kexec-tools, tries to load the kernel image
>>>>>>> at 0x8f80000 (or 0x9080000?, not sure) in your case. It may or may not be
>>>>>>> overlapped with ESRT.
>>>>>>> (Try "-d" option when executing kexec command for confirmation.)
>>>>>> With -d, I see
>>>>>>
>>>>>> get_memory_ranges_iomem_cb: 0000000009611000 - 000000000e5fffff : System RAM
>>>>>>
>>>>>> That overlaps the ESRT reservation -
>>>>>> [ 0.000000] esrt: Reserving ESRT space from 0x000000000b708718 to
>>>>>> 0x000000000b7087f0
>>>>>>
>>>>>>> Are you using initrd with kexec?
>>>>>> Yes
>>>>> To make the things clear, can you show me, if possible, the followings:
>>>> I have attached all of these:
>>> Many thanks.
>>> According to the data, ESRT was overwritten by initrd, not the kernel image.
>>> It doesn't matter to you though :)
>>>
>>> The solution would be, as Ard suggested, that more information be
>>> added to /proc/iomem.
>>> I'm going to fix the issue as quickly as possible.
>> Great, thank you!! Please add us to the fix and we will gladly test it out.
> I have created a workaround patch, attached below, as a kind of PoC.
> Can you give it a go, please?
> You need another patch for kexec-tools, too. See
> https:/git.linaro.org/people/takahiro.akashi/kexecl-tools.git arm64/resv_mem
>
> With this patch, extra entries for firmware-reserved memory resources,
> which means any regions that are already reserved before arm64_memblock_init(),
> or specifically efi/acpi tables in this case, are added to /proc/iomem.
>
>   $ cat /proc/iomem (on my qemu+edk2 execution)
>          ...
>          40000000-5871ffff : System RAM
>            40080000-40f1ffff : Kernel code
>            41040000-411e9fff : Kernel data
>            54400000-583fffff : Crash kernel
>            58590000-585effff : reserved
>            58700000-5871ffff : reserved
>          58720000-58b5ffff : reserved
>          58b60000-5be3ffff : System RAM
>            58b61000-58b61fff : reserved
>            59a7b118-59a7b667 : reserved
>          5be40000-5becffff : reserved
>          5bed0000-5bedffff : System RAM
>            5bee0000-5bffffff : reserved
>          5c000000-5fffffff : System RAM
>            5ec00000-5edfffff : reserved
>          8000000000-ffffffffff : PCI Bus 0000:00
>            8000000000-8000003fff : 0000:00:01.0
>              8000000000-8000003fff : virtio-pci-modern
>
> While all the entries are currently marked as just "reserved," we'd better
> give them more specific names for general/extensive use.
> (Then it will require modifying respective fw/drivers.)
>
> Kexec-tools will allocate spaces for kernel, initrd and dtb so that
> they will not be overlapped with "reserved" memory.
>
> As I haven't run extensive tests, please let me know if you find
> any problems.
Thank you! I've run the test with both the kernel patch and the kexec patch and can
see that this fixes the issue. I see my ESRT memory space marked as reserved:

[    0.000000] esrt: Reserving ESRT space from 0x000000000a4c1c18 to 
0x000000000a4c1cf0.
root@ubuntu:/home/ubuntu# cat /proc/iomem | grep a4c
   0a4c1c18-0a4c1cef : reserved

And I no longer see this memory region getting overwritten when I run kexec -e. ESRT
initializes properly for me now in the kexec'd kernel.

For both of these patches:

tested-by:Tyler Baicar <tbaicar@codeaurora.org>

Thanks,
Tyler

>
> Thanks,
> -Takahiro AKASHI
>
>> Thanks,
>> Tyler
>>
>> -- 
>> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
>> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
>> a Linux Foundation Collaborative Project.
>>
> ===8<===
>  From 57d93b89d16b967c913f3949601a5559ddf4aa57 Mon Sep 17 00:00:00 2001
> From: AKASHI Takahiro <takahiro.akashi@linaro.org>
> Date: Fri, 2 Mar 2018 16:39:18 +0900
> Subject: [PATCH] arm64: kexec: set asdie firmware-reserved memory regions
>
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>   arch/arm64/kernel/setup.c | 24 ++++++++++++++++++++----
>   arch/arm64/mm/init.c      | 21 +++++++++++++++++++++
>   2 files changed, 41 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 30ad2f085d1f..997f07e86243 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -87,6 +87,9 @@ static struct resource mem_res[] = {
>   #define kernel_code mem_res[0]
>   #define kernel_data mem_res[1]
>   
> +/* TODO: Firmware-reserved memory resources */
> +extern struct memblock_type fw_mem;
> +
>   /*
>    * The recorded values of x0 .. x3 upon kernel entry.
>    */
> @@ -206,7 +209,20 @@ static void __init request_standard_resources(void)
>   {
>   	struct memblock_region *region;
>   	struct resource *res;
> +	int i;
> +
> +	/* add firmware-reserved memory first */
> +	for (i = 1; i < fw_mem.cnt; i++) {
> +		res = alloc_bootmem_low(sizeof(*res));
> +		res->name  = "reserved";
> +		res->flags = IORESOURCE_MEM;
> +		res->start = fw_mem.regions[i].base;
> +		res->end = fw_mem.regions[i].base + fw_mem.regions[i].size - 1;
>   
> +		request_resource(&iomem_resource, res);
> +	}
> +
> +	/* add standard resources */
>   	kernel_code.start   = __pa_symbol(_text);
>   	kernel_code.end     = __pa_symbol(__init_begin - 1);
>   	kernel_data.start   = __pa_symbol(_sdata);
> @@ -224,19 +240,19 @@ static void __init request_standard_resources(void)
>   		res->start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
>   		res->end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;
>   
> -		request_resource(&iomem_resource, res);
> +		insert_resource(&iomem_resource, res);
>   
>   		if (kernel_code.start >= res->start &&
>   		    kernel_code.end <= res->end)
> -			request_resource(res, &kernel_code);
> +			insert_resource(res, &kernel_code);
>   		if (kernel_data.start >= res->start &&
>   		    kernel_data.end <= res->end)
> -			request_resource(res, &kernel_data);
> +			insert_resource(res, &kernel_data);
>   #ifdef CONFIG_KEXEC_CORE
>   		/* Userspace will find "Crash kernel" region in /proc/iomem. */
>   		if (crashk_res.end && crashk_res.start >= res->start &&
>   		    crashk_res.end <= res->end)
> -			request_resource(res, &crashk_res);
> +			insert_resource(res, &crashk_res);
>   #endif
>   	}
>   }
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 9f3c47acf8ff..b6f86a7bbfb7 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -62,6 +62,14 @@
>   s64 memstart_addr __ro_after_init = -1;
>   phys_addr_t arm64_dma_phys_limit __ro_after_init;
>   
> +static struct memblock_region fw_mem_regions[INIT_MEMBLOCK_REGIONS];
> +struct memblock_type fw_mem = {
> +	.regions	= fw_mem_regions,
> +	.cnt		= 1,    /* empty dummy entry */
> +	.max		= INIT_MEMBLOCK_REGIONS,
> +	.name		= "firmware-reserved memory",
> +};
> +
>   #ifdef CONFIG_BLK_DEV_INITRD
>   static int __init early_initrd(char *p)
>   {
> @@ -362,6 +370,19 @@ static void __init fdt_enforce_memory_region(void)
>   void __init arm64_memblock_init(void)
>   {
>   	const s64 linear_region_size = -(s64)PAGE_OFFSET;
> +	struct memblock_region *region;
> +
> +	/*
> +	 * Export firmware-reserved memory regions
> +	 * TODO: via more generic interface
> +	 */
> +	for_each_memblock(reserved, region) {
> +		if (WARN_ON(fw_mem.cnt >= fw_mem.max))
> +			break;
> +		fw_mem.regions[fw_mem.cnt].base = region->base;
> +		fw_mem.regions[fw_mem.cnt].size = region->size;
> +		fw_mem.cnt++;
> +	}
>   
>   	/* Handle linux,usable-memory-range property */
>   	fdt_enforce_memory_region();

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
