Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6272059220A;
	Wed,  9 Sep 2026 20:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788986640; cv=none; b=Pkx0k+98YAhaFxz85LQi6Ipiq7MBKk7o/O647+MWWNSVVzUQ2xItD3hF2bW6UOaOK49Sg/Tm1BwDQZZunbcNP/f6QsahFwwAJ3LQMcejZJcvL7e5mlggPnd8Jq9+hH1M9XyhEKQ6S23AO20uLRh2HVWQaTfR+2eWwqxsLDCnSV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788986640; c=relaxed/simple;
	bh=Mpo/eON4EGbciQ62eVHwbqiiR45qKajIcWtR7Cw6JW4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=k4Oskx4G+xYJoA6fYJxXXnhFoSuXab1ZmVgRKdHVWRT6VZyqhUZjXLlh56fxIhhFY+UJRDK84+0XKW+NVy406LKikrRAZDafX+9M6sDZ+VWZYudyxUdwD/GX5+Q9XMn5DixglL8HhtCrxeVPowmkSEFsiFpUTh8QqcbS6CZymCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wgd32pEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wgd32pEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2E01F00898;
	Wed,  9 Sep 2026 20:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788986627;
	bh=ctgKhrQLgtaI7lnS8kf4ZW39i+AzjnlUOX8ibu1nvl4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Wgd32pEQEbxbQNNRG6UZdlvtMRIAtGGcsIREzTqgnPaKs+I/LAU8NWuz1YSPuTXox
	 BGY7W44Tuj9kalXQiIvB1y9E1+gqQ3dUThWSzfQaG/JXzxAvQh5S7iciHcVfBsKJ+J
	 8BObD1ufvhjxbBBXagbNLQtOZw9FoEy/wiqQ7xShBEe0OxKBZibMgp4uWBUC8IBF1W
	 ocPhosNR7ePoXm6CILhk8m5PjD7GKW6jcIZHjbfRAOhG2VDRaMr70gUr6YvvhL8Koz
	 /gjQ+PNKXbfBqfqUudJb2NhiKiB5T88kKfmY1KJWa9d8Jffp3OiXm4RZaW8290sy54
	 SDUDsuf6XIEQQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id DAF3A198004A;
	Wed,  9 Sep 2026 16:43:45 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 09 Sep 2026 16:43:45 -0400
X-ME-Sender: <xms:AMWhahee9Q3XPDeuk1eIsHNXY-qyfdjAePCOd3v5a6tujdNiGj256Q>
    <xme:AMWhaqDNXygTLULgCQE07FkRS-v-i_uzSE0AdJvXh6ZxyVia1sX3VkidQ775vFry8
    DDzDEZgVKg7tBQXD_yKK1KPJUhRu_afx5pQiw50Y5A383MX6ELq333U>
X-ME-Proxy-Cause: dmFkZTFgw4Wq2jougAk49K2fgmK+IGp2tl7ecJoWj6zJXqm30JFGysDXGed1Lq2zUpW0H1
    0n6hL2njPiWcULw0qnT3UQT4CU8LEiZuVDVJO156q5fMnXNIEkpq+RB9z9ij5VCy9bzKWf
    aoyvLHKC9deTLVrj+oj6tCYTsUL0657MaOc9kBFRPCe6dfvgM+IejfflG8qWxO8miKr2rP
    gMkyfE5lFN4xAMcMJItok3GmE1rvSYTzawELUdZgtJekUVe8jhgL5ydGOgaVgKNpCJmE0R
    LK3RcKddMJ7PmWQlbxU2a96R4tVfTIkoi7dTEOX9VZP+tL3blHV4/XM8jsjSf4k7bbSLWP
    97vLhUguvI/To04XjQrxmBiegv39dAvONAU9fzYR26Xx2wBDI8aolhrXddmYYzst5OZ+k8
    iyU8o1NonnlKPOHDYYnie/4kqU4YQFY3VRg86j9Xw/H2VDLVeoSQGtBq/U5p22QCuawVJY
    Fh8pr+CCHkPBP+Lm4Z9+Xyk8iph6y55bzhfWHUlCU4ar6aWHmw9TpETxHtiTaZKgxIEMrm
    OLUzEl/Y2eefpwnhBjlL6221zzCQXeY4/z2nsAm0OU3dHhPNFBLXx1MTcmt0MyiWYFYtK+
    8BaAX8gBZyMZ7LaXBbXSY9SnGRbL/Utvg30JOt8BVC0sVVAJdIY7FabjlymA
