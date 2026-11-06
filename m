Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980294;
	b=D0gASTFT7rd2ToBu4lhoPI2y84C7V/j5d6S0f24zL3vUS39EqfauZVkgUAmqTvKDrwGC
	 994lce6ZadVym3W9kUUqHxB2bUdZoLiyB2KE2tLDrRsHmqd0kSEEelcWzqKJmNQKDH4v/
	 lpN7xAowC6Z2j4QlcmhvhvqWTXwHugFIx9cD7mg0jw4H8sqd3e3LuIqUBwbQmjNujZWjC
	 nxAh5NFO6UG3akDAA9ZkOBrnl2JaxNrhpf0rQIVcGQX9ZtCrqRo0c6eAXsXXD9mcXbPR+
	 MPC4OhPvT+oA2UeXd68F/zN7LcCTzLd6UE5T+Bwn4lyHOdLzfAlkQ6OnocEpm48JXKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980294;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=XvM4aLwTGZj5FmeeGnzfblv0DB1LtfcDNVzyNu2uS04=;
	b=47/aylviafaic8ycy97Ee8PCYpRsP37VgPRH9ZJPC3hoUDOm+QrZ7VBts36UNxQW/fA/
	 pEqNe6UjXFzvQd3n1L98A4ITR79MNoV+nZgb8PaQwRvghPm76SisNF17kNHCJtCGN9+CZ
	 fPPduCxNgUhbOTwLbU8KO5Cb0n80SJzY1FtXcy4D0OXxTU+dTBEy9UatRiSuhkVXkPyRg
	 pVvvOD5TXeVCV2UzUAfju0yuWCrnH9fDkP0Hm6h5LflLBRDDlrR5Aej3zjBPlN7iHy5KT
	 3E8rK3jXhcZcmMHjH297D4IvFTlGVlSww9nEr0WiDVO900ROCdu+SgGj4XC74GgIysw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gg9Qwr4k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559D2606A335
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gg9Qwr4k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CAA1F008A2;
	Fri,  6 Nov 2026 15:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793980294;
	bh=XvM4aLwTGZj5FmeeGnzfblv0DB1LtfcDNVzyNu2uS04=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Gg9Qwr4kbO9AYEeCkv1K0UKo/cQYAwHPADpue+nH3AF5qWLOUVKq1FLTpzmMo50vD
	 6zX6+wjFEwjVHNSD0lihrUxLXN/vzmWGUHs9aWLsm1FT+m25m35m5TYm1BHntIobIp
	 2LtMExaObn5ZvNFXYv+DmeUvmasP/VxNyLixNLPYx16Vp3EkJs0a15YpPvdrtxCNDS
	 soZHZdlkRSLDvMJpD6dEz8t70QU6AJXFsdVOw36r71g3zrQT88gEL5bE1ShZ+DvB/f
	 mOpyFMfNtjzetB+RsDbTR5BLXtxYkJ+m0pxADoNINR1ErWv7v9GaDGH/ZyIvZSbVxc
	 L2YS/0KQ3Zpcw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 76971198003A;
	Fri,  6 Nov 2026 10:51:31 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 06 Nov 2026 10:51:31 -0500
X-ME-Sender: <xms:gfftapY6Upqe6PYvGFyUDwVT4AxOA7G-I4Wv5vbDj_AYY02iid2DTA>
    <xme:gfftarOJfIeWDuHsc1tZjFE8TrAK9J8xJDZ9KBwhvHLYODmpMuij6kdcqqc0MkZr0
    7ns0b9Y3wpeNBY_3yanaSvPBh5JflvoTZeOlVjbhHNj0qwJ1R9HLN41ig>
