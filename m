From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: efivarfs allows non-canonical GUID and duplicate filenames
Date: Fri, 25 Jan 2013 15:01:43 +0800
Message-ID: <51022DD7.4010701@redhat.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org> <1351237923-10313-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/26/2012 03:51 PM, Matt Fleming wrote:
> +static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
> +{
> +	guid->b[0] = hex_to_bin(str[6]) << 4 | hex_to_bin(str[7]);
> +	guid->b[1] = hex_to_bin(str[4]) << 4 | hex_to_bin(str[5]);
> +	guid->b[2] = hex_to_bin(str[2]) << 4 | hex_to_bin(str[3]);
> +	guid->b[3] = hex_to_bin(str[0]) << 4 | hex_to_bin(str[1]);
> +	guid->b[4] = hex_to_bin(str[11]) << 4 | hex_to_bin(str[12]);
> +	guid->b[5] = hex_to_bin(str[9]) << 4 | hex_to_bin(str[10]);
> +	guid->b[6] = hex_to_bin(str[16]) << 4 | hex_to_bin(str[17]);
> +	guid->b[7] = hex_to_bin(str[14]) << 4 | hex_to_bin(str[15]);
> +	guid->b[8] = hex_to_bin(str[19]) << 4 | hex_to_bin(str[20]);
> +	guid->b[9] = hex_to_bin(str[21]) << 4 | hex_to_bin(str[22]);
> +	guid->b[10] = hex_to_bin(str[24]) << 4 | hex_to_bin(str[25]);
> +	guid->b[11] = hex_to_bin(str[26]) << 4 | hex_to_bin(str[27]);
> +	guid->b[12] = hex_to_bin(str[28]) << 4 | hex_to_bin(str[29]);
> +	guid->b[13] = hex_to_bin(str[30]) << 4 | hex_to_bin(str[31]);
> +	guid->b[14] = hex_to_bin(str[32]) << 4 | hex_to_bin(str[33]);
> +	guid->b[15] = hex_to_bin(str[34]) << 4 | hex_to_bin(str[35]);
> +}
> +
> +static int efivarfs_create(struct inode *dir, struct dentry *dentry,
> +			  umode_t mode, bool excl)
> +{
> +	struct inode *inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
> +	struct efivars *efivars = &__efivars;
> +	struct efivar_entry *var;
> +	int namelen, i = 0, err = 0;
> +
> +	if (dentry->d_name.len < 38)
> +		return -EINVAL;
> +
> +	if (!inode)
> +		return -ENOSPC;
> +
> +	var = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
> +
> +	if (!var)
> +		return -ENOMEM;
> +
> +	namelen = dentry->d_name.len - GUID_LEN;
> +
> +	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
> +			&var->var.VendorGuid);

efivarfs_hex_to_guid does not check filename validity. 

[root@qemu-ovmf efivars]# touch test-------------------------------------
[root@qemu-ovmf efivars]# ll test*
-rw-r--r--. 1 root root 0 Jan 25 14:57 test-------------------------------------
[root@qemu-ovmf efivars]# cd ..; umount efivars; mount -t efivarfs - efivars; cd -
/sys/firmware/efi/efivars
[root@qemu-ovmf efivars]# ll test*
-rw-r--r--. 1 root root 4 Jan 25 14:57 test-ffffffff-ffff-ffff-ffff-ffffffffffff

[root@qemu-ovmf efivars]# touch BootOrder-8BE4DF61-93CA-11D2-AA0D-00E098032B8C
[root@qemu-ovmf efivars]# ll BootOrder*
-rw-r--r--. 1 root root 12 Jan 25 14:49 BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c
-rw-r--r--. 1 root root  0 Jan 25 14:55 BootOrder-8BE4DF61-93CA-11D2-AA0D-00E098032B8C
[root@qemu-ovmf efivars]# cd ..; umount efivars; mount -t efivarfs - efivars; cd -
/sys/firmware/efi/efivars
[root@qemu-ovmf efivars]# ll BootOrder*
-rw-r--r--. 1 root root 12 Jan 25 14:56 BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c
-rw-r--r--. 1 root root 12 Jan 25 14:56 BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c


--
Lingzhu Xiang
