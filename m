From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/20] efi: Add support for a UEFI variable filesystem
Date: Fri, 21 Dec 2012 13:54:29 +0800
Message-ID: <50D3F995.5000705@redhat.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org> <1351237923-10313-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/26/2012 03:51 PM, Matt Fleming wrote:
> +static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +	struct efivar_entry *var = dentry->d_inode->i_private;
> +	struct efivars *efivars = var->efivars;
> +	efi_status_t status;
> +
> +	spin_lock(&efivars->lock);
> +
> +	status = efivars->ops->set_variable(var->var.VariableName,
> +					&var->var.VendorGuid,
> +					    0, 0, NULL);
> +
> +	if (status == EFI_SUCCESS || status == EFI_NOT_FOUND) {
> +		list_del(&var->list);
> +		spin_unlock(&efivars->lock);
> +		efivar_unregister(var);
> +		drop_nlink(dir);

This should be  drop_nlink(dentry->d_inode);

I'm getting warnings when testing Fedora 18 kernel with efivarfs patch
backported. i_nlink underflowed.

[root@localhost ~]# mount -t efivarfs - /sys/firmware/efi/efivars/
[root@localhost ~]# ls -1 /sys/firmware/efi/efivars/ | wc -l
28
[root@localhost ~]# stat -c%h /sys/firmware/efi/efivars/
2
[root@localhost ~]# rm -f /sys/firmware/efi/efivars/*
[   41.690805] ------------[ cut here ]------------
[   41.692975] WARNING: at fs/inode.c:280 drop_nlink+0x46/0x50()
[   41.694546] Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables iptable_nat nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack vfat fat i2c_piix4 i2c_core microcode virtio_net
[   41.701583] Pid: 822, comm: rm Tainted: G        W    3.6.11-3.fc18.x86_64.debug #1
[   41.703008] Call Trace:
[   41.703499]  [<ffffffff8106781f>] warn_slowpath_common+0x7f/0xc0
[   41.704591]  [<ffffffff8106787a>] warn_slowpath_null+0x1a/0x20
[   41.705777]  [<ffffffff811eb266>] drop_nlink+0x46/0x50
[   41.706855]  [<ffffffff81553fca>] efivarfs_unlink+0x8a/0xd0
[   41.707952]  [<ffffffff811dd75e>] vfs_unlink+0x9e/0x110
[   41.710800]  [<ffffffff811dd90d>] do_unlinkat+0x13d/0x1a0
[   41.712096]  [<ffffffff810d6b6d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[   41.713808]  [<ffffffff8110181c>] ? __audit_syscall_entry+0xcc/0x300
[   41.714983]  [<ffffffff8134f50e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   41.716548]  [<ffffffff811e025b>] sys_unlinkat+0x1b/0x50
[   41.717694]  [<ffffffff816e7fe9>] system_call_fastpath+0x16/0x1b
[   41.718995] ---[ end trace 33f799b901d1db9e ]---
[root@localhost ~]# ls -1 /sys/firmware/efi/efivars/ | wc -l
15
[root@localhost ~]# stat -c%h /sys/firmware/efi/efivars/
4294967285


> +		dput(dentry);
> +		return 0;
> +	}