X-ME-Proxy-Cause: dmFkZTFO9KjBOddWujNCaW26YpnSt+HPt4zfErT3xj3FNF/1a9rqlMvuEU3djbNRlHCnSO
    j6CtxUPhdBxfm1x9PlRZCBJMaSeB/QVnMvLO3h6vjLjiABTb6G3oWXo/UMP02V2tyF9xSd
    ylwodMfptCLfjKCGtbWfnSRz1ccecmbvLtSi65X9SjZjgrwJD5n5NV8Gyi1ZasftjpmyvN
    dcbyOqogCBnuQWO+gKkGPJrxjvHerG2RYgmtL3oLXMx06xh5gVt9uVMDpOzw9Mx03spLtc
    wrsZcXTDPOmOkFPvLM0oEXQxnLmR2R90sbQ0Zbd76luMVvKbQAwT+GGBKMM0wWMN0GRHtY
    QCm41vfoF1hyeNG+ddEi+UcrooKkHGT56jtCZ9ePlC8nHjWLvAQ7DJSAyCMuemGZZWi3CZ
    sTQAfP+RSuXfJiQja4zrSJ7bbpz/GzQasNZ7I9GOMtAFmEHCjEh+90tZtM73n5C3mTxkIO
    PaUfPtxxDBzch/2PUqn+yh3YsgZAW2QQch6HhLc9bDbs7ii2ucY2IEzvFbrJA3+oJfa3vr
    GKp2+513hG4ikORb9aZdvlEh1lCBcOxqin3spbIZOR+3PdHCbghmWaxB2nsQLENSSnlRzz
    9EyV6FHND5H1JqR7NyFIj5lhT5t8hfAoe5ZXiEOj9SFzqKthVigoQcn7KtwQ
X-ME-Proxy: <xmx:g_ftanCRJ5kjiSpMUjqJxmnIEqP3Q0EewyGDG1e332OI1YbhUnAukA>
    <xmx:g_ftannsEEhk7ByYcfSbFgG6rvDjpI7PO-9cTsNcNxsO-zPmluskqw>
    <xmx:g_ftaifBD0UM1zdPFwkSntUxTiciY2zs00h36A58E-zTb2BcZG64JA>
    <xmx:g_ftarRCm__BadvffeAxf20m50iz-53X5jcv0DqFYc-xrPZ9fkQyCw>
    <xmx:g_ftapvchXwaiiRFqNdzftmtn5cJ8hoQuqcF1erc0UOZOxht8jxeeZK4>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 9F732F80096; Fri,  6 Nov 2026 10:51:29 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Fri, 06 Nov 2026 16:51:09 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jason Gunthorpe" <jgg@nvidia.com>, "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 "Mark Rutland" <mark.rutland@arm.com>, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>
Message-Id: <ee4d4788-3d59-48c9-b5d3-ab7d166f4267@app.fastmail.com>
In-Reply-To: <20261106143418.GC770409@nvidia.com>
References: <20261106141936.2744481-7-ardb+git@google.com>
 <20261106141936.2744481-11-ardb+git@google.com>
 <20261106143418.GC770409@nvidia.com>
Subject: Re: [PATCH 4/5] efi/arm64: Expose struct efi_image_info via the image header
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 6 Nov 2026, at 15:34, Jason Gunthorpe wrote:
> On Fri, Nov 06, 2026 at 03:19:41PM +0100, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>> 
>> The zboot compressed kernel and the uncompressed Image both contain a
>> copy of the EFI stub, and both are tightly coupled to the kernel image.
>> 
>> However, the zboot stub is not linked into vmlinux like the ordinary EFI
>> stub is, and so it does not have direct access to its symbols. This is
>> needed today for things like image size and code size, but there are
>> more cases coming (DRTM) where both stubs need to have a consistent view
>> of these things.
>> 
>> So add a struct efi_image_info that is built into vmlinux and exposed
>> via the image header, so that zboot can access it easily.
>
> I tried hard to avoid doing this because I didn't want to make the
> struct layout ABI. I really see only negatives to that.
>
> Putting it here and documenting it in the rst is going to encourage
> other bootloaders to look inside it and try to read the contents. :(
>

Fair point.

> The linker trick to inject the offset into zboot seemed better because
> it completely prevents it from being ABI as nothing but the EFI stubs
> can ever locate it.
>
> Also, I wanted it to eventually be cross arch and I don't know if
> other arches have any spare space like this.
>

Yeah so let's bring back the code injection hack but only for the
offset of image info. 

What I would still like to avoid (compared to your proposal) are:
- having the efi_image_info pointer be a global that can be grabbed
from anywhere, even though in zboot, it only becomes valid after
the decompression has been performed;
- putting every shared variable in the linker script.

Please confirm whether those aspects look ok to you, and I'll respin
this quickly.

