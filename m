Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87169347BDC;
	Mon, 29 Jun 2026 07:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782718557; cv=none; b=YUjI5jyyyMHyY/eOh7IEpB5IL+5WGMZysmj9FNmq/a4VMqEmxCE3kFstyZz5JgShT0rGsZG0t+aXQHgvjjQTaQPor0D/3aiPiADd643CBqVaUZvCLoTAsuARPZFhZhQrkozD0RkTJUSPjXvL6ZT1zbUXudxD8pSJzaJzqhW7wbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782718557; c=relaxed/simple;
	bh=2zatEBFdK9tskA5xMCuwhriCR8d/k+4Lgiw5vm1QE50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+HDKN4jikqnbIia3P9LXCKkAfcmlq5xvHw2YCacox3s+bynk7tlbulfF7nYpCDkCghjNnxzdL2KryqZ+E+kATPcEhWvqP0QVQ7JiGUevorIvoDRcT5NmEQ8wgjMFchAIOrvFh4vSjdyr04bgjzn2rvaCj3Z8d/ZjKvUwOo9qh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FM7oxT9Z; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FM7oxT9Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782718553; x=1814254553;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2zatEBFdK9tskA5xMCuwhriCR8d/k+4Lgiw5vm1QE50=;
  b=FM7oxT9Z00r0Jia8D4c6tgFm1iEbwfgohqbVZx1Ui1tE1Ehebbq2VpAd
   mqW827tsiti+qYgEhJaZSY3uFZ2Rfe/WyHOlVHw12dMYFd9K119nwNvWm
   XHRwjHtyIeM1pg9SvuF9iwE2hZ+5qUziUCBVCqO06balM/gMy793rAGd4
   5qfm0ymGXw+6K/r/+JLusWd2A/z8ydjTlhMkPW3azH6FOIxMRBvQWRnYn
   hCSKBbjEuiUEGX5vlwwqWmDERYpf5U3+xnIMFiKWCfh4r/aDwAe51DwBb
   CREvSRxQU2cVV44JYpYE3SBBdI8Dt/DtQ6HrGC8F1gk7dMdx68AYW3YDv
   w==;
X-CSE-ConnectionGUID: ju54942sTPC0980juBxX2Q==
X-CSE-MsgGUID: qbpfCqX3Qiue6pgJpTg4KA==
X-IronPort-AV: E=McAfee;i="6800,10657,11831"; a="83276365"
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="83276365"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 00:35:51 -0700
X-CSE-ConnectionGUID: LA/j0INTRCeqBSkQMZkB5w==
X-CSE-MsgGUID: SxLdSLYtT0OyqBtaePGndw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="250189857"
Received: from kniemiec-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.207])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 00:35:47 -0700
Date: Mon, 29 Jun 2026 10:35:40 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-block@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net, linux-s390@vger.kernel.org,
	Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jan =?iso-8859-1?Q?H=F6ppner?= <hoeppner@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>, Josh Law <objecting@objecting.org>,
	Kees Cook <kees@kernel.org>, Md Haris Iqbal <haris.iqbal@linux.dev>,
	Richard Russon <ldm@flatcap.org>,
	Stefan Haberland <sth@linux.ibm.com>,
	Thorsten Blum <thorsten.blum@linux.dev>, vulab@iscas.ac.cn,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Woradorn Laodhanadhaworn <woradorn.laon@gmail.com>
Subject: Re: [PATCH v2] block: partitions: Use seq_buf_putc() at 24 places
Message-ID: <akIgTBcvrZLfY2iL@ashevche-desk.local>
References: <59dfd2ef-2fda-4dd0-a288-52c35613e778@web.de>
 <ajzkRM_RFKBpp0i5@ashevche-desk.local>
 <7de415a7-457d-4dd2-aebb-8e179fa0bbcd@web.de>
 <aj061omzs5WN5ar6@ashevche-desk.local>
 <7360cab3-7a2f-4903-85f1-0f03387b0d88@web.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7360cab3-7a2f-4903-85f1-0f03387b0d88@web.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Jun 29, 2026 at 09:16:09AM +0200, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 29 Jun 2026 08:10:24 +0200
> 
> Single line breaks should occasionally be put into a sequence buffer.
> Thus use the seq_buf_putc() function in these implementations.
> 
> The source code was transformed by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> 
> v2:
> * Andy Shevchenko requested to preserve two blank lines.

This comment in the context of the given commit message may be odd.
The blank lines mentioned were in the code that previous coccinelle
script removed, id est the code

	...blank line...
	seq_buf_puts()
	...blank line...

the script transformed to a single line

	seq_buf_putc()

So my request is to keep the original blank line(s) as is.

> * The source code transformation was extended to all affected places
>   for this software area.

-- 
With Best Regards,
Andy Shevchenko


