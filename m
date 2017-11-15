From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: arm64 crashkernel fails to boot on acpi-only machines due to ACPI
 regions being no longer mapped as NOMAP
Date: Wed, 15 Nov 2017 16:28:55 +0530
Message-ID: <3df4c6c5-0abe-01ee-730d-2edaa5f497d2@redhat.com>
References: <CACi5LpM_95ebYFguPTyjWk+qHT5rDJVXiYDkNWbszo6Zw41zRA@mail.gmail.com>
 <CACi5LpNV_E9pvhTwLcy6vtEj9qbL1ZEHe-5sv=iiW0k9JxPD1Q@mail.gmail.com>
 <20171113092730.GA29552@linaro.org>
 <CAKv+Gu_eQ-s0J22tKeHKJme4qXcvxvDkS7vKrNW+o_XtMTkMhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_eQ-s0J22tKeHKJme4qXcvxvDkS7vKrNW+o_XtMTkMhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard, Akashi,

On 11/14/2017 04:50 PM, Ard Biesheuvel wrote:
> On 13 November 2017 at 09:27, AKASHI Takahiro
> <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> Hi,
>>
>> On Fri, Nov 10, 2017 at 05:41:56PM +0530, Bhupesh Sharma wrote:
>>> Resent with Akashi's correct email address.
>>>
>>> On Fri, Nov 10, 2017 at 5:39 PM, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>> Hi Ard, Akashi
>>>>
>>>> I have met an issue on an arm64 board using the latest master branch from Linus.
>>   (snip)
>>>>
>>>> 8. Also, I think now the crashkernel handling changed by
>>>> e7cd190385d17790cc3eb3821b1094b00aacf325 (arm64: mark reserved
>>>> memblock regions explicitly in iomem), needs to be changed to handle
>>>> the change added by Ard to fix this issue on ACPI only machines.
>>>>
>>>> I have a dirty hack in place, but I would like to have your opinions
>>>> about what can be a more concrete fix to this issue (as we mark these
>>>> regions as System RAM now rather than NOMAP) and I don't have a DTB
>>>> based machine to test on currently.
>>
>> I don't know much about acpi reclaim regions,
>> can you please tell me how your change affects your panic case?

Sorry I was away yesterday and couldn't get back with the dirty hack 
details. But I see Ard has already proposed the following change and it 
looks similar to the change I did locally however that doesn't seem to 
fix the issue completely at my end so far.

Here are more details on the same ..

