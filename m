Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB6A3EA970
	for <linux-efi@vger.kernel.org>; Tue, 19 May 2026 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779204143; cv=none; b=P/pQqUrasEXPAlr2kcD5KASMXJVf6QTC36Sxmx6ATrC+C7FDNsBsRCUSRT6dzauQGGzxpq2qgusgkV8dvLvNlThqubqLTLsmtecNIF2sJ51rXAf5/KyRQ5HuwUhzaaXQg4w1LvQferBmY83/kgg1XfbZdR/UhwqoLcBnukSspUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779204143; c=relaxed/simple;
	bh=5VrOl2Y2oUsSYv+vFwkchuFKwthFO7I3gF2dpNwFzy8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Hco9WrB6dWUZCNQ+vwifXXpqYHQQtHF63/FzYoWVItRo9PT7m9zEiF5P7phNlyTs/E6h48ggvLJAS5g4pGyyrWkDzRDkynRIQEf9qiRHZEUOh9X3DtSmabRcbzXci5N0AkGbvQ6fVjpfRXPf4gtg54fFGh3eUmM4YQ69CYw5RQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StC8dFRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StC8dFRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4D4C2BCC6;
	Tue, 19 May 2026 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779204143;
	bh=5VrOl2Y2oUsSYv+vFwkchuFKwthFO7I3gF2dpNwFzy8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=StC8dFRUzzXpNOavSawNy/OyAuX6qdJQfA6PI1LeZdFDgom9FhAfUasU04Aropq8u
	 x1bY+/zwCkdkErcDZ35sn/XIVZBBMiGI5Md7cMA4r1AuXIEEUWOnaEdzt3vcOYzjO/
	 XPwtAJxI0ClJJQIzvXYittRgnR8Af3ahCd016aKJzRAvJCtfId43qiW1/1xokJDhHc
	 A/Me0yWGUnoGy25ZWBX+aSGy18BqJGpqDzH7vibviTKdBHepy5lcput+60xbT0rp89
	 XaEEcLmLRgTUUyAVE/41kBze1hi+wLm9eyHQAdSOFcC73G3rf4kS3Me5Cr01L8OTPd
	 STqw9LzG0jrIw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3EA6AF4007C;
	Tue, 19 May 2026 11:22:22 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Tue, 19 May 2026 11:22:22 -0400
X-ME-Sender: <xms:LoAMag38IDV-vBLzPZg-M2ChW8_zkunqK_xZ_bEPiFvQRf-Dobuj4w>
    <xme:LoAMal7TCb-B8f2LNnzHCiMy72WdEEf7SMT6Nh49pNIjuBfoPCYSdt0zRLVTl1S2y
    tPBoQv77PJlM1eZyPua14Tt1M8QWOGP2JGqtBwje7t2pqA6cmwRFdM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugedvuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrrhgusgdoghhithesghhoohhglhgvrdgtohhmpdhrtghpthhtohepvggsihhggh
    gvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvggvsheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhr
    gh
X-ME-Proxy: <xmx:LoAMatAjDBRjxYCnEjN2HTP0H-3RTcGhttAPMfwmPo-s0Jk8oXIC7Q>
    <xmx:LoAMakd5FNmfWjkYm61oeGBKuESDQOvx4krhJ8QCzQrkBATstfQDTA>
    <xmx:LoAMakK1WoiOrlUbVjpN_NswdGvFtonWUE6GH2ThyPtFlqkQeuvlHg>
    <xmx:LoAMan26wdkynmhokNg6IdX-A753STHKjISeIL8mBeTQJsIadOcl-w>
    <xmx:LoAMaugPCF_yqLqx4OdbtwgC_arlx8SboZBOGtpWOiTcnPoTrn0StTPS>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 19FEC182007A; Tue, 19 May 2026 11:22:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 19 May 2026 17:22:01 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, "Kees Cook" <kees@kernel.org>,
 "Eric Biggers" <ebiggers@kernel.org>
Message-Id: <6467020e-db1e-415b-9fc2-25f13760c875@app.fastmail.com>
In-Reply-To: <20260501170156.2833364-2-ardb+git@google.com>
References: <20260501170156.2833364-2-ardb+git@google.com>
Subject: Re: [PATCH] lkdtm: Add case to provoke a crash in EFI runtime services
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 1 May 2026, at 19:01, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Add a lkdtm test case that triggers a fault during the execution of a
> EFI runtime service by passing a read-only variable as a by-ref argument
> that the firmware is supposed to update.
>
> This is useful for testing the graceful handling of faults/exception in
> EFI platform firmware, which is implemented on x86 and arm64.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/misc/lkdtm/bugs.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>

Ping?

> diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
> index e0098f314570..3eca2ef64aff 100644
> --- a/drivers/misc/lkdtm/bugs.c
> +++ b/drivers/misc/lkdtm/bugs.c
> @@ -7,6 +7,7 @@
>   */
>  #include "lkdtm.h"
>  #include <linux/cpu.h>
> +#include <linux/efi.h>
>  #include <linux/list.h>
>  #include <linux/hrtimer.h>
>  #include <linux/sched.h>
> @@ -817,6 +818,29 @@ static noinline void lkdtm_CORRUPT_PAC(void)
>  #endif
>  }
> 
> +static void __maybe_unused lkdtm_EFI_RUNTIME_CRASH(void)
> +{
> +	static unsigned long size __ro_after_init = sizeof(efi_char16_t);
> +	efi_status_t status;
> +
> +	if (!efi.get_next_variable ||
> +	    !efi_enabled(EFI_RUNTIME_SERVICES) ||
> +	    !efi_rt_services_supported(EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME)) {
> +		pr_err("FAIL: EFI GetNextVariableName() is not available\n");
> +		return;
> +	}
> +
> +	/*
> +	 * Provoke a fault by asking the firmware to write to a read-only
> +	 * variable.
> +	 */
> +	status = efi.get_next_variable(&size, L"", &(efi_guid_t){});
> +
> +	if (status != EFI_ABORTED || efi_enabled(EFI_RUNTIME_SERVICES))
> +		pr_err("FAIL: EFI GetNextVariable() did not abort (%#lx)\n",
> +		       status);
> +}
> +
>  static struct crashtype crashtypes[] = {
>  	CRASHTYPE(PANIC),
>  	CRASHTYPE(PANIC_STOP_IRQOFF),
> @@ -850,6 +874,9 @@ static struct crashtype crashtypes[] = {
>  	CRASHTYPE(UNSET_SMEP),
>  	CRASHTYPE(DOUBLE_FAULT),
>  	CRASHTYPE(CORRUPT_PAC),
> +#ifdef CONFIG_EFI
> +	CRASHTYPE(EFI_RUNTIME_CRASH),
> +#endif
>  };
> 
>  struct crashtype_category bugs_crashtypes = {
> -- 
> 2.54.0.545.g6539524ca2-goog
