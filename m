Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7857842A7A0;
	Mon, 10 Aug 2026 18:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786387839; cv=none; b=Gk7ZtJxC6aGe5ZPTP/ltU8sgdpUQTeaQppP3Xth+xp5JlKnUE6sGVDBkWXYsxXIWb69DxQhUHTcxsxO0ys4TSV5+EcHgiItYd8Tb9GlbomvCK5Cp61MJ9Pk/jdhf2JTQJ1bkFk7ata39mVbmIHbOW7aIzGuTN3NbXnAhUz2n96Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786387839; c=relaxed/simple;
	bh=FlRD3XvpX1OtCPsSmZz2SGRV+x8ebfoJvdyxconAxXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a8YPnXU2tOlmOqc+5RbEGyeMzmbZPHAt1Pf5pHYc8w9KOXNpzPK8gThQAFaxeKBm9OAGOAsTb0T4xuJtCRlyEFLGgy3NQ0OHIZ0VzopJ6QLy1NaOd3DDzNrSU4zWkGUOyNdpTDc6QVBWDai06V6cRBQEJ+qxyTZNqKG22OrC4X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QVldVe1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QVldVe1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA551F00A3A;
	Mon, 10 Aug 2026 18:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786387838;
	bh=UtAY2Kq/mLIhmPVIgt8ZoTQ90y8AvDRG1NswgunEo0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QVldVe1cR++MDM0SqEGueUbJXb/7923NikIkVyaf1OXk6tHJQbi8B0snFA/qs5XRw
	 1VREgAwGY11bFDJOH73kDk5BWZuLOhWZu8IOm+0g0T7oUL0Ky+8Xj+R4QPG/4wgnmQ
	 koywgiI1PW2ms1NTS96H+pbwpMB9811gatNQ/L0JWAmkWHKrtEnmZG2RCp39VEy2Rs
	 RiSpRvN94gKz/C1puHgisUwi5hjwZwrACfRo5C55v3xKanXblDGtaqt7XbnmpiPToO
	 bynp1Z9vxe/zBGzrlZCw9kYklzrBXTTutKLkY1KnCDD1rjfU79l94NusY3JocACyGc
	 3nF/atJ76Qa7g==
Date: Mon, 10 Aug 2026 11:50:36 -0700
From: Wei Liu <wei.liu@kernel.org>
To: Wei Hu <weh@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Wei Hu <weh@microsoft.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, linux-efi@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 12/13] hyperv: add MSHV Dom0 root-partition boot
 enablement (EFI HvLoader)
Message-ID: <20260810185036.GA2496954@liuwe-devbox-debian-v2.local>
References: <20260810124527.1409634-1-weh@linux.microsoft.com>
 <20260810124527.1409634-13-weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810124527.1409634-13-weh@linux.microsoft.com>

On Mon, Aug 10, 2026 at 12:45:06PM +0000, Wei Hu wrote:
> From: Wei Hu <weh@microsoft.com>
> 
> Port the EFI HvLoader protocol handshake (efi-mshv stub + SETUP_MSHV) and
> the hyperv_resvd_new memory reservation so an upstream kernel can boot as
> a Microsoft Hypervisor (MSHV) root partition. Mainline lacks this
> Linux-side enablement, so lxhvloader declines to hand off a stock kernel
> as root.
> 
> Signed-off-by: Wei Hu <weh@microsoft.com>

This patch should be dropped from this series.

I don't think we should modify the EFI stub yet. We should explore other
methods first.

Thanks,
Wei
