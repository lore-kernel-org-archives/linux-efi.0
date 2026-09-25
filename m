Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDBE45C715;
	Fri, 25 Sep 2026 13:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790342483; cv=none; b=d16n3OEzSGKqVoQT2LeTZJlSbdWOeJUMC6KVTQ0cfbZY6/mzS3kb7IlDdBtJH+u9KhkAigYpO6OGakF2wT8v2q/63Q3uTO8XlEnDKWRvMbBiXeM5OhTAziuKr+GpNM9xd5Qw8Fr2qzJLnLN7d8tG/wFPHmhHtjWChnzUZuEw014=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790342483; c=relaxed/simple;
	bh=BDnnA+wMmkd0GK+KM4NviCTA3nc+bJ+Nj2nL92tXupw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=sUkBARQtix3EesXEuecpoXs+qWKnRetsUNLlZGkTvEVJC8OwFBdtmUJRP27s+XqlUXjFezP6Oy1iTC/tJJQYrTlmVzz6m41dvc3jLhsT1x/lFrsGd/lKsvOOzLXZDXKYtBz523PrHDHwtuc/87TVGRq+tLCtjiTNT1CKf/VEMEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Flu2cb+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Flu2cb+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330231F0089A;
	Fri, 25 Sep 2026 13:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790342480;
	bh=nnp5HOIGcAOyxCzrPOE4p3KTTNVywfZTwHRYxevT9oE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Flu2cb+OOJe+RDoDJQrGbsJowghhwvyWhFhhD3p3l3wq5Ex0Md5wbVj6yOVdLfePX
	 1PGAeXz8uVyGdSQPziBdQDdIG/Gv294GJ9E45iYKLyWLbAUhp+O1izLTfBPHmQD7jT
	 0ZIHSdNdBQbSIWWnhF8WjbV5pQ27qnGamiD8S+MlInOhCEbzE59jyBMwDdYGmlNSSq
	 9S1B2/pYQLP8qFxP3jp7ubgIoiaraIDw34SVn3a5YnwrMjQRF029coGeQOtPdsd3Op
	 ADTNtyMd6oZgQGjPJB80tbJYLLfxDnxiu9PECke7gTWj8SRlaxPmobooblVNJkfg+v
	 I+933a/dY+Geg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id A368B198005A;
	Fri, 25 Sep 2026 09:21:17 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 25 Sep 2026 09:21:17 -0400
X-ME-Sender: <xms:SHW2aktaus6bb3IDuwehy0tHmweKqR04JpLaMh72_iSOaPlqzXvfjQ>
    <xme:SHW2asSnKpWQ-r8xqObdC2hSfp-2imDbKVp5NBJuyfgOSvio4fGmEOyM5nQ9ahFsn
    kqOeUq5fxXXYI5iD6Y_2CQ5nw40e37Is80LXaS-sAhalrV-DLrdURsk>
X-ME-Proxy-Cause: dmFkZTGm//tvmOX7B1Z6aN22M5G/NImGiJI5CG+zWqb2Cz5VW2X9+opF+vwz1PFhssRYty
    oD8XLhwfOFQeDBAu0BJPFbOMXjR8yUQo3h6q/OacKqpkU0GkT9Plok53rbQqbjW3fcguac
    PFdoO4I+6Si4H1xddpnS0WdVtz3WxK8NoXh8W2ru9lYH925szGXJjXx3Y+vB4izliBqDc+
    J1ni3rDNHLoAHy+nSwmI7gwEkj85FUw4B/aFanwVvYpsZBAaCygwrpKO9P9m45bmAZJLrD
    IJDwKb6eb1YdHlf6/5vjdaV2WvJTzeZLEugQPszF1ilewRcazFfoDb+r1OV6+YI9SmRMJg
    punkHkfINQz5IsX9htKb+bV85phrVMj3lY2al1xwQs997rDo15yxZfcBBoQwE5h/etuk0Q
    nqMv8To7cMP5rPdvrcccT5GG+1mY0sC5o8vka5eieW4pZ6HyCnqc3r/mX/WGMGmAWlu7TY
    FCTQnFBks8dPu0cUVM3LZv3/ULJLlsa0QPLsBPxssiLh4T+spgXVbzKrpqM5xPZoKD2AWW
    53sHXPvAERtyW/YFkqdqVkA20ADoFtRf6jfgl+6TgGI6dwIiT0zxjXHEHDKbBEBkL9MLdx
    GjfkR3sbyYPnN7CeuGYvFBSUCxcnTRuwR9qzQWhUUUMfK0KXvALVLTj9CJOw
