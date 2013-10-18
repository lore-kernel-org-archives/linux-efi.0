From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH v3] efivars,efi-pstore: Hold off deletion of sysfs entry
 until, the scan is completed
Date: Fri, 18 Oct 2013 22:30:58 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443F0F2D6@USINDEM103.corp.hds.com>
References: <52584373.3010202@hds.com>
 <20131017131821.GH10834@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131017131821.GH10834-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tomoki Sekiyama <tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Matt,

> It seems to me that because you're no longer dropping __efivars->lock
> when reading from the EFI variable store, you actually don't need all
> the ->scanning and ->deleting logic because anything that sets those
> flags runs to completion while holding the lock.

The scanning and deleting logic is still needed.
In case an entry(A) is found, the pointer is saved to psi->data.
And efi_pstore_read() passes the entry(A) to a pstore filesystem by releasing  __efivars->lock.

And then, the pstore filesystem calls efi_pstore_read() again and the same entry(A), which is saved to
psi->data, is used for re-scanning a sysfs-list.
(That is why list_for_each_entry_safe_from () is used in efi_pstore_sysfs_entry_iter().)

So, to protect the entry(A), the logic is needed because, in pstore filesystem,  __efivars->lock
Is released. 

> Can't the patch be simplified to just allocating data.buf at the
> beginning of efi_pstore_read()? 

I think data.buf is simply allocated at the beginning of efi_pstore_read() with this patch v3.
If you are not satisfied with it, could you please show me your pseudo code?

>Also, it would be a good idea to
> introduce a #define for the 1024 magic number, e.g.
> 
> #define EFIVARS_DATA_SIZE_MAX	1024

It is good idea. I can fix it.

Seiji

<snip>
+/**
+ * efi_pstore_read
+ *
+ * This function returns a size of NVRAM entry logged via efi_pstore_write().
+ * The meaning and behavior of efi_pstore/pstore are as below.
+ *
+ * size > 0: Got data of an entry logged via efi_pstore_write() successfully,
+ *           and pstore filesystem will continue reading subsequent entries.
+ * size == 0: Entry was not logged via efi_pstore_write(),
+ *            and efi_pstore driver will continue reading subsequent entries.
+ * size < 0: Failed to get data of entry logging via efi_pstore_write(),
+ *           and pstore will stop reading entry.
+ */
 static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 			       int *count, struct timespec *timespec,
 			       char **buf, bool *compressed,
 			       struct pstore_info *psi)
 {
 	struct pstore_read_data data;
+	ssize_t size;
 
 	data.id = id;
 	data.type = type;
@@ -112,8 +216,17 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	data.compressed = compressed;
 	data.buf = buf;
 
-	return __efivar_entry_iter(efi_pstore_read_func, &efivar_sysfs_list, &data,
-				   (struct efivar_entry **)&psi->data);
+	*data.buf = kzalloc(1024, GFP_KERNEL);
+	if (!*data.buf)
+		return -ENOMEM;
+
+	efivar_entry_iter_begin();
+	size = efi_pstore_sysfs_entry_iter(&data,
+					   (struct efivar_entry **)&psi->data);
+	efivar_entry_iter_end();
+	if (size <= 0)
+		kfree(*data.buf);
+	return size;
 }
<snip>
