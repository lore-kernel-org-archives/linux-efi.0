From: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: [efi:next 15/19] fs/efivarfs/super.c:180:7-11: ERROR: reference
 preceded by free on line 162
Date: Tue, 9 Aug 2016 14:02:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1608091401570.2911@hadrien>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Possibility of a double free.

julia

---------- Forwarded message ----------
Date: Tue, 9 Aug 2016 19:58:20 +0800
From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
To: kbuild-JC7UmRfGjtg@public.gmane.org
Cc: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: [efi:next 15/19] fs/efivarfs/super.c:180:7-11: ERROR: reference
    preceded by free on line 162

CC: kbuild-all-JC7UmRfGjtg@public.gmane.org
CC: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
TO: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
CC: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next
head:   302c675f2c1f6a2426709695d6dfe8683cfc7bab
commit: 0d22f33bc37ce1c9f10dd304bd335d6feb7796d1 [15/19] efi: Don't use spinlocks for efi vars
:::::: branch date: 4 days ago
:::::: commit date: 2 weeks ago

>> fs/efivarfs/super.c:180:7-11: ERROR: reference preceded by free on line 162

git remote add efi https://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
git remote update efi
git checkout 0d22f33bc37ce1c9f10dd304bd335d6feb7796d1
vim +180 fs/efivarfs/super.c

d68772b7 Matt Fleming     2013-02-08  156  	if (IS_ERR(dentry)) {
d68772b7 Matt Fleming     2013-02-08  157  		err = PTR_ERR(dentry);
d68772b7 Matt Fleming     2013-02-08  158  		goto fail_inode;
d68772b7 Matt Fleming     2013-02-08  159  	}
d68772b7 Matt Fleming     2013-02-08  160
d68772b7 Matt Fleming     2013-02-08  161  	/* copied by the above to local storage in the dentry. */
d68772b7 Matt Fleming     2013-02-08 @162  	kfree(name);
d68772b7 Matt Fleming     2013-02-08  163
d68772b7 Matt Fleming     2013-02-08  164  	efivar_entry_size(entry, &size);
0d22f33b Sylvain Chouleur 2016-07-15  165  	err = efivar_entry_add(entry, &efivarfs_list);
0d22f33b Sylvain Chouleur 2016-07-15  166  	if (err)
0d22f33b Sylvain Chouleur 2016-07-15  167  		goto fail_inode;
d68772b7 Matt Fleming     2013-02-08  168
5955102c Al Viro          2016-01-22  169  	inode_lock(inode);
d68772b7 Matt Fleming     2013-02-08  170  	inode->i_private = entry;
d68772b7 Matt Fleming     2013-02-08  171  	i_size_write(inode, size + sizeof(entry->var.Attributes));
5955102c Al Viro          2016-01-22  172  	inode_unlock(inode);
d68772b7 Matt Fleming     2013-02-08  173  	d_add(dentry, inode);
d68772b7 Matt Fleming     2013-02-08  174
d68772b7 Matt Fleming     2013-02-08  175  	return 0;
d68772b7 Matt Fleming     2013-02-08  176
d68772b7 Matt Fleming     2013-02-08  177  fail_inode:
d68772b7 Matt Fleming     2013-02-08  178  	iput(inode);
d68772b7 Matt Fleming     2013-02-08  179  fail_name:
d68772b7 Matt Fleming     2013-02-08 @180  	kfree(name);
d68772b7 Matt Fleming     2013-02-08  181  fail:
d68772b7 Matt Fleming     2013-02-08  182  	kfree(entry);
d68772b7 Matt Fleming     2013-02-08  183  	return err;

:::::: The code at line 180 was first introduced by commit
:::::: d68772b7c83f4b518be15ae96f4827c8ed02f684 efivarfs: Move to fs/efivarfs

:::::: TO: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
:::::: CC: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
