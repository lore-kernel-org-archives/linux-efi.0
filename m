From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: EFI pstore: BUG: scheduling while atomic, and possible circular
 locking dependency
Date: Thu, 22 Nov 2012 15:32:25 +0800
Message-ID: <50ADD509.2060800@redhat.com>
References: <50AD94A4.4030100@redhat.com> <20121122041239.GA24623@lizard.sbx14280.paloaca.wayport.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121122041239.GA24623-SAfYLu58TvsVgZ49a2IoEzcLetGT9WKNKwcig+XE9tjR7s880joybQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 11/22/2012 12:12 PM, Anton Vorontsov wrote:
>> [   83.505022]  [<ffffffff810d59a0>] ? print_irqtrace_events+0xd0/0xe0
>> [   83.505022]  [<ffffffff810a401d>] __might_sleep+0x18d/0x250
>> [   83.505022]  [<ffffffff811b9dc7>] __kmalloc+0x67/0x2d0
>> [   83.505022]  [<ffffffff8156375b>] ? efivar_create_sysfs_entry+0x3b/0x1b0
>> [   83.505022]  [<ffffffff8156375b>] efivar_create_sysfs_entry+0x3b/0x1b0
> 
> efi_pstore_write calls create_sysfs_entry, which is obviosly unsafe from
> the dumper code, we're in the atomic context.
> 
>> [   83.505022]  [<ffffffff81563c03>] efi_pstore_write+0x333/0x3a0
>> [   83.505022]  [<ffffffff8106a3fe>] ? kmsg_dump_get_buffer+0x24e/0x2b0
>> [   83.505022]  [<ffffffff812ca4c5>] ? pstore_dump+0x195/0x210
>> [   83.505022]  [<ffffffff812ca45f>] pstore_dump+0x12f/0x210
>> [   83.505022]  [<ffffffff8106c459>] kmsg_dump+0xf9/0x240

With the previous patch, this backtrace disappears during crash.


