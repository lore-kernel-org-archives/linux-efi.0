Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B33E3C345F;
	Mon, 29 Jun 2026 07:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782717450; cv=none; b=OioPcI1SWL95SW1FbkAVpICs90s0NkFCrCVgnSi2RMP/WABJhHlyNv3Qb2ylQcsqoblv7oHg4lOOz8wKXqYBYskGTWeo7bMxNUWp+58G8W2JWsiSDjNvR/6WgL8Ev5rPnAqcL4/WNyxHaVAOEw4BdSbIkaV9+/6D+C7OcIIewfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782717450; c=relaxed/simple;
	bh=GSc9qNDZmbnWOQG5z/pDOgH1yqOLDsqD45Wf9RzQ3js=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lB9GW+JwF3wg3PiMIOaVl5ki8OIY6/e+UeXmiCSVAYR2PC1rEtY1VwfkJew8P+m9QVQxXP8FAwmH671DV6XDofvFOgIL5uq+pmoG7DmO7B+UyBSSM1ArjUg87hMTmoUW0ERKZNQs4yg5sC0UjqWV63W9iuvjjA8NBRMyyLojZzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ZstoSLi5; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ZstoSLi5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1782717386; x=1783322186; i=markus.elfring@web.de;
	bh=8auRlBtGj3V75V6wHFSmaqeopwKwwhvdmy0HNeSSsyU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ZstoSLi5ozKMWob3zzFPIM3FDTqiJb00GHH9zc7EkIS7SPQtxXG2LXuK6vRyihtC
	 jmBelihCYybA0w6dcrXJ4p8rQJMvoCZf4tBBPrLVRNnDG+niWYCw+0KHjzbYt3ydr
	 PWIe8oa4Taa6p3rp/AHGSALhyzcTfCKSQGEMzbouabKh+tawGXmro+RGHt6vqAzTM
	 3LCz5lZxSeL1NFdS/icIZ46vdZDwy8FoEJQMCS836aFVikXltvmnlggOKHOeI/syI
	 /5l9GMAgRO/goTUOv2U/eJp6tS3zah0p36QNeu5/LeHM7fkCu61ByIeEFzWynOitU
	 G3qbTwHNNUCBX1whIQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MqZQS-1xQePB36Vk-00l297; Mon, 29
 Jun 2026 09:16:25 +0200
Message-ID: <7360cab3-7a2f-4903-85f1-0f03387b0d88@web.de>
Date: Mon, 29 Jun 2026 09:16:09 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2] block: partitions: Use seq_buf_putc() at 24 places
To: linux-block@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-s390@vger.kernel.org,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
 Davidlohr Bueso <dave@stgolabs.net>, =?UTF-8?Q?Jan_H=C3=B6ppner?=
 <hoeppner@linux.ibm.com>, Jens Axboe <axboe@kernel.dk>,
 Josh Law <objecting@objecting.org>, Kees Cook <kees@kernel.org>,
 Md Haris Iqbal <haris.iqbal@linux.dev>, Richard Russon <ldm@flatcap.org>,
 Stefan Haberland <sth@linux.ibm.com>, Thorsten Blum
 <thorsten.blum@linux.dev>, vulab@iscas.ac.cn
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>,
 Woradorn Laodhanadhaworn <woradorn.laon@gmail.com>
References: <59dfd2ef-2fda-4dd0-a288-52c35613e778@web.de>
 <ajzkRM_RFKBpp0i5@ashevche-desk.local>
 <7de415a7-457d-4dd2-aebb-8e179fa0bbcd@web.de>
 <aj061omzs5WN5ar6@ashevche-desk.local>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <aj061omzs5WN5ar6@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:w8jtQAYQ1NAaWWY23ACDYv0h/mSFFVOm25FhZNO/QPMwvlbgK5y
 X8/k3JoYfaQvKJTAaWRS5ps03G+wkGq0VyvYwDCkV6FXGg4bEYsQUsjVneVPVncb7wdm0jn
 Uw+DKFnCCE6j/kIBI8oFMJwyUXb50mCjsfrdkN9cbq1jtRXI9BjLsgknvgm8px0iN2XXx6W
 onbJ9jUAv/eq67Xc+yv0g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hEHrZiNWPOs=;NqTVGUTR8W6fD1qsG6y+wFHL8rq
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 29 Jun 2026 08:10:24 +0200

Single line breaks should occasionally be put into a sequence buffer.
Thus use the seq_buf_putc() function in these implementations.

The source code was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--

v2:
* Andy Shevchenko requested to preserve two blank lines.

* The source code transformation was extended to all affected places
  for this software area.


 block/partitions/acorn.c   |  8 ++++----
 block/partitions/amiga.c   |  2 +-
 block/partitions/atari.c   |  2 +-
 block/partitions/cmdline.c |  2 +-
 block/partitions/efi.c     |  2 +-
 block/partitions/ibm.c     | 10 +++++-----
 block/partitions/karma.c   |  2 +-
 block/partitions/ldm.c     |  2 +-
 block/partitions/mac.c     |  2 +-
 block/partitions/msdos.c   |  4 ++--
 block/partitions/of.c      |  2 +-
 block/partitions/osf.c     |  2 +-
 block/partitions/sgi.c     |  2 +-
 block/partitions/sun.c     |  2 +-
 block/partitions/sysv68.c  |  2 +-
 block/partitions/ultrix.c  |  2 +-
 16 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/block/partitions/acorn.c b/block/partitions/acorn.c
