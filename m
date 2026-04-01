Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5893CA4B6
	for <linux-efi@vger.kernel.org>; Wed,  1 Apr 2026 17:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775065682; cv=none; b=JXh+8DSi1Az1xTEDvdg+HjhfZtNzmklENHaPgwEC0Lr21siCKfKHXO0FYmDCdt9nERpudlOy8vs0FDNTaIWRVPEMjnzeNagr+FlAMgtyI36YJBjlkHPx0TQZnNowGISkjbLbzfbpokmt50I00++DnLAJqx8+PgWIeiiapkiFftU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775065682; c=relaxed/simple;
	bh=LLqoJIi67bkezxSWE5ihVWy2DsafQ5h4eCOtpIAZYGg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=J9Jv43Fo32KtGYOX1JlRVMsqsQ2yDflXFHgKLnxcjKguSp5ESxZioAg+g9gK0xUE+EcGHcI1yCyvM/Krz0aXlanBgY2JqzALQPi5NKGpfAgZt3nszdwIR/H8T247Rs56Wu/n2Uc8GrHmhsUdJaIRFSOwMWvYh1aRNCsXgu4SZEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuST5rNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuST5rNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02555C19423;
	Wed,  1 Apr 2026 17:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775065682;
	bh=LLqoJIi67bkezxSWE5ihVWy2DsafQ5h4eCOtpIAZYGg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=NuST5rNNCghIasVWC1RAADHgpjeYGu5qWFzXvDTzQe1ZJRbtq/9Jet49co1/SA54T
	 ugZc1z/WoCSN08iP/QtsZdryqXEFUhle/9fAQQRMvAUEFTztUUtT+vwG0/1vmseFsg
	 aTZi+ABhPYKnQG96JY/eDkYiT5JGznKu0R+2jVmMqRzRBGki7qq5VguS67wkaBfFFt
	 VFTDO+odeTAlxIAwoYx/N3GtG0yAZF66w9nJVIvsv4qF0Bz/aIqH75BYTrtcDHb0ER
	 knybPPCqkvricI/+u2q6UQqB07ANjQFFtATO7E5PHheGxmDdvf7fcBCU7Vw96uyyrM
	 wW/qFy0duIKpQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0D08AF4006B;
	Wed,  1 Apr 2026 13:48:01 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 01 Apr 2026 13:48:01 -0400
X-ME-Sender: <xms:UFrNaZAjgsrbpmGFdmfjE6jP5HzNXRx8Szyd48_HjkUF8wCtn4HCcQ>
    <xme:UFrNaSVYq6niPIPIJLXLu95Phx4vcTO_2RZhe3GcENO9em3Aegw0stXSOAVbznJUA
    21fZVUd71YpSzRhXCSdziBLe4OeSMHhzDotIUQN2tcylQ4vWdlVZVs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcuuehi
    vghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeeijeef
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    guodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeelqdef
    fedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurd
    gtohhmpdhnsggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehlvghithgrohesuggvsghirghnrdhorhhgpdhrtghpthhtohepuhhsrghmrggrrhhifh
    eigedvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghruggsodhgihhtsehgohhoghhl
    vgdrtghomhdprhgtphhtthhopehgohhurhhrhiesghhouhhrrhihrdhnvghtpdhrtghpth
    htohepjhhirhhishhlrggshieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepgiekiees
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepugihohhunhhgsehrvgguhhgrthdrtghomh
    dprhgtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhr
    tghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:UFrNaaSBiqXse4VMPRbxEdcymG7n_sNKxU-k_f84z6naNkmU6vAREg>
    <xmx:UVrNaQNBRLmh0a27Jz_W2EkAzLiXHxu5NX0gtnnXTOQaHDQDuAXQUA>
    <xmx:UVrNaYhcQ4YCONaBlsDhMsGI06wJ7j-J2-XYWw-iOV8Ng7-nbp8SYg>
    <xmx:UVrNadl8_GRQzjT7PaBZuZfyQBV2hzrFk48LY0Rupsfi-JvYtMopQQ>
    <xmx:UVrNaUhXXpGc9rDUfC85g2X7ZO4pt4c8JSlmeRokvS8RFhezJZD9CV-4>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E22E7700065; Wed,  1 Apr 2026 13:48:00 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AHKieutuY5AR
Date: Wed, 01 Apr 2026 19:47:39 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Breno Leitao" <leitao@debian.org>, "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 "Dave Young" <dyoung@redhat.com>, "Gregory Price" <gourry@gourry.net>,
 "Usama Arif" <usamaarif642@gmail.com>, "Jiri Slaby" <jirislaby@kernel.org>
Message-Id: <26c58b96-d41c-45e4-aaef-2e10ed4328ab@app.fastmail.com>
In-Reply-To: <ac1YPh9xuRyMHVX3@gmail.com>
References: <20260401122351.2058145-7-ardb+git@google.com>
 <20260401122351.2058145-11-ardb+git@google.com> <ac1YPh9xuRyMHVX3@gmail.com>
Subject: Re: [PATCH v2 4/5] efi: Use efi_mem_reserve() to reserve the memory attribute
 table
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 1 Apr 2026, at 19:39, Breno Leitao wrote:
> On Wed, Apr 01, 2026 at 02:23:56PM +0200, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>> 
>> Use efi_mem_reserve() rather than memblock_reserve() to reserve the EFI
>> memory attributes table. This is needed on x86, where memblock_reserve()
>> is not sufficient for assets that may be placed in EFI boot services
>> data memory.
>> 
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> Reviewed-by: Breno Leitao <leitao@debian.org>
>
>> ---
>>  drivers/firmware/efi/memattr.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
>> index b83f1c5a9164..785b7fc687fe 100644
>> --- a/drivers/firmware/efi/memattr.c
>> +++ b/drivers/firmware/efi/memattr.c
>> @@ -75,7 +75,7 @@ void __init efi_memattr_init(void)
>>  	}
>>  
>>  	tbl_size = sizeof(*tbl) + tbl->num_entries * tbl->desc_size;
>> -	memblock_reserve(efi_mem_attr_table, tbl_size);
>
> nit: memblock_reserve seems to be the only memblock usage in the file,
> so after this patch, the #include <linux/memblock.h> becomes dead.

Thanks for spotting that. Will fix.

