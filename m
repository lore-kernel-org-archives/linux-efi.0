Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794857626;
	b=eK0VRBa6hat2OAkI5YIqk+YTRx+I6XDIo9e1OtxRZsSvbnfdreCXQxxxRUASih260kIq
	 fZlBkFsia46Pd7BFsachryVEFmW+WwsSlZbqESZp3X3gWubR3rPPI0TZUGHm7gn88p7aN
	 6abER2pITjcDLIrEeKkXrgs4IM7YwX8uTP22hMDxWvKLTujF68CShVbeWjknVwdSAKpcu
	 LnUbJYbdxEQImf+YrkuQrCozY8/NPLu8L28ii1X/L60eaSDgP06CMr9SdKtcTBy1MOeNx
	 gKhiGH1BesqvHYs0agu7bLDnaQ8hYq6XBS9trOILZIXSclh91DLrERv+ZgBpWfZJWMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794857626;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=PVpms2o1EVmRGV9LLOQ7J/09tS82gfik30j3xDX0yg0=;
	b=NF67DizFSZQFoc1Y7NskKpejtAyv/WJgDy6C7GGyoW+XVxe2GnQChFU7oUX4ct1n32Pq
	 bSfgfmcGYZePgHbRw8+GLgSO0QR2pP1V3Z9ApsfaphXEELoqxMmDTrztkVksD8eQFpxFj
	 Wv5krpOkV/dQFwaIscSAO+I1e6y8TFuqeD8WJL8qlimTh+ZftPB8MRpEZJ1QFi8cAtFk2
	 zRPMvVLnCQJBBIFeIqLr1Er2v2m6oYI3d/79gWHJGa202c4KGf2R4qIfXv02h8Q3AATAh
	 gFsq2N9IqQJXlN2VKcfM3cv6dupuUm0+nuYozpcsLiZaFKjBYPnwcCTKCDFLxR9kI8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DoF307gz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BD2606A322
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 19:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DoF307gz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C8F1F000C5;
	Mon, 16 Nov 2026 19:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794857625;
	bh=PVpms2o1EVmRGV9LLOQ7J/09tS82gfik30j3xDX0yg0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=DoF307gz5M1yrgDz53bvqPNhfpUVTF3k7asrDIxmNb1O0HXbUjiZWFEehcnyk4L6c
	 Rc1wxZ2LSw9N2TW6TUgVvJhza3XZ3rODeFFqC+Jz+Ozphc7CGXUGQy8/UGAWXB0sBD
	 25bT2TJRsJ5ncG7GA/r+r3k/YqFH1Q+H0Kho09e5GrhitgkdrKHhsaM9/5OHjzRVmT
	 ISUwD/L1QSxCGMpRJuwwXxkIYmbdBDw/c3/m81kKu9fzu4ywocsXu2eOmlSTsonUs5
	 5FtFYF0xs4kn3X3+DB0dXCkU3P6C6a/L4sxG/uhsLFrNhI83jpRaoKd/WmEBtHLp0k
	 Afd9xplXmC+EA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 4D0C5198003A;
	Mon, 16 Nov 2026 14:33:43 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 16 Nov 2026 14:33:43 -0500
X-ME-Sender: <xms:lVr7amuD3NuJhkSrpWp3VzZUR3jOpvkWDvXaegYsFvV86bEzMcaazg>
    <xme:lVr7amTqKIc2VuyaiZwhDWThqZXwXbVRzr7h7UA2s-Hb8lmhPDYVY2qmwdoQD6Of_
    sXli3_8BsneC929ZGNnqvEVa3T8-phI-ra4Gp3ZkaG0stnPx1zwCJ6A>
X-ME-Proxy-Cause: dmFkZTEsUjVsRuDkUa7AsdpqUHn/DF5gSGtgp0t8TzPcoTvUuShZj8JJiVDC3OOXEtCV2r
    HxvjuTO6TDcDBy4GimavF8rjlflLcDYxuACE4bWE8jDIzLK6SKIeI4JBs4haT51OcvNaKx
    9e+X0NK037q9wSnPrajH28ZKGPxwsGVq7FukXREgnna0dCjjQX7q+MOjOKLt9MoAsVeVOi
    Jm52s0xdZY71jDkcx8KTwcECX1OQpEaFUqPHUAVdZWlHMaUdAwjh2E4c6P6aeqx2q+U1/N
    x79WnOCzEspF2JvrVc78i54LZo+ejlLcS7YeDpkJyRkZZpFY9i1JAJXPwzjylm9ORgKtQF
    /aMbxdJUQWK81aLhl19MdNhjdVB9Q+ACijf9YH1N219JKM1YqIcEv6IwgjxHpwO5GOD2N2
    siWcWFDKFV+DA6wrBaES/aFDc6a7ieB7Ji2wB3QNEv3hf1xYArHqfbsgc6b2ndSQHiMlNc
    A9XBKaDJBDkXlVewYP87uORVQgpWsN3fcazwC76qgsJkN3mO/52EohAtJ6BhioFEAOav4u
    IUImWAFMCtziV2O0XBeGYfnqxojIg4z93Bwv+gA3EfMmnpPdKLHv67BnTSDHALDySWsIZK
    lzHLeAOzrIOGH+RbDtd9abhxcuC39anQmauxMw7nKt0mBDWfK0srTa80+ErA