index 067d6a27a3bd..c48250517448 100644
=2D-- a/block/partitions/acorn.c
+++ b/block/partitions/acorn.c
@@ -290,7 +290,7 @@ int adfspart_check_ADFS(struct parsed_partitions *stat=
e)
 			break;
 		}
 	}
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
 	return 1;
 }
 #endif
@@ -397,7 +397,7 @@ int adfspart_check_ICS(struct parsed_partitions *state=
)
 	}
=20
 	put_dev_sector(sect);
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
 	return 1;
 }
 #endif
@@ -468,7 +468,7 @@ int adfspart_check_POWERTEC(struct parsed_partitions *=
state)
 	}
=20
 	put_dev_sector(sect);
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
 	return 1;
 }
 #endif
@@ -539,7 +539,7 @@ int adfspart_check_EESOX(struct parsed_partitions *sta=
te)
=20
 		size =3D get_capacity(state->disk);
 		put_partition(state, slot++, start, size - start);
-		seq_buf_puts(&state->pp_buf, "\n");
+		seq_buf_putc(&state->pp_buf, '\n');
 	}
=20
 	return i ? 1 : 0;
diff --git a/block/partitions/amiga.c b/block/partitions/amiga.c
index 8325046a14eb..a272f64450ec 100644
=2D-- a/block/partitions/amiga.c
+++ b/block/partitions/amiga.c
@@ -194,7 +194,7 @@ int amiga_partition(struct parsed_partitions *state)
 		}
 		res =3D 1;
 	}
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
=20
 rdb_done:
 	return res;
diff --git a/block/partitions/atari.c b/block/partitions/atari.c
index 2438d1448f38..58863c1a2723 100644
=2D-- a/block/partitions/atari.c
+++ b/block/partitions/atari.c
@@ -150,7 +150,7 @@ int atari_partition(struct parsed_partitions *state)
 #endif
 	put_dev_sector(sect);
=20
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
=20
 	return 1;
 }
diff --git a/block/partitions/cmdline.c b/block/partitions/cmdline.c
index 4fd52ed154b4..50075eccaade 100644
=2D-- a/block/partitions/cmdline.c
+++ b/block/partitions/cmdline.c
@@ -377,7 +377,7 @@ int cmdline_partition(struct parsed_partitions *state)
 	cmdline_parts_set(parts, disk_size, state);
 	cmdline_parts_verifier(1, state);
=20
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
=20
 	return 1;
 }
diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 9865d59093fa..650b91efc832 100644
=2D-- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -751,6 +751,6 @@ int efi_partition(struct parsed_partitions *state)
 	}
 	kfree(ptes);
 	kfree(gpt);
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
 	return 1;
 }
diff --git a/block/partitions/ibm.c b/block/partitions/ibm.c
index 54047e722a9d..a57de3b192fc 100644
=2D-- a/block/partitions/ibm.c
+++ b/block/partitions/ibm.c
@@ -217,7 +217,7 @@ static int find_vol1_partitions(struct parsed_partitio=
ns *state,
 		blk++;
 		data =3D read_part_sector(state, blk * secperblk, &sect);
 	}
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
=20
 	if (!data)
 		return -1;
@@ -254,7 +254,7 @@ static int find_lnx1_partitions(struct parsed_partitio=
ns *state,
 		size =3D nr_sectors;
 		if (size !=3D geo_size) {
 			if (!info) {
-				seq_buf_puts(&state->pp_buf, "\n");
+				seq_buf_putc(&state->pp_buf, '\n');
 				return 1;
 			}
 			if (!strcmp(info->type, "ECKD"))
@@ -266,7 +266,7 @@ static int find_lnx1_partitions(struct parsed_partitio=
ns *state,
 	/* first and only partition starts in the first block after the label */
 	offset =3D labelsect + secperblk;
 	put_partition(state, 1, offset, size - offset);
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
 	return 1;
 }
=20
@@ -307,7 +307,7 @@ static int find_cms1_partitions(struct parsed_partitio=
ns *state,
 	}
=20
 	put_partition(state, 1, offset, size-offset);
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
 	return 1;
 }
=20
@@ -388,7 +388,7 @@ int ibm_partition(struct parsed_partitions *state)
 			size =3D nr_sectors;
 			offset =3D (info->label_block + 1) * (blocksize >> 9);
 			put_partition(state, 1, offset, size-offset);
-			seq_buf_puts(&state->pp_buf, "\n");
+			seq_buf_putc(&state->pp_buf, '\n');
 		}
 	} else
 		res =3D 0;
