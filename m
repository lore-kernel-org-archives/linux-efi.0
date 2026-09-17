Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C53530DEA;
	Thu, 17 Sep 2026 13:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789651969; cv=none; b=heZjPYmwwTA4OLzkmoK8pcq6otcKNWubgLDcMA9k8RhivLTXzR00lyXgSUPL+oBqKpo8sXOE7jnbZ6OdQGE3+zxe1RFdkVOZIyPtlJhGJ566922tKjd60Tclm/81WFX1OFIiYJ20J4HkpfMamJT8OJN2GTP5ySPHKnqMEevvz8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789651969; c=relaxed/simple;
	bh=eYn5TOcIy9kWmU+JtdQGMGeKpH1NmsCeyZgN+JNAelw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MsQPC0gvu53td11/DHRemELO7PraVmWQhQkPxRFA+YdWXed0J/snv+UbuLmoZyt9h1P1FpbajCqXc1k50VzGldJ451cEeV7vgm0i9n4dNiJ3hUdn/3EOC0UOvoHat1al2c+pjoUVgNP14WU8rl/bvBrDM84V4SgJOHoWiH3Fy2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nk/4F43B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nk/4F43B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497271F00898;
	Thu, 17 Sep 2026 13:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789651965;
	bh=ko49Ot3o0NniWU3hR3PnM8ISBRDYZsmkkz4KRfawXvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nk/4F43B/0+kYN+J4SZDUHWw9VlGVxWp33EAh/B7C2hsyFstUTuKRk4WJMZ+AqqZb
	 fOyhhFELxxTdevZraTs8489drmM8F1zrGaOdKazd7kIZ37G8kPSxgwAqhBjS2aKi2T
	 E6dXttmnjO7d2S8jnvu+NQrl5EdMfTLlHjLYFcT5e0vYGRSjxZqpqbBILANsRxw5QH
	 VOCEnpna5O8Gm3O1vqnUs2D1YNskKy2UxVYWHbCcxthDP/VpBWLJ1sZ3H2IKZDKbix
	 Z4Wh3vwNXS+40P7eFbrlMGqbiQub6Xnp6xd1GLrd+mZPhtJlirN94TrFXAwxUNLhH1
	 +KlBcoRmNOZkg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id A0F871980059;
	Thu, 17 Sep 2026 09:32:42 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 17 Sep 2026 09:32:43 -0400
X-ME-Sender: <xms:-uuran1OCTWYgSwsEdA_5mqTKy0SVsGgxycNN7MsI_0-C7TCzj-DOA>
    <xme:-uurasc3IQXgMICL26A9GH5537k4ahuTMCG6a_SS-p3NRs5aqvbimHAeSEv_Niox7
    QrISwygdAn_gaQQ6jTCeW7rDvOs6QC5r_JO3H4b04erx0XHcG6thFw>
X-ME-Received: <xmr:-uurakKrpYGU7ywLpfYLwaWLlpT4aKpxg5zI2ERmNb4EbI0CFQ4yS3kS2M0>
X-ME-Proxy-Cause: dmFkZTFOF5O4sTpE9EJNPUr7VB9NcEHlk7cjZMCWa+4YHeczag6So+a0dgZvLjjhLhadhh
    O8vQbpT+syF5VxVduc2L83+ju713cQItVSUbVT2jLMK1/P6proh8Yk4I4y73UPitplE8sQ
    VPxVLMjoqbZHBrDrI7L1e9LsUJSn5lRusxFnngoWJl1GAIQsF+eG081buI0gId4+uEjgFf
    PHmnEvKnrgNXNxCkCse4S3FrPUdjug/8ott9G3KUQ4HiK+6VoFxlXJEJDqh/6kcJSnWiR3
    0XH+LBzUIKVyOjr7JPFTlJq1OlRo3qe5MjyqWgbwVRegva+0SAfFyqY7pYZeZFN7K1mQOv
    i+McLGLLnsPj6U29qNTLspfJufLe5JyhK84UpNdMPESxkvg8l7DHE3xH+nAL4am9yIcv+A
    AGmBbfd4YMOLupiduLf96jeZOq6PiY4GMXCcmbbdYa6oJKNPLHHtkfyUBf0nvdC1YuOidS
    aevVZl0PIMe1kC7JZK/SyW14nC4EtSIyfv/OIVnw9hoi+u7hsVTDdNwfAgIdhw/e1K8rdS
    NdwhCp6MBaFkaIOKaSRF2grwA1llnv5RNT16BB0lQGojoEZFzPa9sQXfRQQJKYCk92dFld
    iMC3Y6sKIYsFw+0ksfgP3eLeKsY0t9t12xawz/Ia8KZlWfOYpJs1xg94yxeA
X-ME-Proxy: <xmx:-uuraqrWrI2O3BQm4o2z7qGQktk7-KFlH8d_eRcbLo-r4tM3iFybXw>
    <xmx:-uuraistFoXcvLp93aFNG8XZqBBf64M-hT7aV-W6IipzTZt6DnBwZQ>
    <xmx:-uurakIpVJIAnJ0oMREzmey1rxcgZbj84JuU-W6_LpnZl2xJoAbxQw>
    <xmx:-uurahrArKlHMFtvfXSWyhI295_eF6_Q87Pr5gRD-heBpfWI4zdHGQ>
    <xmx:-uuranUa47RMFSQBfAm1Nm_QZo_AxGqUrYqNBVGmJetLA2ZKp5eyrJ1Y>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Sep 2026 09:32:41 -0400 (EDT)
Date: Thu, 17 Sep 2026 14:32:40 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, 
	"ardb@kernel.org" <ardb@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Message-ID: <aqvrUeIfpE4D-Ol0@thinkstation>
References: <20260914183745.37538-5-ardb@kernel.org>
 <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>

On Wed, Sep 16, 2026 at 06:16:30PM +0000, Edgecombe, Rick P wrote:
> Kiryl, 
> 
> On Mon, 2026-09-14 at 20:37 +0200, Ard Biesheuvel wrote:
> > This is a follow-up to [0].
> > 
> > Move arch_accept_memory(), which is only called by the EFI stub and
> > never by the decompressor on a non-EFI boot, into the EFI stub, and
> > avoid relying directly on decompressor APIs such as error().
> > 
> > Instead, call tdx_panic() on a failure to accept memory in a TDX guest.
> 
> The TDG accept call can return:
> 
> TDX_OPERAND_INVALID - That would be a bug in Linux TDX code, we don't need to
> pass it to the caller. Probably don't need to handle it.
> TDX_PAGE_ALREADY_ACCEPTED - Potential security sensitive error that is the
> guests fault.

Yes, but it can also be safe in some contexts as we discussed before.

> TDX_PAGE_SIZE_MISMATCH - Already handled. Sort of. Not sure if it is robust to
> S-EPT page size changes?
> TDX_SUCCESS - Already handled
> TDX_OPERAND_BUSY - Can happen from transient host side S-EPT locking. Or it
> could be the guest's fault if they are accepting the same page from different
> vCPUs at the same time, so the guest case is similar to
> TDX_PAGE_ALREADY_ACCEPTED.
> 
> I guess the caller could care about TDX_PAGE_ALREADY_ACCEPTED errors. But SNP
> doesn't do anything for this case. It seems like part of the problem is that we
> are passing errors back that the caller can't feasibly handle.

Maybe. I don't understand SNP model and why they don't care about errors
here.

Do you have a proposal here?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
