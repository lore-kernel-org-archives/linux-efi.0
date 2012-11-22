From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: EFI pstore: BUG: scheduling while atomic, and possible circular locking
 dependency
Date: Thu, 22 Nov 2012 10:57:40 +0800
Message-ID: <50AD94A4.4030100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Anton Vorontsov <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Debug kernels generate such messages when doing EFI pstore read and write.

Kernel version ranges from 3.2 to 3.7-rc.

Always reproducible on QEMU/OVMF instances and a Thinkpad T520 laptop.

I hope this report helps.


mount pstore and crash
======================

[   83.504275] SysRq : Trigger a crash
[   83.505022] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   83.505022] IP: [<ffffffff81415d86>] sysrq_handle_crash+0x16/0x20
[   83.505022] PGD 9ea4067 PUD 9e1a067 PMD 0 
[   83.505022] Oops: 0002 [#1] SMP 
[   83.505022] Modules linked in: ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack vfat fat microcode virtio_net i2c_piix4 i2c_core
[   83.505022] CPU 2 
[   83.505022] Pid: 797, comm: bash Tainted: G        W    3.7.0-0.rc5.git2.1.fc19.x86_64 #1  
[   83.505022] RIP: 0010:[<ffffffff81415d86>]  [<ffffffff81415d86>] sysrq_handle_crash+0x16/0x20
[   83.505022] RSP: 0018:ffff88001a7abe28  EFLAGS: 00010096
[   83.505022] RAX: 000000000000000f RBX: ffffffff81cc28a0 RCX: 0000000000000000
[   83.505022] RDX: ffff880005182690 RSI: 0000000000000000 RDI: 0000000000000063
[   83.505022] RBP: ffff88001a7abe28 R08: 0000000000000001 R09: 0000000000000001
[   83.505022] R10: 0000000000000002 R11: 000000000000029c R12: 0000000000000063
[   83.505022] R13: 0000000000000282 R14: 0000000000000000 R15: 000000000000000a
[   83.505022] FS:  00007fa8d353a740(0000) GS:ffff88001b000000(0000) knlGS:0000000000000000
[   83.505022] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   83.505022] CR2: 0000000000000000 CR3: 0000000007fd3000 CR4: 00000000000406e0
[   83.505022] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   83.505022] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   83.505022] Process bash (pid: 797, threadinfo ffff88001a7aa000, task ffff880005182690)
[   83.505022] Stack:
[   83.505022]  ffff88001a7abe68 ffffffff81416547 ffff88001a7abe68 0000000000000002
[   83.505022]  ffff8800188aa940 ffffffff814165b0 ffff880016cde2b8 ffff88001a7abf50
[   83.505022]  ffff88001a7abe98 ffffffff814165fa ffff88001a7abe98 00007fa8d3541000
[   83.505022] Call Trace:
[   83.505022]  [<ffffffff81416547>] __handle_sysrq+0x127/0x190
[   83.505022]  [<ffffffff814165b0>] ? __handle_sysrq+0x190/0x190
[   83.505022]  [<ffffffff814165fa>] write_sysrq_trigger+0x4a/0x50
[   83.505022]  [<ffffffff81242770>] proc_reg_write+0x80/0xc0
[   83.505022]  [<ffffffff811d2eff>] vfs_write+0xaf/0x190
[   83.505022]  [<ffffffff811d3255>] sys_write+0x55/0xa0
[   83.505022]  [<ffffffff816fb8d9>] system_call_fastpath+0x16/0x1b
[   83.505022] Code: c1 f7 ff ff eb d8 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 66 66 66 66 90 55 c7 05 cc f4 cb 00 01 00 00 00 48 89 e5 0f ae f8 <c6> 04 25 00 00 00 00 01 5d c3 66 66 66 66 90 55 31 c0 48 89 e5 
[   83.505022] RIP  [<ffffffff81415d86>] sysrq_handle_crash+0x16/0x20
[   83.505022]  RSP <ffff88001a7abe28>
[   83.505022] CR2: 0000000000000000
[   83.505022] ---[ end trace b0c0c16a378b5fe5 ]---
[   83.505022] BUG: sleeping function called from invalid context at mm/slub.c:928
[   83.505022] in_atomic(): 1, irqs_disabled(): 1, pid: 797, name: bash
[   83.505022] INFO: lockdep is turned off.
[   83.505022] irq event stamp: 54760
[   83.505022] hardirqs last  enabled at (54759): [<ffffffff816f2858>] retint_swapgs+0x13/0x1b
[   83.505022] hardirqs last disabled at (54760): [<ffffffff816f2392>] _raw_spin_lock_irqsave+0x32/0xb0
[   83.505022] softirqs last  enabled at (54672): [<ffffffff81072977>] __do_softirq+0x167/0x3d0
[   83.505022] softirqs last disabled at (54655): [<ffffffff816fcb7c>] call_softirq+0x1c/0x30
[   83.505022] Pid: 797, comm: bash Tainted: G      D W    3.7.0-0.rc5.git2.1.fc19.x86_64 #1
[   83.505022] Call Trace:
[   83.505022]  [<ffffffff810d59a0>] ? print_irqtrace_events+0xd0/0xe0
[   83.505022]  [<ffffffff810a401d>] __might_sleep+0x18d/0x250
[   83.505022]  [<ffffffff811b9dc7>] __kmalloc+0x67/0x2d0
[   83.505022]  [<ffffffff8156375b>] ? efivar_create_sysfs_entry+0x3b/0x1b0
[   83.505022]  [<ffffffff8156375b>] efivar_create_sysfs_entry+0x3b/0x1b0
[   83.505022]  [<ffffffff81563c03>] efi_pstore_write+0x333/0x3a0
[   83.505022]  [<ffffffff8106a3fe>] ? kmsg_dump_get_buffer+0x24e/0x2b0
[   83.505022]  [<ffffffff812ca4c5>] ? pstore_dump+0x195/0x210
[   83.505022]  [<ffffffff812ca45f>] pstore_dump+0x12f/0x210
[   83.505022]  [<ffffffff8106c459>] kmsg_dump+0xf9/0x240
[   83.505022]  [<ffffffff8106c385>] ? kmsg_dump+0x25/0x240
[   83.505022]  [<ffffffff81068a49>] oops_exit+0x29/0x30
[   83.505022]  [<ffffffff816f37c3>] oops_end+0x73/0xe0
[   83.505022]  [<ffffffff816e48bf>] no_context+0x258/0x283
[   83.505022]  [<ffffffff816e4ab4>] __bad_area_nosemaphore+0x1ca/0x1e9
[   83.505022]  [<ffffffff816e4ae6>] bad_area_nosemaphore+0x13/0x15
[   83.505022]  [<ffffffff816f67ce>] __do_page_fault+0x2ae/0x580
[   83.505022]  [<ffffffff810d258d>] ? trace_hardirqs_off+0xd/0x10
[   83.505022]  [<ffffffff816f2257>] ? _raw_spin_unlock_irqrestore+0x77/0x80
[   83.505022]  [<ffffffff8106a97d>] ? console_unlock+0x1ed/0x4a0
[   83.505022]  [<ffffffff816f6aae>] do_page_fault+0xe/0x10
[   83.505022]  [<ffffffff816f6195>] do_async_page_fault+0x35/0xa0
[   83.505022]  [<ffffffff816f2b78>] async_page_fault+0x28/0x30
[   83.505022]  [<ffffffff81415d86>] ? sysrq_handle_crash+0x16/0x20
[   83.505022]  [<ffffffff81416547>] __handle_sysrq+0x127/0x190
[   83.505022]  [<ffffffff814165b0>] ? __handle_sysrq+0x190/0x190
[   83.505022]  [<ffffffff814165fa>] write_sysrq_trigger+0x4a/0x50
[   83.505022]  [<ffffffff81242770>] proc_reg_write+0x80/0xc0
[   83.505022]  [<ffffffff811d2eff>] vfs_write+0xaf/0x190
[   83.505022]  [<ffffffff811d3255>] sys_write+0x55/0xa0
[   83.505022]  [<ffffffff816fb8d9>] system_call_fastpath+0x16/0x1b
[   83.596022] BUG: scheduling while atomic: bash/797/0x10000004
[   83.596744] INFO: lockdep is turned off.
[   83.603006] Modules linked in: ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack vfat fat microcode virtio_net i2c_piix4 i2c_core
[   83.609408] Pid: 797, comm: bash Tainted: G      D W    3.7.0-0.rc5.git2.1.fc19.x86_64 #1
[   83.620001] Call Trace:
[   83.620461]  [<ffffffff816e570c>] __schedule_bug+0x68/0x76
[   83.621888]  [<ffffffff816f030e>] __schedule+0x99e/0xa00
[   83.623166]  [<ffffffff810a68ca>] __cond_resched+0x2a/0x40
[   83.624160]  [<ffffffff816f03ef>] _cond_resched+0x2f/0x40
[   83.625516]  [<ffffffff8116b510>] __alloc_pages_nodemask+0x2d0/0xb40
[   83.626721]  [<ffffffff816f228b>] ? _raw_spin_unlock+0x2b/0x50
[   83.627783]  [<ffffffff811b7fb7>] ? deactivate_slab+0x567/0x7d0
[   83.629012]  [<ffffffff8111efb7>] ? rcu_irq_exit+0x87/0xd0
[   83.629958]  [<ffffffff811ad3a0>] alloc_pages_current+0xb0/0x120
[   83.631013]  [<ffffffff811b7925>] ? new_slab+0x275/0x3a0
[   83.631878]  [<ffffffff811b7970>] new_slab+0x2c0/0x3a0
[   83.632752]  [<ffffffff816e8848>] __slab_alloc+0x3a2/0x58f
[   83.633697]  [<ffffffff8125492e>] ? sysfs_new_dirent+0x2e/0x130
[   83.634710]  [<ffffffff81254959>] ? sysfs_new_dirent+0x59/0x130
[   83.635719]  [<ffffffff810d1d64>] ? mutex_remove_waiter+0x44/0x120
[   83.636767]  [<ffffffff81254959>] ? sysfs_new_dirent+0x59/0x130
[   83.637767]  [<ffffffff811b9087>] kmem_cache_alloc+0x237/0x290
[   83.643006]  [<ffffffff81254959>] sysfs_new_dirent+0x59/0x130
[   83.644065]  [<ffffffff81254d0b>] ? sysfs_addrm_finish+0x1b/0x70
[   83.645256]  [<ffffffff81253b3b>] sysfs_add_file_mode+0x6b/0x110
[   83.646410]  [<ffffffff81253bf2>] sysfs_add_file+0x12/0x20
[   83.647485]  [<ffffffff81253cc6>] sysfs_create_file+0x26/0x30
[   83.653019]  [<ffffffff8134f13c>] kobject_add_internal+0x15c/0x270
[   83.654105]  [<ffffffff8134f643>] kobject_init_and_add+0x63/0x90
[   83.655228]  [<ffffffff81563844>] efivar_create_sysfs_entry+0x124/0x1b0
[   83.656753]  [<ffffffff81563c03>] efi_pstore_write+0x333/0x3a0
[   83.657932]  [<ffffffff8106a3fe>] ? kmsg_dump_get_buffer+0x24e/0x2b0
[   83.663008]  [<ffffffff812ca4c5>] ? pstore_dump+0x195/0x210
[   83.664032]  [<ffffffff812ca45f>] pstore_dump+0x12f/0x210
[   83.664993]  [<ffffffff8106c459>] kmsg_dump+0xf9/0x240
[   83.666077]  [<ffffffff8106c385>] ? kmsg_dump+0x25/0x240
[   83.667124]  [<ffffffff81068a49>] oops_exit+0x29/0x30
[   83.668147]  [<ffffffff816f37c3>] oops_end+0x73/0xe0
[   83.673005]  [<ffffffff816e48bf>] no_context+0x258/0x283
[   83.674916]  [<ffffffff816e4ab4>] __bad_area_nosemaphore+0x1ca/0x1e9
[   83.677798]  [<ffffffff816e4ae6>] bad_area_nosemaphore+0x13/0x15
[   83.680031]  [<ffffffff816f67ce>] __do_page_fault+0x2ae/0x580
[   83.681694]  [<ffffffff810d258d>] ? trace_hardirqs_off+0xd/0x10
[   83.691002]  [<ffffffff816f2257>] ? _raw_spin_unlock_irqrestore+0x77/0x80
[   83.692209]  [<ffffffff8106a97d>] ? console_unlock+0x1ed/0x4a0
[   83.693481]  [<ffffffff816f6aae>] do_page_fault+0xe/0x10
[   83.694577]  [<ffffffff816f6195>] do_async_page_fault+0x35/0xa0
[   83.695696]  [<ffffffff816f2b78>] async_page_fault+0x28/0x30
[   83.696676]  [<ffffffff81415d86>] ? sysrq_handle_crash+0x16/0x20
[   83.697674]  [<ffffffff81416547>] __handle_sysrq+0x127/0x190
[   83.699098]  [<ffffffff814165b0>] ? __handle_sysrq+0x190/0x190
[   83.700142]  [<ffffffff814165fa>] write_sysrq_trigger+0x4a/0x50
[   83.701284]  [<ffffffff81242770>] proc_reg_write+0x80/0xc0
[   83.710005]  [<ffffffff811d2eff>] vfs_write+0xaf/0x190
[   83.710998]  [<ffffffff811d3255>] sys_write+0x55/0xa0
[   83.711900]  [<ffffffff816fb8d9>] system_call_fastpath+0x16/0x1b

