From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efivarfs: drop_nlink on the correct inode in
 efivarfs_unlink
Date: Sun, 27 Jan 2013 17:16:46 +0000
Message-ID: <1359307006.8282.4.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1359240549.15160.60199223209.1.gpush@pororo>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359240549.15160.60199223209.1.gpush@pororo>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sun, 2013-01-27 at 06:49 +0800, Jeremy Kerr wrote:
> Currently, we're calling drop_nlink on the directory, not the file
> inode.
> 
> Signed-off-by: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
> 
> ---
>  drivers/firmware/efivars.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks Jeremy, but I've already queued up the below patch from Lingzhu.
But I now realise that while I did send out a pull request with the
commit, I didn't put it on a public branch. So I've merged my urgent
queue of patches into master.

---

>From de5fe95587b4dcc86cc451fce2909dfa504fce10 Mon Sep 17 00:00:00 2001
From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Sat, 5 Jan 2013 13:59:52 +0800
Subject: [PATCH] efivarfs: Drop link count of the right inode

efivarfs_unlink() should drop the file's link count, not the directory's.

Signed-off-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7b1c374..fa9fa03 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -994,7 +994,7 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 		list_del(&var->list);
 		spin_unlock(&efivars->lock);
 		efivar_unregister(var);
-		drop_nlink(dir);
+		drop_nlink(dentry->d_inode);
 		dput(dentry);
 		return 0;
 	}
-- 
1.7.11.7



-- 
Matt Fleming, Intel Open Source Technology Center