X-ME-Proxy: <xmx:AcWharHLob06hEPtAZbKUkkJNzfrau3q5qVMUKp03pJolF3stcKEZA>
    <xmx:AcWhaiYgXrJBGwzGQAUIzTu-lvxJqIAFocvWxMl-VXpYJubiMLCWlA>
    <xmx:AcWhatAv2I3fsjv4IrHT2OsQgqwlugJtlsAZ73WPSe6LKb_c5phwWg>
    <xmx:AcWhaqk2KqI4mtoHFtBgt2LVVdymyhW3ly-tRbVhBV9AuoPpYwL7Kg>
    <xmx:AcWhauzZbX6eFVNlaTYwDpw1p0RC7L0shUVaBswYruesOVSS2CAUEzL6>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 093A2F8007E; Wed,  9 Sep 2026 16:43:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 09 Sep 2026 22:43:23 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Borislav Petkov" <bp@alien8.de>, "Ard Biesheuvel" <ardb+git@google.com>,
 "Kiryl Shutsemau" <kirill@shutemov.name>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Vincent Mailhol" <mailhol@kernel.org>, x86@kernel.org
Message-Id: <cee2e02b-3817-44cf-857f-62a148290367@app.fastmail.com>
In-Reply-To: <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-13-ardb+git@google.com>
 <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
Subject: Re: [PATCH v2 01/10] x86/boot: Drop pointless re-implementation of panic()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 9 Sep 2026, at 21:14, Borislav Petkov wrote:
> On Wed, Sep 09, 2026 at 01:55:32PM +0200, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>> 
>> The decompressor has its own implementation of panic(), which is based
>> on the vsnprintf() routine provided by the EFI stub.
>> 
>> Relying on the EFI stub from code that does not execute in the context
>> of the EFI boot services is a bad idea. It is also completely pointless
>> in this case, given that the only user of this version of panic() only
>> passes a compile time constant string, without any printf conversions.
>> 
>> So use error() instead of panic() in that case, and drop the panic()
>> implementation entirely. This is needed so that the EFI stub's
>> vsnprintf() can be modified in a manner that is incompatible with the
>> expectations of this caller.
>> 
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>  arch/x86/boot/compressed/error.c | 19 -------------------
>>  arch/x86/boot/compressed/error.h |  1 -
>>  arch/x86/boot/compressed/mem.c   |  2 +-
>>  3 files changed, 1 insertion(+), 21 deletions(-)
>> 
>> diff --git a/arch/x86/boot/compressed/error.c b/arch/x86/boot/compressed/error.c
>> index 19a8251de506..ce5ed7d8265e 100644
>> --- a/arch/x86/boot/compressed/error.c
>> +++ b/arch/x86/boot/compressed/error.c
>> @@ -22,22 +22,3 @@ void error(char *m)
>>  	while (1)
>>  		asm("hlt");
>>  }
>> -
>> -/* EFI libstub  provides vsnprintf() */
>> -#ifdef CONFIG_EFI_STUB
>> -void panic(const char *fmt, ...)
>
> So this thing appeared magically in v8 of the TDX unaccepted memory patches
> and I don't think we questioned it back then.
>
> v7's tdx_accept_memory() does error():
>
> https://lore.kernel.org/all/20220614120231.48165-15-kirill.shutemov@linux.intel.com/
>
> and v8 started doing panic():
>
> +void tdx_accept_memory(phys_addr_t start, phys_addr_t end)
> +{
> +	if (!tdx_enc_status_changed_phys(start, end, true))
> +		panic("Accepting memory failed: %#llx-%#llx\n",  start, end);
> +}
>
> https://lore.kernel.org/all/20221207014933.8435-15-kirill.shutemov@linux.intel.com/
>
> and it switched to it being a vsnprintf() wrapper because it wanted to dump
> start and end perhaps.
>
> But then it ended up dropping the params in v13 and landed upstream with
> a single string as an argument.
>
> Anyway, adding Kiryl/Kirill for comment and leaving in the rest for reference.
>

Looking at that v13, it seems the panic() call was added to
arch/x86/coco/tdx/tdx-shared.c, which was shared between the kernel proper and
the decompressorat the time, and so a panic() implementation was needed in the
decompressor too. But that is no longer the case.
