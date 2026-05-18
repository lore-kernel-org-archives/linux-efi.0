Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A472C187
	for <linux-efi@vger.kernel.org>; Mon, 18 May 2026 18:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779129304; cv=none; b=ABYSryp7L1y8KIZ26aXH81I6zkm+mrODj1J6AYCzJ9s9nj+aQFJ5NXsNpyqD51zlESlA5LUZRUay7RAlIaGekTit6Ru5MwpWQthAtN+Y2ycUM5nYohb0XhvoRl6ZDhHkrjHJxGRyGdZlV0klAEcqaeib+QCNgazVKNsFgWEU5tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779129304; c=relaxed/simple;
	bh=BBgdSEmquIQtG+Vd4wr31W7UJ/hyuPfdXKhRmNVBIjQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=DhwI6bGfkO6gAtVqlC2LRa7fot2CW09oDUY1xJnEwSYVPxlYq9JeGmg5SJkFh3adbRmuWpJ2aD4skzK0CiQhPXaGORSRQpVo72jQNNuVioCJptmN9WTE+1PM0CBiPC1qIJZQhJqkKca/CLU5ewBl1u021r0xwtDFxymu0jDpebA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QkgeDcvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QkgeDcvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D9AC2BCB7;
	Mon, 18 May 2026 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779129303;
	bh=BBgdSEmquIQtG+Vd4wr31W7UJ/hyuPfdXKhRmNVBIjQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QkgeDcvYx/sBQZg0QJXxqsoGkJ/P/vbR4j0IO1OkYDDt7xuWVngrwN1HfDrrWcAlK
	 mQ1W/DHxp9TMTTHoxBA+9exvTLN4SMYGwAaCA8FD044WZl7IafDyg01QOye9i2iunN
	 VIqN+TIBMnXkesp51AJU7oKDIcS697b6GM0eRCqk=
Date: Mon, 18 May 2026 11:35:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>, Charlie Jenkins
 <thecharlesjenkins@gmail.com>, Paul Walmsley <pjw@kernel.org>, Palmer
 Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre
 Ghiti <alex@ghiti.fr>, Ard Biesheuvel <ardb@kernel.org>,
 linux-riscv@lists.infradead.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH v10 0/8] lib and lib/cmdline enhancements
Message-Id: <20260518113502.11a2f420d48f79bb7de31c67@linux-foundation.org>
In-Reply-To: <20260513134407.884033-1-dmantipov@yandex.ru>
References: <20260513134407.884033-1-dmantipov@yandex.ru>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 13 May 2026 16:43:59 +0300 Dmitry Antipov <dmantipov@yandex.ru> wrote:

> This series is a merge of the recently posted [1] and [2]. The first
> one is intended to adjust '_parse_integer_limit()' and 'memparse()' to
> not ignore overflows, extend string to 64-bit integer conversion tests,
> add KUnit-based test for 'memparse()' and fix kernel-doc glitches found
> in lib/cmdline.c. The second one was originated from RISCV-specific
> build fixes needed to integrate the former and now aims to provide
> platform-specific double-word shifts and corresponding KUnit test.
> 
> This series was briefly tested on X86, RISCV32, ARM, and MIPS using QEMU.
> 
> Getting feedback from RISC-V core maintainers would be very helpful.
> 
> Special thanks to Andy Shevchenko, Charlie Jenkins, and Andrew Morton.

Thanks, I've added this to mm.git's mm-nonmm-unstable (and hence to
linux-next) for testing.

AI review asked a few questions - please check these out and decide if
any updates are desirable.

	https://sashiko.dev/#/patchset/20260513134407.884033-1-dmantipov@yandex.ru

Also, please cc linux-kernel on patchsets?  I'm not subscribed to
linux-riscv or linux-efi so my "check lkml archive to see if I missed
any emails" trick doesn't work.  linux-kernel's main purpose nowadays
seems to be "the place to archive patchsets".

