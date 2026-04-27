Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05D330AD0B;
	Mon, 27 Apr 2026 10:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285842; cv=none; b=KWwtd1LHbZ2XtTVfZqazHcs74uDKOMJINHLFluTSOTnn1ATQcK8OvaG4HPjdvhEiZAOi0AWtSXHW77qnCpYvl9gYdXUJQyx/vwVUVmPcpyf0bxY3q6/fyNA7Syr/gdi+NTCujxD+mvsBZFiKRoY3LIgb6OXd02v26cHHqwsyzik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285842; c=relaxed/simple;
	bh=j9lgxZ72pFNOq6i9OiE2AUQyWJMA3vzMop55XlLUiRg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=heJpm2bOcKvczJvJXiCBwoS9ukLi91wezh9hq/Ypc4bttc6SC52JHVzr4P2twQV+H7xWfPw3SOy5XXYjQF4njOpfXdTe1Ip55lbKtgHSnsCQO4HXY+8cHwa1CimmgaJ5Ykr5xmrKXlj+WD+p+94AXV+aYe7OyNjAiEa4DnC7IYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HzEXn/hi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HzEXn/hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3444AC19425;
	Mon, 27 Apr 2026 10:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777285841;
	bh=j9lgxZ72pFNOq6i9OiE2AUQyWJMA3vzMop55XlLUiRg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HzEXn/hi9Khwt86iTN4xHXpTp2FZ9xvCO198c8okdgVWYeML0UCSCY3/Cah7Lf4FN
	 PwzcS5nOFkQVal1m7Fh84OKypgHytKQOEsfJI8Xr0WYYcrKo00oVUY4WKvwebrdmpJ
	 0cvlk7PXsCql8E7iC6tuja7Eawx3N7q7fwlSbMDg=
Date: Mon, 27 Apr 2026 03:30:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Charlie Jenkins <thecharlesjenkins@gmail.com>, Alexandre Ghiti
 <alex@ghiti.fr>, Ard Biesheuvel <ardb@kernel.org>,
 linux-riscv@lists.infradead.org, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] riscv32 library enhancements and build fixes
Message-Id: <20260427033040.b10055b592ebb4ce935d3b97@linux-foundation.org>
In-Reply-To: <ae8dGrM77NuCe4S0@ashevche-desk.local>
References: <20260425185151.477442-1-dmantipov@yandex.ru>
	<20260425143631.e20246946f59925c5eb8dc22@linux-foundation.org>
	<df673a44d292bb3df498b78a8b637f880e28931f.camel@yandex.ru>
	<ae8dGrM77NuCe4S0@ashevche-desk.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Apr 2026 11:23:54 +0300 Andy Shevchenko <andriy.shevchenko@intel.com> wrote:

> On Mon, Apr 27, 2026 at 11:13:20AM +0300, Dmitry Antipov wrote:
> > On Sat, 2026-04-25 at 14:36 -0700, Andrew Morton wrote:
> > 
> > > I didn't upstream "lib and lib/cmdline enhancements v9" this cycle.
> > 
> > You don't have to upstream v9. Because v9 is v8 + initial RISC-V build
> > fix, which is a part of another series (this one) now. The proper sequence
> > is v8 + this series.
> > 
> > > So can we please sort through these things (and the AI review) before
> > > adding more?
> > 
> > Not sure about AI but hopefully human should realize that I'm not an
> > expert in m68k/sparc32/xtensa/csky/[your favorite arch here]. Enabling
> > and running the test on _all_ architectures where it is expected to 
> > work requires obtaining (or even building by myself) a cross-compiler,
> > setting up the kernel and QEMU, etc. I've spent a reasonable time with
> > RISC-V and ARM and hopefully set up a good starting point for 
> > m68k/sparc32/xtensa/csky/[your favorite arch here] maintainers, who are
> > free to incorporate the test into their target architecture.
> > 
> > I'm going to fix everything I consider reasonable, submit v7 and give up -
> > because without even a single reply from core RISC-V maintainers, this
> > just turns into an endless brain masturbation.
> 
> I believe it's better to issue v10 of that series + v7 of this in one go.

Yes please.

It's been a while and there are so many patches and everyone's
forgotten everything.  A fresh resend of everything is a good way to
reset and restart.  It's also an opportunity to update changelogs so
they address everything which has been discussed thus far.  And an
opportunity to add cc's to everyone who has commented thus far.

