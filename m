Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D55026ED37
	for <linux-efi@vger.kernel.org>; Fri, 11 Sep 2026 07:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111971; cv=none; b=Rbncby36EOLTlDnxgvwuW3ynQnQTgoLAeVVffjTmMo3+P9ubIC2Vc3TuILZteY02/pzugqd4HfRF0LXGc8CyiTDPWQbkehjvjeAtL1DeKHg7vbozbbUApj5WCXLdMsenQrCG4CaJfZBKOFrkaDCU3kChnebXbv6fOatX+hNbLRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111971; c=relaxed/simple;
	bh=1UFHnwd6+8Wr85l8PNqVg9OGvRzjDP7RS2PmEv71huo=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=fR2coWuf55HJ3di5YBDz5YKkGE8Mzfm9hOdhTk/Vl5n9rTdZ0VklA2SPnIx6WC1xjK8vNBbExeHOSHbDPLrKsQz7eJ9ruxeOK5KacBw6J4KeRL5p7RoteGcw+RSe2FsmfmhrrZEPa6bbP9ymAYWsJ7CoCRtPSQ+GHgkKqyoRiS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cp3EG9iM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cp3EG9iM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BC71F00898;
	Fri, 11 Sep 2026 07:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789111970;
	bh=zRoqA8gwo46Z3d3793xmQ09WXeGIuNZTk/LbcAQmCXc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=cp3EG9iMYLd2b1XT2xoX9M3RezyPQX9/ChM+hJZNV84tfUhItZgSvz2TaasyRkIhc
	 g9gd6QJsPRZFH3Et4SWVR8dtR6nqrEQK/H5vY4x3ePxMd/64vk0Ug3ENOFUqB6zuJv
	 GiMYGm7lDcfEEKkB03+utbFbqG9TLes1M3u+i6VaG80wU4bnVZbB0PzFnHR6rToqJK
	 Q53SAMQBO8KehW6lSpqMtyKVHhHjewNWisTBBf3Iuf+xrZHtPfuFejGPZRv/VU4x6D
	 Uqbd79i/UkjUF9GoDlEtKi/z8zsLwp2glNgui5UGPQMlxcpyuTpb9n8gIgEBBsfrKf
	 RBi1Vr5HNcGiw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7A9FE198005C;
	Fri, 11 Sep 2026 03:32:48 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 11 Sep 2026 03:32:48 -0400
X-ME-Sender: <xms:n66jao8z-GA-k_vaH3SoJT6xRgYo6dX3JEeM1Ku6M7gM5NYC1i9aYw>
    <xme:n66jarhBY61pQvqPbnEmBRixgwH9UM65RlU3ZYtrfY0Hy-esn407LThXYI-iGgW1f
    daINW_CWHVrKQBlVRjxvlNcz9TTfQYyG3I6ZQnZA5U0tJyfGbS5WJLt>
X-ME-Proxy-Cause: dmFkZTEEpozdq6tFcxcD2mkfJbcSNGdltWWmuDlHCPU83f9wctUWSTu/n82SxX94Ph42oK
    MTsFHkOapClX1grXWGfyIdbqrmagAKXFg54yeQeNrV/hbT47A1HYOnG6Mmx6D8vmYRjnpQ
    RtP5YL4LoSyVe8QCBf/EJiMHJ90iJvTd1NROvJxnRNHxCUOurPJJYYNK+uXfDGpke7Ntn2
    0Mi+XK8jLGNLpnaB2ThcsFNa+22SW09zjD09VkaiWnfU5T7E2Y1GFwtJTm3ioEWTXR0uw/
    cfHqtJk4eL+BjnnjP68q9TUFieTH3fB3NbxwCrepDqAK2WXkaWkj2bfpoKnEhD06iTAHa0
    59HYgfqW+5MBbHu/dX2GVYPRUYPKp4gulpc5lwcY0S+xJtmVay3s2iEk+XvnFWeg1x/KPS
    SKW1NAknqgjfrK6EF5v6qoCab/c4499IaokAcQp6vgZxDO+zS41AHIhYS9DsPehwjjluKA
    TkykPQdq+E1tknC6Dhh6q7eju3h3vhSc2i9xXskPvJcnJBVYSNrPcxENFLBMrRRJNUwVPn
    eklg77xDMc5dEaOEyTf9OHOXVB+ei8l7qVpnWBU1weCB0TqFl1cyEw8NhtkRb5NYVtvJSr
    wy7W4hmMpmRg2G4gPAiUYiYGnSNgLf3EDKWugwbxeCEHjVm5tYSFIP2Ap8TA
