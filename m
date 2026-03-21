Received: from sender-of-o53.zoho.eu (sender-of-o53.zoho.eu [136.143.169.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3102284B37;
	Sat, 21 Mar 2026 12:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094976; cv=pass; b=EF+an0ky+rPAW4SW8reYZnv1bk/qAlDDo53td1gBvJqo++gobQfQeMC9tYdOy74sVfyoRXq1e0W/wB6uqjc3hcQDNgWtmaygUhnJLNw8ftsxFMnv7kyBp49Gp4FopzhvkLd/35PltrmsyNhS7ab1wHqj+o99z8NlqdIQGOs4pkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094976; c=relaxed/simple;
	bh=aK6tzatDuFdZA2RiC418ni9p+LnHD9sOcxwbnGtY+mA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=lBJM5AOFi+IKYl3yXlCwpGn9pwtI4oCSzL81Dym2Ve5u+BwdV+gladLn4f693arjYAnoW8NqAFVkGY0RtDD7jbeRvgehZkFYQgXxb4Jga7meJ+aQ3Wrg2i431KZ5jBkXxnfjPQ8EFyxTiFxsmVS+3cxmR9zl4bonGKixt72TUDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=objecting.org; spf=pass smtp.mailfrom=objecting.org; dkim=pass (1024-bit key) header.d=objecting.org header.i=objecting@objecting.org header.b=Yw0njHO5; arc=pass smtp.client-ip=136.143.169.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=objecting.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=objecting.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=objecting.org header.i=objecting@objecting.org header.b="Yw0njHO5"
ARC-Seal: i=1; a=rsa-sha256; t=1774094919; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=b1ddv6e/oDW6bXp0oLSDw1hI/D4ezFUEP89d7ei0mUoZctMebEeARLe13UPou/2GIcoIabw78VpVj/pRagdMC3ilBuxNAOpETPbz7fXBWYKnFLtN8s7yQfrOy1wGcKAlClaTt090CcnZkyO4QNuunngM2l1ximaFvSOQSlf80oc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774094919; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=nHiUJDel0AxoqE8MlDbcuyBy93ogNetIEbbFITmfr8A=; 
	b=X8x8PmyNSf0ulloj/LPT8faA/F1XIyWLmOya/49K9Bf9PJALwZ6LXmOinoHyAxm7TMMEGcYYmvInAuZuB0pp9NkbEHp5z2YauxkxnlcfB2pkSsdaHusc851fIozttveqj/E+kyYpQC3Jejqc4ILBST0q9xMiOVWsWzZq6pF7I0U=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774094919;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=nHiUJDel0AxoqE8MlDbcuyBy93ogNetIEbbFITmfr8A=;
	b=Yw0njHO5LMda3SSPqKzTcLCQT6lQpVNHFt/9CoJ/BSyln+6IUvyKFhBIqCF7nCn4
	1Pil2RLFU2/1QX14yDDrQExt0ZyXO9Ud67ac4+gpkBcKq1GQnIVq+FrxDDOY8UA7Q2T
	1w0xxy4Od5/4V/ZNXhQBxx7nGkg2XODkB/Q2rqh4=
Received: by mx.zoho.eu with SMTPS id 1774094915606940.4231050470418;
	Sat, 21 Mar 2026 13:08:35 +0100 (CET)
Date: Sat, 21 Mar 2026 12:08:35 +0000
From: Josh Law <objecting@objecting.org>
To: Kees Cook <kees@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>,
 Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>,
 "Richard Russon (FlatCap)" <ldm@flatcap.org>,
 Thorsten Blum <thorsten.blum@linux.dev>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
 linux-hardening@vger.kernel.org
Subject: Re: [PATCH] block: partitions: Replace pp_buf with struct seq_buf
User-Agent: Thunderbird for Android
In-Reply-To: <20260321004840.work.670-kees@kernel.org>
References: <20260321004840.work.670-kees@kernel.org>
Message-ID: <D47F8215-FD08-45ED-AB01-0A5C48CD41DD@objecting.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External



On 21 March 2026 00:48:44 GMT, Kees Cook <kees@kernel=2Eorg> wrote:
>In preparation for removing the strlcat API[1], replace the char *pp_buf
>with a struct seq_buf, which tracks the current write position and
>remaining space internally=2E This allows for:
>
>- Direct use of seq_buf_printf() in place of snprintf()+strlcat()
>  pairs, eliminating local tmp buffers throughout=2E
>- Adjacent strlcat() calls that build strings piece-by-piece
>  (e=2Eg=2E, strlcat("["); strlcat(name); strlcat("]")) to be collapsed
>  into single seq_buf_printf() calls=2E
>- Simpler call sites: seq_buf_puts() takes only the buffer and string,
>  with no need to pass PAGE_SIZE at every call=2E
>
>The backing buffer allocation is unchanged (__get_free_page), and the
>output path uses seq_buf_str() to NUL-terminate before passing to
>printk()=2E
>
>Link: https://github=2Ecom/KSPP/linux/issues/370 [1]
>Cc: Andy Shevchenko <andriy=2Eshevchenko@linux=2Eintel=2Ecom>
>Cc: Josh Law <objecting@objecting=2Eorg>
>Signed-off-by: Kees Cook <kees@kernel=2Eorg>
>---
>I couldn't help myself=2E Here's the full patch, as I suggested in
>https://lore=2Ekernel=2Eorg/lkml/202603201230=2E74BBFFABAD@keescook/
>There are plenty more like this to do=2E=2E=2E
>---
> block/partitions/check=2Eh   |  8 ++---
> block/partitions/core=2Ec    | 20 ++++++------
> block/partitions/acorn=2Ec   | 32 ++++++++----------
> block/partitions/aix=2Ec     | 21 +++++-------
> block/partitions/amiga=2Ec   | 35 +++++++++-----------
> block/partitions/atari=2Ec   | 12 +++----
> block/partitions/cmdline=2Ec |  6 ++--
> block/partitions/efi=2Ec     |  2 +-
> block/partitions/ibm=2Ec     | 27 ++++++---------
> block/partitions/karma=2Ec   |  2 +-
> block/partitions/ldm=2Ec     |  4 +--
> block/partitions/mac=2Ec     |  4 +--
> block/partitions/msdos=2Ec   | 67 +++++++++++++-------------------------
> block/partitions/of=2Ec      |  6 ++--
> block/partitions/osf=2Ec     |  2 +-
> block/partitions/sgi=2Ec     |  2 +-
> block/partitions/sun=2Ec     |  2 +-
> block/partitions/sysv68=2Ec  |  9 ++---
> block/partitions/ultrix=2Ec  |  2 +-
> 19 files changed, 106 insertions(+), 157 deletions(-)
>
>diff --git a/block/partitions/check=2Eh b/block/partitions/check=2Eh
>index e5c1c61eb353=2E=2Eb0997467b61a 100644
>--- a/block/partitions/check=2Eh
>+++ b/block/partitions/check=2Eh
>@@ -1,6 +1,7 @@
> /* SPDX-License-Identifier: GPL-2=2E0 */
> #include <linux/pagemap=2Eh>
> #include <linux/blkdev=2Eh>
>+#include <linux/seq_buf=2Eh>
> #include "=2E=2E/blk=2Eh"
>=20
> /*
>@@ -20,7 +21,7 @@ struct parsed_partitions {
> 	int next;
> 	int limit;
> 	bool access_beyond_eod;
>-	char *pp_buf;
>+	struct seq_buf pp_buf;
> };
>=20
> typedef struct {
>@@ -37,12 +38,9 @@ static inline void
> put_partition(struct parsed_partitions *p, int n, sector_t from, sector_=
t size)
> {
> 	if (n < p->limit) {
>-		char tmp[1 + BDEVNAME_SIZE + 10 + 1];
>-
> 		p->parts[n]=2Efrom =3D from;
> 		p->parts[n]=2Esize =3D size;
>-		snprintf(tmp, sizeof(tmp), " %s%d", p->name, n);
>-		strlcat(p->pp_buf, tmp, PAGE_SIZE);
>+		seq_buf_printf(&p->pp_buf, " %s%d", p->name, n);
> 	}
> }
>=20
>diff --git a/block/partitions/core=2Ec b/block/partitions/core=2Ec
>index 740228750aaf=2E=2E3b5928836c69 100644
>--- a/block/partitions/core=2Ec
>+++ b/block/partitions/core=2Ec
>@@ -123,16 +123,16 @@ static struct parsed_partitions *check_partition(st=
ruct gendisk *hd)
> 	state =3D allocate_partitions(hd);
> 	if (!state)
> 		return NULL;
>-	state->pp_buf =3D (char *)__get_free_page(GFP_KERNEL);
>-	if (!state->pp_buf) {
>+	state->pp_buf=2Ebuffer =3D (char *)__get_free_page(GFP_KERNEL);
>+	if (!state->pp_buf=2Ebuffer) {
> 		free_partitions(state);
> 		return NULL;
> 	}
>-	state->pp_buf[0] =3D '\0';
>+	seq_buf_init(&state->pp_buf, state->pp_buf=2Ebuffer, PAGE_SIZE);
>=20
> 	state->disk =3D hd;
> 	strscpy(state->name, hd->disk_name);
>-	snprintf(state->pp_buf, PAGE_SIZE, " %s:", state->name);
>+	seq_buf_printf(&state->pp_buf, " %s:", state->name);
> 	if (isdigit(state->name[strlen(state->name)-1]))
> 		sprintf(state->name, "p");
>=20
>@@ -151,9 +151,9 @@ static struct parsed_partitions *check_partition(stru=
ct gendisk *hd)
>=20
> 	}
> 	if (res > 0) {
>-		printk(KERN_INFO "%s", state->pp_buf);
>+		printk(KERN_INFO "%s", seq_buf_str(&state->pp_buf));
>=20
>-		free_page((unsigned long)state->pp_buf);
>+		free_page((unsigned long)state->pp_buf=2Ebuffer);
> 		return state;
> 	}
> 	if (state->access_beyond_eod)
>@@ -164,12 +164,12 @@ static struct parsed_partitions *check_partition(st=
ruct gendisk *hd)
> 	if (err)
> 		res =3D err;
> 	if (res) {
>-		strlcat(state->pp_buf,
>-			" unable to read partition table\n", PAGE_SIZE);
>-		printk(KERN_INFO "%s", state->pp_buf);
>+		seq_buf_puts(&state->pp_buf,
>+			     " unable to read partition table\n");
>+		printk(KERN_INFO "%s", seq_buf_str(&state->pp_buf));
> 	}
>=20
>-	free_page((unsigned long)state->pp_buf);
>+	free_page((unsigned long)state->pp_buf=2Ebuffer);
> 	free_partitions(state);
> 	return ERR_PTR(res);
> }
>diff --git a/block/partitions/acorn=2Ec b/block/partitions/acorn=2Ec
>index d2fc122d7426=2E=2E9f7389f174d0 100644
>--- a/block/partitions/acorn=2Ec
>+++ b/block/partitions/acorn=2Ec
>@@ -40,9 +40,7 @@ adfs_partition(struct parsed_partitions *state, char *n=
ame, char *data,
> 		   (le32_to_cpu(dr->disc_size) >> 9);
>=20
> 	if (name) {
>-		strlcat(state->pp_buf, " [", PAGE_SIZE);
>-		strlcat(state->pp_buf, name, PAGE_SIZE);
>-		strlcat(state->pp_buf, "]", PAGE_SIZE);
>+		seq_buf_printf(&state->pp_buf, " [%s]", name);
> 	}
> 	put_partition(state, slot, first_sector, nr_sects);
> 	return dr;
>@@ -78,14 +76,14 @@ static int riscix_partition(struct parsed_partitions =
*state,
> 	if (!rr)
> 		return -1;
>=20
>-	strlcat(state->pp_buf, " [RISCiX]", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, " [RISCiX]");
>=20
>=20
> 	if (rr->magic =3D=3D RISCIX_MAGIC) {
> 		unsigned long size =3D nr_sects > 2 ? 2 : nr_sects;
> 		int part;
>=20
>-		strlcat(state->pp_buf, " <", PAGE_SIZE);
>+		seq_buf_puts(&state->pp_buf, " <");
>=20
> 		put_partition(state, slot++, first_sect, size);
> 		for (part =3D 0; part < 8; part++) {
>@@ -94,13 +92,11 @@ static int riscix_partition(struct parsed_partitions =
*state,
> 				put_partition(state, slot++,
> 					le32_to_cpu(rr->part[part]=2Estart),
> 					le32_to_cpu(rr->part[part]=2Elength));
>-				strlcat(state->pp_buf, "(", PAGE_SIZE);
>-				strlcat(state->pp_buf, rr->part[part]=2Ename, PAGE_SIZE);
>-				strlcat(state->pp_buf, ")", PAGE_SIZE);
>+				seq_buf_printf(&state->pp_buf, "(%s)", rr->part[part]=2Ename);
> 			}
> 		}
>=20
>-		strlcat(state->pp_buf, " >\n", PAGE_SIZE);
>+		seq_buf_puts(&state->pp_buf, " >\n");
> 	} else {
> 		put_partition(state, slot++, first_sect, nr_sects);
> 	}
>@@ -130,7 +126,7 @@ static int linux_partition(struct parsed_partitions *=
state,
> 	struct linux_part *linuxp;
> 	unsigned long size =3D nr_sects > 2 ? 2 : nr_sects;
>=20
>-	strlcat(state->pp_buf, " [Linux]", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, " [Linux]");
>=20
> 	put_partition(state, slot++, first_sect, size);
>=20
>@@ -138,7 +134,7 @@ static int linux_partition(struct parsed_partitions *=
state,
> 	if (!linuxp)
> 		return -1;
>=20
>-	strlcat(state->pp_buf, " <", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, " <");
> 	while (linuxp->magic =3D=3D cpu_to_le32(LINUX_NATIVE_MAGIC) ||
> 	       linuxp->magic =3D=3D cpu_to_le32(LINUX_SWAP_MAGIC)) {
> 		if (slot =3D=3D state->limit)
>@@ -148,7 +144,7 @@ static int linux_partition(struct parsed_partitions *=
state,
> 				 le32_to_cpu(linuxp->nr_sects));
> 		linuxp ++;
> 	}
>-	strlcat(state->pp_buf, " >", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, " >");
>=20
> 	put_dev_sector(sect);
> 	return slot;
>@@ -293,7 +289,7 @@ int adfspart_check_ADFS(struct parsed_partitions *sta=
te)
> 			break;
> 		}
> 	}
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
> 	return 1;
> }
> #endif
>@@ -366,7 +362,7 @@ int adfspart_check_ICS(struct parsed_partitions *stat=
e)
> 		return 0;
> 	}
>=20
>-	strlcat(state->pp_buf, " [ICS]", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, " [ICS]");
>=20
> 	for (slot =3D 1, p =3D (const struct ics_part *)data; p->size; p++) {
> 		u32 start =3D le32_to_cpu(p->start);
>@@ -400,7 +396,7 @@ int adfspart_check_ICS(struct parsed_partitions *stat=
e)
> 	}
>=20
> 	put_dev_sector(sect);
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
> 	return 1;
> }
> #endif
>@@ -460,7 +456,7 @@ int adfspart_check_POWERTEC(struct parsed_partitions =
*state)
> 		return 0;
> 	}
>=20
>-	strlcat(state->pp_buf, " [POWERTEC]", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, " [POWERTEC]");
>=20
> 	for (i =3D 0, p =3D (const struct ptec_part *)data; i < 12; i++, p++) {
> 		u32 start =3D le32_to_cpu(p->start);
>@@ -471,7 +467,7 @@ int adfspart_check_POWERTEC(struct parsed_partitions =
*state)
> 	}
>=20
> 	put_dev_sector(sect);
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
> 	return 1;
> }
> #endif
>@@ -542,7 +538,7 @@ int adfspart_check_EESOX(struct parsed_partitions *st=
ate)
>=20
> 		size =3D get_capacity(state->disk);
> 		put_partition(state, slot++, start, size - start);
>-		strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+		seq_buf_puts(&state->pp_buf, "\n");
> 	}
>=20
> 	return i ? 1 : 0;
>diff --git a/block/partitions/aix=2Ec b/block/partitions/aix=2Ec
>index a886cefbefbb=2E=2E29b8f4cebb63 100644
>--- a/block/partitions/aix=2Ec
>+++ b/block/partitions/aix=2Ec
>@@ -173,24 +173,22 @@ int aix_partition(struct parsed_partitions *state)
> 	if (d) {
> 		struct lvm_rec *p =3D (struct lvm_rec *)d;
> 		u16 lvm_version =3D be16_to_cpu(p->version);
>-		char tmp[64];
>=20
> 		if (lvm_version =3D=3D 1) {
> 			int pp_size_log2 =3D be16_to_cpu(p->pp_size);
>=20
> 			pp_bytes_size =3D 1 << pp_size_log2;
> 			pp_blocks_size =3D pp_bytes_size / 512;
>-			snprintf(tmp, sizeof(tmp),
>-				" AIX LVM header version %u found\n",
>-				lvm_version);
>+			seq_buf_printf(&state->pp_buf,
>+				       " AIX LVM header version %u found\n",
>+				       lvm_version);
> 			vgda_len =3D be32_to_cpu(p->vgda_len);
> 			vgda_sector =3D be32_to_cpu(p->vgda_psn[0]);
> 		} else {
>-			snprintf(tmp, sizeof(tmp),
>-				" unsupported AIX LVM version %d found\n",
>-				lvm_version);
>+			seq_buf_printf(&state->pp_buf,
>+				       " unsupported AIX LVM version %d found\n",
>+				       lvm_version);
> 		}
>-		strlcat(state->pp_buf, tmp, PAGE_SIZE);
> 		put_dev_sector(sect);
> 	}
> 	if (vgda_sector && (d =3D read_part_sector(state, vgda_sector, &sect)))=
 {
>@@ -251,14 +249,11 @@ int aix_partition(struct parsed_partitions *state)
> 				continue;
> 			}
> 			if (lp_ix =3D=3D lvip[lv_ix]=2Epps_per_lv) {
>-				char tmp[70];
>-
> 				put_partition(state, lv_ix + 1,
> 				  (i + 1 - lp_ix) * pp_blocks_size + psn_part1,
> 				  lvip[lv_ix]=2Epps_per_lv * pp_blocks_size);
>-				snprintf(tmp, sizeof(tmp), " <%s>\n",
>-					 n[lv_ix]=2Ename);
>-				strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+				seq_buf_printf(&state->pp_buf, " <%s>\n",
>+					       n[lv_ix]=2Ename);
> 				lvip[lv_ix]=2Elv_is_contiguous =3D 1;
> 				ret =3D 1;
> 				next_lp_ix =3D 1;
>diff --git a/block/partitions/amiga=2Ec b/block/partitions/amiga=2Ec
>index 506921095412=2E=2E8325046a14eb 100644
>--- a/block/partitions/amiga=2Ec
>+++ b/block/partitions/amiga=2Ec
>@@ -81,13 +81,8 @@ int amiga_partition(struct parsed_partitions *state)
> 	/* blksize is blocks per 512 byte standard block */
> 	blksize =3D be32_to_cpu( rdb->rdb_BlockBytes ) / 512;
>=20
>-	{
>-		char tmp[7 + 10 + 1 + 1];
>-
>-		/* Be more informative */
>-		snprintf(tmp, sizeof(tmp), " RDSK (%d)", blksize * 512);
>-		strlcat(state->pp_buf, tmp, PAGE_SIZE);
>-	}
>+	/* Be more informative */
>+	seq_buf_printf(&state->pp_buf, " RDSK (%d)", blksize * 512);
> 	blk =3D be32_to_cpu(rdb->rdb_PartitionList);
> 	put_dev_sector(sect);
> 	for (part =3D 1; (s32) blk>0 && part<=3D16; part++, put_dev_sector(sect=
)) {
>@@ -179,27 +174,27 @@ int amiga_partition(struct parsed_partitions *state=
)
> 		{
> 			/* Be even more informative to aid mounting */
> 			char dostype[4];
>-			char tmp[42];
>=20
> 			__be32 *dt =3D (__be32 *)dostype;
> 			*dt =3D pb->pb_Environment[16];
> 			if (dostype[3] < ' ')
>-				snprintf(tmp, sizeof(tmp), " (%c%c%c^%c)",
>-					dostype[0], dostype[1],
>-					dostype[2], dostype[3] + '@' );
>+				seq_buf_printf(&state->pp_buf,
>+					       " (%c%c%c^%c)",
>+					       dostype[0], dostype[1],
>+					       dostype[2],
>+					       dostype[3] + '@');
> 			else
>-				snprintf(tmp, sizeof(tmp), " (%c%c%c%c)",
>-					dostype[0], dostype[1],
>-					dostype[2], dostype[3]);
>-			strlcat(state->pp_buf, tmp, PAGE_SIZE);
>-			snprintf(tmp, sizeof(tmp), "(res %d spb %d)",
>-				be32_to_cpu(pb->pb_Environment[6]),
>-				be32_to_cpu(pb->pb_Environment[4]));
>-			strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+				seq_buf_printf(&state->pp_buf,
>+					       " (%c%c%c%c)",
>+					       dostype[0], dostype[1],
>+					       dostype[2], dostype[3]);
>+			seq_buf_printf(&state->pp_buf, "(res %d spb %d)",
>+				       be32_to_cpu(pb->pb_Environment[6]),
>+				       be32_to_cpu(pb->pb_Environment[4]));
> 		}
> 		res =3D 1;
> 	}
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
>=20
> rdb_done:
> 	return res;
>diff --git a/block/partitions/atari=2Ec b/block/partitions/atari=2Ec
>index 9655c728262a=2E=2E2438d1448f38 100644
>--- a/block/partitions/atari=2Ec
>+++ b/block/partitions/atari=2Ec
>@@ -70,7 +70,7 @@ int atari_partition(struct parsed_partitions *state)
> 	}
>=20
> 	pi =3D &rs->part[0];
>-	strlcat(state->pp_buf, " AHDI", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, " AHDI");
> 	for (slot =3D 1; pi < &rs->part[4] && slot < state->limit; slot++, pi++=
) {
> 		struct rootsector *xrs;
> 		Sector sect2;
>@@ -89,7 +89,7 @@ int atari_partition(struct parsed_partitions *state)
> #ifdef ICD_PARTS
> 		part_fmt =3D 1;
> #endif
>-		strlcat(state->pp_buf, " XGM<", PAGE_SIZE);
>+		seq_buf_puts(&state->pp_buf, " XGM<");
> 		partsect =3D extensect =3D be32_to_cpu(pi->st);
> 		while (1) {
> 			xrs =3D read_part_sector(state, partsect, &sect2);
>@@ -128,14 +128,14 @@ int atari_partition(struct parsed_partitions *state=
)
> 				break;
> 			}
> 		}
>-		strlcat(state->pp_buf, " >", PAGE_SIZE);
>+		seq_buf_puts(&state->pp_buf, " >");
> 	}
> #ifdef ICD_PARTS
> 	if ( part_fmt!=3D1 ) { /* no extended partitions -> test ICD-format */
> 		pi =3D &rs->icdpart[0];
> 		/* sanity check: no ICD format if first partition invalid */
> 		if (OK_id(pi->id)) {
>-			strlcat(state->pp_buf, " ICD<", PAGE_SIZE);
>+			seq_buf_puts(&state->pp_buf, " ICD<");
> 			for (; pi < &rs->icdpart[8] && slot < state->limit; slot++, pi++) {
> 				/* accept only GEM,BGM,RAW,LNX,SWP partitions */
> 				if (!((pi->flg & 1) && OK_id(pi->id)))
>@@ -144,13 +144,13 @@ int atari_partition(struct parsed_partitions *state=
)
> 						be32_to_cpu(pi->st),
> 						be32_to_cpu(pi->siz));
> 			}
>-			strlcat(state->pp_buf, " >", PAGE_SIZE);
>+			seq_buf_puts(&state->pp_buf, " >");
> 		}
> 	}
> #endif
> 	put_dev_sector(sect);
>=20
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
>=20
> 	return 1;
> }
>diff --git a/block/partitions/cmdline=2Ec b/block/partitions/cmdline=2Ec
>index a2b1870c3fd4=2E=2E4fd52ed154b4 100644
>--- a/block/partitions/cmdline=2Ec
>+++ b/block/partitions/cmdline=2Ec
>@@ -229,7 +229,6 @@ static int add_part(int slot, struct cmdline_subpart =
*subpart,
> 		struct parsed_partitions *state)
> {
> 	struct partition_meta_info *info;
>-	char tmp[sizeof(info->volname) + 4];
>=20
> 	if (slot >=3D state->limit)
> 		return 1;
>@@ -244,8 +243,7 @@ static int add_part(int slot, struct cmdline_subpart =
*subpart,
>=20
> 	strscpy(info->volname, subpart->name, sizeof(info->volname));
>=20
>-	snprintf(tmp, sizeof(tmp), "(%s)", info->volname);
>-	strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+	seq_buf_printf(&state->pp_buf, "(%s)", info->volname);
>=20
> 	state->parts[slot]=2Ehas_info =3D true;
>=20
>@@ -379,7 +377,7 @@ int cmdline_partition(struct parsed_partitions *state=
)
> 	cmdline_parts_set(parts, disk_size, state);
> 	cmdline_parts_verifier(1, state);
>=20
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
>=20
> 	return 1;
> }
>diff --git a/block/partitions/efi=2Ec b/block/partitions/efi=2Ec
>index 75474fb3848e=2E=2E9865d59093fa 100644
>--- a/block/partitions/efi=2Ec
>+++ b/block/partitions/efi=2Ec
>@@ -751,6 +751,6 @@ int efi_partition(struct parsed_partitions *state)
> 	}
> 	kfree(ptes);
> 	kfree(gpt);
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
> 	return 1;
> }
>diff --git a/block/partitions/ibm=2Ec b/block/partitions/ibm=2Ec
>index 9311ad5fb95d=2E=2E54047e722a9d 100644
>--- a/block/partitions/ibm=2Ec
>+++ b/block/partitions/ibm=2Ec
>@@ -173,15 +173,13 @@ static int find_vol1_partitions(struct parsed_parti=
tions *state,
> {
> 	sector_t blk;
> 	int counter;
>-	char tmp[64];
> 	Sector sect;
> 	unsigned char *data;
> 	loff_t offset, size;
> 	struct vtoc_format1_label f1;
> 	int secperblk;
>=20
>-	snprintf(tmp, sizeof(tmp), "VOL1/%8s:", name);
>-	strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+	seq_buf_printf(&state->pp_buf, "VOL1/%8s:", name);
> 	/*
> 	 * get start of VTOC from the disk label and then search for format1
> 	 * and format8 labels
>@@ -219,7 +217,7 @@ static int find_vol1_partitions(struct parsed_partiti=
ons *state,
> 		blk++;
> 		data =3D read_part_sector(state, blk * secperblk, &sect);
> 	}
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
>=20
> 	if (!data)
> 		return -1;
>@@ -237,11 +235,9 @@ static int find_lnx1_partitions(struct parsed_partit=
ions *state,
> 				dasd_information2_t *info)
> {
> 	loff_t offset, geo_size, size;
>-	char tmp[64];
> 	int secperblk;
>=20
>-	snprintf(tmp, sizeof(tmp), "LNX1/%8s:", name);
>-	strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+	seq_buf_printf(&state->pp_buf, "LNX1/%8s:", name);
> 	secperblk =3D blocksize >> 9;
> 	if (label->lnx=2Eldl_version =3D=3D 0xf2) {
> 		size =3D label->lnx=2Eformatted_blocks * secperblk;
>@@ -258,7 +254,7 @@ static int find_lnx1_partitions(struct parsed_partiti=
ons *state,
> 		size =3D nr_sectors;
> 		if (size !=3D geo_size) {
> 			if (!info) {
>-				strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+				seq_buf_puts(&state->pp_buf, "\n");
> 				return 1;
> 			}
> 			if (!strcmp(info->type, "ECKD"))
>@@ -270,7 +266,7 @@ static int find_lnx1_partitions(struct parsed_partiti=
ons *state,
> 	/* first and only partition starts in the first block after the label *=
/
> 	offset =3D labelsect + secperblk;
> 	put_partition(state, 1, offset, size - offset);
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
> 	return 1;
> }
>=20
>@@ -282,7 +278,6 @@ static int find_cms1_partitions(struct parsed_partiti=
ons *state,
> 				sector_t labelsect)
> {
> 	loff_t offset, size;
>-	char tmp[64];
> 	int secperblk;
>=20
> 	/*
>@@ -291,14 +286,12 @@ static int find_cms1_partitions(struct parsed_parti=
tions *state,
> 	blocksize =3D label->cms=2Eblock_size;
> 	secperblk =3D blocksize >> 9;
> 	if (label->cms=2Edisk_offset !=3D 0) {
>-		snprintf(tmp, sizeof(tmp), "CMS1/%8s(MDSK):", name);
>-		strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+		seq_buf_printf(&state->pp_buf, "CMS1/%8s(MDSK):", name);
> 		/* disk is reserved minidisk */
> 		offset =3D label->cms=2Edisk_offset * secperblk;
> 		size =3D (label->cms=2Eblock_count - 1) * secperblk;
> 	} else {
>-		snprintf(tmp, sizeof(tmp), "CMS1/%8s:", name);
>-		strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+		seq_buf_printf(&state->pp_buf, "CMS1/%8s:", name);
> 		/*
> 		 * Special case for FBA devices:
> 		 * If an FBA device is CMS formatted with blocksize > 512 byte
>@@ -314,7 +307,7 @@ static int find_cms1_partitions(struct parsed_partiti=
ons *state,
> 	}
>=20
> 	put_partition(state, 1, offset, size-offset);
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
> 	return 1;
> }
>=20
>@@ -391,11 +384,11 @@ int ibm_partition(struct parsed_partitions *state)
> 		 */
> 		res =3D 1;
> 		if (info->format =3D=3D DASD_FORMAT_LDL) {
>-			strlcat(state->pp_buf, "(nonl)", PAGE_SIZE);
>+			seq_buf_puts(&state->pp_buf, "(nonl)");
> 			size =3D nr_sectors;
> 			offset =3D (info->label_block + 1) * (blocksize >> 9);
> 			put_partition(state, 1, offset, size-offset);
>-			strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+			seq_buf_puts(&state->pp_buf, "\n");
> 		}
> 	} else
> 		res =3D 0;
>diff --git a/block/partitions/karma=2Ec b/block/partitions/karma=2Ec
>index 4d93512f4bd4=2E=2Ea4e3c5050177 100644
>--- a/block/partitions/karma=2Ec
>+++ b/block/partitions/karma=2Ec
>@@ -53,7 +53,7 @@ int karma_partition(struct parsed_partitions *state)
> 		}
> 		slot++;
> 	}
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
> 	put_dev_sector(sect);
> 	return 1;
> }
>diff --git a/block/partitions/ldm=2Ec b/block/partitions/ldm=2Ec
>index 776b4ad95091=2E=2Ec0bdcae58a3e 100644
>--- a/block/partitions/ldm=2Ec
>+++ b/block/partitions/ldm=2Ec
>@@ -582,7 +582,7 @@ static bool ldm_create_data_partitions (struct parsed=
_partitions *pp,
> 		return false;
> 	}
>=20
>-	strlcat(pp->pp_buf, " [LDM]", PAGE_SIZE);
>+	seq_buf_puts(&pp->pp_buf, " [LDM]");
>=20
> 	/* Create the data partitions */
> 	list_for_each (item, &ldb->v_part) {
>@@ -597,7 +597,7 @@ static bool ldm_create_data_partitions (struct parsed=
_partitions *pp,
> 		part_num++;
> 	}
>=20
>-	strlcat(pp->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&pp->pp_buf, "\n");
> 	return true;
> }
>=20
>diff --git a/block/partitions/mac=2Ec b/block/partitions/mac=2Ec
>index b02530d98629=2E=2Edf03ca428e15 100644
>--- a/block/partitions/mac=2Ec
>+++ b/block/partitions/mac=2Ec
>@@ -86,7 +86,7 @@ int mac_partition(struct parsed_partitions *state)
> 	if (blocks_in_map >=3D state->limit)
> 		blocks_in_map =3D state->limit - 1;
>=20
>-	strlcat(state->pp_buf, " [mac]", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, " [mac]");
> 	for (slot =3D 1; slot <=3D blocks_in_map; ++slot) {
> 		int pos =3D slot * secsize;
> 		put_dev_sector(sect);
>@@ -152,6 +152,6 @@ int mac_partition(struct parsed_partitions *state)
> #endif
>=20
> 	put_dev_sector(sect);
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
> 	return 1;
> }
>diff --git a/block/partitions/msdos=2Ec b/block/partitions/msdos=2Ec
>index 073be78ba0b0=2E=2E200ea53ea6a2 100644
>--- a/block/partitions/msdos=2Ec
>+++ b/block/partitions/msdos=2Ec
>@@ -263,18 +263,11 @@ static void parse_solaris_x86(struct parsed_partiti=
ons *state,
> 		put_dev_sector(sect);
> 		return;
> 	}
>-	{
>-		char tmp[1 + BDEVNAME_SIZE + 10 + 11 + 1];
>-
>-		snprintf(tmp, sizeof(tmp), " %s%d: <solaris:", state->name, origin);
>-		strlcat(state->pp_buf, tmp, PAGE_SIZE);
>-	}
>+	seq_buf_printf(&state->pp_buf, " %s%d: <solaris:", state->name, origin)=
;
> 	if (le32_to_cpu(v->v_version) !=3D 1) {
>-		char tmp[64];
>-
>-		snprintf(tmp, sizeof(tmp), "  cannot handle version %d vtoc>\n",
>-			 le32_to_cpu(v->v_version));
>-		strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+		seq_buf_printf(&state->pp_buf,
>+			       "  cannot handle version %d vtoc>\n",
>+			       le32_to_cpu(v->v_version));
> 		put_dev_sector(sect);
> 		return;
> 	}
>@@ -282,12 +275,10 @@ static void parse_solaris_x86(struct parsed_partiti=
ons *state,
> 	max_nparts =3D le16_to_cpu(v->v_nparts) > 8 ? SOLARIS_X86_NUMSLICE : 8;
> 	for (i =3D 0; i < max_nparts && state->next < state->limit; i++) {
> 		struct solaris_x86_slice *s =3D &v->v_slice[i];
>-		char tmp[3 + 10 + 1 + 1];
>=20
> 		if (s->s_size =3D=3D 0)
> 			continue;
>-		snprintf(tmp, sizeof(tmp), " [s%d]", i);
>-		strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+		seq_buf_printf(&state->pp_buf, " [s%d]", i);
> 		/* solaris partitions are relative to current MS-DOS
> 		 * one; must add the offset of the current partition */
> 		put_partition(state, state->next++,
>@@ -295,7 +286,7 @@ static void parse_solaris_x86(struct parsed_partition=
s *state,
> 				 le32_to_cpu(s->s_size));
> 	}
> 	put_dev_sector(sect);
>-	strlcat(state->pp_buf, " >\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, " >\n");
> #endif
> }
>=20
>@@ -359,7 +350,6 @@ static void parse_bsd(struct parsed_partitions *state=
,
> 	Sector sect;
> 	struct bsd_disklabel *l;
> 	struct bsd_partition *p;
>-	char tmp[64];
>=20
> 	l =3D read_part_sector(state, offset + 1, &sect);
> 	if (!l)
>@@ -369,8 +359,7 @@ static void parse_bsd(struct parsed_partitions *state=
,
> 		return;
> 	}
>=20
>-	snprintf(tmp, sizeof(tmp), " %s%d: <%s:", state->name, origin, flavour)=
;
>-	strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+	seq_buf_printf(&state->pp_buf, " %s%d: <%s:", state->name, origin, flav=
our);
>=20
> 	if (le16_to_cpu(l->d_npartitions) < max_partitions)
> 		max_partitions =3D le16_to_cpu(l->d_npartitions);
>@@ -391,18 +380,16 @@ static void parse_bsd(struct parsed_partitions *sta=
te,
> 			/* full parent partition, we have it already */
> 			continue;
> 		if (offset > bsd_start || offset+size < bsd_start+bsd_size) {
>-			strlcat(state->pp_buf, "bad subpartition - ignored\n", PAGE_SIZE);
>+			seq_buf_puts(&state->pp_buf, "bad subpartition - ignored\n");
> 			continue;
> 		}
> 		put_partition(state, state->next++, bsd_start, bsd_size);
> 	}
> 	put_dev_sector(sect);
>-	if (le16_to_cpu(l->d_npartitions) > max_partitions) {
>-		snprintf(tmp, sizeof(tmp), " (ignored %d more)",
>-			 le16_to_cpu(l->d_npartitions) - max_partitions);
>-		strlcat(state->pp_buf, tmp, PAGE_SIZE);
>-	}
>-	strlcat(state->pp_buf, " >\n", PAGE_SIZE);
>+	if (le16_to_cpu(l->d_npartitions) > max_partitions)
>+		seq_buf_printf(&state->pp_buf, " (ignored %d more)",
>+			       le16_to_cpu(l->d_npartitions) - max_partitions);
>+	seq_buf_puts(&state->pp_buf, " >\n");
> }
> #endif
>=20
>@@ -496,12 +483,7 @@ static void parse_unixware(struct parsed_partitions =
*state,
> 		put_dev_sector(sect);
> 		return;
> 	}
>-	{
>-		char tmp[1 + BDEVNAME_SIZE + 10 + 12 + 1];
>-
>-		snprintf(tmp, sizeof(tmp), " %s%d: <unixware:", state->name, origin);
>-		strlcat(state->pp_buf, tmp, PAGE_SIZE);
>-	}
>+	seq_buf_printf(&state->pp_buf, " %s%d: <unixware:", state->name, origin=
);
> 	p =3D &l->vtoc=2Ev_slice[1];
> 	/* I omit the 0th slice as it is the same as whole disk=2E */
> 	while (p - &l->vtoc=2Ev_slice[0] < UNIXWARE_NUMSLICE) {
>@@ -515,7 +497,7 @@ static void parse_unixware(struct parsed_partitions *=
state,
> 		p++;
> 	}
> 	put_dev_sector(sect);
>-	strlcat(state->pp_buf, " >\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, " >\n");
> #endif
> }
>=20
>@@ -546,10 +528,7 @@ static void parse_minix(struct parsed_partitions *st=
ate,
> 	 * the normal boot sector=2E */
> 	if (msdos_magic_present(data + 510) &&
> 	    p->sys_ind =3D=3D MINIX_PARTITION) { /* subpartition table present =
*/
>-		char tmp[1 + BDEVNAME_SIZE + 10 + 9 + 1];
>-
>-		snprintf(tmp, sizeof(tmp), " %s%d: <minix:", state->name, origin);
>-		strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+		seq_buf_printf(&state->pp_buf, " %s%d: <minix:", state->name, origin);
> 		for (i =3D 0; i < MINIX_NR_SUBPARTITIONS; i++, p++) {
> 			if (state->next =3D=3D state->limit)
> 				break;
>@@ -558,7 +537,7 @@ static void parse_minix(struct parsed_partitions *sta=
te,
> 				put_partition(state, state->next++,
> 					      start_sect(p), nr_sects(p));
> 		}
>-		strlcat(state->pp_buf, " >\n", PAGE_SIZE);
>+		seq_buf_puts(&state->pp_buf, " >\n");
> 	}
> 	put_dev_sector(sect);
> #endif /* CONFIG_MINIX_SUBPARTITION */
>@@ -602,7 +581,7 @@ int msdos_partition(struct parsed_partitions *state)
> #ifdef CONFIG_AIX_PARTITION
> 		return aix_partition(state);
> #else
>-		strlcat(state->pp_buf, " [AIX]", PAGE_SIZE);
>+		seq_buf_puts(&state->pp_buf, " [AIX]");
> 		return 0;
> #endif
> 	}
>@@ -629,7 +608,7 @@ int msdos_partition(struct parsed_partitions *state)
> 			fb =3D (struct fat_boot_sector *) data;
> 			if (slot =3D=3D 1 && fb->reserved && fb->fats
> 				&& fat_valid_media(fb->media)) {
>-				strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+				seq_buf_puts(&state->pp_buf, "\n");
> 				put_dev_sector(sect);
> 				return 1;
> 			} else {
>@@ -678,9 +657,9 @@ int msdos_partition(struct parsed_partitions *state)
> 			n =3D min(size, max(sector_size, n));
> 			put_partition(state, slot, start, n);
>=20
>-			strlcat(state->pp_buf, " <", PAGE_SIZE);
>+			seq_buf_puts(&state->pp_buf, " <");
> 			parse_extended(state, start, size, disksig);
>-			strlcat(state->pp_buf, " >", PAGE_SIZE);
>+			seq_buf_puts(&state->pp_buf, " >");
> 			continue;
> 		}
> 		put_partition(state, slot, start, size);
>@@ -688,12 +667,12 @@ int msdos_partition(struct parsed_partitions *state=
)
> 		if (p->sys_ind =3D=3D LINUX_RAID_PARTITION)
> 			state->parts[slot]=2Eflags =3D ADDPART_FLAG_RAID;
> 		if (p->sys_ind =3D=3D DM6_PARTITION)
>-			strlcat(state->pp_buf, "[DM]", PAGE_SIZE);
>+			seq_buf_puts(&state->pp_buf, "[DM]");
> 		if (p->sys_ind =3D=3D EZD_PARTITION)
>-			strlcat(state->pp_buf, "[EZD]", PAGE_SIZE);
>+			seq_buf_puts(&state->pp_buf, "[EZD]");
> 	}
>=20
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
>=20
> 	/* second pass - output for each on a separate line */
> 	p =3D (struct msdos_partition *) (0x1be + data);
>diff --git a/block/partitions/of=2Ec b/block/partitions/of=2Ec
>index 4e760fdffb3f=2E=2Ec22b60661098 100644
>--- a/block/partitions/of=2Ec
>+++ b/block/partitions/of=2Ec
>@@ -36,7 +36,6 @@ static void add_of_partition(struct parsed_partitions *=
state, int slot,
> 			     struct device_node *np)
> {
> 	struct partition_meta_info *info;
>-	char tmp[sizeof(info->volname) + 4];
> 	const char *partname;
> 	int len;
>=20
>@@ -63,8 +62,7 @@ static void add_of_partition(struct parsed_partitions *=
state, int slot,
> 		partname =3D of_get_property(np, "name", &len);
> 	strscpy(info->volname, partname, sizeof(info->volname));
>=20
>-	snprintf(tmp, sizeof(tmp), "(%s)", info->volname);
>-	strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+	seq_buf_printf(&state->pp_buf, "(%s)", info->volname);
> }
>=20
> int of_partition(struct parsed_partitions *state)
>@@ -104,7 +102,7 @@ int of_partition(struct parsed_partitions *state)
> 		slot++;
> 	}
>=20
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
>=20
> 	return 1;
> }
>diff --git a/block/partitions/osf=2Ec b/block/partitions/osf=2Ec
>index 84560d0765ed=2E=2E2a692584dba9 100644
>--- a/block/partitions/osf=2Ec
>+++ b/block/partitions/osf=2Ec
>@@ -81,7 +81,7 @@ int osf_partition(struct parsed_partitions *state)
> 				le32_to_cpu(partition->p_size));
> 		slot++;
> 	}
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
> 	put_dev_sector(sect);
> 	return 1;
> }
>diff --git a/block/partitions/sgi=2Ec b/block/partitions/sgi=2Ec
>index b5ecddd5181a=2E=2E2383ca63cd66 100644
>--- a/block/partitions/sgi=2Ec
>+++ b/block/partitions/sgi=2Ec
>@@ -79,7 +79,7 @@ int sgi_partition(struct parsed_partitions *state)
> 		}
> 		slot++;
> 	}
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
> 	put_dev_sector(sect);
> 	return 1;
> }
>diff --git a/block/partitions/sun=2Ec b/block/partitions/sun=2Ec
>index 2419af76120f=2E=2E92c645fcd2e0 100644
>--- a/block/partitions/sun=2Ec
>+++ b/block/partitions/sun=2Ec
>@@ -121,7 +121,7 @@ int sun_partition(struct parsed_partitions *state)
> 		}
> 		slot++;
> 	}
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
> 	put_dev_sector(sect);
> 	return 1;
> }
>diff --git a/block/partitions/sysv68=2Ec b/block/partitions/sysv68=2Ec
>index 6f6257fd4eb4=2E=2E470e0f9de7be 100644
>--- a/block/partitions/sysv68=2Ec
>+++ b/block/partitions/sysv68=2Ec
>@@ -54,7 +54,6 @@ int sysv68_partition(struct parsed_partitions *state)
> 	unsigned char *data;
> 	struct dkblk0 *b;
> 	struct slice *slice;
>-	char tmp[64];
>=20
> 	data =3D read_part_sector(state, 0, &sect);
> 	if (!data)
>@@ -74,8 +73,7 @@ int sysv68_partition(struct parsed_partitions *state)
> 		return -1;
>=20
> 	slices -=3D 1; /* last slice is the whole disk */
>-	snprintf(tmp, sizeof(tmp), "sysV68: %s(s%u)", state->name, slices);
>-	strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+	seq_buf_printf(&state->pp_buf, "sysV68: %s(s%u)", state->name, slices);
> 	slice =3D (struct slice *)data;
> 	for (i =3D 0; i < slices; i++, slice++) {
> 		if (slot =3D=3D state->limit)
>@@ -84,12 +82,11 @@ int sysv68_partition(struct parsed_partitions *state)
> 			put_partition(state, slot,
> 				be32_to_cpu(slice->blkoff),
> 				be32_to_cpu(slice->nblocks));
>-			snprintf(tmp, sizeof(tmp), "(s%u)", i);
>-			strlcat(state->pp_buf, tmp, PAGE_SIZE);
>+			seq_buf_printf(&state->pp_buf, "(s%u)", i);
> 		}
> 		slot++;
> 	}
>-	strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+	seq_buf_puts(&state->pp_buf, "\n");
> 	put_dev_sector(sect);
> 	return 1;
> }
>diff --git a/block/partitions/ultrix=2Ec b/block/partitions/ultrix=2Ec
>index 4aaa81043ca0=2E=2Eb4b9ddc57a5d 100644
>--- a/block/partitions/ultrix=2Ec
>+++ b/block/partitions/ultrix=2Ec
>@@ -39,7 +39,7 @@ int ultrix_partition(struct parsed_partitions *state)
> 					      label->pt_part[i]=2Epi_blkoff,
> 					      label->pt_part[i]=2Epi_nblocks);
> 		put_dev_sector(sect);
>-		strlcat(state->pp_buf, "\n", PAGE_SIZE);
>+		seq_buf_puts(&state->pp_buf, "\n");
> 		return 1;
> 	} else {
> 		put_dev_sector(sect);


Reviewed-by: Josh Law <objecting@objecting=2Eorg>
