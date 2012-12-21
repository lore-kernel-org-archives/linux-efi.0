From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: General protection fault in efivarfs
Date: Fri, 21 Dec 2012 19:05:29 +0800
Message-ID: <50D44279.7010008@redhat.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org> <1351237923-10313-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The following reproducer triggers certain bugs in efivarfs_file_write.

#!/bin/bash
p=/sys/firmware/efi/efivars
mount -t efivarfs - $p
cat $p/Lang-* >$p/test-12341234-1234-1234-1234-123412341234
umount $p
mount -t efivarfs - $p
echo -en "\0\0\0\0" >$p/test-12341234-1234-1234-1234-123412341234
cat $p/Lang-* >$p/test-12341234-1234-1234-1234-123412341234

Without the umount and mount, it causes nothing. After reproduction,
umount and various filesystem operations become unstable.

3.6.11 and 3.7 kernels are from Fedora 18/Rawhide with efivarfs
backported by Josh Boyer on Nov 2.

It is always reproducible, but sometimes it hanged with no call trace.

IBM machine, 3.7:
[   59.978216] general protection fault: 0000 [#1] SMP
[   59.983214] Modules linked in: nf_conntrack_netbios_ns 
nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat 
iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack 
nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables vfat fat 
iTCO_wdt shpchp vhost_net i7core_edac coretemp crc32c_intel 
iTCO_vendor_support serio_raw ioatdma edac_core lpc_ich i2c_i801 
cdc_ether microcode mfd_core dca usbnet tun mii bnx2 macvtap macvlan 
kvm_intel kvm mgag200 i2c_algo_bit mptsas drm_kms_helper ttm mptscsih 
drm mptbase i2c_core scsi_transport_sas
[   60.038660] CPU 9
[   60.040501] Pid: 1001, comm: cat Not tainted 3.7.0-2.fc19.x86_64 #1 
IBM System x3550 M3 -[7944I21]-/69Y4438
[   60.050840] RIP: 0010:[<ffffffff810d5d1e>]  [<ffffffff810d5d1e>] 
__lock_acquire+0x5e/0x1bb0
[   60.059198] RSP: 0018:ffff880270595ce8  EFLAGS: 00010046
[   60.064500] RAX: 0000000000000046 RBX: 0000000000000002 RCX: 
0000000000000000
[   60.071617] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
6b6b6b6b6b6b6b83
[   60.078735] RBP: ffff880270595dd8 R08: 0000000000000002 R09: 
0000000000000000
[   60.085852] R10: 6b6b6b6b6b6b6b83 R11: 0000000000000000 R12: 
0000000000000000
[   60.092971] R13: ffff88027170cd20 R14: 0000000000000000 R15: 
0000000000000000
[   60.100091] FS:  00007fc0c8ff3740(0000) GS:ffff880277000000(0000) 
knlGS:0000000000000000
[   60.108164] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   60.113899] CR2: 0000000001520000 CR3: 000000026d594000 CR4: 
00000000000007e0
[   60.121016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   60.128135] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   60.135254] Process cat (pid: 1001, threadinfo ffff880270594000, task 
ffff88027170cd20)
[   60.143239] Stack:
[   60.145251]  ffff880270595cf8 ffffffff81021da3 ffff880270595d08 
ffffffff81021e19
[   60.152714]  ffff880270595d38 ffffffff810acdb5 ffff880200000168 
0000000000000086
[   60.160175]  ffff88027170d5e8 ffffffff810d25ed ffff880270595d58 
ffffffff810ace7f
[   60.167638] Call Trace:
[   60.170088]  [<ffffffff81021da3>] ? native_sched_clock+0x13/0x80
[   60.176085]  [<ffffffff81021e19>] ? sched_clock+0x9/0x10
[   60.181389]  [<ffffffff810acdb5>] ? sched_clock_cpu+0xc5/0x120
[   60.187211]  [<ffffffff810d25ed>] ? trace_hardirqs_off+0xd/0x10
[   60.193121]  [<ffffffff810ace7f>] ? local_clock+0x6f/0x80
[   60.198513]  [<ffffffff810d2f6f>] ? 
lock_release_holdtime.part.26+0xf/0x180
[   60.205465]  [<ffffffff810d7b57>] ? lock_release_non_nested+0x2e7/0x320
[   60.212073]  [<ffffffff815638bb>] ? efivarfs_file_write+0x5b/0x280
[   60.218242]  [<ffffffff810d7f41>] lock_acquire+0xa1/0x1f0
[   60.223633]  [<ffffffff81563971>] ? efivarfs_file_write+0x111/0x280
[   60.229892]  [<ffffffff8118b47c>] ? might_fault+0x5c/0xb0
[   60.235287]  [<ffffffff816f1bf6>] _raw_spin_lock+0x46/0x80
[   60.240762]  [<ffffffff81563971>] ? efivarfs_file_write+0x111/0x280
[   60.247018]  [<ffffffff81563971>] efivarfs_file_write+0x111/0x280
[   60.253103]  [<ffffffff811d307f>] vfs_write+0xaf/0x190
[   60.258233]  [<ffffffff811d33d5>] sys_write+0x55/0xa0
[   60.263278]  [<ffffffff816fbd19>] system_call_fastpath+0x16/0x1b
[   60.269271] Code: 41 0f 45 d8 4c 89 75 f0 4c 89 7d f8 85 c0 0f 84 09 
01 00 00 8b 05 a3 f9 ff 00 49 89 fa 41 89 f6 41 89 d3 85 c0 0f 84 12 01 
00 00 <49> 8b 02 ba 01 00 00 00 48 3d a0 07 14 82 0f 44 da 41 83 fe 01
[   60.289431] RIP  [<ffffffff810d5d1e>] __lock_acquire+0x5e/0x1bb0
[   60.295444]  RSP <ffff880270595ce8>
[   60.298928] ---[ end trace 1bbfd41a2cf6a0d8 ]---
(More pstore "scheduling while atomic" ensues if debug options are 
turned on.)
Segmentation fault