diff --git a/block/partitions/karma.c b/block/partitions/karma.c
index a4e3c5050177..b0ab84169538 100644
=2D-- a/block/partitions/karma.c
+++ b/block/partitions/karma.c
@@ -53,7 +53,7 @@ int karma_partition(struct parsed_partitions *state)
 		}
 		slot++;
 	}
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
 	put_dev_sector(sect);
 	return 1;
 }
diff --git a/block/partitions/ldm.c b/block/partitions/ldm.c
index c0bdcae58a3e..d1bbc9fb09f9 100644
=2D-- a/block/partitions/ldm.c
+++ b/block/partitions/ldm.c
@@ -597,7 +597,7 @@ static bool ldm_create_data_partitions (struct parsed_=
partitions *pp,
 		part_num++;
 	}
=20
-	seq_buf_puts(&pp->pp_buf, "\n");
+	seq_buf_putc(&pp->pp_buf, '\n');
 	return true;
 }
=20
diff --git a/block/partitions/mac.c b/block/partitions/mac.c
index df03ca428e15..bb570b5a6eaa 100644
=2D-- a/block/partitions/mac.c
+++ b/block/partitions/mac.c
@@ -152,6 +152,6 @@ int mac_partition(struct parsed_partitions *state)
 #endif
=20
 	put_dev_sector(sect);
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
 	return 1;
 }
diff --git a/block/partitions/msdos.c b/block/partitions/msdos.c
index 200ea53ea6a2..4a96541f5351 100644
=2D-- a/block/partitions/msdos.c
+++ b/block/partitions/msdos.c
@@ -608,7 +608,7 @@ int msdos_partition(struct parsed_partitions *state)
 			fb =3D (struct fat_boot_sector *) data;
 			if (slot =3D=3D 1 && fb->reserved && fb->fats
 				&& fat_valid_media(fb->media)) {
-				seq_buf_puts(&state->pp_buf, "\n");
+				seq_buf_putc(&state->pp_buf, '\n');
 				put_dev_sector(sect);
 				return 1;
 			} else {
@@ -672,7 +672,7 @@ int msdos_partition(struct parsed_partitions *state)
 			seq_buf_puts(&state->pp_buf, "[EZD]");
 	}
=20
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
=20
 	/* second pass - output for each on a separate line */
 	p =3D (struct msdos_partition *) (0x1be + data);
diff --git a/block/partitions/of.c b/block/partitions/of.c
index 53664ea06b65..7803e6f4ecdd 100644
=2D-- a/block/partitions/of.c
+++ b/block/partitions/of.c
@@ -104,7 +104,7 @@ int of_partition(struct parsed_partitions *state)
 		slot++;
 	}
=20
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
=20
 	of_node_put(partitions_np);
 	return 1;
diff --git a/block/partitions/osf.c b/block/partitions/osf.c
index 2a692584dba9..6f83d4759a5d 100644
=2D-- a/block/partitions/osf.c
+++ b/block/partitions/osf.c
@@ -81,7 +81,7 @@ int osf_partition(struct parsed_partitions *state)
 				le32_to_cpu(partition->p_size));
 		slot++;
 	}
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
 	put_dev_sector(sect);
 	return 1;
 }
diff --git a/block/partitions/sgi.c b/block/partitions/sgi.c
index 2383ca63cd66..f743e3583417 100644
=2D-- a/block/partitions/sgi.c
+++ b/block/partitions/sgi.c
@@ -79,7 +79,7 @@ int sgi_partition(struct parsed_partitions *state)
 		}
 		slot++;
 	}
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
 	put_dev_sector(sect);
 	return 1;
 }
diff --git a/block/partitions/sun.c b/block/partitions/sun.c
index 92c645fcd2e0..c71bad78f34a 100644
=2D-- a/block/partitions/sun.c
+++ b/block/partitions/sun.c
@@ -121,7 +121,7 @@ int sun_partition(struct parsed_partitions *state)
 		}
 		slot++;
 	}
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
 	put_dev_sector(sect);
 	return 1;
 }
diff --git a/block/partitions/sysv68.c b/block/partitions/sysv68.c
index 470e0f9de7be..31d348ac2dfb 100644
=2D-- a/block/partitions/sysv68.c
+++ b/block/partitions/sysv68.c
@@ -86,7 +86,7 @@ int sysv68_partition(struct parsed_partitions *state)
 		}
 		slot++;
 	}
-	seq_buf_puts(&state->pp_buf, "\n");
+	seq_buf_putc(&state->pp_buf, '\n');
 	put_dev_sector(sect);
 	return 1;
 }
diff --git a/block/partitions/ultrix.c b/block/partitions/ultrix.c
index b4b9ddc57a5d..8ac42fda25d1 100644
=2D-- a/block/partitions/ultrix.c
+++ b/block/partitions/ultrix.c
@@ -39,7 +39,7 @@ int ultrix_partition(struct parsed_partitions *state)
 					      label->pt_part[i].pi_blkoff,
 					      label->pt_part[i].pi_nblocks);
 		put_dev_sector(sect);
-		seq_buf_puts(&state->pp_buf, "\n");
+		seq_buf_putc(&state->pp_buf, '\n');
 		return 1;
 	} else {
 		put_dev_sector(sect);
=2D-=20
2.54.0

