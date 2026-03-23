Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0583B9613;
	Mon, 23 Mar 2026 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278356; cv=none; b=Len1ftKF9EuizZgDFJ0aLUFSAxhYDp9NS+8PRbl+PAl5y2heLfv7CAzZqkXBQoEcl8l3wnkzIFTrBP7mKWm+KCjfs/mb10lPVAeftpWDKhsCiTjfhZPKjhtTs6eCbC86T9iQeTgCDG4G6SOQicVfGyH5n0TnhHTwb2st25RbCAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278356; c=relaxed/simple;
	bh=38fmMNiWvDfyXTwBdfTFl0XJCwc8gv/bEC9L+BzNIxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kqzw+Psz0sLEE3L3ShVBL6W0IueP3uzeNKGRymKxho3LhysNlV5MbG4v6jBtDo8m3X8OgNYUd/5J7SS4C92WEhyDYJNsPxOA4Daz/joh4dQVms/jFRzImrfqYP3vEcgeIHcfVVwygIIKnjdS3uC0AfmpSe0RVRrVBCAGJFe7yao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PqlWyf5o; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PqlWyf5o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774278356; x=1805814356;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=38fmMNiWvDfyXTwBdfTFl0XJCwc8gv/bEC9L+BzNIxw=;
  b=PqlWyf5oG9XXqNQGIo0Z2wvaJJTc7Y7gvZlekgS6LjxaXkzyjgbyxdS8
   qScWaz9/FKFfS+ctqLNWVNiGgGEaEc7eEr/BSRGTylM32KlAefrUsFZap
   X3gUJs9JpmL2+H5ecJ9TEnX0FF6jGheDoA/KlaTK4AaV5hv9+OgEVWrvc
   q9JTb4+OG8C9wFNkm4nD40QZ60XbTaWh4cgQkw8wjx7RdF/UgFFRnN7kR
   a3zrxHy206fdjqc6g89zHX4GmDYISWc0HJdLhzYbV7Y6e3fe0xvOkeKSE
   /dVoYR0Ua55efnCplsWY57yonBH9GY14f90Z3dNmoZwZE/cV8eWiANRPQ
   A==;
X-CSE-ConnectionGUID: hUpeyiliQSyofMs1lqrrtg==
X-CSE-MsgGUID: YgExWvhITCWCXbRIjAN8hQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="75345863"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="75345863"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 08:05:55 -0700
X-CSE-ConnectionGUID: E4WzUs5wSn6ltlycGc4Wxw==
X-CSE-MsgGUID: pIOZugwYSHKF9UKaG+q9FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="247084583"
Received: from vpanait-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.22])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 08:05:52 -0700
Date: Mon, 23 Mar 2026 17:05:49 +0200
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
Message-ID: <acFWzUYlNE2k2aca@ashevche-desk.local>
References: <20260321004840.work.670-kees@kernel.org>
 <acD_IIEXmhnVlO0C@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acD_IIEXmhnVlO0C@ashevche-desk.local>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Mar 23, 2026 at 10:51:49AM +0200, Andy Shevchenko wrote:
> On Fri, Mar 20, 2026 at 05:48:44PM -0700, Kees Cook wrote:

...

> > -			char tmp[42];
> >  
> >  			__be32 *dt = (__be32 *)dostype;
> >  			*dt = pb->pb_Environment[16];
> >  			if (dostype[3] < ' ')
> > -				snprintf(tmp, sizeof(tmp), " (%c%c%c^%c)",
> > -					dostype[0], dostype[1],
> > -					dostype[2], dostype[3] + '@' );
> > +				seq_buf_printf(&state->pp_buf,
> > +					       " (%c%c%c^%c)",
> > +					       dostype[0], dostype[1],
> > +					       dostype[2],
> > +					       dostype[3] + '@');
> >  			else
> > -				snprintf(tmp, sizeof(tmp), " (%c%c%c%c)",
> > -					dostype[0], dostype[1],
> > -					dostype[2], dostype[3]);
> > -			strlcat(state->pp_buf, tmp, PAGE_SIZE);
> > -			snprintf(tmp, sizeof(tmp), "(res %d spb %d)",
> > -				be32_to_cpu(pb->pb_Environment[6]),
> > -				be32_to_cpu(pb->pb_Environment[4]));
> > -			strlcat(state->pp_buf, tmp, PAGE_SIZE);
> > +				seq_buf_printf(&state->pp_buf,
> > +					       " (%c%c%c%c)",
> > +					       dostype[0], dostype[1],
> > +					       dostype[2], dostype[3]);
> 
> Wouldn't
> 				seq_buf_printf(&state->pp_buf, " (%.4s)", dostype);
> 
> work?
> 
> But probably okay as in the previous branch it needs more work to follow,
> something like
> 
> 			char dostype[8];
> 			...
> 			if (dostype[3] < ' ') {
> 				/* Escape control character */
> 				dostype[4] = dostype[3] + '@';
> 				dostype[3] = '^';
> 				seq_buf_printf(&state->pp_buf, " (%.5s)", dostype);
> 			} else {
> 				seq_buf_printf(&state->pp_buf, " (%.4s)", dostype);
> 			}

Or maybe even replace the whole conditional with

			seq_buf_printf(&state->pp_buf, " (%4pE)", dostype);

What do you think?

> Taking how invasive is this, it might be better to done separately.
> 
> > +			seq_buf_printf(&state->pp_buf, "(res %d spb %d)",
> > +				       be32_to_cpu(pb->pb_Environment[6]),
> > +				       be32_to_cpu(pb->pb_Environment[4]));

-- 
With Best Regards,
Andy Shevchenko


