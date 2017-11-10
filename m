From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: arm64 crashkernel fails to boot on acpi-only machines due to ACPI
 regions being no longer mapped as NOMAP
Date: Fri, 10 Nov 2017 17:39:44 +0530
Message-ID: <CACi5LpM_95ebYFguPTyjWk+qHT5rDJVXiYDkNWbszo6Zw41zRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, akahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, james.morse-5wv7dgnIgG8@public.gmane.org, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard, Akashi

I have met an issue on an arm64 board using the latest master branch from Linus.

I think I have a dirty hack to avoid the issue, but would want more
opinions from you as it might break crashkernel dump on other arm64
machines.

1. This arm64 machine supports acpi only boot mode (i.e. acpi=force is
always set in bootargs)

2. Since f56ab9a5b73ca2aee777ccdf2d355ae2dd31db5a (efi/arm: Don't mark
ACPI reclaim memory as MEMBLOCK_NOMAP), Ard rightly added a chunk
which marks the 'EFI_ACPI_RECLAIM_MEMORY' regions as useable memory
(by setting the EFI_MEMORY_WB flag for such efi memory descriptors
thus marking them as System RAM).

3. However this causes crashkernel booting on ACPI only machines to fail:

[    0.039205] ACPI: Core revision 20170728
pud=000000002e7d0003, *pmd=000000002e7c0003, *pte=00e8000039710707
[    0.095098] Internal error: Oops: 96000021 [#1] SMP
[    0.100022] Modules linked in:
[    0.103102] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.0-rc6 #1
[    0.109432] task: ffff000008d05180 task.stack: ffff000008cc0000
[    0.115414] PC is at acpi_ns_lookup+0x25c/0x3c0
[    0.119987] LR is at acpi_ds_load1_begin_op+0xa4/0x294
[    0.125175] pc : [<ffff0000084a6764>] lr : [<ffff00000849b4f8>]
pstate: 60000045
[    0.132647] sp : ffff000008ccfb40
[    0.135989] x29: ffff000008ccfb40 x28: ffff000008a9f2a4
[    0.141354] x27: ffff0000088be820 x26: 0000000000000000
[    0.146718] x25: 000000000000001b x24: 0000000000000001
[    0.152083] x23: 0000000000000001 x22: ffff000009710027
[    0.157447] x21: ffff000008ccfc50 x20: 0000000000000001
[    0.162812] x19: 000000000000001b x18: 0000000000000005
[    0.168176] x17: 0000000000000000 x16: 0000000000000000
[    0.173541] x15: 0000000000000000 x14: 000000000000038e
[    0.178905] x13: ffffffff00000000 x12: ffffffffffffffff
[    0.184270] x11: 0000000000000006 x10: 00000000ffffff76
[    0.189634] x9 : 000000000000005f x8 : ffff8000126d0140
[    0.194998] x7 : 0000000000000000 x6 : ffff000008ccfc50
[    0.200362] x5 : ffff80000fe62c00 x4 : 0000000000000001
[    0.205727] x3 : ffff000008ccfbe0 x2 : ffff0000095e3980
[    0.211091] x1 : ffff000009710027 x0 : 0000000000000000
[    0.216456] Process swapper/0 (pid: 0, stack limit = 0xffff000008cc0000)
[    0.223224] Call trace:
[    0.225688] Exception stack(0xffff000008ccfa00 to 0xffff000008ccfb40)
[    0.232194] fa00: 0000000000000000 ffff000009710027
ffff0000095e3980 ffff000008ccfbe0
[    0.240106] fa20: 0000000000000001 ffff80000fe62c00
ffff000008ccfc50 0000000000000000
[    0.248018] fa40: ffff8000126d0140 000000000000005f
00000000ffffff76 0000000000000006
[    0.255931] fa60: ffffffffffffffff ffffffff00000000
000000000000038e 0000000000000000
[    0.263843] fa80: 0000000000000000 0000000000000000
0000000000000005 000000000000001b
[    0.271754] faa0: 0000000000000001 ffff000008ccfc50
ffff000009710027 0000000000000001
[    0.279667] fac0: 0000000000000001 000000000000001b
0000000000000000 ffff0000088be820
[    0.287579] fae0: ffff000008a9f2a4 ffff000008ccfb40
ffff00000849b4f8 ffff000008ccfb40
[    0.295491] fb00: ffff0000084a6764 0000000060000045
ffff000008ccfb40 ffff000008260a18
[    0.303403] fb20: ffffffffffffffff ffff0000087f3fb0
ffff000008ccfb40 ffff0000084a6764
[    0.311316] [<ffff0000084a6764>] acpi_ns_lookup+0x25c/0x3c0
[    0.316943] [<ffff00000849b4f8>] acpi_ds_load1_begin_op+0xa4/0x294
[    0.323186] [<ffff0000084ad4ac>] acpi_ps_build_named_op+0xc4/0x198
[    0.329428] [<ffff0000084ad6cc>] acpi_ps_create_op+0x14c/0x270
[    0.335319] [<ffff0000084acfa8>] acpi_ps_parse_loop+0x188/0x5c8
[    0.341298] [<ffff0000084ae048>] acpi_ps_parse_aml+0xb0/0x2b8
[    0.347101] [<ffff0000084a8e10>] acpi_ns_one_complete_parse+0x144/0x184
[    0.353783] [<ffff0000084a8e98>] acpi_ns_parse_table+0x48/0x68
[    0.359675] [<ffff0000084a82cc>] acpi_ns_load_table+0x4c/0xdc
[    0.365479] [<ffff0000084b32f8>] acpi_tb_load_namespace+0xe4/0x264
[    0.371723] [<ffff000008baf9b4>] acpi_load_tables+0x48/0xc0
[    0.377350] [<ffff000008badc20>] acpi_early_init+0x9c/0xd0
[    0.382891] [<ffff000008b70d50>] start_kernel+0x3b4/0x43c
[    0.388343] Code: b9008fb9 2a000318 36380054 32190318 (b94002c0)
[    0.394500] ---[ end trace c46ed37f9651c58e ]---
[    0.399160] Kernel panic - not syncing: Fatal exception
[    0.404437] Rebooting in 10 seconds..

4. On the primary kernel boot, I notice with efi=debug that while the
ACPI regions are properly recognized as Reclaim regions:

...
[    0.000000] efi:   0x000039710000-0x00003975ffff [ACPI Reclaim
Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x000039770000-0x0000397affff [ACPI Reclaim
Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
...
[    0.000000] efi:   0x0000398a0000-0x0000398bffff [ACPI Reclaim
Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]

And appear correctly as early memory node ranges:

[    0.000000] Early memory node ranges
...
[    0.000000]   node   0: [mem 0x00000000396c0000-0x000000003975ffff]
[    0.000000]   node   0: [mem 0x0000000039760000-0x000000003976ffff]
[    0.000000]   node   0: [mem 0x0000000039770000-0x00000000397affff]
[    0.000000]   node   0: [mem 0x00000000397b0000-0x000000003989ffff]
[    0.000000]   node   0: [mem 0x00000000398a0000-0x00000000398bffff]

5. However when the crashkernel is boot'ed I see that although the
same regions are recognized as Reclaim regions they do not appear in
the "Early Memory node range" entries:

[  141.348355] Starting crashdump kernel...
[  141.352269] Bye!
...
[    0.000000] efi:   0x000039710000-0x00003975ffff [ACPI Reclaim
Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x000039770000-0x0000397affff [ACPI Reclaim
Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
...
[    0.000000] efi:   0x0000398a0000-0x0000398bffff [ACPI Reclaim
Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]

...
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x000000000e800000-0x000000002e7fffff]
[    0.000000]   node   0: [mem 0x0000000039620000-0x00000000396bffff]
[    0.000000]   node   0: [mem 0x0000000039760000-0x000000003976ffff]
[    0.000000]   node   0: [mem 0x00000000397b0000-0x000000003989ffff]
[    0.000000]   node   0: [mem 0x00000000398c0000-0x0000000039d3ffff]
[    0.000000]   node   0: [mem 0x000000003ed30000-0x000000003ed5ffff]

( ^^^ No entry for ACPI Reclaim Memory regions)

6a. Also I see that during the primary kernel boot:

'acpi_os_ioremap' calls 'ioremap_cache' for the ACPI Reclaim Memory regions.

6b. But during the crashkernel boot, ''acpi_os_ioremap' calls
'ioremap' for the ACPI Reclaim Memory regions and not the _cache
variant.

7. I think this is because of how the memblock regions are mapped in
'arch/arm64/mm/mmu.c':

I am not quite sure if I fully understand the trick we have presently
inside '__init map_mem(pgd_t *pgd)', but reading the comment below:

    /*
     * Take care not to create a writable alias for the
     * read-only text and rodata sections of the kernel image.
     * So temporarily mark them as NOMAP to skip mappings in
     * the following for-loop
     */

I think we are marking only the kernel text and crashkernel regions
with NO_CONT_MAPPINGS or NO_CONT_MAPPINGS and NO_BLOCK_MAPPINGS

8. Also, I think now the crashkernel handling changed by
e7cd190385d17790cc3eb3821b1094b00aacf325 (arm64: mark reserved
memblock regions explicitly in iomem), needs to be changed to handle
the change added by Ard to fix this issue on ACPI only machines.

I have a dirty hack in place, but I would like to have your opinions
about what can be a more concrete fix to this issue (as we mark these
regions as System RAM now rather than NOMAP) and I don't have a DTB
based machine to test on currently.

Please share your views.

Regards,
Bhupesh
