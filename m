From: Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memory corruption caused by efi driver?
Date: Sun, 25 Jun 2017 21:06:58 +0800
Message-ID: <594FB572.4000506@huawei.com>
References: <9372b781-62ed-fcad-6306-42a0da1a37ca@huawei.com> <20170624111205.GA16218@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170624111205.GA16218-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hanjun Guo <guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2017/6/24 19:12, Greg KH wrote:

> On Sat, Jun 24, 2017 at 05:52:23PM +0800, Yisheng Xie wrote:
>> hi all,
>>
>> I met an Oops problem with linux-3.10. The RIP is sysfs_open_file+0x46/0x2b0 (I will and the full
>> crash log in the end of this mail).
> 
> 3.10 is _very_ old and obsolete, can you duplicate this on a modern
> kernel, like 4.11?
> 
> thanks,
> 
> greg k-h
> 
> .
> 

Hi, if I disable CONFIG_EFI_VARS, it seems OK now.

And I cann't reproduce the problem on mainline(v4.12).

Here is my test, run some stress test, then
cat /sys/firmware/efi/efivars/*
or
cat /sys/firmware/efi/vars/*/*

1) 3.10, get warning
CONFIG_EFI_VARS=y
CONFIG_EFIVAR_FS=y

2) 3.10, get warning
CONFIG_EFI_VARS=y
CONFIG_EFIVAR_FS=n

3) 3.10, ok
CONFIG_EFI_VARS=n
CONFIG_EFIVAR_FS=y

4) mainline, ok
CONFIG_EFI_VARS=y
CONFIG_EFIVAR_FS=y

log:
[78872.389117] WARNING: at fs/sysfs/file.c:343 sysfs_open_file+0x222/0x2b0()
[78872.389118] missing sysfs attribute operations for kobject: (null)
[78872.389177] Modules linked in: gen_timer(OVE) tun zram(C) ext4 jbd2 mbcache loop regmap_i2c binfmt_misc scsi_transport_iscsi cfg80211 ip6t_rpfilter ip6t_REJECT ipt_REJECT xt_conntrack rfk
ill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter
 ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter ip_tables sg iTCO_wdt ipmi_devintf iTCO_ve
ndor_support vfat fat intel_powerclamp coretemp kvm_intel kvm nfsd crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ipmi_ssif aesni_intel lrw gf128mul auth_rpcgss glue_helper a
blk_helper i7core_edac nfs_acl cryptd lpc_ich pcspkr
[78872.389197]  ipmi_si i2c_i801 edac_core shpchp mfd_core lockd ipmi_msghandler acpi_cpufreq grace sunrpc uinput xfs libcrc32c sd_mod sr_mod crc_t10dif cdrom crct10dif_common ixgbe igb ahci
 mdio libahci ptp i2c_algo_bit pps_core libata i2c_core megaraid_sas dca dm_mirror dm_region_hash dm_log dm_mod [last unloaded: gen_timer]
[78872.389202] CPU: 52 PID: 28434 Comm: cat Tainted: G        WC OE  ----V-------   3.10.0-327.55.58.81.x86_64 #2
[78872.389204] Hardware name: HUAWEI TECHNOLOGIES CO.,LTD. Tecal RH5885 V2/CH91RGPUC, BIOS RGPUC-BIOS-V058 06/23/2013
[78872.389207]  ffff88200a61fc10 00000000df10e27d ffff88200a61fbc8 ffffffff8163ed14
[78872.389208]  ffff88200a61fc00 ffffffff8107b300 00000000fffffff3 ffff88103f6473a0
[78872.389209]  ffff8880236cb700 ffff88103f6473a0 ffff8860281d8838 ffff88200a61fc68
[78872.389210] Call Trace:
[78872.389224]  [<ffffffff8163ed14>] dump_stack+0x19/0x1b
[78872.389233]  [<ffffffff8107b300>] warn_slowpath_common+0x70/0xb0
[78872.389234]  [<ffffffff8107b39c>] warn_slowpath_fmt+0x5c/0x80
[78872.389236]  [<ffffffff8125f1d2>] sysfs_open_file+0x222/0x2b0
[78872.389242]  [<ffffffff811e0167>] do_dentry_open+0x1a7/0x2e0
[78872.389244]  [<ffffffff8125efb0>] ? sysfs_schedule_callback+0x1c0/0x1c0
[78872.389245]  [<ffffffff811e0399>] vfs_open+0x39/0x70
[78872.389251]  [<ffffffff811f183d>] do_last+0x1ed/0x12a0
[78872.389259]  [<ffffffff811c4ffe>] ? kmem_cache_alloc_trace+0x1ce/0x1f0
[78872.389261]  [<ffffffff811f29b2>] path_openat+0xc2/0x490
[78872.389267]  [<ffffffff8112786d>] ? call_rcu_sched+0x1d/0x20
[78872.389275]  [<ffffffff8118484d>] ? shmem_destroy_inode+0x2d/0x40
[78872.389281]  [<ffffffff811fe4c6>] ? evict+0x106/0x170
[78872.389283]  [<ffffffff811f417b>] do_filp_open+0x4b/0xb0
[78872.389286]  [<ffffffff81200d97>] ? __alloc_fd+0xa7/0x130
[78872.389290]  [<ffffffff811e1863>] do_sys_open+0xf3/0x1f0
[78872.389291]  [<ffffffff811e197e>] SyS_open+0x1e/0x20
[78872.389297]  [<ffffffff8164f109>] system_call_fastpath+0x16/0x1b
[78872.389298] ---[ end trace cbe34632be0fdedf ]---
[78872.390067] ------------[ cut here ]------------
