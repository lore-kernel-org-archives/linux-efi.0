From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2] efivarfs: 'efivarfs_file_write' function
 reorganization
Date: Fri, 8 Nov 2013 15:29:44 +0000
Message-ID: <20131108152944.GC22636@console-pimps.org>
References: <1383159461-29668-1-git-send-email-geyslan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1383159461-29668-1-git-send-email-geyslan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Geyslan G. Bem" <geyslan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: kernel-br-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "open list:EFI VARIABLE FILE..." <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 30 Oct, at 03:57:41PM, Geyslan G. Bem wrote:
> This reorganization:
> 
> Removes useless 'bytes' prior assignment.
> 
> Uses 'memdup_user' instead 'kmalloc' + 'copy_from_user'.
> 
> Signed-off-by: Geyslan G. Bem <geyslan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/efivarfs/file.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)

Thanks, this is what I applied,

---

>From 00ad8da13638dba692eaa58b0cba25f3f1a801b1 Mon Sep 17 00:00:00 2001
From: "Geyslan G. Bem" <geyslan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Wed, 30 Oct 2013 15:57:41 -0300
Subject: [PATCH] efivarfs: 'efivarfs_file_write' function reorganization

This reorganization removes useless 'bytes' prior assignment and uses
'memdup_user' instead 'kmalloc' + 'copy_from_user'.

Signed-off-by: Geyslan G. Bem <geyslan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 fs/efivarfs/file.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index 8dd524f32284..cdb2971192a5 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -21,7 +21,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 	u32 attributes;
 	struct inode *inode = file->f_mapping->host;
 	unsigned long datasize = count - sizeof(attributes);
-	ssize_t bytes = 0;
+	ssize_t bytes;
 	bool set = false;
 
 	if (count < sizeof(attributes))
@@ -33,14 +33,9 @@ static ssize_t efivarfs_file_write(struct file *file,
 	if (attributes & ~(EFI_VARIABLE_MASK))
 		return -EINVAL;
 
-	data = kmalloc(datasize, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	if (copy_from_user(data, userbuf + sizeof(attributes), datasize)) {
-		bytes = -EFAULT;
-		goto out;
-	}
+	data = memdup_user(userbuf + sizeof(attributes), datasize);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
 
 	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
 					  data, &set);
-- 
1.8.1.4

-- 
Matt Fleming, Intel Open Source Technology Center
