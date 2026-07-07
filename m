Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC1F41D4D7;
	Tue,  7 Jul 2026 13:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783431637; cv=none; b=DfU/pz+yVn7Ux9ZDp9U2SrfJfRnWsd9sPxaVEViB516/JWQwfkJayuhK28r9XkfavHE9fjFF1NDFNsIbURvVhBAjCnUKmo+6bbKoNnBBEnP0+0l8ZBBsDPWL3lRqCVwjrexS4lbNMFUgIOM33sss7v+CShIp7/eFbK6373NBoeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783431637; c=relaxed/simple;
	bh=OFDPPY7kR+ZKFxYAzeZMG3uqE+PPGueomySwECaLpCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DsscsXDlkbatAY68/QFVCLMNFzTDfshfu/pYeJMPdFlg1MXrjsdab8UAOOkwY/xWRERByMUnwu4/+DNxmVwHbMc0hOgn3mvBG9u+NGwjfUDjrhMPC5rwOcgDK3uZD7j8V2d4t/luAGd9uOjVpt/LFirmjGsEK8dbA8xciVpOURw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rt1U2lb9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rt1U2lb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034A91F000E9;
	Tue,  7 Jul 2026 13:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783431635;
	bh=bmqUt+g9FyWmU6ipf2GuV7nDUiq2yVCFHD4qz2spAaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rt1U2lb9H02UccHpTsgdX7JQcUo66j+coktV1nVn/mBIWyNGO3PhZsxunbAcW83Ka
	 54kp8+S5mjCXn5HtTbFjhDCYTzAdkkwPBpUFbX0whVqiC8ziFubhi2qlHdvdByzzms
	 4nk7JcTLdxAPhNaMIaOAMEP7QNAVNRRGmeyfScH9xe6waEQmbq1NpGJX8K/HDsBUo1
	 jZp37rBWM92UU7LoN9B13cTA39ZGzZ/6ZDrqSbEYvuEk2nbD/lABU1ulNRDnib41Nn
	 I/8pmobomED2Vl4XQIHtRfuJ7Fmt57A8Nf7iLZmzqpRpxKxZGyTtorI+eccftmIKR9
	 GazRqD5MT+VKQ==
Date: Tue, 7 Jul 2026 16:40:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>, Thomas Gleixner <tglx@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>, linux-mm@kvack.org,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>, x86@kernel.org
Subject: Re: [PATCH v2 0/5] treewide: remove unreachable memblock_reserve()
 return value checks in early boot
Message-ID: <ak0BycosiHcaZLqg@kernel.org>
References: <20260706163753.193875-1-ekffu200098@gmail.com>
 <akyZ5DhIV_Grn1Kc@kernel.org>
 <CABFDxME7ig1SQDB39TUeUXoAOA2jSRhg6h-bm0kUHrHzGYeE-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABFDxME7ig1SQDB39TUeUXoAOA2jSRhg6h-bm0kUHrHzGYeE-A@mail.gmail.com>

On Tue, Jul 07, 2026 at 10:24:09PM +0900, Sang-Heon Jeon wrote:
> Hi Mike,
> 
> On Tue, Jul 7, 2026 at 3:17 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > Hi Sang-Heon,
> >
> > On Tue, Jul 07, 2026 at 01:37:48AM +0900, Sang-Heon Jeon wrote:
> > > memblock_reserve() can only return an error after memblock_allow_resize()
> > > has been called. Before that it either succeeds or panics, never returning
> > > an error.
> > >
> > > Before memblock_allow_resize() is called, the return value checks of
> > > memblock_reserve() are unreachable and can be removed.
> >
> > I'd rather keep these checks.
> >
> > Removing them relies on internal details of memblock_reserve() implementation
> > and the existing event sequence. If the code would move around relying on
> > panic in memblock_reserve() may not be correct.
> >
> > And the few bytes and cycles the change saves do not worth the churn.
> 
> Makes sense to me.
> 
> But most early boot callers of memblock_reserve() don't check the
> return value, so I thought we already rely on its internal behavior
> anyway. So the few remaining checks just looked a bit inconsistent to
> me.

In reality it's very unlikely for memblock_reserve() to fail, especially
after resize is allowed. 
And if it does fail, the system would trip on a memory error, usually
sooner than later.

> Would you still prefer to keep these checks? If so, I'm fine with
> dropping this patch series. It's not a big deal :)

Let's keep the checks as they are now.
 
> Best Regards,
> Sang-Heon Jeon

-- 
Sincerely yours,
Mike.
