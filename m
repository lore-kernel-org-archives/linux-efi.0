Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBC7171CD;
	Mon, 15 Jun 2026 18:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781546715; cv=none; b=kVFCh0vXRSPxlL0xLWk7fbpUSGJ5H7TIy0sSQNai9Xz3L/pGeNvQXkf6UjoN4Q+0TmIh8m0po/i42qcbuvllxuODDrjhcFAg8PBK7HsiDOKVnVv/Lja0KuQFnr51VzB68Eeu94BTodxrS/O3sqpDeKGZMlqE0cjqNvhY1RQEJFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781546715; c=relaxed/simple;
	bh=/ph9hmv8Bv3gxVKJvA7XMnqgK8s/htGVs7RhLC844Jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eutPKGpVnAV4b6RYtV5wbbMHvz6PSIKrkdfulYa54VZFvI+XEK7h6QpLIP5PVvQSh7Nmh/pfzW3HBQXsAhIkuS3eSgTurYuJxm6T0V6PKq8yPQkvMYDYHc4BbSW75CF6nFukRYdOrHp87+vqtE5JN9ALF8uob66a/orFXM1NxRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=meDmn82a; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="meDmn82a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gV3RARbyoDWxd2FbFDV10A8E6ApjHuUWEwK765GMoFs=; b=meDmn82aI5X1jsBR4O+/ynZVS1
	dRyY2y3L3HsISR0ckn+NlhrlhlUo8xqZTLFqkX1Ws1hHMzyZJ2Jz9fp/I8v4GrVch+ycAyKIn+FS9
	F+HS98vrZmbZ/0VxEZHamPMEvKFuN+HRMIOyDtMHgR17tpDM0ffztCZgqGCO97s7MgQ3m0mMe/z1C
	6iCgbfUa8eR9NP+5SLsPNAwvOPp+HQGze0I3OJIDclmCupACHdHoCO0U5QQdgLegpb5TW/pFwC8GE
	fW0DGRDIjASOe58SfucrbzVcqnc/ux5LqkHZFGZ8xOFHZS+SJcasPm7pEY5gk/W5TyequpTLLvYan
	ZmB3dOUA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZBgH-00000009Exo-3OE8;
	Mon, 15 Jun 2026 18:05:05 +0000
Date: Mon, 15 Jun 2026 19:05:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Vincent Mailhol <mailhol@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Subject: Re: [PATCH 12/19] x86: define DPS root partition type UUIDs
Message-ID: <ajA-0YJW4gLr02c7@casper.infradead.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
 <20260615-discoverable-root_partitions-v1-12-39c78fac42e2@kernel.org>
 <03be57ae-0e41-4b8a-adc5-bdd85ccce951@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03be57ae-0e41-4b8a-adc5-bdd85ccce951@intel.com>

On Mon, Jun 15, 2026 at 09:46:41AM -0700, Dave Hansen wrote:
> There are a lot of ways to do this. I'm just not a super big fan of the
> current proposal.
> 
> So, boiling it down:
> 
> 1. Should more than one UUID be supported per kernel build?
> 2. Should the UUIDs be defined in arch code or generic code?
> 3. Kconfig or #ifdefs?

Further questions ... why do this in the kernel?  Seems perfectly
suited to be in initramfs where we can throw away the code after boot.