After reboot, mount pstore
==========================

[root@localhost ~]# mount -t pstore -o kmsg_bytes=8000 - /dev/pstore
[   36.502832] BUG: sleeping function called from invalid context at mm/slub.c:928
[   36.504379] in_atomic(): 1, irqs_disabled(): 0, pid: 851, name: mount
[   36.505652] 3 locks held by mount/851:
[   36.506355]  #0:  (&type->s_umount_key#38/1){+.+.+.}, at: [<ffffffff811d5aed>] sget+0x37d/0x640
[   36.508899]  #1:  (&psinfo->read_mutex){+.+.+.}, at: [<ffffffff812ca59b>] pstore_get_records+0x3b/0x130
[   36.510688]  #2:  (&(&efivars->lock)->rlock){+.+.+.}, at: [<ffffffff8156273d>] efi_pstore_open+0x1d/0x40
[   36.512468] Pid: 851, comm: mount Tainted: G        W    3.7.0-0.rc5.git2.1.fc19.x86_64 #1
[   36.514001] Call Trace:
[   36.514440]  [<ffffffff810a401d>] __might_sleep+0x18d/0x250
[   36.515634]  [<ffffffff811b9dc7>] __kmalloc+0x67/0x2d0
[   36.516509]  [<ffffffff81562103>] ? efi_pstore_read+0x1c3/0x220
[   36.517525]  [<ffffffff81562103>] efi_pstore_read+0x1c3/0x220
[   36.518507]  [<ffffffff812ca5f1>] pstore_get_records+0x91/0x130
[   36.519524]  [<ffffffff812eddfc>] ? selinux_d_instantiate+0x1c/0x20
[   36.520586]  [<ffffffff812c9c10>] ? pstore_get_inode+0x50/0x50
[   36.521566]  [<ffffffff812c9cb2>] pstore_fill_super+0xa2/0xc0
[   36.522542]  [<ffffffff811d6b42>] mount_single+0xb2/0xe0
[   36.523449]  [<ffffffff812c9a98>] pstore_mount+0x18/0x20
[   36.524322]  [<ffffffff811d6d63>] mount_fs+0x43/0x1b0
[   36.525360]  [<ffffffff811f4ee3>] vfs_kern_mount+0x73/0x110
[   36.526408]  [<ffffffff811f5984>] do_kern_mount+0x54/0x110
[   36.530014]  [<ffffffff811f7535>] do_mount+0x315/0x8e0
[   36.531181]  [<ffffffff811f708a>] ? copy_mount_options+0x3a/0x180
[   36.532390]  [<ffffffff811f7b8e>] sys_mount+0x8e/0xe0
[   36.533438]  [<ffffffff816fb8d9>] system_call_fastpath+0x16/0x1b
[   36.540017] BUG: scheduling while atomic: mount/851/0x10000002
[   36.541315] 3 locks held by mount/851:
[   36.541952]  #0:  (&type->s_umount_key#38/1){+.+.+.}, at: [<ffffffff811d5aed>] sget+0x37d/0x640
[   36.544260]  #1:  (&psinfo->read_mutex){+.+.+.}, at: [<ffffffff812ca59b>] pstore_get_records+0x3b/0x130
[   36.546146]  #2:  (&(&efivars->lock)->rlock){+.+.+.}, at: [<ffffffff8156273d>] efi_pstore_open+0x1d/0x40
[   36.547964] Modules linked in: ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack vfat fat microcode i2c_piix4 i2c_core virtio_net
[   36.560478] Pid: 851, comm: mount Tainted: G        W    3.7.0-0.rc5.git2.1.fc19.x86_64 #1
[   36.562019] Call Trace:
[   36.562655]  [<ffffffff816e570c>] __schedule_bug+0x68/0x76
[   36.570017]  [<ffffffff816f030e>] __schedule+0x99e/0xa00
[   36.570915]  [<ffffffff810a68ca>] __cond_resched+0x2a/0x40
[   36.571974]  [<ffffffff816f03ef>] _cond_resched+0x2f/0x40
[   36.573279]  [<ffffffff811b9dcc>] __kmalloc+0x6c/0x2d0
[   36.574642]  [<ffffffff81562103>] ? efi_pstore_read+0x1c3/0x220
[   36.576426]  [<ffffffff81562103>] efi_pstore_read+0x1c3/0x220
[   36.577679]  [<ffffffff812ca5f1>] pstore_get_records+0x91/0x130
[   36.578981]  [<ffffffff812eddfc>] ? selinux_d_instantiate+0x1c/0x20
[   36.585520]  [<ffffffff812c9c10>] ? pstore_get_inode+0x50/0x50
[   36.586595]  [<ffffffff812c9cb2>] pstore_fill_super+0xa2/0xc0
[   36.587648]  [<ffffffff811d6b42>] mount_single+0xb2/0xe0
[   36.588625]  [<ffffffff812c9a98>] pstore_mount+0x18/0x20
[   36.590078]  [<ffffffff811d6d63>] mount_fs+0x43/0x1b0
[   36.591511]  [<ffffffff811f4ee3>] vfs_kern_mount+0x73/0x110
[   36.592847]  [<ffffffff811f5984>] do_kern_mount+0x54/0x110
[   36.600017]  [<ffffffff811f7535>] do_mount+0x315/0x8e0
[   36.601128]  [<ffffffff811f708a>] ? copy_mount_options+0x3a/0x180
[   36.602257]  [<ffffffff811f7b8e>] sys_mount+0x8e/0xe0
[   36.603221]  [<ffffffff816fb8d9>] system_call_fastpath+0x16/0x1b