>
> Does this help at all?
>
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 7768423b39d3..61d867647cca 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -213,7 +213,7 @@ static void __init request_standard_resources(void)
>
>         for_each_memblock(memory, region) {
>                 res = alloc_bootmem_low(sizeof(*res));
> -               if (memblock_is_nomap(region)) {
> +               if (memblock_is_nomap(region) || memblock_is_reserved(region)) {
>                         res->name  = "reserved";
>                         res->flags = IORESOURCE_MEM;
>                 } else {
>

.. So, I tried using the 'memblock_is_reserved' check in ' 
request_standard_resources' however as 'memblock_is_reserved' expects a 
phy_addr as an input argument, I changed mine to something like this:

-               if (memblock_is_nomap(region)) {
+               if (memblock_is_nomap(region) || 
memblock_is_reserved(__pfn_to_phys(memblock_region_reserved_base_pfn(region)))) 
{

However, I see I am hitting a still hitting the issue and its quite 
peculiar one. First some more background on what is happening on this
Huawei Taishan arm64 board that I have:

1a. I see from the boot logs that one of the ACPI tables (DSDT) is at 
phy addr 0x39710000:

# dmesg | grep -i "DSDT"
[    0.000000] ACPI: DSDT 0x0000000039710000 006656 (v02 HISI   HIP07 
00000000 INTL 20151124)

1b. This DSDT table is correctly marked as a ACPI Reclaim memory, 
however I see that just preceding this entry there also is a 'Boot Code' 
entry from address '0x0000396c0000-0x00003970ffff':

# dmesg | grep -B 2 -i "ACPI reclaim"
[    0.000000] efi:   0x000039670000-0x0000396bffff [Runtime Code 
|RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0000396c0000-0x00003970ffff [Boot Code 
|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x000039710000-0x00003975ffff [ACPI Reclaim 
Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]

2. Now, I am not sure which kernel layer does the following changes (I 
am still trying to dig it out more), but I see that the 'Boot Code' and 
ACPI DSDT table regions are somehow merged into one memblock_region and 
appear as range '396c0000-3975ffff' in the '/proc/iomem' interface:

# cat /proc/iomem | grep -A 2 -B 2 39
00000000-3961ffff : System RAM
   00080000-00b6ffff : Kernel code
   00cb0000-0167ffff : Kernel data
   0e800000-2e7fffff : Crash kernel
39620000-396bffff : reserved
396c0000-3975ffff : System RAM
39760000-3976ffff : reserved
39770000-397affff : reserved
397b0000-3989ffff : reserved
398a0000-398bffff : reserved
398c0000-39d3ffff : reserved
39d40000-3ed2ffff : System RAM

3. As to why this merged region appears as a System RAM area, rather 
than a RESERVED one, the following code path explains the same:

3a. The check we added in 'arch/arm64/kernel/setup.c' doesn't handle the 
ACPI DSDT table properly and mark it as 'RESERVED'. This is because 
'memblock_is_reserved' calls 'memblock_search' internally which is 
implemented currently as:

static int __init_memblock memblock_search(struct memblock_type *type, 
phys_addr_t addr)
{
	unsigned int left = 0, right = type->cnt;

	do {
		unsigned int mid = (right + left) / 2;

		if (addr < type->regions[mid].base)
			right = mid;
		else if (addr >= (type->regions[mid].base +
				  type->regions[mid].size))
			left = mid + 1;
		else
			return mid;
	} while (left < right);
	return -1;
}

3b. Since 'addr' being passed to 'memblock_search' calculated via 
'__pfn_to__phys(memblock_region_memory_base_pfn(region)' in this case is 
0x396c0000 (see iomem entry in point 2 above), so we never see that
this memblock is reserved for the ACPI DSDT entry at 0x39710000.

4. Now, when we run the kexec-tools to load a crashdump kernel, it 
doesn't find an entry for the ACPI DSDT table in the reserved range (but 
instead finds it as a System RAM range):

# kexec -p /boot/vmlinuz-`uname -r` --initrd=/boot/initramfs-`uname 
-r`.img --reuse-cmdline -d

...
get_memory_ranges_iomem_cb: 0000000000000000 - 000000003961ffff : System RAM
get_memory_ranges_iomem_cb: 0000000039620000 - 00000000396bffff : reserved
get_memory_ranges_iomem_cb: 00000000396c0000 - 000000003975ffff : System RAM
get_memory_ranges_iomem_cb: 0000000039760000 - 000000003976ffff : reserved
get_memory_ranges_iomem_cb: 0000000039770000 - 00000000397affff : reserved
get_memory_ranges_iomem_cb: 00000000397b0000 - 000000003989ffff : reserved
get_memory_ranges_iomem_cb: 00000000398a0000 - 00000000398bffff : reserved
get_memory_ranges_iomem_cb: 00000000398c0000 - 0000000039d3ffff : reserved
get_memory_ranges_iomem_cb: 0000000039d40000 - 000000003ed2ffff : System RAM
get_memory_ranges_iomem_cb: 000000003ed30000 - 000000003ed5ffff : reserved
get_memory_ranges_iomem_cb: 000000003ed60000 - 000000003fbfffff : System RAM
get_memory_ranges_iomem_cb: 0000001040000000 - 0000001ffbffffff : System RAM
get_memory_ranges_iomem_cb: 0000002000000000 - 0000002ffbffffff : System RAM
get_memory_ranges_iomem_cb: 0000009000000000 - 0000009ffbffffff : System RAM
get_memory_ranges_iomem_cb: 000000a000000000 - 000000affbffffff : System RAM
elf_arm64_probe: Not an ELF executable.
..

5. Now when a crash is issued to boot the crashkernel, we see it panic 
while trying to access the acpi tables (note that the logs below have 
been snipped for clarity):

# echo c > /proc/sysrq-trigger

...
[  419.495621] Bye!
...
[    0.000000] efi:   0x0000396c0000-0x00003970ffff [Boot Code 
|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x000039710000-0x00003975ffff [ACPI Reclaim 
Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
...
[    0.000000] ACPI: DSDT 0x0000000039710000 006656 (v02 HISI   HIP07 
00000000 INTL 20151124)
...
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000010200000-0x00000000301fffff]
[    0.000000]   node   0: [mem 0x0000000039620000-0x00000000396bffff]
[    0.000000]   node   0: [mem 0x0000000039760000-0x000000003976ffff]
[    0.000000]   node   0: [mem 0x00000000397b0000-0x000000003989ffff]
[    0.000000]   node   0: [mem 0x00000000398c0000-0x0000000039d3ffff]
[    0.000000]   node   0: [mem 0x000000003ed30000-0x000000003ed5ffff]
...
[    0.039309] ACPI: Core revision 20170728
[    0.044383] Unable to handle kernel paging request at virtual address 
ffff000009f10027
[    0.052386] Mem abort info:
[    0.055201]   Exception class = DABT (current EL), IL = 32 bits
[    0.061179]   SET = 0, FnV = 0
[    0.064258]   EA = 0, S1PTW = 0
[    0.067424] Data abort info:
[    0.070326]   ISV = 0, ISS = 0x00000021
[    0.074195]   CM = 0, WnR = 0
[    0.077187] swapper pgtable: 64k pages, 48-bit VAs, pgd = 
ffff000009650000
[    0.084133] [ffff000009f10027] *pgd=00000000301d0003, 
*pud=00000000301d0003, *pmd=00000000301c0003, *pte=00e8000039710707
[    0.095215] Internal error: Oops: 96000021 [#1] SMP
[    0.100139] Modules linked in:
[    0.103219] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.0+ #30
[    0.109373] task: ffff000008d05580 task.stack: ffff000008cc0000
[    0.115356] PC is at acpi_ns_lookup+0x25c/0x3c0
[    0.119929] LR is at acpi_ds_load1_begin_op+0xa4/0x294
[    0.125117] pc : [<ffff0000084a862c>] lr : [<ffff00000849d3c0>] 
pstate: 60000045
[    0.132589] sp : ffff000008ccfb40
[    0.135930] x29: ffff000008ccfb40 x28: ffff000008a9c18c
[    0.141295] x27: ffff0000088be820 x26: 0000000000000000
[    0.146659] x25: 000000000000001b x24: 0000000000000001
[    0.152024] x23: 0000000000000001 x22: ffff000009f10027
[    0.157389] x21: ffff000008ccfc50 x20: 0000000000000001
[    0.162753] x19: 000000000000001b x18: 0000000000000005
[    0.168117] x17: 0000000000000000 x16: 0000000000000000
[    0.173481] x15: 0000000000000000 x14: 000000000000038e
[    0.178846] x13: ffffffff00000000 x12: ffffffffffffffff
[    0.184210] x11: 0000000000000006 x10: 00000000ffffff76
[    0.189574] x9 : 000000000000005f x8 : ffff800014670140
[    0.194939] x7 : 0000000000000000 x6 : ffff000008ccfc50
[    0.200303] x5 : ffff800012d45000 x4 : 0000000000000001
[    0.205668] x3 : ffff000008ccfbe0 x2 : ffff0000095e3a00
[    0.211032] x1 : ffff000009f10027 x0 : 0000000000000000
[    0.216397] Process swapper/0 (pid: 0, stack limit = 0xffff000008cc0000)
[    0.223166] Call trace:
[    0.225629] Exception stack(0xffff000008ccfa00 to 0xffff000008ccfb40)
[    0.232136] fa00: 0000000000000000 ffff000009f10027 ffff0000095e3a00 
ffff000008ccfbe0
[    0.240048] fa20: 0000000000000001 ffff800012d45000 ffff000008ccfc50 
0000000000000000
[    0.247960] fa40: ffff800014670140 000000000000005f 00000000ffffff76 
0000000000000006
[    0.255872] fa60: ffffffffffffffff ffffffff00000000 000000000000038e 
0000000000000000
[    0.263785] fa80: 0000000000000000 0000000000000000 0000000000000005 
000000000000001b
[    0.271697] faa0: 0000000000000001 ffff000008ccfc50 ffff000009f10027 
0000000000000001
[    0.279609] fac0: 0000000000000001 000000000000001b 0000000000000000 
ffff0000088be820
[    0.287521] fae0: ffff000008a9c18c ffff000008ccfb40 ffff00000849d3c0 
ffff000008ccfb40
[    0.295433] fb00: ffff0000084a862c 0000000060000045 ffff000008ccfb40 
ffff000008261918
[    0.303345] fb20: ffffffffffffffff ffff0000087f193c ffff000008ccfb40 
ffff0000084a862c
[    0.311258] [<ffff0000084a862c>] acpi_ns_lookup+0x25c/0x3c0
[    0.316885] [<ffff00000849d3c0>] acpi_ds_load1_begin_op+0xa4/0x294
[    0.323128] [<ffff0000084af374>] acpi_ps_build_named_op+0xc4/0x198
[    0.329371] [<ffff0000084af594>] acpi_ps_create_op+0x14c/0x270
[    0.335262] [<ffff0000084aee70>] acpi_ps_parse_loop+0x188/0x5c8
[    0.341241] [<ffff0000084aff10>] acpi_ps_parse_aml+0xb0/0x2b8
[    0.347044] [<ffff0000084aacd8>] acpi_ns_one_complete_parse+0x144/0x184
[    0.353726] [<ffff0000084aad60>] acpi_ns_parse_table+0x48/0x68
[    0.359616] [<ffff0000084aa194>] acpi_ns_load_table+0x4c/0xdc
[    0.365420] [<ffff0000084b51c0>] acpi_tb_load_namespace+0xe4/0x264
[    0.371664] [<ffff000008bafd64>] acpi_load_tables+0x48/0xc0
[    0.377292] [<ffff000008badfd0>] acpi_early_init+0x9c/0xd0
[    0.382832] [<ffff000008b70d50>] start_kernel+0x3b4/0x43c

So, I am looking at what could be causing the 'Boot Code' and 'ACPI DSDT 
table' ranges to be merged into a single region at 
'0x0000396c0000-0x00003970ffff' which cannot be marked as RESERVED using 
'memblock_is_reserved'.

Any pointers?

Regards,
Bhupesh
