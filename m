Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF4746F4A4
	for <linux-efi@vger.kernel.org>; Fri, 25 Sep 2026 11:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790337565; cv=none; b=uYKgfdALU+VwQtLapQWJBtt9RGBGMdWEU/k+CzR4JMaPvzzxhhLQOa5G8YyEYRY1sXuEgalQfatLvTDZHoJj1WC9/hnPIhG2JyLDCkFonXo9NVnUn8SeoLLLrZnOc9r+fkmTjfj1HJwRC42CyqvNlGhACm2yacA+6YmsOy/Wlm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790337565; c=relaxed/simple;
	bh=OkZ9s7qVYewObevOjHB9U5ffiZOXpaUNJ0IxWSPk1lU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WSKNaESB3p3DeHcEdDGxFf/7QYd0iVFx/OrUwAxOZ+nff8qd0HGBSaRlmULwH9AXVBGH/aCMiCyMT7ZawYAuMCfqMTLE1P6CNk2E43CYwYKys/qHFNQyWVjutQzj7SO5oVwKEl5oqy+028aNSk2XurCQwJgO1ExLsgJneODEvl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OYjOHOnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OYjOHOnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB1E1F000FF
	for <linux-efi@vger.kernel.org>; Fri, 25 Sep 2026 11:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790337561;
	bh=EglN99ky8xNvNvSuV7HNM4RJ6oE3elkW/pJP+eSaMCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OYjOHOnUTgzJhBJmbOJUCCg6D2LWvW31yIB+UE2OWRRwxVuvVmuBzV3UAhxetIx4V
	 mlt44scWKgrddr3WVJZEvU5qVqE7Qvk5sVosC6DtvcDcSBtN6j/ySmSopBLtTGQF0q
	 Vf866o3fsUdzBFCT3W5TgzrbVVEwkkuDCobCw7hvHgTG5hDhGy6yGoIZbzKjanmb5i
	 8JbLIqi3jOmZLEUOubIT7E50EhpnZtcC3X9AEgmNIFmvk81VxTyLxWzvPy6BNZeA7C
	 wgFaTpDImfJMVjLMG6hJN41sL6RRP473eVdPEch823lIoOyrePLhdiYQzqHhtIT7NU
	 6WNXtzG1Q9e1g==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id E35F2198005E;
	Fri, 25 Sep 2026 07:59:18 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 25 Sep 2026 07:59:19 -0400
X-ME-Sender: <xms:FmK2am4eBZe--91lMwbRD8FRox4T90bd5RKQidxcu8ks6x76Y4uOuA>
    <xme:FmK2amRHV6o-fhKcYYqq5tsR1be3TW4kUtz0e2FRzmgE0eR9SXnmyF_gALp8yy91s
    ZxJ3nFLud_nh73VA094323Doal9juit4mc3JmG2L2wtlX21Cr3gWqwM>
X-ME-Received: <xmr:FmK2ahtfbfbJ8MkA-WRv6ufMqoLTvP43U7nJLou32rMCok_SynbNBb_VNTw>
X-ME-Proxy-Cause: dmFkZTF4B9jc6bPKzIGqXkE9W+iQRipTWSC9+5pT01lO9q61FziH2ejxZPJtqo076PKenr
    QTkkz6cyPTc+9FjDjMnSuX3wTgX26l8A69DHv6/D3nrvsJ0b2rFzvB5mRFjUrH4T+905wi
    zUbGFcggifhAhcDvlMzTmfd+pvC6T/JQB85GM7ZUMvpLFjtzLN5Bw4Cln0av5F4pUDWKyw
    XflUwYEKPbMh7v3YuHDw1xOED6CrfiYED3Fx8IGyT50HVsOfzdBqRL9CEINo9Ur9zqU5SC
    yQFKo3sKVgHRYkto5XJ4QxYVVPnOP/YB5BYlS+kjDZEXeZF6kDe1b1UbsnS0WhjQ+dIcYU
    CRhhBtxXaJeBBlKYc3w30OCfLMNC43ciWstWP3LI5kOKOpClYkX/svAP743nu0KbgJwtKT
    pdRXpPOlnZb9j4ptsmX1rjArvwci5bCNdb3gODXMYA74rhfJw+vocg8Z5p1nudC8fyv8pY
    +NQT9qqeYL+vc301nlWIOpF7RaXtHfn3cYRxsnY/sdSxo3rW8v69dxXHecJzvG6wHLptuf
    x8KT4NJfo6maR0i519MkfhFFEv9J+YkstP7i7Apx1yH6MGZ7M3lNWkc1KaXJG0CdP2tILT
    QZZ5DPWl6sZ5qgLglUKf/YGBweeMRwdLxOom+g7C5QjUSibasfxkFjLy2z4g
X-ME-Proxy: <xmx:FmK2ag9gVazRQ24PetfqXjiHqijM7YEK8wAxKesoI5Qe63SUsU6ldw>
    <xmx:FmK2aixrZT1we4_sHeK4C_UCKG6UoJTKOk9UDRNVR6YCjpapCXP-vQ>
    <xmx:FmK2aq91skRaNyR0kZO79K6mBj88dkOaedPzmQdxhpDVqhKDsT_pAQ>
    <xmx:FmK2aoM4-U7xkAhXYCvXY1CdqV48WqotoxPeKchdTRy2BSTmrO7ATA>
    <xmx:FmK2aiq1bNkIbYRyAyZ2QV0OuoWCRwuGqe4VHpBSktVWfsEQruEFRZLD>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Sep 2026 07:59:18 -0400 (EDT)
Date: Fri, 25 Sep 2026 12:59:17 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Borislav Petkov <bp@alien8.de>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 2/3] x86/boot: Move unaccepted memory handling out of
 the decompressor
Message-ID: <arZh_KWXq7-kmwiw@thinkstation>
References: <20260925075137.44298-5-ardb@kernel.org>
 <20260925075137.44298-7-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925075137.44298-7-ardb@kernel.org>

On Fri, Sep 25, 2026 at 09:51:40AM +0200, Ard Biesheuvel wrote:
> arch_accept_memory() is an arch-specific hook that is required by the
> EFI stub when processing memory that the firmware reports to the OS as
> EFI_UNACCEPTED_MEMORY.
> 
> This hook is called after ExitBootServices() has been called, as before
> that point, the EFI memory map may get updated behind the back of the
> running EFI stub, making it difficult to get a stable view on it while
> iterating over the entries.
> 
> Currently, the x86 version of this hook is implemented in its
> decompressor rather than in the EFI stub itself, in a manner that is
> problematic: when an error occurs, it calls the decompressor's error()
> routine, but without having gone through the decompressor initialization
> code. This means it will resort to direct port I/O rather than the
> hypercall based interface that TDX guests would use otherwise.
> 
> Conceptually, code that is only called from the EFI stub, and never by
> the decompressor when doing legacy boot, belongs in the EFI stub and not
> in the decompressor.
> 
> So move it into the x86-specific EFI stub code, replacing the error() on
> the TDX path with tdx_panic(), and dropping the error() when no CC
> support is detected - the kernel can decide what to do in this case
> after it has booted.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
