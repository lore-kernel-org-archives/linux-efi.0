Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795284972;
	b=14OKIJUPsNLxqYym2b+Du1uR2Pvah8275HYrpt7A39iKLXfxfnfOmDM5Rg95Bxe5qDFH
	 uI3YpOK8PRk2c3fLTsAdKxpt3Gvzw44NlUVuq4FYkQ3DBVRBEvwIEkWRaDILpfAP9pFEI
	 boaD3bzbVEMLmI7pDSJlwCCRHMMJml6A33NUbjK6OOrQtn5+BckVl9bWo2VeSdTOlPcbC
	 teWBubzkQd2zqURcmWESJW9+UcsaUsSjEjkmT7sfGrJH/4c31OoKGhQZm4xqkdQX1A+w9
	 JjxVHIFjxE1nmODfdpX/Rrsv3RzXAGCqy8e7HwbrWQeIHyw/w4ooglAj6oNxqp4n/lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795284972;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=1X5j7YQdcz6iEhlSddIVL1ix+zetO1vVrxlepqlUlLI=;
	b=UnmiH8eWSEfHee3UxrjBCD4Pcm3ttttSKl1oOmRatXWbIMHj7y62OpvYAswPUTi9F9/9
	 qNawVy7nCBcHV5D4ShXIcHFfbWplGWssX3eKyIsxLmZjVmmMuMQdnNft7jJJXgjER6tLy
	 zDKr3IUCUGYdv2GePvManl1niaMQYmPVkztmA9mUJmN0DDv88vaBUpSHDtTGP+ravc0pq
	 PdaaO9glnh6BbyzgsAdi6qxDGldy5EYOXp9O6R7RPzrWEydwJsV7OCYPmWdAHvCf0b1xT
	 I2i8E9XNWynB5Rb3quaL7/XSX2Myp8H3VaDi7A6+JfKHDzKz8xcc6ckKj4JHBdpE9OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=asuLfqv+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77618606A334;
	Sat, 21 Nov 2026 18:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=asuLfqv+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511541F000CA;
	Sat, 21 Nov 2026 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795284971;
	bh=1X5j7YQdcz6iEhlSddIVL1ix+zetO1vVrxlepqlUlLI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=asuLfqv+WoimE3lnRbXLpEZ4xaibv3RcLStvAWZagJmDQ/94yST4XsB7X8GNlAm0X
	 Fg3p1aMVIg2psOQI1nTL092nU6PoOVLSw0CXn64RcjWi2ktTHFQ4NjdyXvGU3xbgAv
	 lAsZmdeJi462bL+xnUn8JU2JsbxenUG11ucyRLThUOdVUgCA2JV2Iv6gSm7gQUsnwM
	 mz9oN4SPPJQKmbwNOkHkLM7egwl/UPP+9x07Cx2swWtckEFXGyO90IBsUqdjpN8FbI
	 I4PqZaYEdrypOuctVSLvXK/zw8eG35i85BVEpHLwBFhalQlLoIWQGRbNnsiQ+Weh6J
	 bHIoewRY9Xd8w==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3FACA198003A;
	Sat, 21 Nov 2026 13:16:07 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Sat, 21 Nov 2026 13:16:07 -0500
X-ME-Sender: <xms:498Ba5oRqe_6IRddTVKiT6LhTlnB8Y8L53p9D0szvXvP81pP2L5AYA>
    <xme:498Ba2euU5ISwHA9xnw0ZCN5WNbnbT1FAIwjlRsBbAQqx1yvFtcdB0OVy1okW02AN
    iRGMCtRP9YDLF7QprqrV-RRmYxMtUi8v2HJdwm0g5PHYT6urSoJZ2EO>
