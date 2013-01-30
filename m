From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC,PATCH] efivarfs: Don't delete efivar_entry structures on
 unlink
Date: Wed, 30 Jan 2013 16:55:29 +0800
Message-ID: <5108E001.2010005@redhat.com>
References: <1359240720.964087.170020751085.1.gpush@pororo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359240720.964087.170020751085.1.gpush@pororo>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/27/2013 06:52 AM, Jeremy Kerr wrote:
> @@ -1221,8 +1290,10 @@ static int efi_pstore_write(enum pstore_type_id type,
>   					   0, NULL);
>   	}
>   
> -	if (found)
> -		list_del(&found->list);
> +	if (found) {
> +		list_del_init(&found->list);
> +		efivar_entry_put(found);
> +	}
>   
>   	for (i = 0; i < DUMP_NAME_LEN; i++)
>   		efi_name[i] = name[i];

Can't apply against mainline. This part has been removed in commit
96480d9c.

I verify that the open-unlink bug is fixed with this patch (without
the above part) and 3.8-rc5. But now I'm getting extra call traces.

At boot time:
[    0.808347] EFI Variables Facility v0.08 2004-May-17
[    0.809848] ------------[ cut here ]------------
[    0.811048] WARNING: at include/linux/kref.h:42 efivar_create_sysfs_entry+0x1d1/0x1e0()
[    0.813203] Modules linked in:
[    0.813958] Pid: 1, comm: swapper/0 Not tainted 3.8.0-0.rc5.git1.1.efivarfs.open.unlink.fc18.x86_64 #1
[    0.816501] Call Trace:
[    0.817143]  [<ffffffff8105eddf>] warn_slowpath_common+0x7f/0xc0
[    0.818472]  [<ffffffff8105ee3a>] warn_slowpath_null+0x1a/0x20
[    0.819720]  [<ffffffff81545ef1>] efivar_create_sysfs_entry+0x1d1/0x1e0
[    0.821209]  [<ffffffff815464ae>] register_efivars+0xee/0x3b0
[    0.822441]  [<ffffffff81d5970c>] ? dmi_sysfs_register_handle+0x1c0/0x1c0
[    0.823886]  [<ffffffff81d597c6>] efivars_init+0xba/0x108
[    0.825046]  [<ffffffff8100215a>] do_one_initcall+0x12a/0x180
[    0.826273]  [<ffffffff81d1bdbe>] kernel_init_freeable+0x154/0x1de
[    0.827551]  [<ffffffff81d1b614>] ? do_early_param+0x8c/0x8c
[    0.828754]  [<ffffffff816ad600>] ? rest_init+0x140/0x140
[    0.829895]  [<ffffffff816ad60e>] kernel_init+0xe/0xf0
[    0.830991]  [<ffffffff816d47ec>] ret_from_fork+0x7c/0xb0
[    0.832139]  [<ffffffff816ad600>] ? rest_init+0x140/0x140
[    0.833307] ---[ end trace 7f6e14e7c9c8160e ]---
(repeat for each variable)

Later:
[root@qemu-ovmf ~]# umount /sys/firmware/efi/efivars/
[   31.794457] BUG: unable to handle kernel NULL pointer dereference at 000000000000082c
[   31.795025] IP: [<ffffffff81544695>] efivar_entry_put+0x5/0x30
[   31.795025] PGD 0
[   31.795025] Oops: 0002 [#1] SMP
[   31.795025] Modules linked in: vfat fat crc32c_intel ppdev parport_pc i2c_piix4 parport i2c_core virtio_net microcode
[   31.795025] CPU 7
[   31.795025] Pid: 615, comm: umount Tainted: G        W    3.8.0-0.rc5.git1.1.efivarfs.open.unlink.fc18.x86_64 #1
[   31.795025] RIP: 0010:[<ffffffff81544695>]  [<ffffffff81544695>] efivar_entry_put+0x5/0x30
[   31.795025] RSP: 0018:ffff88021253dd30  EFLAGS: 00010292
[   31.795025] RAX: ffffffff81544700 RBX: ffff880212ef6a90 RCX: 0000000000000034
[   31.795025] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
[   31.795025] RBP: ffff88021253dd48 R08: c038000000000000 R09: 0000000000000002
[   31.795025] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880212ef6c28
[   31.795025] R13: ffffffff8187b920 R14: ffffffff8187b920 R15: ffff880214076680
[   31.795025] FS:  00007ff23e7f9840(0000) GS:ffff88021fce0000(0000) knlGS:0000000000000000
[   31.795025] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   31.795025] CR2: 000000000000082c CR3: 00000001fe835000 CR4: 00000000000007e0
[   31.795025] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   31.795025] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   31.795025] Process umount (pid: 615, threadinfo ffff88021253c000, task ffff8802125fc2a0)
[   31.795025] Stack:
[   31.795025]  ffffffff8154471d ffff880212ef6a90 ffff880212ef6a90 ffff88021253dd78
[   31.795025]  ffffffff811dacf7 ffff88021253dd78 ffff880212ef6a90 ffff880212ef6b18
[   31.795025]  ffff88020fb1c0f8 ffff88021253dda8 ffffffff811db4f5 ffff880212f17180
[   31.795025] Call Trace:
[   31.795025]  [<ffffffff8154471d>] ? efivarfs_evict_inode+0x1d/0x30
[   31.795025]  [<ffffffff811dacf7>] evict+0xa7/0x1a0
[   31.795025]  [<ffffffff811db4f5>] iput+0x105/0x190
[   31.795025]  [<ffffffff811d55c1>] shrink_dcache_for_umount_subtree+0x111/0x190
[   31.795025]  [<ffffffff816cb4db>] ? _raw_spin_unlock+0x2b/0x40
[   31.795025]  [<ffffffff811d7e03>] shrink_dcache_for_umount+0x33/0x60
[   31.795025]  [<ffffffff811c132c>] generic_shutdown_super+0x2c/0xf0
[   31.795025]  [<ffffffff811c1486>] kill_anon_super+0x16/0x30
[   31.795025]  [<ffffffff811c14c7>] kill_litter_super+0x27/0x30
[   31.795025]  [<ffffffff81543fde>] efivarfs_kill_sb+0xe/0x20
[   31.795025]  [<ffffffff811c18b7>] deactivate_locked_super+0x57/0x80
[   31.795025]  [<ffffffff811c24fe>] deactivate_super+0x4e/0x70
[   31.795025]  [<ffffffff811e1827>] mntput_no_expire+0xd7/0x130
[   31.795025]  [<ffffffff811e2706>] sys_umount+0x76/0x3a0
[   31.795025]  [<ffffffff816d4899>] system_call_fastpath+0x16/0x1b
[   31.795025] Code: 43 20 00 ba 87 81 48 c7 83 d0 01 00 00 00 8a 81 81 48 89 df e8 7d 4f c9 ff 48 89 d8 5b 41 5c 5d c3 0f 1f 44 00 00 66 66 66 66 90 <f0> 83 af 2c 08 00 00 01 0f 94 c0 84 c0 75 0c f3 c3 66 2e 0f 1f
[   31.795025] RIP  [<ffffffff81544695>] efivar_entry_put+0x5/0x30
[   31.795025]  RSP <ffff88021253dd30>
[   31.795025] CR2: 000000000000082c
[   31.876930] ---[ end trace 01acf8f410487409 ]---
Killed
