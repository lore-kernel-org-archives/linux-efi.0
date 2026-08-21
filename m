Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0AE4ADD9D;
	Fri, 21 Aug 2026 14:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787321080; cv=none; b=o+9rxBOeAKg4q3+Qs9MhKAy8bt4Rx5MVZCglN3WtFGxsqetKsJ5mtPrtEiFa9oFz2zc20aauZmOGKqHAIPT+LpNM3PobYV/fhRmc4JuV7BI4MPR36TWXlYq9F/ga7IpP8Vip7cIoYHnyUWDWpcjse5qNi13VXtnaG4Xyb0OFv6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787321080; c=relaxed/simple;
	bh=iR8t9kGDFEgpSPkTUKFI/4CZI5l1bH00mWfBN17G0aE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YONi6NL16/gdXjDJPPuvKLqezHUnDNogmIvkPsEfzAHNRcmttb8mJIJBxT7uRv1BslcCS//4WLV/j7fKPiA05A23EKzezzl9sPSx+Ogo8jn8eyJyIJeW7sGXA2XGNB61jCgoJJ5ms5X1LClu/23Js5NNyTmPqvlXI3ZhMr+ETV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=T7sUuy38; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="T7sUuy38"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SdBGGRg8n21wLsq1Rr/9aeWOWntBAs5V69fUplLxRqk=; b=T7sUuy381KVuQSt4ma4ewlJSTw
	e7l+OZDvXvcr8tEVVR9NJzHPlp2E5/WOGVam1eErJmCrIbBUSvoPajkqNgUanMiTlPkV6F6weqzsV
	UEPbfwuT9WOknpJvCqZSimfzcRZ+IM+6zQBfKHVV6CtFir+a2vmC0D5jhn8vp90zRMxqKdMenoKdW
	KDfG9PHMmg30GcbAW9e1gnuNmqWM5Bvx31mfdSwRPY406L1w5tISz5D68wGxzvQpdq1Mc2pDrOIfv
	gSdhdgyS1EDWs7VYqYGtri5BH1maCKBTVXMTkVfBUISBT5CACU3iLX0u9XD5FAAWn9JGN0EqV7EJy
	tJy0+N5g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxPrE-00BOLF-0L;
	Fri, 21 Aug 2026 14:04:32 +0000
Date: Fri, 21 Aug 2026 07:04:27 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/6] efi: add the LINUX_EFI_POISONED_MEMORY
 configuration table
Message-ID: <aohavv-xpcNkDP48@gmail.com>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-2-5743791e48e6@debian.org>
 <aog7bwfMVpSy9LcY@thinkstation>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aog7bwfMVpSy9LcY@thinkstation>
X-Debian-User: leitao

On Fri, Aug 21, 2026 at 12:51:34PM +0100, Kiryl Shutsemau wrote:
> On Fri, Aug 21, 2026 at 03:06:02AM -0700, Breno Leitao wrote:
> > diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> > index 29e0729299f5b..69c0dc02bc112 100644
> > --- a/drivers/firmware/efi/Kconfig
> > +++ b/drivers/firmware/efi/Kconfig
> > @@ -263,6 +263,16 @@ config EFI_COCO_SECRET
> >  	  virt/coco/efi_secret module to access the secrets, which in turn
> >  	  allows userspace programs to access the injected secrets.
> >  
> > +config EFI_POISONED_MEMORY
> > +	bool "Carry hardware-poisoned pages across kexec"
> > +	depends on EFI_STUB && MEMORY_FAILURE && 64BIT
> > +	help
> > +	  Record page frames that are hardware-poisoned while this kernel runs
> > +	  into an EFI configuration table, and honor that table early on the
> > +	  next kernel so a kexec does not hand known-bad RAM back out.
> > +
> > +	  If unsure, say N.
> > +
> 
> Do we want to make it conditional? Maybe just for everyone with EFI_STUB
> && MEMORY_FAILURE?
> 
> Where 64BIT limitation comes from?

That simplifies a bit the maths for memory operations, and 
make them more digestible.

Do we really care about it on non 64 bits platform?