X-ME-Proxy-Cause: dmFkZTEtnHGhzDjhdINsG+KI0AoS/50TK6i0wx1kQ//6c35E2ONVRFcccFQwcKMKtHY8mi
    bpKgiKFvgyr5dJzeZ3i9+Wpo9GY7dsrP0B5Q7pRmFO8jNvkYwxDvX72jCnQhaXF/lbhLU7
    cuhmg/0yG+L1AOBY58lznHtSzbcbrz8Tt5TrAGIrXp8x7mTuSDCEy8ZLJ7pQHLmHkCxoN4
    9DNUcTVGGis4QgolqvOmcUwB0NDvIAxwlHDkhKpfEBJuN4KIk2oefdaWg4cVlCAsVFojwu
    6elGZvjbiLHilZ+ggJVlCnal4RSLjOe34UQkgEPyiOQ/osegaaaVWWoJYnVLI5A4H0PPTE
    tNyotbzbZ4WhPf9sGuZUNl3qfvmWh8Mht94TIVZWmom+eLXngnpGxMjmbNIGjC4JMC9Jwh
    HhtxIJ4PxPMGTye2eEOCAqZL7aUeUKPr1nMmlPpxHPnTDiwbXyqcHDI8W+TH5ekEOfBs8h
    tAjM52b23mFqW01Uj3K1WOIm525O/G1o5cbTxA9hwSPiU5Dv8MegKypFQUFCF/EUeyZ4xr
    nOLSiNWkgfTq+Q+atQEShXQdnWnPStC57ECGtQZkhGgtUHCB4uf7XaKcwm81cxHRHOMUUT
    VB5gf9jp2LMf99oh3KXve7qkvCCxRamQ6pvLQadt4w9adP7M/Cwf46VUXZQw
X-ME-Proxy: <xmx:598Ba3oL8wJA71R9Zd8aIE4BGHiYeNHyJbs7NH7qBaM1Q78WegXW9w>
    <xmx:598Baw63-SL2kR2AhznfEySyxH01iOH7gHwj0xlDswYKK5FqEej_3w>
    <xmx:598Ba3B5ED4oSbUHDnx2vPMOjl_TLjH81RAGTI2SNZCbf1ThuNay3Q>
    <xmx:598BayYsMMoatGidertwgS_KZQcP0M5yXhWLDSlWR_HcXVm0l-bnig>
    <xmx:598Ba7I4gThabSsAzvM1bknYm5nzofGQadLXacyxdXTKmUfVLXMscH19>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 2505FF8008E; Sat, 21 Nov 2026 13:16:03 -0500 (EST)
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
Date: Sat, 21 Nov 2026 19:15:42 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Han Gao" <rabenda.cn@gmail.com>
Cc: gaohan@iscas.ac.cn, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>,
 "Atish Patra" <atish.patra@linux.dev>, "Stephen Boyd" <sboyd@kernel.org>,
 "Brian Masney" <bmasney+clk@redhat.com>,
 "Jerome Brunet" <jbrunet+clk@baylibre.com>,
 "Chen Wang" <chen.wang@linux.dev>, "Inochi Amaoto" <inochiama@gmail.com>,
 linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 sophgo@lists.linux.dev
Message-Id: <9a94e434-13b8-4a45-bf3a-78f99a2435d9@app.fastmail.com>
In-Reply-To: <20261121144848.1277368-1-rabenda.cn@gmail.com>
References: <20261121144848.1277368-1-rabenda.cn@gmail.com>
Subject: Re: [PATCH 1/2] riscv: efi: Map runtime MMIO with device attributes
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 21 Nov 2026, at 15:48, Han Gao wrote:
> On Sat, 21 Nov 2026 13:42:20 +0100 "Ard Biesheuvel" <ardb@kernel.org> wrote:
>
>> 
>> 
>> On Sat, 21 Nov 2026, at 11:38, Han Gao via B4 Relay wrote:
>> > From: Han Gao <gaohan@iscas.ac.cn>
>> >
>> > EFI_MEMORY_MAPPED_IO regions are mapped with PAGE_KERNEL, so device
>> > registers end up mapped as normal memory.
>> >
>> > On Milk-V Pioneer, GetTime() reads the clock controller registers and
>> > faults:
>> >
>> >   Oops - load access fault [#1]
>> >   Workqueue: efi_runtime efi_call_rts
>> >   status: 0000000200000120 badaddr: 0000007030012000 cause: 0000000000000005
>> >
>> > Use PAGE_KERNEL_IO for these regions.
>> >
>> > Fixes: b91540d52a08 ("RISC-V: Add EFI runtime services")
>> > Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
>> > ---
>> >  arch/riscv/kernel/efi.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> 
>> Acked-by: Ard Biesheuvel <ardb@kernel.org>
>> 
>> I can take this as a fix via the EFI tree if you like.
>
> Yes, please take it through the EFI tree. Thanks!
>

OK, I've queued up patch #1