After reboot, rm a pstore entry
===============================

[root@localhost ~]# rm -f /dev/pstore/dmesg-efi-9
[   55.572466] 
[   55.572767] ======================================================
[   55.573015] [ INFO: possible circular locking dependency detected ]
[   55.573015] 3.7.0-0.rc5.git2.1.fc19.x86_64 #1 Tainted: G        W   
[   55.573015] -------------------------------------------------------
[   55.573015] rm/855 is trying to acquire lock:
[   55.573015]  (&(&efivars->lock)->rlock){+.+.+.}, at: [<ffffffff815639c5>] efi_pstore_write+0xf5/0x3a0
[   55.573015] 
[   55.573015] but task is already holding lock:
[   55.573015]  (&sb->s_type->i_mutex_key#15){+.+.+.}, at: [<ffffffff811e0a53>] vfs_unlink+0x53/0x110
[   55.573015] 
[   55.573015] which lock already depends on the new lock.
[   55.573015] 
[   55.573015] 
[   55.573015] the existing dependency chain (in reverse order) is:
[   55.573015] 
-> #1 (&sb->s_type->i_mutex_key#15){+.+.+.}:
[   55.573015]        [<ffffffff810d7ee1>] lock_acquire+0xa1/0x1f0
[   55.573015]        [<ffffffff816ee226>] mutex_lock_nested+0x76/0x390
[   55.573015]        [<ffffffff812ca0dc>] pstore_mkfile+0x1bc/0x390
[   55.573015]        [<ffffffff812ca621>] pstore_get_records+0xc1/0x130
[   55.573015]        [<ffffffff812c9cb2>] pstore_fill_super+0xa2/0xc0
[   55.573015]        [<ffffffff811d6b42>] mount_single+0xb2/0xe0
[   55.573015]        [<ffffffff812c9a98>] pstore_mount+0x18/0x20
[   55.573015]        [<ffffffff811d6d63>] mount_fs+0x43/0x1b0
[   55.573015]        [<ffffffff811f4ee3>] vfs_kern_mount+0x73/0x110
[   55.573015]        [<ffffffff811f5984>] do_kern_mount+0x54/0x110
[   55.573015]        [<ffffffff811f7535>] do_mount+0x315/0x8e0
[   55.573015]        [<ffffffff811f7b8e>] sys_mount+0x8e/0xe0
[   55.573015]        [<ffffffff816fb8d9>] system_call_fastpath+0x16/0x1b
[   55.573015] 
-> #0 (&(&efivars->lock)->rlock){+.+.+.}:
[   55.573015]        [<ffffffff810d775f>] __lock_acquire+0x1aff/0x1bb0
[   55.573015]        [<ffffffff810d7ee1>] lock_acquire+0xa1/0x1f0
[   55.573015]        [<ffffffff816f17a6>] _raw_spin_lock+0x46/0x80
[   55.573015]        [<ffffffff815639c5>] efi_pstore_write+0xf5/0x3a0
[   55.573015]        [<ffffffff81563c95>] efi_pstore_erase+0x25/0x30
[   55.573015]        [<ffffffff812c9adf>] pstore_unlink+0x3f/0x60
[   55.573015]        [<ffffffff811e0a9e>] vfs_unlink+0x9e/0x110
[   55.573015]        [<ffffffff811e0c11>] do_unlinkat+0x101/0x1b0
[   55.573015]        [<ffffffff811e368b>] sys_unlinkat+0x1b/0x40
[   55.573015]        [<ffffffff816fb8d9>] system_call_fastpath+0x16/0x1b
[   55.573015] 
[   55.573015] other info that might help us debug this:
[   55.573015] 
[   55.573015]  Possible unsafe locking scenario:
[   55.573015] 
[   55.573015]        CPU0                    CPU1
[   55.573015]        ----                    ----
[   55.573015]   lock(&sb->s_type->i_mutex_key#15);
[   55.573015]                                lock(&(&efivars->lock)->rlock);
[   55.573015]                                lock(&sb->s_type->i_mutex_key#15);
[   55.573015]   lock(&(&efivars->lock)->rlock);
[   55.573015] 
[   55.573015]  *** DEADLOCK ***
[   55.573015] 
[   55.573015] 3 locks held by rm/855:
[   55.573015]  #0:  (sb_writers#12){.+.+..}, at: [<ffffffff811f5c24>] mnt_want_write+0x24/0x50
[   55.573015]  #1:  (&sb->s_type->i_mutex_key#15/1){+.+...}, at: [<ffffffff811e0bbb>] do_unlinkat+0xab/0x1b0
[   55.573015]  #2:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at: [<ffffffff811e0a53>] vfs_unlink+0x53/0x110
[   55.573015] 
[   55.573015] stack backtrace:
[   55.573015] Pid: 855, comm: rm Tainted: G        W    3.7.0-0.rc5.git2.1.fc19.x86_64 #1
[   55.573015] Call Trace:
[   55.573015]  [<ffffffff816e608f>] print_circular_bug+0x1fb/0x20c
[   55.573015]  [<ffffffff810d775f>] __lock_acquire+0x1aff/0x1bb0
[   55.573015]  [<ffffffff81356bdb>] ? number.isra.2+0x35b/0x390
[   55.573015]  [<ffffffff810d7ee1>] lock_acquire+0xa1/0x1f0
[   55.573015]  [<ffffffff815639c5>] ? efi_pstore_write+0xf5/0x3a0
[   55.573015]  [<ffffffff816f17a6>] _raw_spin_lock+0x46/0x80
[   55.573015]  [<ffffffff815639c5>] ? efi_pstore_write+0xf5/0x3a0
[   55.573015]  [<ffffffff815639c5>] efi_pstore_write+0xf5/0x3a0
[   55.573015]  [<ffffffff810d258d>] ? trace_hardirqs_off+0xd/0x10
[   55.573015]  [<ffffffff810ace0f>] ? local_clock+0x6f/0x80
[   55.573015]  [<ffffffff810d2f0f>] ? lock_release_holdtime.part.26+0xf/0x180
[   55.573015]  [<ffffffff812e5ccb>] ? avc_has_perm_flags+0x17b/0x2c0
[   55.573015]  [<ffffffff812e5b79>] ? avc_has_perm_flags+0x29/0x2c0
[   55.573015]  [<ffffffff81563c95>] efi_pstore_erase+0x25/0x30
[   55.573015]  [<ffffffff812c9adf>] pstore_unlink+0x3f/0x60
[   55.573015]  [<ffffffff811e0a9e>] vfs_unlink+0x9e/0x110
[   55.573015]  [<ffffffff811e0c11>] do_unlinkat+0x101/0x1b0
[   55.573015]  [<ffffffff810d8a6d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[   55.573015]  [<ffffffff8110495c>] ? __audit_syscall_entry+0xcc/0x300
[   55.573015]  [<ffffffff8135a76e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   55.573015]  [<ffffffff811e368b>] sys_unlinkat+0x1b/0x40
[   55.573015]  [<ffffffff816fb8d9>] system_call_fastpath+0x16/0x1b


---
Lingzhu Xiang