X-ME-Proxy: <xmx:l1r7aqRlQwBrmsGSQoSroK7Eep_8sK5kGLtajL4VxTRLDVji1VAZiQ>
    <xmx:l1r7arpxGIzlQHI5imELvfpHUUzhULRwoA6c12SbhurpD4Wv8Dsgug>
    <xmx:l1r7ak2j2I9BdDpP7SYYFsBvWH05IiZYZdJ98OE8_LWw0pOKR20EBg>
    <xmx:l1r7aq4gIvAKsDs_Jr9kGXhDzNnekzOFgKqq86jNrQPlC_whL6ruDA>
    <xmx:l1r7aoR3nbTsrOemmnE0wakAmdbT8ugINVyDE11rW1COkcAB4HBeCpug>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 03D94F8008E; Mon, 16 Nov 2026 14:33:41 -0500 (EST)
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
Date: Mon, 16 Nov 2026 20:33:20 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jason Gunthorpe" <jgg@nvidia.com>, "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Message-Id: <49bd9e1e-abfb-4dd9-9de5-fe4e94308fd1@app.fastmail.com>
In-Reply-To: <179485513572.2274641.13924640952978903053.b4-review@b4>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-25-ardb+git@google.com>
 <179485513572.2274641.13924640952978903053.b4-review@b4>
Subject: Re: [PATCH v3 08/15] efi/libstub: arm64: Use struct efi_image_info to access
 image properties
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 16 Nov 2026, at 19:52, Jason Gunthorpe wrote:
>> [ ... 53 lines skipped ... ]
>> @@ -22,23 +21,23 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>>  				 efi_handle_t image_handle,
>>  				 const struct efi_image_info **image_info)
>>  {
>> -	unsigned long kernel_size, kernel_codesize, kernel_memsize;
>> +	unsigned long kernel_base	= efistub_kernel_base(*image_info);
>> +	unsigned long kernel_size	= efistub_kernel_size(*image_info);
>> +	unsigned long kernel_codesize	= efistub_kernel_codesize(*image_info);
>> +	unsigned long kernel_memsize	= efistub_kernel_memsize(*image_info);
>>  	efi_status_t status;
>>  
>> -	if (image->image_base != _text) {
>> +	if (image->image_base != (void *)kernel_base) {
>>  		efi_err("FIRMWARE BUG: efi_loaded_image_t::image_base has bogus value\n");
>> -		image->image_base = _text;
>> +		image->image_base = (void *)kernel_base;
>>  	}
>>  
>> -	if (!IS_ALIGNED((u64)_text, SEGMENT_ALIGN))
>> +	if (!IS_ALIGNED(kernel_base, SEGMENT_ALIGN))
>>  		efi_err("FIRMWARE BUG: kernel image not aligned on %dk boundary\n",
>>  			SEGMENT_ALIGN >> 10);
>>  
>> -	kernel_size = _edata - _text;
>> -	kernel_codesize = __inittext_end - _text;
>> -	kernel_memsize = kernel_size + (_end - _edata);
>>  	*reserve_size = kernel_memsize;
>> -	*image_addr = (unsigned long)_text;
>> +	*image_addr = kernel_base;
>>  
>>  	status = efi_kaslr_relocate_kernel(image_addr, reserve_addr,
>>  					   reserve_size, kernel_size,
>
> There is a further consolidation here, the two places that call
> efi_kaslr_relocate_kernel() get the args from image_info, so we could
> just pass image_info directly and remove the duplicated extraction and
> extra parameters.
>
> It could then handle the image_info adjustment too instead of open
> coding it twice.
>

Indeed.

> I wonder if riscv should have the segment_align and image_base checks
> too? Maybe the whole function is just a call to
> efi_kaslr_relocate_kernel() ?
>

IIRC they were added specifically for RedHat's spectacularly buggy
GRUB fork at the the time, so maybe by now we can just remove those.

>> [ ... 9 lines skipped ... ]
>> -asmlinkage void primary_entry(void);
>> -
>> -unsigned long primary_entry_offset(void)
>> -{
>> -	/*
>> -	 * When built as part of the kernel, the EFI stub cannot branch to the
>> -	 * kernel proper via the image header, as the PE/COFF header is
>> -	 * strictly not part of the in-memory presentation of the image, only
>> -	 * of the file representation. So instead, we need to jump to the
>> -	 * actual entrypoint in the .text region of the image.
>> -	 */
>> -	return (char *)primary_entry - _text;
>> -}
>
> I think this hunk belongs to the previous patch which removed the
> caller?
>

Indeed.

> Anyhow, the logic looks fine to me
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>

Thanks.
