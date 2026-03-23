Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864573603FC;
	Mon, 23 Mar 2026 08:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774255911; cv=none; b=XLEf6Hv408AYrCPI3JiF4qYh3kktj6qN594g0DjjlPVGdVlB/8L06VHHE1zXrx3axApv37wmd9WjYl1lFarmoLswj1y2MHrd1EjHdWTwmgBF53vaWmNb8J6xypNeSpWHp0M2zgEQVZktKC/kKz71fWVWQeOK0OOhsPb99VmMS6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774255911; c=relaxed/simple;
	bh=dmgQeU3RW0ZvG5Al9Vg1ngqjadpe9kAbYXZbA7yKC/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWq1o58dUn4M/Fq9IINUpCx6i2sPo2Kb9gMpIDfuyy9hVSG3xaVoucEzHVgfk1p2ipdoEVAV5oQNZUmpcBUBvTdHsxWCJePBDrQQ68LlrAsQqFvYqz/+bzSc4hghn9KTr2qPBlfD9u4+2jt007sdGGOiFXtoIBNDsyOoyD8tU3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lBCwxNgK; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lBCwxNgK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774255911; x=1805791911;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dmgQeU3RW0ZvG5Al9Vg1ngqjadpe9kAbYXZbA7yKC/o=;
  b=lBCwxNgKcecwvuVqHTY8XuWxg+ZvN7vTfOdmwscnFhTN1VpD8/ysmAwL
   UVcYKpH3fWMGFvRpBbim6nusqR9HMKPPuRXEPYmo/8tOhCq6srIIU1Q85
   bDjiI+Y1kydw9kNBm/6KyTO7ZtQD+ltZ/graT9sKnCDfFUykgTPrx8MIV
   JVPuXLdhEt7FaD4csZ/NRF3tyvtDbKAleCKu/Z9FXJJvloPS2e8ZX788d
   b9pULmi+SeSIS6Ag2bSroCVcEcJvGgE9IGXeVvey2f4/ssthHSPh8twWi
   W6cm1BXez+99ieSPqsYMOZvHtMxbJTn7E92rujDj9NEyLyU49kTTLe5ad
   g==;
X-CSE-ConnectionGUID: 8iRTGY8GTzG8mf/USL/7FA==
X-CSE-MsgGUID: Y0rQz1TNTHKTuRqsN6y1lg==
X-IronPort-AV: E=McAfee;i="6800,10657,11737"; a="74427215"
X-IronPort-AV: E=Sophos;i="6.23,136,1770624000"; 
   d="scan'208";a="74427215"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 01:51:50 -0700
X-CSE-ConnectionGUID: ock8Tlp0TquOEKkUY4ALRA==
X-CSE-MsgGUID: kxhnSGJ+Sq+epLMtPDxTVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,136,1770624000"; 
   d="scan'208";a="254438657"
Received: from vpanait-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.22])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 01:51:46 -0700
Date: Mon, 23 Mar 2026 10:51:44 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kees Cook <kees@kernel.org>
Cc: Josh Law <objecting@objecting.org>, Jens Axboe <axboe@kernel.dk>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	"Richard Russon (FlatCap)" <ldm@flatcap.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-efi@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] block: partitions: Replace pp_buf with struct seq_buf
Message-ID: <acD_IIEXmhnVlO0C@ashevche-desk.local>
References: <20260321004840.work.670-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260321004840.work.670-kees@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Mar 20, 2026 at 05:48:44PM -0700, Kees Cook wrote:
> In preparation for removing the strlcat API[1], replace the char *pp_buf
> with a struct seq_buf, which tracks the current write position and
> remaining space internally. This allows for:
> 
> - Direct use of seq_buf_printf() in place of snprintf()+strlcat()
>   pairs, eliminating local tmp buffers throughout.
> - Adjacent strlcat() calls that build strings piece-by-piece
>   (e.g., strlcat("["); strlcat(name); strlcat("]")) to be collapsed
>   into single seq_buf_printf() calls.
> - Simpler call sites: seq_buf_puts() takes only the buffer and string,
>   with no need to pass PAGE_SIZE at every call.
> 
> The backing buffer allocation is unchanged (__get_free_page), and the
> output path uses seq_buf_str() to NUL-terminate before passing to
> printk().

Thanks a lot! A few comments below.
Personally I'm in favour of this patch as it also removes a lot of ugly code
(which is scoped string manipulations), FWIW,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Link: https://github.com/KSPP/linux/issues/370 [1]

> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Josh Law <objecting@objecting.org>

While not long, this still can be placed...

> Signed-off-by: Kees Cook <kees@kernel.org>
> ---

...somewhere here to reduce unneeded noise in the commit message.

> I couldn't help myself. Here's the full patch, as I suggested in
> https://lore.kernel.org/lkml/202603201230.74BBFFABAD@keescook/
> There are plenty more like this to do...

Indeed, but thanks for the example on how to do that!

...

> @@ -78,14 +76,14 @@ static int riscix_partition(struct parsed_partitions *state,
>  	if (!rr)
>  		return -1;
>  
> -	strlcat(state->pp_buf, " [RISCiX]", PAGE_SIZE);
> +	seq_buf_puts(&state->pp_buf, " [RISCiX]");
>  
>  

While at it, you can also drop a second blank line.

>  	if (rr->magic == RISCIX_MAGIC) {
>  		unsigned long size = nr_sects > 2 ? 2 : nr_sects;
>  		int part;
>  
> -		strlcat(state->pp_buf, " <", PAGE_SIZE);
> +		seq_buf_puts(&state->pp_buf, " <");
>  
>  		put_partition(state, slot++, first_sect, size);
>  		for (part = 0; part < 8; part++) {

...

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

Hmm... here it's %u...

>  			vgda_len = be32_to_cpu(p->vgda_len);
>  			vgda_sector = be32_to_cpu(p->vgda_psn[0]);
>  		} else {
> -			snprintf(tmp, sizeof(tmp),
> -				" unsupported AIX LVM version %d found\n",
> -				lvm_version);
> +			seq_buf_printf(&state->pp_buf,
> +				       " unsupported AIX LVM version %d found\n",
> +				       lvm_version);

...and here it's %d. Perhaps also fix specifiers to be aligned with the actual
data type?

>  		}
> -		strlcat(state->pp_buf, tmp, PAGE_SIZE);
>  		put_dev_sector(sect);
>  	}
>  	if (vgda_sector && (d = read_part_sector(state, vgda_sector, &sect))) {

...

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

Wouldn't
				seq_buf_printf(&state->pp_buf, " (%.4s)", dostype);

work?

But probably okay as in the previous branch it needs more work to follow,
something like

			char dostype[8];
			...
			if (dostype[3] < ' ') {
				/* Escape control character */
				dostype[4] = dostype[3] + '@';
				dostype[3] = '^';
				seq_buf_printf(&state->pp_buf, " (%.5s)", dostype);
			} else {
				seq_buf_printf(&state->pp_buf, " (%.4s)", dostype);
			}

Taking how invasive is this, it might be better to done separately.

> +			seq_buf_printf(&state->pp_buf, "(res %d spb %d)",
> +				       be32_to_cpu(pb->pb_Environment[6]),
> +				       be32_to_cpu(pb->pb_Environment[4]));
>  		}
>  		res = 1;

-- 
With Best Regards,
Andy Shevchenko


