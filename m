From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Date: Fri, 5 Sep 2014 23:16:16 +0100
Message-ID: <20140905221616.GP3001@console-pimps.org>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
 <20140904100137.GK3001@console-pimps.org>
 <5408D299.5000300@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5408D299.5000300-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 04 Sep, at 01:59:05PM, H. Peter Anvin wrote:
>=20
> I am fine with this patch, but at the same time I do want to note tha=
t
> there is an alternative to double-buffer the patch and/or (if that
> applies to the buggy BIOS) round up the size of the target buffer.

I took a whack at the double-buffer strategy, and I think the patch is
conceptually pretty straight forward.

Could someone try out the following patch? It works around the problem
on my ASUS machine.

---

=46rom 89e7fdaeb04f79d9834678e486215974986d4ac8 Mon Sep 17 00:00:00 200=
1
=46rom: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Fri, 5 Sep 2014 23:15:11 +0100
Subject: [PATCH] x86/efi: Workaround firmware bug with double-buffer re=
ad
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
loaded above 4G"), the kernel freezes at the earliest possible moment
when trying to boot via UEFI on Asus laptop.

The cause of the freeze appears to be a firmware bug when reading file
data into buffers above 4GB, though the exact reason is unknown.  Manta=
s
reports that the hang can be avoided if the file size is a multiple of
512 bytes, but I've seen some ASUS firmware simply corrupting the file
data rather than freezing.

Since the bug has only been reported when reading into a buffer above
4GB, we can workaround the problem by doing a double-buffer read, where
we read a partial file chunk into a buffer < 4GB then copy it to the
buffer (potentially) above 4GB.

Laszlo fixed an issue in the upstream EDK2 DiskIO code in Aug 2013 whic=
h
may possibly be related, commit 4e39b75e ("MdeModulePkg/DiskIoDxe: fix
source/destination pointer of overrun transfer"). Whatever the cause,
it's unlikely that a fix will be forthcoming from the vendor, hence the
workaround.

Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 28 ++++++++++++++++++=
++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/f=
irmware/efi/libstub/efi-stub-helper.c
index 32d5cca30f49..470793ce2617 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -297,6 +297,7 @@ efi_status_t handle_cmdline_files(efi_system_table_=
t *sys_table_arg,
 {
 	struct file_info *files;
 	unsigned long file_addr;
+	unsigned long chunkbuf;
 	u64 file_size_total;
 	efi_file_handle_t *fh =3D NULL;
 	efi_status_t status;
@@ -416,6 +417,24 @@ efi_status_t handle_cmdline_files(efi_system_table=
_t *sys_table_arg,
 			goto free_file_total;
 		}
=20
+		/*
+		 * Allocate a bounce buffer below 4GB.
+		 *
+		 * Some firmware implementations cannot perform file
+		 * reads into buffers above 4G and at best corrupt the
+		 * buffer, at worst they hang completely.
+		 *
+		 * Pass chunkbuf to the firmware to perform reads in
+		 * chunksize bytes and copy them to the target buffer
+		 * 'file_addr'.
+		 */
+		status =3D efi_high_alloc(sys_table_arg, EFI_READ_CHUNK_SIZE,
+					0x1000, &chunkbuf, 0xffffffff);
+		if (status !=3D EFI_SUCCESS) {
+			pr_efi_err(sys_table_arg, "Failed to alloc file chunk buffer\n");
+			goto free_chunk;
+		}
+
 		addr =3D file_addr;
 		for (j =3D 0; j < nr_files; j++) {
 			unsigned long size;
@@ -430,11 +449,13 @@ efi_status_t handle_cmdline_files(efi_system_tabl=
e_t *sys_table_arg,
=20
 				status =3D efi_file_read(files[j].handle,
 						       &chunksize,
-						       (void *)addr);
+						       (void *)chunkbuf);
 				if (status !=3D EFI_SUCCESS) {
 					pr_efi_err(sys_table_arg, "Failed to read file\n");
-					goto free_file_total;
+					goto free_chunk;
 				}
+
+				memcpy((void *)addr, (void *)chunkbuf, chunksize);
 				addr +=3D chunksize;
 				size -=3D chunksize;
 			}
@@ -442,6 +463,7 @@ efi_status_t handle_cmdline_files(efi_system_table_=
t *sys_table_arg,
 			efi_file_close(files[j].handle);
 		}
=20
+		efi_free(sys_table_arg, EFI_READ_CHUNK_SIZE, chunkbuf);
 	}
=20
 	efi_call_early(free_pool, files);
@@ -451,6 +473,8 @@ efi_status_t handle_cmdline_files(efi_system_table_=
t *sys_table_arg,
=20
 	return status;
=20
+free_chunk:
+	efi_free(sys_table_arg, EFI_READ_CHUNK_SIZE, chunkbuf);
 free_file_total:
 	efi_free(sys_table_arg, file_size_total, file_addr);
=20
--=20
1.9.3

--=20
Matt Fleming, Intel Open Source Technology Center
