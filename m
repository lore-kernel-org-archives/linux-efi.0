Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792701029;
	b=L8S6e7uEldRuBeBC0bW/OwGQOV5RfjWDqQd1yLymRgWd0iHBzgMzpXTubgGuGVVylxUj
	 4laBG4P3Jcojg9P2MXMf9xxFi7jA9lR+TOhQfVnOgLJeL9px8h4d8pvnHLgq6c4ksbCQO
	 cuFyyo5jz/LK1mNt4f744JbrwIeSQXEMrLM26Yt/cPvB1CE8dAFsI7z+hCSl2HU6FyYWp
	 UoknsP808zndYBe2T9zjFfhYnvx0fZuTRybJkZgccZbPb2m3gZCD+oJfrH+aw1UIvyvYs
	 hjie/KskvVctI9h3oCx+TrVqcrpE7i6E4m7ERLjwQQ/5C1P0exjwDDTM/VKHmMmrM3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792701029;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=mtF3vQajQOPyJhZ8pZIyA9etEeF4yqJcmtRFAJQzuNs=;
	b=BieR1n5D+1mZ6bLGKLzeBJlkwY2GBGGB4gCnf75v3wHe+2VOTA7zKuP/jRwyoUp0HhWW
	 w+8gtVlfNbiFoM1LPbyunvhqvWthiZBvSgp6h57ClHmz7LQAM5NByj6bve2ySPq0fQQqr
	 bU8PqPlguVFiUZUdO/clARZ0HzDzfihX8SFtuc/WhP4jxOvfK0G5vVI/WclV9FHLk+ljt
	 XG12DDZ/N5CvTxKV7i8vcWgoX0p7fSm/WRGkSmWZk1XhMi23XzENQaFLQFEKjhJ77T0aD
	 V7/rCwVdlgTGAcX8XNuxurezqtyRA2L5alXegjmU0TvJB77wS3KXDQ2ZNWzCaKBtKLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=LDsSSODm;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C472D606A328
	for <linux-efi@vger.kernel.org>; Thu, 22 Oct 2026 20:30:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C472D606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=LDsSSODm
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 2CB2320B7166; Thu, 22 Oct 2026 13:30:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2CB2320B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792701020;
	bh=mtF3vQajQOPyJhZ8pZIyA9etEeF4yqJcmtRFAJQzuNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LDsSSODm88dt4lyk/zBK7CKfoYnpC2lgIEiuBHBs/rtG60wZIcR8b8fvHqkRJ18mT
	 wvLDi2J83KFr0VuZ5xlQYfmTtrReRTLGjFv5zDjKO9gfBBbErkwW345VaYfwFDvl58
	 YJBSgYSZ8ba21XA2qMvHe8lfusIbQIWJHkaogxpM=
Date: Thu, 22 Oct 2026 16:30:20 -0400
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64/efi: only disable the EFI runtime service that
 faulted
Message-ID: <atpyXJFY1dN/W2nv@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20261021230503.2075618-1-hamzamahfooz@linux.microsoft.com>
 <13d53e6d-9fc0-4926-b8e6-3ee75ea82660@app.fastmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13d53e6d-9fc0-4926-b8e6-3ee75ea82660@app.fastmail.com>

On Thu, Oct 22, 2026 at 08:05:17AM +0200, Ard Biesheuvel wrote:
> Hello Hamza,
> 
> On Thu, 22 Oct 2026, at 01:05, Hamza Mahfooz wrote:
> > When the firmware faults while executing an EFI runtime service, arm64
> > recovers from the exception, returns EFI_ABORTED to the caller and
> > disables all EFI runtime services for the remainder of the boot.
> >
> > That is a rather big hammer.
> 
> It does not just return EFI_ABORTED to the caller. It basically does a
> longjmp() out of the faulting context straight back to the caller in
> the kernel, skipping all execution that would have occurred on the
> way back out if the fault had not occurred.
> 
> Assuming that the runtime services are still in a sane state after this
> is not justified, so I don't think making this change is a good idea.
> 
> Do the systems in question expose the RTC via the standardized ACPI
> methods as well? I'd be fine with some logic that avoids rtc-efi

Ya the machines export ACPI000E devices and acpi-tad is able to
register them (as /dev/rtc0). I'll send out a series that I've tested
that implements that idea soon.

> entirely if the RTC can be driven by a native ACPI driver: that
> seems a worthwhile improvement in its own right, given that EFI
> runtime services are evil and should be avoided where possible.
