Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B419318BA8
	for <linux-efi@vger.kernel.org>; Sat, 21 Mar 2026 15:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774106656; cv=none; b=cnoYndPan6J3qoIjJFmbi1Wk5OXFde3YXK3C1m7VfJibyaV+nwWp3Z82F/z5kspaS0DMyxpOGFzNpLGpKFRzCwPA9ynNCcI7PlN/E3lSm0q8xExUWm3M3+UNHyNdQoaK8OUkW/FVj3/CTS/eLJK3zxsdxjc42FuMJDP/HMQApxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774106656; c=relaxed/simple;
	bh=qV6tZJAvSa4HGPzx0gQcTds97M3x8wBjTYQD7Geffnk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hegbzqlFQWw9w3ATKG8xo2K2LLeknWbH8wWjmtfKlEOb8Yfp4wbBkAg9xPb3j2NvKhAEFeKTRwBT2AdutcOL0E0J1JXPUH7+/V6g07lRU4WaUHVr8xEnUHyJg3+Af9qleDJqelGbw5gHdpzYdxaOtxQDBNsoPOniPXgMOrWxNLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gUEyQWcf; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gUEyQWcf"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43b4d73463dso963495f8f.3
        for <linux-efi@vger.kernel.org>; Sat, 21 Mar 2026 08:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774106652; x=1774711452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eg4DqMnCwunAySdMszbObeXDZehbQraNCqk6XqRqW+4=;
        b=gUEyQWcf8wn882c45J8WM/+sg10GaYmTZKEGh+p8LxR8fa2zO1G8yaqfY2Pe9Be/KF
         rwRNW6FovD3D/VjQsY3G1hdjc6SutQ8MAGNhXgWjgwOLZjaXtLgejA+LiKLTY2mBii42
         nddQdC3tng5s8IUQdB36d25qaOdDLy4S9V7giJG9g5biJFLxd2uo50IuPuqHt3I3TukL
         Jehw6iPPqLa4ueVSpbH4097Qy6WPj7HbxI0U5P45DjE33tV1+1SpSwKkj4TeZnf6btmk
         sEo+IjfqhN6ST8jHDG3SyuoDcHVhWtQ3HC9Q6s/qIaR8glq8O810AqP8e8sFJKPN9M7B
         Ssow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774106652; x=1774711452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Eg4DqMnCwunAySdMszbObeXDZehbQraNCqk6XqRqW+4=;
        b=GM3+/9v5yBKyGsdeX+KP3d9Dp3K/LBmX9LkrJKbbNrxiKHmjOuXQUt9r3b//ttq6y7
         r+1skW1nCfaoK0hc5sSY0SnyOYJHV5kTVBBPcp4qyRlciqKt7imGhguvcDSBgJh2PlO8
         xdUH7odRQsF6XIn4hmKxfnjROwas+PU+wDcEzRO/tBqJRW+f9mOpyKWEpwHO2V2l6dRX
         A3ngtYRPRr4cu/7sV8+IIL9ZxwMZF5S406/PLiTAn+R57YhlcGjt5XQ2wyU0IH5xpMgj
         S0toCQrGYFMvs4T88cmqEeGJmwnTNQ6+mgESQ+pqipph+DdQEtWh7uPXQEyWm0zDUeaN
         tsIg==
X-Forwarded-Encrypted: i=1; AJvYcCUDZkCBsKOHPB3TTJfGO77ot4Qun+o4q+0QrL+02VclzcAJXxRM2TCHD81aAVenAebo7+JNW9dfdBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YztzaqqIzsCcsd7lA8O7l97SqlkeHnjGxarjgZZtqSQYC08ZWRQ
	9KuZsS/ggoGAa+LL7jnV+lQfPAKcjh6Y2xCf6L9rXo/esBCgmZ4x8rAC
X-Gm-Gg: ATEYQzyC+9mZzei4KwF7kgpfGnqUHaD+UawLuIgCy4lV7uqVzc5C40aS0i+tD0x2bzK
	zz5uUZ5Rgb6WyAXztYc/kz7cODSuXwZ8XmLBMCj8MlGLmqDFT5nuFT9KSFPaG+PSljHoBmn9q93
	3gaNyT4Y2W5tD5kqhqWT2xDERuAdFZw8GHkepRCI/SUujEHnCzoH+++r8M4o1xyS1HU4tNKbM8z
	2hDOorC1q97JojTlQ/nyvmIte3WGjbSE3CJEdato4RYnqI+juh3ynjZkodFrqqhA5bEmf6SlbjO
	7ICJrDgQycSiUNW1rbcZ6SKULhVx2CRclpsBpLuMd6xqrG4moRK2LWnHbX7whO9ljLCPE1ej2I3
	xPnGYKHPlSfwWTXTSa78/BgdieoMAt5JKzTp0hcGbSKmZmvWniYnQ0dttVPbhnHVtyrSpFucQ19
	EWKNSfDO0YiM7Uzh7mp44LKwdpRBXbFtiTDiA3V4NfpmbfeOuhkO1AG7or2Ic+QUnU
X-Received: by 2002:a05:6000:4024:b0:439:afc1:ec64 with SMTP id ffacd0b85a97d-43b6428ae1cmr10497502f8f.53.1774106651335;
        Sat, 21 Mar 2026 08:24:11 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b64703650sm14134617f8f.20.2026.03.21.08.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:24:10 -0700 (PDT)
Date: Sat, 21 Mar 2026 15:24:08 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Kees Cook <kees@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Josh Law
 <objecting@objecting.org>, Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso
 <dave@stgolabs.net>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner
 <hoeppner@linux.ibm.com>, "Richard Russon (FlatCap)" <ldm@flatcap.org>,
 Thorsten Blum <thorsten.blum@linux.dev>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
 linux-hardening@vger.kernel.org