X-ME-Proxy: <xmx:oK6jainLI2qgtrH2WCZU5DlTQRoT9M5yJEohLUgtEEDyfQl3UV9_0Q>
    <xmx:oK6jaj623YP4pjc8Sk7T6frQxyeXxs2KJVXNVNMD8ICOS5xj7iDWeA>
    <xmx:oK6jagioJJDlOc2kRExWgsiWX9LiKWwxdeIx5vfF1T7V-G4FwpKv3Q>
    <xmx:oK6jaoG2W7TY0lLzjp8AT7qLCeFc4qOl1YjWjbzoOI-SHp5Jhwwlag>
    <xmx:oK6jauRYfeH3RE6kefmtlp0Nf89sTDKPkbZ4Gil17OWG996H0e6KD9TT>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1974AF8007D; Fri, 11 Sep 2026 03:32:47 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 11 Sep 2026 09:32:26 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>
Cc: "Borislav Petkov" <bp@alien8.de>, "Ard Biesheuvel" <ardb+git@google.com>,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Vincent Mailhol" <mailhol@kernel.org>, x86@kernel.org
Message-Id: <b24b9785-b790-476d-985d-e8c5405d192b@app.fastmail.com>
In-Reply-To: <aqKrhNQ3mZMs5-Dy@thinkstation>
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-13-ardb+git@google.com>
 <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
 <cee2e02b-3817-44cf-857f-62a148290367@app.fastmail.com>
 <aqKrhNQ3mZMs5-Dy@thinkstation>
Subject: Re: [PATCH v2 01/10] x86/boot: Drop pointless re-implementation of panic()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 10 Sep 2026, at 15:12, Kiryl Shutsemau wrote:
> On Wed, Sep 09, 2026 at 10:43:23PM +0200, Ard Biesheuvel wrote:
>> 
>> On Wed, 9 Sep 2026, at 21:14, Borislav Petkov wrote:
>> > On Wed, Sep 09, 2026 at 01:55:32PM +0200, Ard Biesheuvel wrote:
>> >> From: Ard Biesheuvel <ardb@kernel.org>
>> >> 
>> >> The decompressor has its own implementation of panic(), which is based
>> >> on the vsnprintf() routine provided by the EFI stub.
>> >> 
>> >> Relying on the EFI stub from code that does not execute in the context
>> >> of the EFI boot services is a bad idea. It is also completely pointless
>> >> in this case, given that the only user of this version of panic() only
>> >> passes a compile time constant string, without any printf conversions.
>> >> 
>> >> So use error() instead of panic() in that case, and drop the panic()
>> >> implementation entirely. This is needed so that the EFI stub's
>> >> vsnprintf() can be modified in a manner that is incompatible with the
>> >> expectations of this caller.
>> >> 
>> >> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> >> ---
>> >>  arch/x86/boot/compressed/error.c | 19 -------------------
>> >>  arch/x86/boot/compressed/error.h |  1 -
>> >>  arch/x86/boot/compressed/mem.c   |  2 +-
>> >>  3 files changed, 1 insertion(+), 21 deletions(-)
>> >> 
>> >> diff --git a/arch/x86/boot/compressed/error.c b/arch/x86/boot/compressed/error.c
>> >> index 19a8251de506..ce5ed7d8265e 100644
>> >> --- a/arch/x86/boot/compressed/error.c
>> >> +++ b/arch/x86/boot/compressed/error.c
>> >> @@ -22,22 +22,3 @@ void error(char *m)
>> >>  	while (1)
>> >>  		asm("hlt");
>> >>  }
>> >> -
>> >> -/* EFI libstub  provides vsnprintf() */
>> >> -#ifdef CONFIG_EFI_STUB
>> >> -void panic(const char *fmt, ...)
>> >
>> > So this thing appeared magically in v8 of the TDX unaccepted memory patches
>> > and I don't think we questioned it back then.
>> >
>> > v7's tdx_accept_memory() does error():
>> >
>> > https://lore.kernel.org/all/20220614120231.48165-15-kirill.shutemov@linux.intel.com/
>> >
>> > and v8 started doing panic():
>> >
>> > +void tdx_accept_memory(phys_addr_t start, phys_addr_t end)
>> > +{
>> > +	if (!tdx_enc_status_changed_phys(start, end, true))
>> > +		panic("Accepting memory failed: %#llx-%#llx\n",  start, end);
>> > +}
>> >
>> > https://lore.kernel.org/all/20221207014933.8435-15-kirill.shutemov@linux.intel.com/
>> >
>> > and it switched to it being a vsnprintf() wrapper because it wanted to dump
>> > start and end perhaps.
>> >
>> > But then it ended up dropping the params in v13 and landed upstream with
>> > a single string as an argument.
>> >
>> > Anyway, adding Kiryl/Kirill for comment and leaving in the rest for reference.
>> >
>> 
>> Looking at that v13, it seems the panic() call was added to
>> arch/x86/coco/tdx/tdx-shared.c, which was shared between the kernel proper and
>> the decompressorat the time, and so a panic() implementation was needed in the
>> decompressor too. But that is no longer the case.
>
> Right. I don't mind dropping this panic() from the decompressor. The
> range was already gone since v13 and I never saw the error trigger
> anyway.
>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>

Thanks. Can this be applied as a fix please? I need it to base efi/next
on it for the next cycle.