QEMU with OVMF, 3.6.11:
[   74.193012] BUG: unable to handle kernel NULL pointer dereference at 
           (null)
[   74.193016] IP: [<ffffffff81623b0e>] _raw_spin_lock+0xe/0x30
[   74.193016] PGD 3ff0d067 PUD 3fe41067 PMD 0
[   74.193016] Oops: 0002 [#1] SMP
[   74.193016] Modules linked in: nf_conntrack_netbios_ns 
nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat iptable_mangle 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
ebtable_filter ebtables ip6table_filter ip6_tables vfat fat virtio_net 
i2c_piix4 i2c_core microcode
[   74.193016] CPU 1
[   74.193016] Pid: 782, comm: echo Tainted: G        W 
3.6.11-3.fc18.x86_64 #1
[   74.193016] RIP: 0010:[<ffffffff81623b0e>]  [<ffffffff81623b0e>] 
_raw_spin_lock+0xe/0x30
[   74.193016] RSP: 0018:ffff8800797f7e88  EFLAGS: 00010202
[   74.193016] RAX: 0000000000000100 RBX: ffff8800787db6a0 RCX: 
0000000000000074
[   74.193016] RDX: 0000000000000004 RSI: ffff8800787db6a0 RDI: 
0000000000000000
[   74.193016] RBP: ffff8800797f7e88 R08: 0000000000000050 R09: 
ffffffff814d558b
[   74.193016] R10: 00007fff02dff770 R11: ffffffff81a1c31c R12: 
0000000000000008
[   74.193016] R13: ffff880078297000 R14: 0000000000000004 R15: 
ffff880077eee000
[   74.193016] FS:  00007fc6dbbc4740(0000) GS:ffff88007d900000(0000) 
knlGS:0000000000000000
[   74.193016] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   74.193016] CR2: 0000000000000000 CR3: 000000003fc31000 CR4: 
00000000000406e0
[   74.193016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   74.193016] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   74.193016] Process echo (pid: 782, threadinfo ffff8800797f6000, task 
ffff880078184530)
[   74.193016] Stack:
[   74.193016]  ffff8800797f7ef8 ffffffff814d5641 ffff8800797f7ec8 
ffff88007c4313b0
[   74.193016]  0000000000000000 ffff880077eee008 0000000078297000 
0000000000000001
[   74.193016]  ffff8800797f7ef8 ffff880078297000 0000000000000008 
00007fc6dbbcb000
[   74.193016] Call Trace:
[   74.193016]  [<ffffffff814d5641>] efivarfs_file_write+0x111/0x270
[   74.193016]  [<ffffffff811908cc>] vfs_write+0xac/0x180
[   74.193016]  [<ffffffff81190bfa>] sys_write+0x4a/0x90
[   74.193016]  [<ffffffff8162bd69>] system_call_fastpath+0x16/0x1b
[   74.193016] Code: c2 ff ff ff ff be 01 00 00 00 48 89 e5 e8 8b fe ff 
ff 5d c3 90 90 90 90 90 90 90 90 90 55 48 89 e5 66 66 66 66 90 b8 00 01 
00 00 <f0> 66 0f c1 07 0f b6 d4 38 c2 74 0f 66 0f 1f 44 00 00 f3 90 0f
[   74.193016] RIP  [<ffffffff81623b0e>] _raw_spin_lock+0xe/0x30
[   74.193016]  RSP <ffff8800797f7e88>
[   74.193016] CR2: 0000000000000000
[   74.241459] ---[ end trace 675d5a6c2b09c5be ]---
Killed