Subject: Re: [PATCH] block: partitions: Replace pp_buf with struct seq_buf
Message-ID: <20260321152408.329cc48c@pumpkin>
In-Reply-To: <20260321004840.work.670-kees@kernel.org>
References: <20260321004840.work.670-kees@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Mar 2026 17:48:44 -0700
Kees Cook <kees@kernel.org> wrote:

> In preparation for removing the strlcat API[1], replace the char *pp_buf
> with a struct seq_buf, which tracks the current write position and
> remaining space internally. This allows for:
> 
> - Direct use of seq_buf_printf() in place of snprintf()+strlcat()
>   pairs, eliminating local tmp buffers throughout.

and repeated scanning of the output buffer.

> - Adjacent strlcat() calls that build strings piece-by-piece
>   (e.g., strlcat("["); strlcat(name); strlcat("]")) to be collapsed
>   into single seq_buf_printf() calls.
> - Simpler call sites: seq_buf_puts() takes only the buffer and string,
>   with no need to pass PAGE_SIZE at every call.
> 
> The backing buffer allocation is unchanged (__get_free_page),

It might make sens to change that at the same time.
I'm not sure how big it needs to be either, 4k is a lot, 64k stupid.
Indeed, since the structure that contains the pointer is kmalloced
then just using an inlined array is probably enough.
Although the size would need to be a bit smaller to keep the kmalloc()
call below 4k (or even 2k - I'm sure that would be plenty...)

In any case the buffer can be allocated by alloc_partitions().

One further comment below.
But does all look a good idea to me.

> and the
> output path uses seq_buf_str() to NUL-terminate before passing to
> printk().
> 
> Link: https://github.com/KSPP/linux/issues/370 [1]
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Josh Law <objecting@objecting.org>
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> I couldn't help myself. Here's the full patch, as I suggested in
> https://lore.kernel.org/lkml/202603201230.74BBFFABAD@keescook/
> There are plenty more like this to do...
> ---
>  block/partitions/check.h   |  8 ++---
>  block/partitions/core.c    | 20 ++++++------
>  block/partitions/acorn.c   | 32 ++++++++----------
>  block/partitions/aix.c     | 21 +++++-------
>  block/partitions/amiga.c   | 35 +++++++++-----------
>  block/partitions/atari.c   | 12 +++----
>  block/partitions/cmdline.c |  6 ++--
>  block/partitions/efi.c     |  2 +-
>  block/partitions/ibm.c     | 27 ++++++---------
>  block/partitions/karma.c   |  2 +-
>  block/partitions/ldm.c     |  4 +--
>  block/partitions/mac.c     |  4 +--
>  block/partitions/msdos.c   | 67 +++++++++++++-------------------------
>  block/partitions/of.c      |  6 ++--
>  block/partitions/osf.c     |  2 +-
>  block/partitions/sgi.c     |  2 +-
>  block/partitions/sun.c     |  2 +-
>  block/partitions/sysv68.c  |  9 ++---
>  block/partitions/ultrix.c  |  2 +-
>  19 files changed, 106 insertions(+), 157 deletions(-)
> 
> diff --git a/block/partitions/check.h b/block/partitions/check.h
> index e5c1c61eb353..b0997467b61a 100644
> --- a/block/partitions/check.h
> +++ b/block/partitions/check.h
> @@ -1,6 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #include <linux/pagemap.h>
>  #include <linux/blkdev.h>
> +#include <linux/seq_buf.h>
>  #include "../blk.h"
>  
>  /*
> @@ -20,7 +21,7 @@ struct parsed_partitions {
>  	int next;
>  	int limit;
>  	bool access_beyond_eod;
> -	char *pp_buf;
> +	struct seq_buf pp_buf;
>  };
>  
>  typedef struct {
> @@ -37,12 +38,9 @@ static inline void
>  put_partition(struct parsed_partitions *p, int n, sector_t from, sector_t size)
>  {
>  	if (n < p->limit) {
> -		char tmp[1 + BDEVNAME_SIZE + 10 + 1];
> -
>  		p->parts[n].from = from;
>  		p->parts[n].size = size;
> -		snprintf(tmp, sizeof(tmp), " %s%d", p->name, n);
> -		strlcat(p->pp_buf, tmp, PAGE_SIZE);
> +		seq_buf_printf(&p->pp_buf, " %s%d", p->name, n);
>  	}
>  }
>  
> diff --git a/block/partitions/core.c b/block/partitions/core.c
> index 740228750aaf..3b5928836c69 100644
> --- a/block/partitions/core.c
> +++ b/block/partitions/core.c
> @@ -123,16 +123,16 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
>  	state = allocate_partitions(hd);
>  	if (!state)
>  		return NULL;
> -	state->pp_buf = (char *)__get_free_page(GFP_KERNEL);
> -	if (!state->pp_buf) {
> +	state->pp_buf.buffer = (char *)__get_free_page(GFP_KERNEL);
> +	if (!state->pp_buf.buffer) {
>  		free_partitions(state);
>  		return NULL;
>  	}
> -	state->pp_buf[0] = '\0';
> +	seq_buf_init(&state->pp_buf, state->pp_buf.buffer, PAGE_SIZE);
>  
>  	state->disk = hd;
>  	strscpy(state->name, hd->disk_name);
> -	snprintf(state->pp_buf, PAGE_SIZE, " %s:", state->name);
> +	seq_buf_printf(&state->pp_buf, " %s:", state->name);
>  	if (isdigit(state->name[strlen(state->name)-1]))
>  		sprintf(state->name, "p");
>  
> @@ -151,9 +151,9 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
>  
>  	}
>  	if (res > 0) {
> -		printk(KERN_INFO "%s", state->pp_buf);
> +		printk(KERN_INFO "%s", seq_buf_str(&state->pp_buf));
>  
> -		free_page((unsigned long)state->pp_buf);
> +		free_page((unsigned long)state->pp_buf.buffer);
>  		return state;
>  	}
>  	if (state->access_beyond_eod)
> @@ -164,12 +164,12 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
>  	if (err)
>  		res = err;
>  	if (res) {
> -		strlcat(state->pp_buf,
> -			" unable to read partition table\n", PAGE_SIZE);
> -		printk(KERN_INFO "%s", state->pp_buf);
> +		seq_buf_puts(&state->pp_buf,
> +			     " unable to read partition table\n");
> +		printk(KERN_INFO "%s", seq_buf_str(&state->pp_buf));

Just put the string in the printk format:
		printk(KERN_INFO "%s unable to read partition table\n",
			seq_buf_str(&state->pp_buf));
Although I'm not sure that embedded '\n' get handled sensibly.

	David

>  	}
>  
> -	free_page((unsigned long)state->pp_buf);
> +	free_page((unsigned long)state->pp_buf.buffer);
>  	free_partitions(state);
>  	return ERR_PTR(res);
>  }
> diff --git a/block/partitions/acorn.c b/block/partitions/acorn.c
> index d2fc122d7426..9f7389f174d0 100644
> --- a/block/partitions/acorn.c
> +++ b/block/partitions/acorn.c
> @@ -40,9 +40,7 @@ adfs_partition(struct parsed_partitions *state, char *name, char *data,
>  		   (le32_to_cpu(dr->disc_size) >> 9);
>  
>  	if (name) {
> -		strlcat(state->pp_buf, " [", PAGE_SIZE);
> -		strlcat(state->pp_buf, name, PAGE_SIZE);
> -		strlcat(state->pp_buf, "]", PAGE_SIZE);
> +		seq_buf_printf(&state->pp_buf, " [%s]", name);
>  	}
>  	put_partition(state, slot, first_sector, nr_sects);
>  	return dr;
> @@ -78,14 +76,14 @@ static int riscix_partition(struct parsed_partitions *state,
>  	if (!rr)
>  		return -1;
>  
> -	strlcat(state->pp_buf, " [RISCiX]", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, " [RISCiX]");
>  
>  
>  	if (rr->magic == RISCIX_MAGIC) {
>  		unsigned long size = nr_sects > 2 ? 2 : nr_sects;
>  		int part;
>  
> -		strlcat(state->pp_buf, " <", PAGE_SIZE);
> +		seq_buf_puts(&state->pp_buf, " <");
>  
>  		put_partition(state, slot++, first_sect, size);
>  		for (part = 0; part < 8; part++) {
> @@ -94,13 +92,11 @@ static int riscix_partition(struct parsed_partitions *state,
>  				put_partition(state, slot++,
>  					le32_to_cpu(rr->part[part].start),
>  					le32_to_cpu(rr->part[part].length));
> -				strlcat(state->pp_buf, "(", PAGE_SIZE);
> -				strlcat(state->pp_buf, rr->part[part].name, PAGE_SIZE);
> -				strlcat(state->pp_buf, ")", PAGE_SIZE);
> +				seq_buf_printf(&state->pp_buf, "(%s)", rr->part[part].name);
>  			}
>  		}
>  
> -		strlcat(state->pp_buf, " >\n", PAGE_SIZE);
> +		seq_buf_puts(&state->pp_buf, " >\n");
>  	} else {
>  		put_partition(state, slot++, first_sect, nr_sects);
>  	}
> @@ -130,7 +126,7 @@ static int linux_partition(struct parsed_partitions *state,
>  	struct linux_part *linuxp;
>  	unsigned long size = nr_sects > 2 ? 2 : nr_sects;
>  
> -	strlcat(state->pp_buf, " [Linux]", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, " [Linux]");
>  
>  	put_partition(state, slot++, first_sect, size);
>  
> @@ -138,7 +134,7 @@ static int linux_partition(struct parsed_partitions *state,
>  	if (!linuxp)
>  		return -1;
>  
> -	strlcat(state->pp_buf, " <", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, " <");
>  	while (linuxp->magic == cpu_to_le32(LINUX_NATIVE_MAGIC) ||
>  	       linuxp->magic == cpu_to_le32(LINUX_SWAP_MAGIC)) {
>  		if (slot == state->limit)
> @@ -148,7 +144,7 @@ static int linux_partition(struct parsed_partitions *state,
>  				 le32_to_cpu(linuxp->nr_sects));
>  		linuxp ++;
>  	}
> -	strlcat(state->pp_buf, " >", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, " >");
>  
>  	put_dev_sector(sect);
>  	return slot;
> @@ -293,7 +289,7 @@ int adfspart_check_ADFS(struct parsed_partitions *state)
>  			break;
>  		}
>  	}
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  	return 1;
>  }
>  #endif
> @@ -366,7 +362,7 @@ int adfspart_check_ICS(struct parsed_partitions *state)
>  		return 0;
>  	}
>  
> -	strlcat(state->pp_buf, " [ICS]", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, " [ICS]");
>  
>  	for (slot = 1, p = (const struct ics_part *)data; p->size; p++) {
>  		u32 start = le32_to_cpu(p->start);
> @@ -400,7 +396,7 @@ int adfspart_check_ICS(struct parsed_partitions *state)
>  	}
>  
>  	put_dev_sector(sect);
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  	return 1;
>  }
>  #endif
> @@ -460,7 +456,7 @@ int adfspart_check_POWERTEC(struct parsed_partitions *state)
>  		return 0;
>  	}
>  
> -	strlcat(state->pp_buf, " [POWERTEC]", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, " [POWERTEC]");
>  
>  	for (i = 0, p = (const struct ptec_part *)data; i < 12; i++, p++) {
>  		u32 start = le32_to_cpu(p->start);
> @@ -471,7 +467,7 @@ int adfspart_check_POWERTEC(struct parsed_partitions *state)
>  	}
>  
>  	put_dev_sector(sect);
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  	return 1;
>  }
>  #endif
> @@ -542,7 +538,7 @@ int adfspart_check_EESOX(struct parsed_partitions *state)
>  
>  		size = get_capacity(state->disk);
>  		put_partition(state, slot++, start, size - start);
> -		strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +		seq_buf_puts(&state->pp_buf, "\n");
>  	}
>  
>  	return i ? 1 : 0;
> diff --git a/block/partitions/aix.c b/block/partitions/aix.c
> index a886cefbefbb..29b8f4cebb63 100644
> --- a/block/partitions/aix.c
> +++ b/block/partitions/aix.c
> @@ -173,24 +173,22 @@ int aix_partition(struct parsed_partitions *state)
>  	if (d) {
>  		struct lvm_rec *p = (struct lvm_rec *)d;
>  		u16 lvm_version = be16_to_cpu(p->version);
> -		char tmp[64];
>  
>  		if (lvm_version == 1) {
>  			int pp_size_log2 = be16_to_cpu(p->pp_size);
>  
>  			pp_bytes_size = 1 << pp_size_log2;
>  			pp_blocks_size = pp_bytes_size / 512;
> -			snprintf(tmp, sizeof(tmp),
> -				" AIX LVM header version %u found\n",
> -				lvm_version);
> +			seq_buf_printf(&state->pp_buf,
> +				       " AIX LVM header version %u found\n",
> +				       lvm_version);
>  			vgda_len = be32_to_cpu(p->vgda_len);
>  			vgda_sector = be32_to_cpu(p->vgda_psn[0]);
>  		} else {
> -			snprintf(tmp, sizeof(tmp),
> -				" unsupported AIX LVM version %d found\n",
> -				lvm_version);
> +			seq_buf_printf(&state->pp_buf,
> +				       " unsupported AIX LVM version %d found\n",
> +				       lvm_version);
>  		}
> -		strlcat(state->pp_buf, tmp, PAGE_SIZE);
>  		put_dev_sector(sect);
>  	}
>  	if (vgda_sector && (d = read_part_sector(state, vgda_sector, &sect))) {
> @@ -251,14 +249,11 @@ int aix_partition(struct parsed_partitions *state)
>  				continue;
>  			}
>  			if (lp_ix == lvip[lv_ix].pps_per_lv) {
> -				char tmp[70];
> -
>  				put_partition(state, lv_ix + 1,
>  				  (i + 1 - lp_ix) * pp_blocks_size + psn_part1,
>  				  lvip[lv_ix].pps_per_lv * pp_blocks_size);
> -				snprintf(tmp, sizeof(tmp), " <%s>\n",
> -					 n[lv_ix].name);
> -				strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +				seq_buf_printf(&state->pp_buf, " <%s>\n",
> +					       n[lv_ix].name);
>  				lvip[lv_ix].lv_is_contiguous = 1;
>  				ret = 1;
>  				next_lp_ix = 1;
> diff --git a/block/partitions/amiga.c b/block/partitions/amiga.c
> index 506921095412..8325046a14eb 100644
> --- a/block/partitions/amiga.c
> +++ b/block/partitions/amiga.c
> @@ -81,13 +81,8 @@ int amiga_partition(struct parsed_partitions *state)
>  	/* blksize is blocks per 512 byte standard block */
>  	blksize = be32_to_cpu( rdb->rdb_BlockBytes ) / 512;
>  
> -	{
> -		char tmp[7 + 10 + 1 + 1];
> -
> -		/* Be more informative */
> -		snprintf(tmp, sizeof(tmp), " RDSK (%d)", blksize * 512);
> -		strlcat(state->pp_buf, tmp, PAGE_SIZE);
> -	}
> +	/* Be more informative */
> +	seq_buf_printf(&state->pp_buf, " RDSK (%d)", blksize * 512);
>  	blk = be32_to_cpu(rdb->rdb_PartitionList);
>  	put_dev_sector(sect);
>  	for (part = 1; (s32) blk>0 && part<=16; part++, put_dev_sector(sect)) {
> @@ -179,27 +174,27 @@ int amiga_partition(struct parsed_partitions *state)
>  		{
>  			/* Be even more informative to aid mounting */
>  			char dostype[4];
> -			char tmp[42];
>  
>  			__be32 *dt = (__be32 *)dostype;
>  			*dt = pb->pb_Environment[16];
>  			if (dostype[3] < ' ')
> -				snprintf(tmp, sizeof(tmp), " (%c%c%c^%c)",
> -					dostype[0], dostype[1],
> -					dostype[2], dostype[3] + '@' );
> +				seq_buf_printf(&state->pp_buf,
> +					       " (%c%c%c^%c)",
> +					       dostype[0], dostype[1],
> +					       dostype[2],
> +					       dostype[3] + '@');
>  			else
> -				snprintf(tmp, sizeof(tmp), " (%c%c%c%c)",
> -					dostype[0], dostype[1],
> -					dostype[2], dostype[3]);
> -			strlcat(state->pp_buf, tmp, PAGE_SIZE);
> -			snprintf(tmp, sizeof(tmp), "(res %d spb %d)",
> -				be32_to_cpu(pb->pb_Environment[6]),
> -				be32_to_cpu(pb->pb_Environment[4]));
> -			strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +				seq_buf_printf(&state->pp_buf,
> +					       " (%c%c%c%c)",
> +					       dostype[0], dostype[1],
> +					       dostype[2], dostype[3]);
> +			seq_buf_printf(&state->pp_buf, "(res %d spb %d)",
> +				       be32_to_cpu(pb->pb_Environment[6]),
> +				       be32_to_cpu(pb->pb_Environment[4]));
>  		}
>  		res = 1;
>  	}
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  
>  rdb_done:
>  	return res;
> diff --git a/block/partitions/atari.c b/block/partitions/atari.c
> index 9655c728262a..2438d1448f38 100644
> --- a/block/partitions/atari.c
> +++ b/block/partitions/atari.c
> @@ -70,7 +70,7 @@ int atari_partition(struct parsed_partitions *state)
>  	}
>  
>  	pi = &rs->part[0];
> -	strlcat(state->pp_buf, " AHDI", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, " AHDI");
>  	for (slot = 1; pi < &rs->part[4] && slot < state->limit; slot++, pi++) {
>  		struct rootsector *xrs;
>  		Sector sect2;
> @@ -89,7 +89,7 @@ int atari_partition(struct parsed_partitions *state)
>  #ifdef ICD_PARTS
>  		part_fmt = 1;
>  #endif
> -		strlcat(state->pp_buf, " XGM<", PAGE_SIZE);
> +		seq_buf_puts(&state->pp_buf, " XGM<");
>  		partsect = extensect = be32_to_cpu(pi->st);
>  		while (1) {
>  			xrs = read_part_sector(state, partsect, &sect2);
> @@ -128,14 +128,14 @@ int atari_partition(struct parsed_partitions *state)
>  				break;
>  			}
>  		}
> -		strlcat(state->pp_buf, " >", PAGE_SIZE);
> +		seq_buf_puts(&state->pp_buf, " >");
>  	}
>  #ifdef ICD_PARTS
>  	if ( part_fmt!=1 ) { /* no extended partitions -> test ICD-format */
>  		pi = &rs->icdpart[0];
>  		/* sanity check: no ICD format if first partition invalid */
>  		if (OK_id(pi->id)) {
> -			strlcat(state->pp_buf, " ICD<", PAGE_SIZE);
> +			seq_buf_puts(&state->pp_buf, " ICD<");
>  			for (; pi < &rs->icdpart[8] && slot < state->limit; slot++, pi++) {
>  				/* accept only GEM,BGM,RAW,LNX,SWP partitions */
>  				if (!((pi->flg & 1) && OK_id(pi->id)))
> @@ -144,13 +144,13 @@ int atari_partition(struct parsed_partitions *state)
>  						be32_to_cpu(pi->st),
>  						be32_to_cpu(pi->siz));
>  			}
> -			strlcat(state->pp_buf, " >", PAGE_SIZE);
> +			seq_buf_puts(&state->pp_buf, " >");
>  		}
>  	}
>  #endif
>  	put_dev_sector(sect);
>  
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  
>  	return 1;
>  }
> diff --git a/block/partitions/cmdline.c b/block/partitions/cmdline.c
> index a2b1870c3fd4..4fd52ed154b4 100644
> --- a/block/partitions/cmdline.c
> +++ b/block/partitions/cmdline.c
> @@ -229,7 +229,6 @@ static int add_part(int slot, struct cmdline_subpart *subpart,
>  		struct parsed_partitions *state)
>  {
>  	struct partition_meta_info *info;
> -	char tmp[sizeof(info->volname) + 4];
>  
>  	if (slot >= state->limit)
>  		return 1;
> @@ -244,8 +243,7 @@ static int add_part(int slot, struct cmdline_subpart *subpart,
>  
>  	strscpy(info->volname, subpart->name, sizeof(info->volname));
>  
> -	snprintf(tmp, sizeof(tmp), "(%s)", info->volname);
> -	strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +	seq_buf_printf(&state->pp_buf, "(%s)", info->volname);
>  
>  	state->parts[slot].has_info = true;
>  
> @@ -379,7 +377,7 @@ int cmdline_partition(struct parsed_partitions *state)
>  	cmdline_parts_set(parts, disk_size, state);
>  	cmdline_parts_verifier(1, state);
>  
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  
>  	return 1;
>  }
> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index 75474fb3848e..9865d59093fa 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -751,6 +751,6 @@ int efi_partition(struct parsed_partitions *state)
>  	}
>  	kfree(ptes);
>  	kfree(gpt);
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  	return 1;
>  }
> diff --git a/block/partitions/ibm.c b/block/partitions/ibm.c
> index 9311ad5fb95d..54047e722a9d 100644
> --- a/block/partitions/ibm.c
> +++ b/block/partitions/ibm.c
> @@ -173,15 +173,13 @@ static int find_vol1_partitions(struct parsed_partitions *state,
>  {
>  	sector_t blk;
>  	int counter;
> -	char tmp[64];
>  	Sector sect;
>  	unsigned char *data;
>  	loff_t offset, size;
>  	struct vtoc_format1_label f1;
>  	int secperblk;
>  
> -	snprintf(tmp, sizeof(tmp), "VOL1/%8s:", name);
> -	strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +	seq_buf_printf(&state->pp_buf, "VOL1/%8s:", name);
>  	/*
>  	 * get start of VTOC from the disk label and then search for format1
>  	 * and format8 labels
> @@ -219,7 +217,7 @@ static int find_vol1_partitions(struct parsed_partitions *state,
>  		blk++;
>  		data = read_part_sector(state, blk * secperblk, &sect);
>  	}
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  
>  	if (!data)
>  		return -1;
> @@ -237,11 +235,9 @@ static int find_lnx1_partitions(struct parsed_partitions *state,
>  				dasd_information2_t *info)
>  {
>  	loff_t offset, geo_size, size;
> -	char tmp[64];
>  	int secperblk;
>  
> -	snprintf(tmp, sizeof(tmp), "LNX1/%8s:", name);
> -	strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +	seq_buf_printf(&state->pp_buf, "LNX1/%8s:", name);
>  	secperblk = blocksize >> 9;
>  	if (label->lnx.ldl_version == 0xf2) {
>  		size = label->lnx.formatted_blocks * secperblk;
> @@ -258,7 +254,7 @@ static int find_lnx1_partitions(struct parsed_partitions *state,
>  		size = nr_sectors;
>  		if (size != geo_size) {
>  			if (!info) {
> -				strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +				seq_buf_puts(&state->pp_buf, "\n");
>  				return 1;
>  			}
>  			if (!strcmp(info->type, "ECKD"))
> @@ -270,7 +266,7 @@ static int find_lnx1_partitions(struct parsed_partitions *state,
>  	/* first and only partition starts in the first block after the label */
>  	offset = labelsect + secperblk;
>  	put_partition(state, 1, offset, size - offset);
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  	return 1;
>  }
>  
> @@ -282,7 +278,6 @@ static int find_cms1_partitions(struct parsed_partitions *state,
>  				sector_t labelsect)
>  {
>  	loff_t offset, size;
> -	char tmp[64];
>  	int secperblk;
>  
>  	/*
> @@ -291,14 +286,12 @@ static int find_cms1_partitions(struct parsed_partitions *state,
>  	blocksize = label->cms.block_size;
>  	secperblk = blocksize >> 9;
>  	if (label->cms.disk_offset != 0) {
> -		snprintf(tmp, sizeof(tmp), "CMS1/%8s(MDSK):", name);
> -		strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +		seq_buf_printf(&state->pp_buf, "CMS1/%8s(MDSK):", name);
>  		/* disk is reserved minidisk */
>  		offset = label->cms.disk_offset * secperblk;
>  		size = (label->cms.block_count - 1) * secperblk;
>  	} else {
> -		snprintf(tmp, sizeof(tmp), "CMS1/%8s:", name);
> -		strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +		seq_buf_printf(&state->pp_buf, "CMS1/%8s:", name);
>  		/*
>  		 * Special case for FBA devices:
>  		 * If an FBA device is CMS formatted with blocksize > 512 byte
> @@ -314,7 +307,7 @@ static int find_cms1_partitions(struct parsed_partitions *state,
>  	}
>  
>  	put_partition(state, 1, offset, size-offset);
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  	return 1;
>  }
>  
> @@ -391,11 +384,11 @@ int ibm_partition(struct parsed_partitions *state)
>  		 */
>  		res = 1;
>  		if (info->format == DASD_FORMAT_LDL) {
> -			strlcat(state->pp_buf, "(nonl)", PAGE_SIZE);
> +			seq_buf_puts(&state->pp_buf, "(nonl)");
>  			size = nr_sectors;
>  			offset = (info->label_block + 1) * (blocksize >> 9);
>  			put_partition(state, 1, offset, size-offset);
> -			strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +			seq_buf_puts(&state->pp_buf, "\n");
>  		}
>  	} else
>  		res = 0;
> diff --git a/block/partitions/karma.c b/block/partitions/karma.c
> index 4d93512f4bd4..a4e3c5050177 100644
> --- a/block/partitions/karma.c
> +++ b/block/partitions/karma.c
> @@ -53,7 +53,7 @@ int karma_partition(struct parsed_partitions *state)
>  		}
>  		slot++;
>  	}
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  	put_dev_sector(sect);
>  	return 1;
>  }
> diff --git a/block/partitions/ldm.c b/block/partitions/ldm.c
> index 776b4ad95091..c0bdcae58a3e 100644
> --- a/block/partitions/ldm.c
> +++ b/block/partitions/ldm.c
> @@ -582,7 +582,7 @@ static bool ldm_create_data_partitions (struct parsed_partitions *pp,
>  		return false;
>  	}
>  
> -	strlcat(pp->pp_buf, " [LDM]", PAGE_SIZE);
> +	seq_buf_puts(&pp->pp_buf, " [LDM]");
>  
>  	/* Create the data partitions */
>  	list_for_each (item, &ldb->v_part) {
> @@ -597,7 +597,7 @@ static bool ldm_create_data_partitions (struct parsed_partitions *pp,
>  		part_num++;
>  	}
>  
> -	strlcat(pp->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&pp->pp_buf, "\n");
>  	return true;
>  }
>  
> diff --git a/block/partitions/mac.c b/block/partitions/mac.c
> index b02530d98629..df03ca428e15 100644
> --- a/block/partitions/mac.c
> +++ b/block/partitions/mac.c
> @@ -86,7 +86,7 @@ int mac_partition(struct parsed_partitions *state)
>  	if (blocks_in_map >= state->limit)
>  		blocks_in_map = state->limit - 1;
>  
> -	strlcat(state->pp_buf, " [mac]", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, " [mac]");
>  	for (slot = 1; slot <= blocks_in_map; ++slot) {
>  		int pos = slot * secsize;
>  		put_dev_sector(sect);
> @@ -152,6 +152,6 @@ int mac_partition(struct parsed_partitions *state)
>  #endif
>  
>  	put_dev_sector(sect);
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  	return 1;
>  }
> diff --git a/block/partitions/msdos.c b/block/partitions/msdos.c
> index 073be78ba0b0..200ea53ea6a2 100644
> --- a/block/partitions/msdos.c
> +++ b/block/partitions/msdos.c
> @@ -263,18 +263,11 @@ static void parse_solaris_x86(struct parsed_partitions *state,
>  		put_dev_sector(sect);
>  		return;
>  	}
> -	{
> -		char tmp[1 + BDEVNAME_SIZE + 10 + 11 + 1];
> -
> -		snprintf(tmp, sizeof(tmp), " %s%d: <solaris:", state->name, origin);
> -		strlcat(state->pp_buf, tmp, PAGE_SIZE);
> -	}
> +	seq_buf_printf(&state->pp_buf, " %s%d: <solaris:", state->name, origin);
>  	if (le32_to_cpu(v->v_version) != 1) {
> -		char tmp[64];
> -
> -		snprintf(tmp, sizeof(tmp), "  cannot handle version %d vtoc>\n",
> -			 le32_to_cpu(v->v_version));
> -		strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +		seq_buf_printf(&state->pp_buf,
> +			       "  cannot handle version %d vtoc>\n",
> +			       le32_to_cpu(v->v_version));
>  		put_dev_sector(sect);
>  		return;
>  	}
> @@ -282,12 +275,10 @@ static void parse_solaris_x86(struct parsed_partitions *state,
>  	max_nparts = le16_to_cpu(v->v_nparts) > 8 ? SOLARIS_X86_NUMSLICE : 8;
>  	for (i = 0; i < max_nparts && state->next < state->limit; i++) {
>  		struct solaris_x86_slice *s = &v->v_slice[i];
> -		char tmp[3 + 10 + 1 + 1];
>  
>  		if (s->s_size == 0)
>  			continue;
> -		snprintf(tmp, sizeof(tmp), " [s%d]", i);
> -		strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +		seq_buf_printf(&state->pp_buf, " [s%d]", i);
>  		/* solaris partitions are relative to current MS-DOS
>  		 * one; must add the offset of the current partition */
>  		put_partition(state, state->next++,
> @@ -295,7 +286,7 @@ static void parse_solaris_x86(struct parsed_partitions *state,
>  				 le32_to_cpu(s->s_size));
>  	}
>  	put_dev_sector(sect);
> -	strlcat(state->pp_buf, " >\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, " >\n");
>  #endif
>  }
>  
> @@ -359,7 +350,6 @@ static void parse_bsd(struct parsed_partitions *state,
>  	Sector sect;
>  	struct bsd_disklabel *l;
>  	struct bsd_partition *p;
> -	char tmp[64];
>  
>  	l = read_part_sector(state, offset + 1, &sect);
>  	if (!l)
> @@ -369,8 +359,7 @@ static void parse_bsd(struct parsed_partitions *state,
>  		return;
>  	}
>  
> -	snprintf(tmp, sizeof(tmp), " %s%d: <%s:", state->name, origin, flavour);
> -	strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +	seq_buf_printf(&state->pp_buf, " %s%d: <%s:", state->name, origin, flavour);
>  
>  	if (le16_to_cpu(l->d_npartitions) < max_partitions)
>  		max_partitions = le16_to_cpu(l->d_npartitions);
> @@ -391,18 +380,16 @@ static void parse_bsd(struct parsed_partitions *state,
>  			/* full parent partition, we have it already */
>  			continue;
>  		if (offset > bsd_start || offset+size < bsd_start+bsd_size) {
> -			strlcat(state->pp_buf, "bad subpartition - ignored\n", PAGE_SIZE);
> +			seq_buf_puts(&state->pp_buf, "bad subpartition - ignored\n");
>  			continue;
>  		}
>  		put_partition(state, state->next++, bsd_start, bsd_size);
>  	}
>  	put_dev_sector(sect);
> -	if (le16_to_cpu(l->d_npartitions) > max_partitions) {
> -		snprintf(tmp, sizeof(tmp), " (ignored %d more)",
> -			 le16_to_cpu(l->d_npartitions) - max_partitions);
> -		strlcat(state->pp_buf, tmp, PAGE_SIZE);
> -	}
> -	strlcat(state->pp_buf, " >\n", PAGE_SIZE);
> +	if (le16_to_cpu(l->d_npartitions) > max_partitions)
> +		seq_buf_printf(&state->pp_buf, " (ignored %d more)",
> +			       le16_to_cpu(l->d_npartitions) - max_partitions);
> +	seq_buf_puts(&state->pp_buf, " >\n");
>  }
>  #endif
>  
> @@ -496,12 +483,7 @@ static void parse_unixware(struct parsed_partitions *state,
>  		put_dev_sector(sect);
>  		return;
>  	}
> -	{
> -		char tmp[1 + BDEVNAME_SIZE + 10 + 12 + 1];
> -
> -		snprintf(tmp, sizeof(tmp), " %s%d: <unixware:", state->name, origin);
> -		strlcat(state->pp_buf, tmp, PAGE_SIZE);
> -	}
> +	seq_buf_printf(&state->pp_buf, " %s%d: <unixware:", state->name, origin);
>  	p = &l->vtoc.v_slice[1];
>  	/* I omit the 0th slice as it is the same as whole disk. */
>  	while (p - &l->vtoc.v_slice[0] < UNIXWARE_NUMSLICE) {
> @@ -515,7 +497,7 @@ static void parse_unixware(struct parsed_partitions *state,
>  		p++;
>  	}
>  	put_dev_sector(sect);
> -	strlcat(state->pp_buf, " >\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, " >\n");
>  #endif
>  }
>  
> @@ -546,10 +528,7 @@ static void parse_minix(struct parsed_partitions *state,
>  	 * the normal boot sector. */
>  	if (msdos_magic_present(data + 510) &&
>  	    p->sys_ind == MINIX_PARTITION) { /* subpartition table present */
> -		char tmp[1 + BDEVNAME_SIZE + 10 + 9 + 1];
> -
> -		snprintf(tmp, sizeof(tmp), " %s%d: <minix:", state->name, origin);
> -		strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +		seq_buf_printf(&state->pp_buf, " %s%d: <minix:", state->name, origin);
>  		for (i = 0; i < MINIX_NR_SUBPARTITIONS; i++, p++) {
>  			if (state->next == state->limit)
>  				break;
> @@ -558,7 +537,7 @@ static void parse_minix(struct parsed_partitions *state,
>  				put_partition(state, state->next++,
>  					      start_sect(p), nr_sects(p));
>  		}
> -		strlcat(state->pp_buf, " >\n", PAGE_SIZE);
> +		seq_buf_puts(&state->pp_buf, " >\n");
>  	}
>  	put_dev_sector(sect);
>  #endif /* CONFIG_MINIX_SUBPARTITION */
> @@ -602,7 +581,7 @@ int msdos_partition(struct parsed_partitions *state)
>  #ifdef CONFIG_AIX_PARTITION
>  		return aix_partition(state);
>  #else
> -		strlcat(state->pp_buf, " [AIX]", PAGE_SIZE);
> +		seq_buf_puts(&state->pp_buf, " [AIX]");
>  		return 0;
>  #endif
>  	}
> @@ -629,7 +608,7 @@ int msdos_partition(struct parsed_partitions *state)
>  			fb = (struct fat_boot_sector *) data;
>  			if (slot == 1 && fb->reserved && fb->fats
>  				&& fat_valid_media(fb->media)) {
> -				strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +				seq_buf_puts(&state->pp_buf, "\n");
>  				put_dev_sector(sect);
>  				return 1;
>  			} else {
> @@ -678,9 +657,9 @@ int msdos_partition(struct parsed_partitions *state)
>  			n = min(size, max(sector_size, n));
>  			put_partition(state, slot, start, n);
>  
> -			strlcat(state->pp_buf, " <", PAGE_SIZE);
> +			seq_buf_puts(&state->pp_buf, " <");
>  			parse_extended(state, start, size, disksig);
> -			strlcat(state->pp_buf, " >", PAGE_SIZE);
> +			seq_buf_puts(&state->pp_buf, " >");
>  			continue;
>  		}
>  		put_partition(state, slot, start, size);
> @@ -688,12 +667,12 @@ int msdos_partition(struct parsed_partitions *state)
>  		if (p->sys_ind == LINUX_RAID_PARTITION)
>  			state->parts[slot].flags = ADDPART_FLAG_RAID;
>  		if (p->sys_ind == DM6_PARTITION)
> -			strlcat(state->pp_buf, "[DM]", PAGE_SIZE);
> +			seq_buf_puts(&state->pp_buf, "[DM]");
>  		if (p->sys_ind == EZD_PARTITION)
> -			strlcat(state->pp_buf, "[EZD]", PAGE_SIZE);
> +			seq_buf_puts(&state->pp_buf, "[EZD]");
>  	}
>  
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  
>  	/* second pass - output for each on a separate line */
>  	p = (struct msdos_partition *) (0x1be + data);
> diff --git a/block/partitions/of.c b/block/partitions/of.c
> index 4e760fdffb3f..c22b60661098 100644
> --- a/block/partitions/of.c
> +++ b/block/partitions/of.c
> @@ -36,7 +36,6 @@ static void add_of_partition(struct parsed_partitions *state, int slot,
>  			     struct device_node *np)
>  {
>  	struct partition_meta_info *info;
> -	char tmp[sizeof(info->volname) + 4];
>  	const char *partname;
>  	int len;
>  
> @@ -63,8 +62,7 @@ static void add_of_partition(struct parsed_partitions *state, int slot,
>  		partname = of_get_property(np, "name", &len);
>  	strscpy(info->volname, partname, sizeof(info->volname));
>  
> -	snprintf(tmp, sizeof(tmp), "(%s)", info->volname);
> -	strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +	seq_buf_printf(&state->pp_buf, "(%s)", info->volname);
>  }
>  
>  int of_partition(struct parsed_partitions *state)
> @@ -104,7 +102,7 @@ int of_partition(struct parsed_partitions *state)
>  		slot++;
>  	}
>  
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  
>  	return 1;
>  }
> diff --git a/block/partitions/osf.c b/block/partitions/osf.c
> index 84560d0765ed..2a692584dba9 100644
> --- a/block/partitions/osf.c
> +++ b/block/partitions/osf.c
> @@ -81,7 +81,7 @@ int osf_partition(struct parsed_partitions *state)
>  				le32_to_cpu(partition->p_size));
>  		slot++;
>  	}
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  	put_dev_sector(sect);
>  	return 1;
>  }
> diff --git a/block/partitions/sgi.c b/block/partitions/sgi.c
> index b5ecddd5181a..2383ca63cd66 100644
> --- a/block/partitions/sgi.c
> +++ b/block/partitions/sgi.c
> @@ -79,7 +79,7 @@ int sgi_partition(struct parsed_partitions *state)
>  		}
>  		slot++;
>  	}
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  	put_dev_sector(sect);
>  	return 1;
>  }
> diff --git a/block/partitions/sun.c b/block/partitions/sun.c
> index 2419af76120f..92c645fcd2e0 100644
> --- a/block/partitions/sun.c
> +++ b/block/partitions/sun.c
> @@ -121,7 +121,7 @@ int sun_partition(struct parsed_partitions *state)
>  		}
>  		slot++;
>  	}
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  	put_dev_sector(sect);
>  	return 1;
>  }
> diff --git a/block/partitions/sysv68.c b/block/partitions/sysv68.c
> index 6f6257fd4eb4..470e0f9de7be 100644
> --- a/block/partitions/sysv68.c
> +++ b/block/partitions/sysv68.c
> @@ -54,7 +54,6 @@ int sysv68_partition(struct parsed_partitions *state)
>  	unsigned char *data;
>  	struct dkblk0 *b;
>  	struct slice *slice;
> -	char tmp[64];
>  
>  	data = read_part_sector(state, 0, &sect);
>  	if (!data)
> @@ -74,8 +73,7 @@ int sysv68_partition(struct parsed_partitions *state)
>  		return -1;
>  
>  	slices -= 1; /* last slice is the whole disk */
> -	snprintf(tmp, sizeof(tmp), "sysV68: %s(s%u)", state->name, slices);
> -	strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +	seq_buf_printf(&state->pp_buf, "sysV68: %s(s%u)", state->name, slices);
>  	slice = (struct slice *)data;
>  	for (i = 0; i < slices; i++, slice++) {
>  		if (slot == state->limit)
> @@ -84,12 +82,11 @@ int sysv68_partition(struct parsed_partitions *state)
>  			put_partition(state, slot,
>  				be32_to_cpu(slice->blkoff),
>  				be32_to_cpu(slice->nblocks));
> -			snprintf(tmp, sizeof(tmp), "(s%u)", i);
> -			strlcat(state->pp_buf, tmp, PAGE_SIZE);
> +			seq_buf_printf(&state->pp_buf, "(s%u)", i);
>  		}
>  		slot++;
>  	}
> -	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, "\n");
>  	put_dev_sector(sect);
>  	return 1;
>  }
> diff --git a/block/partitions/ultrix.c b/block/partitions/ultrix.c
> index 4aaa81043ca0..b4b9ddc57a5d 100644
> --- a/block/partitions/ultrix.c
> +++ b/block/partitions/ultrix.c
> @@ -39,7 +39,7 @@ int ultrix_partition(struct parsed_partitions *state)
>  					      label->pt_part[i].pi_blkoff,
>  					      label->pt_part[i].pi_nblocks);
>  		put_dev_sector(sect);
> -		strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +		seq_buf_puts(&state->pp_buf, "\n");
>  		return 1;
>  	} else {
>  		put_dev_sector(sect);