>> After reboot, mount pstore
>> ==========================
>>
>> [root@localhost ~]# mount -t pstore -o kmsg_bytes=8000 - /dev/pstore
>> [   36.502832] BUG: sleeping function called from invalid context at mm/slub.c:928
>> [   36.504379] in_atomic(): 1, irqs_disabled(): 0, pid: 851, name: mount
>> [   36.505652] 3 locks held by mount/851:
>> [   36.506355]  #0:  (&type->s_umount_key#38/1){+.+.+.}, at: [<ffffffff811d5aed>] sget+0x37d/0x640
>> [   36.508899]  #1:  (&psinfo->read_mutex){+.+.+.}, at: [<ffffffff812ca59b>] pstore_get_records+0x3b/0x130
>> [   36.510688]  #2:  (&(&efivars->lock)->rlock){+.+.+.}, at: [<ffffffff8156273d>] efi_pstore_open+0x1d/0x40
>> [   36.512468] Pid: 851, comm: mount Tainted: G        W    3.7.0-0.rc5.git2.1.fc19.x86_64 #1
>> [   36.514001] Call Trace:
>> [   36.514440]  [<ffffffff810a401d>] __might_sleep+0x18d/0x250
>> [   36.515634]  [<ffffffff811b9dc7>] __kmalloc+0x67/0x2d0
>> [   36.516509]  [<ffffffff81562103>] ? efi_pstore_read+0x1c3/0x220
>> [   36.517525]  [<ffffffff81562103>] efi_pstore_read+0x1c3/0x220
>> [   36.518507]  [<ffffffff812ca5f1>] pstore_get_records+0x91/0x130
> 
> get_records() calls pinfo->open, which is efi_pstore_open, which grabs a
> spin_lock. Then efi_pstore_read tries to kmalloc things with GFP_KERNEL,
> which clearly a bug, since we're holding the spinlock.
> 
> The second issue is easy to fix, but the fix is not pretty: we must
> allocate buf with GFP_ATOMIC (the lock is required during ->read(), it
> protects efivars->list, so we can't simply drop it).
> 
> The first issue requires us to not create the sysfs entry (since it must
> be done in a non-atomic context). This makes pstore efi vars invisible via
> /sys/firmware/efi. :( If anyone wants to fix it, he'd have to "sync"
> efivars with sysfs thru a workqueue.

efi_pstore_read stops trying to kmalloc(GFP_KERNEL), but some others still do.

[   38.185217] BUG: sleeping function called from invalid context at mm/slub.c:930
[   38.186584] in_atomic(): 1, irqs_disabled(): 0, pid: 852, name: mount
[   38.187749] 3 locks held by mount/852:
[   38.188457]  #0:  (&type->s_umount_key#38/1){+.+.+.}, at: [<ffffffff811d0cce>] sget+0x3ae/0x670
[   38.190208]  #1:  (&psinfo->read_mutex){+.+.+.}, at: [<ffffffff812c060b>] pstore_get_records+0x3b/0x130
[   38.191956]  #2:  (&(&efivars->lock)->rlock){+.+.+.}, at: [<ffffffff8154e55d>] efi_pstore_open+0x1d/0x40
[   38.193790] Pid: 852, comm: mount Tainted: G        W    3.6.6-1.fc17.x86_64.debug #1
[   38.195162] Call Trace:
[   38.195606]  [<ffffffff810a2a1a>] __might_sleep+0x18a/0x240
[   38.196631]  [<ffffffff811b2497>] kmem_cache_alloc+0x47/0x290
[   38.197662]  [<ffffffff811ea621>] alloc_inode+0x61/0xa0
[   38.198615]  [<ffffffff811ec8aa>] new_inode_pseudo+0x1a/0x70
[   38.199687]  [<ffffffff811ec91d>] new_inode+0x1d/0x40
[   38.200658]  [<ffffffff812bfc43>] pstore_get_inode+0x13/0x50
[   38.201684]  [<ffffffff812c008b>] pstore_mkfile+0xfb/0x390
[   38.202619]  [<ffffffff812c0691>] pstore_get_records+0xc1/0x130
[   38.203690]  [<ffffffff812bfc80>] ? pstore_get_inode+0x50/0x50
[   38.204728]  [<ffffffff812bfd22>] pstore_fill_super+0xa2/0xc0
[   38.205754]  [<ffffffff811d1d22>] mount_single+0xb2/0xe0
[   38.206724]  [<ffffffff812bfb08>] pstore_mount+0x18/0x20
[   38.207695]  [<ffffffff811d1f43>] mount_fs+0x43/0x1b0
[   38.208619]  [<ffffffff811ef023>] vfs_kern_mount+0x73/0x110
[   38.209634]  [<ffffffff811efac4>] do_kern_mount+0x54/0x110
[   38.210633]  [<ffffffff811f1675>] do_mount+0x315/0x8e0
[   38.211561]  [<ffffffff811f11ca>] ? copy_mount_options+0x3a/0x180
[   38.212663]  [<ffffffff811f1ccd>] sys_mount+0x8d/0xe0
[   38.213591]  [<ffffffff816e2329>] system_call_fastpath+0x16/0x1b
[   38.214686] BUG: scheduling while atomic: mount/852/0x10000002
[   38.215782] 3 locks held by mount/852:
[   38.216483]  #0:  (&type->s_umount_key#38/1){+.+.+.}, at: [<ffffffff811d0cce>] sget+0x3ae/0x670
[   38.218182]  #1:  (&psinfo->read_mutex){+.+.+.}, at: [<ffffffff812c060b>] pstore_get_records+0x3b/0x130
[   38.219860]  #2:  (&(&efivars->lock)->rlock){+.+.+.}, at: [<ffffffff8154e55d>] efi_pstore_open+0x1d/0x40
[   38.221656] Modules linked in: ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables iptable_nat nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio libcxgbi ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi vfat fat microcode i2c_piix4 virtio_net i2c_core
[   38.230376] Pid: 852, comm: mount Tainted: G        W    3.6.6-1.fc17.x86_64.debug #1
[   38.231778] Call Trace:
[   38.233584]  [<ffffffff816cc82c>] __schedule_bug+0x67/0x75
[   38.234625]  [<ffffffff816d74cb>] __schedule+0x98b/0x9f0
[   38.235612]  [<ffffffff811ea621>] ? alloc_inode+0x61/0xa0
[   38.236848]  [<ffffffff810a520a>] __cond_resched+0x2a/0x40
[   38.238584]  [<ffffffff816d75b0>] _cond_resched+0x30/0x40
[   38.239696]  [<ffffffff811b249c>] kmem_cache_alloc+0x4c/0x290
[   38.240763]  [<ffffffff811ea621>] alloc_inode+0x61/0xa0
[   38.241721]  [<ffffffff811ec8aa>] new_inode_pseudo+0x1a/0x70
[   38.242741]  [<ffffffff811ec91d>] new_inode+0x1d/0x40
[   38.243679]  [<ffffffff812bfc43>] pstore_get_inode+0x13/0x50
[   38.244745]  [<ffffffff812c008b>] pstore_mkfile+0xfb/0x390
[   38.245751]  [<ffffffff812c0691>] pstore_get_records+0xc1/0x130
[   38.246833]  [<ffffffff812bfc80>] ? pstore_get_inode+0x50/0x50
[   38.247954]  [<ffffffff812bfd22>] pstore_fill_super+0xa2/0xc0
[   38.249006]  [<ffffffff811d1d22>] mount_single+0xb2/0xe0
[   38.253548]  [<ffffffff812bfb08>] pstore_mount+0x18/0x20
[   38.254571]  [<ffffffff811d1f43>] mount_fs+0x43/0x1b0
[   38.255504]  [<ffffffff811ef023>] vfs_kern_mount+0x73/0x110
[   38.256515]  [<ffffffff811efac4>] do_kern_mount+0x54/0x110
[   38.257539]  [<ffffffff811f1675>] do_mount+0x315/0x8e0
[   38.264673]  [<ffffffff811f11ca>] ? copy_mount_options+0x3a/0x180
[   38.265783]  [<ffffffff811f1ccd>] sys_mount+0x8d/0xe0
[   38.266714]  [<ffffffff816e2329>] system_call_fastpath+0x16/0x1b
[   38.268096] BUG: scheduling while atomic: mount/852/0x10000002
[   38.269169] 3 locks held by mount/852:
[   38.269841]  #0:  (&type->s_umount_key#38/1){+.+.+.}, at: [<ffffffff811d0cce>] sget+0x3ae/0x670
[   38.271546]  #1:  (&psinfo->read_mutex){+.+.+.}, at: [<ffffffff812c060b>] pstore_get_records+0x3b/0x130
[   38.273323]  #2:  (&(&efivars->lock)->rlock){+.+.+.}, at: [<ffffffff8154e55d>] efi_pstore_open+0x1d/0x40
[   38.275134] Modules linked in: ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables iptable_nat nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio libcxgbi ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi vfat fat microcode i2c_piix4 virtio_net i2c_core
[   38.283936] Pid: 852, comm: mount Tainted: G        W    3.6.6-1.fc17.x86_64.debug #1
[   38.285345] Call Trace:
[   38.285755]  [<ffffffff816cc82c>] __schedule_bug+0x67/0x75
[   38.286758]  [<ffffffff816d74cb>] __schedule+0x98b/0x9f0
[   38.287685]  [<ffffffff811ea621>] ? alloc_inode+0x61/0xa0
[   38.288672]  [<ffffffff810a520a>] __cond_resched+0x2a/0x40
[   38.289659]  [<ffffffff816d75b0>] _cond_resched+0x30/0x40
[   38.290632]  [<ffffffff811b249c>] kmem_cache_alloc+0x4c/0x290
[   38.291646]  [<ffffffff811ea621>] alloc_inode+0x61/0xa0
[   38.292579]  [<ffffffff811ec8aa>] new_inode_pseudo+0x1a/0x70
[   38.293591]  [<ffffffff811ec91d>] new_inode+0x1d/0x40
[   38.294510]  [<ffffffff812bfc43>] pstore_get_inode+0x13/0x50
[   38.295523]  [<ffffffff812c008b>] pstore_mkfile+0xfb/0x390
[   38.296519]  [<ffffffff812c0691>] pstore_get_records+0xc1/0x130
[   38.297583]  [<ffffffff812bfc80>] ? pstore_get_inode+0x50/0x50
[   38.298642]  [<ffffffff812bfd22>] pstore_fill_super+0xa2/0xc0
[   38.299675]  [<ffffffff811d1d22>] mount_single+0xb2/0xe0
[   38.300644]  [<ffffffff812bfb08>] pstore_mount+0x18/0x20
[   38.301603]  [<ffffffff811d1f43>] mount_fs+0x43/0x1b0
[   38.302519]  [<ffffffff811ef023>] vfs_kern_mount+0x73/0x110
[   38.303531]  [<ffffffff811efac4>] do_kern_mount+0x54/0x110
[   38.304470]  [<ffffffff811f1675>] do_mount+0x315/0x8e0
[   38.305390]  [<ffffffff811f11ca>] ? copy_mount_options+0x3a/0x180
[   38.306470]  [<ffffffff811f1ccd>] sys_mount+0x8d/0xe0
[   38.307368]  [<ffffffff816e2329>] system_call_fastpath+0x16/0x1b


>> After reboot, rm a pstore entry
>> ===============================
>>
>> [root@localhost ~]# rm -f /dev/pstore/dmesg-efi-9
>> [   55.572466]
>> [   55.572767] ======================================================
>> [   55.573015] [ INFO: possible circular locking dependency detected ]
>> [   55.573015] 3.7.0-0.rc5.git2.1.fc19.x86_64 #1 Tainted: G        W
> 
> I don't see an obvious problem, but let's solve the first two, and see if
> this will help, since the kernel was tainted already.

This info persists.