QEMU with OVMF, 3.6.11, another one:
[   19.437433] general protection fault: 0000 [#1] SMP
[   19.438011] Modules linked in: nf_conntrack_netbios_ns 
nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat iptable_mangle 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
ebtable_filter ebtables ip6table_filter ip6_tables vfat fat i2c_piix4 
i2c_core virtio_net microcode
[   19.438011] CPU 0
[   19.438011] Pid: 775, comm: cat Tainted: G        W 
3.6.11-3.fc18.x86_64 #1
[   19.438011] RIP: 0010:[<ffffffff814d5664>]  [<ffffffff814d5664>] 
efivarfs_file_write+0x134/0x270
[   19.438011] RSP: 0018:ffff880077fd1e98  EFLAGS: 00010246
[   19.438011] RAX: 3134333231343332 RBX: ffff8800786871f0 RCX: 
0000000000000004
[   19.438011] RDX: 0000000000000007 RSI: ffff88007f45b408 RDI: 
ffff88007f45b008
[   19.438011] RBP: ffff880077fd1ef8 R08: ffff8800786871f0 R09: 
ffff88007f45b408
[   19.438011] R10: 00007fff15780f60 R11: ffffffff81a1c31c R12: 
0000000000000008
[   19.438011] R13: ffff880078919700 R14: 0000000000000004 R15: 
ffff88007f45b000
[   19.438011] FS:  00007fa220298740(0000) GS:ffff88007d800000(0000) 
knlGS:0000000000000000
[   19.438011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   19.438011] CR2: 0000000001c56000 CR3: 0000000079286000 CR4: 
00000000000406f0
[   19.438011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   19.438011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   19.438011] Process cat (pid: 775, threadinfo ffff880077fd0000, task 
ffff88007e84ae20)
[   19.438011] Stack:
[   19.438011]  ffff88007f45b408 ffff880079a088c0 ffff88007f459000 
ffff88007f45b008
[   19.438011]  0000000778919700 0000000000000001 ffff880077fd1ef8 
ffff880078919700
[   19.438011]  0000000000000008 0000000001c56000 ffff880077fd1f50 
0000000000010000
[   19.438011] Call Trace:
[   19.438011]  [<ffffffff811908cc>] vfs_write+0xac/0x180
[   19.438011]  [<ffffffff81190bfa>] sys_write+0x4a/0x90
[   19.438011]  [<ffffffff8162bd69>] system_call_fastpath+0x16/0x1b
[   19.438011] Code: 8b 7d b0 e8 bf e4 14 00 48 8b 55 b0 4d 8d 8f 08 04 
00 00 4c 89 f1 49 89 d8 48 8b 7d b8 4c 89 ce 48 8b 42 38 4c 89 4d a0 8b 
55 c4 <ff> 50 10 48 85 c0 49 89 c6 4c 8b 4d a0 74 59 48 8b 45 b0 80 00
[   19.438011] RIP  [<ffffffff814d5664>] efivarfs_file_write+0x134/0x270
[   19.438011]  RSP <ffff880077fd1e98>
[   19.475465] ---[ end trace 969a2b2b14764a38 ]---
[   19.479214] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000100
[   19.480040] IP: [<ffffffff8117b543>] kmem_cache_alloc_trace+0x63/0x160
[   19.480040] PGD 3fb00067 PUD 79d51067 PMD 0
[   19.480040] Oops: 0000 [#2] SMP
[   19.480040] Modules linked in: nf_conntrack_netbios_ns 
nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat iptable_mangle 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
ebtable_filter ebtables ip6table_filter ip6_tables vfat fat i2c_piix4 
i2c_core virtio_net microcode
[   19.480040] CPU 0
[   19.480040] Pid: 775, comm: cat Tainted: G      D W 
3.6.11-3.fc18.x86_64 #1
[   19.480040] RIP: 0010:[<ffffffff8117b543>]  [<ffffffff8117b543>] 
kmem_cache_alloc_trace+0x63/0x160
[   19.480040] RSP: 0018:ffff880077fd19c8  EFLAGS: 00010246
[   19.480040] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
0000000000000000
[   19.480040] RDX: 000000000000e97e RSI: 00000000000080d0 RDI: 
ffff88007d402d00
[   19.480040] RBP: ffff880077fd1a18 R08: 0000000000016ae0 R09: 
ffffffff812df6ec
[   19.480040] R10: 0000000000002580 R11: 66386366632d3536 R12: 
0000000000000100
[   19.480040] R13: 00000000000080d0 R14: 0000000000000908 R15: 
ffff88007d402d00
[   19.480040] FS:  00007fa220298740(0000) GS:ffff88007d800000(0000) 
knlGS:0000000000000000
[   19.480040] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   19.480040] CR2: 0000000000000100 CR3: 0000000079286000 CR4: 
00000000000406f0
[   19.480040] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   19.480040] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   19.480040] Process cat (pid: 775, threadinfo ffff880077fd0000, task 
ffff88007e84ae20)
[   19.480040] Stack:
[   19.480040]  ffff880077fd19d8 ffffffff81201a62 ffffffff812df6ec 
ffffffff81201b36
[   19.480040]  ffff880077fd1a48 0000000000000000 0000000000000000 
ffff88007f459840
[   19.480040]  0000000000000000 ffff88007f570960 ffff880077fd1ab8 
ffffffff812df6ec
[   19.480040] Call Trace:
[   19.480040]  [<ffffffff81201a62>] ? sysfs_add_file+0x12/0x20
[   19.480040]  [<ffffffff812df6ec>] ? kobject_uevent_env+0x14c/0x610
[   19.480040]  [<ffffffff81201b36>] ? sysfs_create_file+0x26/0x30
[   19.480040]  [<ffffffff812df6ec>] kobject_uevent_env+0x14c/0x610
[   19.480040]  [<ffffffff812dee63>] ? kobject_init_and_add+0x63/0x90
[   19.480040]  [<ffffffff812dfbbb>] kobject_uevent+0xb/0x10
[   19.480040]  [<ffffffff814d58d2>] efivar_create_sysfs_entry+0x132/0x1b0
[   19.480040]  [<ffffffff814d5c83>] efi_pstore_write+0x333/0x3a0
[   19.480040]  [<ffffffff8105dc5e>] ? kmsg_dump_get_buffer+0x24e/0x2b0
[   19.480040]  [<ffffffff8126caec>] pstore_dump+0x12c/0x1f0
[   19.480040]  [<ffffffff8106017c>] kmsg_dump+0x9c/0xc0
[   19.480040]  [<ffffffff8105ca09>] oops_exit+0x29/0x30
[   19.480040]  [<ffffffff81624e72>] oops_end+0x72/0xe0
[   19.480040]  [<ffffffff810177d8>] die+0x58/0x90
[   19.480040]  [<ffffffff816249a2>] do_general_protection+0x162/0x170
[   19.480040]  [<ffffffff816242b5>] general_protection+0x25/0x30
[   19.480040]  [<ffffffff814d5664>] ? efivarfs_file_write+0x134/0x270
[   19.480040]  [<ffffffff814d5641>] ? efivarfs_file_write+0x111/0x270
[   19.480040]  [<ffffffff811908cc>] vfs_write+0xac/0x180
[   19.480040]  [<ffffffff81190bfa>] sys_write+0x4a/0x90
[   19.480040]  [<ffffffff8162bd69>] system_call_fastpath+0x16/0x1b
[   19.480040] Code: 4c 8b 4d c0 4d 8b 07 65 4c 03 04 25 c8 db 00 00 49 
8b 50 08 4d 8b 20 4d 85 e4 0f 84 9d 00 00 00 49 63 47 20 4d 8b 07 41 f6 
c0 0f <49> 8b 1c 04 0f 85 c7 00 00 00 48 8d 4a 01 4c 89 e0 65 49 0f c7
[   19.480040] RIP  [<ffffffff8117b543>] kmem_cache_alloc_trace+0x63/0x160
[   19.480040]  RSP <ffff880077fd19c8>
[   19.480040] CR2: 0000000000000100
[   19.539320] ---[ end trace 969a2b2b14764a39 ]---
(Kernel hangs)

--
Lingzhu Xiang