X-ME-Proxy: <xmx:TXW2aoFGG9loSWBbU31zJMbvMsmadwoE-lf0L6goyRTRjs2sMswMwg>
    <xmx:TXW2ahQsQs7GlhxzxyfMH8kbES1Gm9RO1OqkFbvawwTGnlRkN_fS4w>
    <xmx:TXW2atvaN1CUhzVQloD2COOrpG08nOOHR7XsZMzf6Eq6Y4J5b8EsNw>
    <xmx:TXW2avBFFV8S5v5cD7WUgwOyDYfNJ0TZUkcRgUm-E5DU7gWWxkwD7A>
    <xmx:TXW2an0LHs8XQNJAz7oOEnt22V-eLS5U9yMpLvFpPM292dcPHo1nbyYl>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 622AEF80086; Fri, 25 Sep 2026 09:21:12 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 25 Sep 2026 15:20:51 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jason Gunthorpe" <jgg@nvidia.com>,
 "Jonathan Cameron" <jonathan.cameron@oss.qualcomm.com>
Cc: "Alexandre Ghiti" <alex@ghiti.fr>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Arnd Bergmann" <arnd@arndb.de>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "David Sterba" <dsterba@suse.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-riscv@lists.infradead.org, "Mark Rutland" <mark.rutland@arm.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Paul Walmsley" <pjw@kernel.org>,
 "Randy Dunlap" <rdunlap@infradead.org>, "Simon Glass" <sjg@chromium.org>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Nick Terrell" <terrelln@fb.com>, "Will Deacon" <will@kernel.org>,
 "Alexandre Ghiti" <alexghiti@rivosinc.com>,
 "Conor Dooley" <conor.dooley@microchip.com>,
 linux-integrity@vger.kernel.org, "Palmer Dabbelt" <palmer@rivosinc.com>,
 patches@lists.linux.dev, "Ross Philipson" <ross.philipson@gmail.com>,
 "Sami Tolvanen" <samitolvanen@google.com>,
 "Song Shuai" <songshuaishuai@tinylab.org>
Message-Id: <ee493585-e685-4616-945f-9d1daae0667f@app.fastmail.com>
In-Reply-To: <20260925125945.GN9354@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <3-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <20260924154902.0000528b@oss.qualcomm.com> <20260925125945.GN9354@nvidia.com>
Subject: Re: [PATCH 03/16] efi/libstub: Free cmdline_ptr in efi_pe_entry
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 25 Sep 2026, at 14:59, Jason Gunthorpe wrote:
> On Thu, Sep 24, 2026 at 03:49:02PM -0700, Jonathan Cameron wrote:
>> On Thu, 24 Sep 2026 10:53:06 -0300
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>> 
>> > Sashiko points out that efi_handle_cmdline() allocates this memory and
>> > hands it over to the caller. If efi_pe_entry() ever returns it should be
>> > freed. Add a __free annotation.
>> > 
>> > Fixes: 42c8ea3dca09 ("efi: libstub: Factor out EFI stub entrypoint into separate file")
>> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> > ---
>> >  drivers/firmware/efi/libstub/efi-stub-entry.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> > 
>> > diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
>> > index aa85e910fe595e..83fade2b0d3b84 100644
>> > --- a/drivers/firmware/efi/libstub/efi-stub-entry.c
>> > +++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
>> > @@ -40,7 +40,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
>> >  	unsigned long image_addr;
>> >  	unsigned long image_size = 0;
>> >  	/* addr/point and size pairs for memory management*/
>> > -	char *cmdline_ptr = NULL;
>> > +	char *cmdline_ptr __free(efi_pool) = NULL;
>> 
>> Can we move this down to just above the call to efi_handle_cmdline that
>> does the constructor side of this?
>> 
>> I see none of the efi stuff follow those guidance note that went in
>> cleanup.h.
>

My bad. Patches welcome.


> Yeah, I stuck with what was there.. It looks kind of weird that way:
>
> 	char *cmdline_ptr __free(efi_pool) = NULL;
> 	status = efi_handle_cmdline(image, &cmdline_ptr);
> 	if (status != EFI_SUCCESS)
> 		return status;
>

That looks fine, no?
