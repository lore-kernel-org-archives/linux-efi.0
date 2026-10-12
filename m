Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA0136E477
	for <linux-efi@vger.kernel.org>; Mon, 12 Oct 2026 08:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791794226; cv=none; b=g+WbezgBbv+e2ckkyjijuvXTUSm7FmXNcIS+o/4qfTz5kwuUquvqtKrGcARtSp+zRQa4xwkZXBcjrej9cTWjU54vP4MqEHa6KPTpWKzLd/sbBTqVNbP3Xxwi/zzz2d/4GVO+ox+eNT9mwVGJDt95qnntula4eWEMjnlvYJWTe68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791794226; c=relaxed/simple;
	bh=sZTgt9R/jsBGgS+PNLj2DAay5FHJUaZM8HmhOX7wPG4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=OqK2iw8J1Oi7eJbKvj77jV+b6z1b+5u8PRSi/0wOBKDBiniP8tZBTLQLNoIhLIMiKqAXHDztNKL5kNrNumDh6xIoXf+AqHM2FPSpreXM2qHz5fiKwhSgP+IW/Z+QuXPEkGQQHhMDQZFFevdpxM+qpSTHGscPGgba93LptXb2dpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XjfnxLQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XjfnxLQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016F71F0089D;
	Mon, 12 Oct 2026 08:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791794225;
	bh=KaTDNeGIs4Eya8Iq0e/D24HTq8sf7hkN0/Y704r7Hpo=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=XjfnxLQL1JzyLJJ+aJCNe8mgOI3NMLP/wrtu8mpwo04hq7G5J7iRzlA8yBa9BUorz
	 D/7zYyGyGZnc7DVknS5lRiNHvl6vm3TgjwinQ2E6LVZRc9AqcBVy/DBF7Wt800Sj9O
	 0DcHfEqr6q9nJwZXo1tAAFnROyBeQBZxzMli60Fa22KpK6xCNsMLELkgf2cmZAwMXb
	 PBRk2hAyxVxBtO3BXfLf0F96S3uQTKH+OY+LirVFnTukKPnLuc0GQfy6VVxmzmmyPu
	 vmVDRyTYQ4qgpY2gqjN1EjlcJ8RggjhaiJO424FolrCRSMQfSdU9tTUUvIysakXq6g
	 qDmRfKoRZtHIg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 4BAD7198003A;
	Mon, 12 Oct 2026 04:37:03 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 12 Oct 2026 04:37:03 -0400
X-ME-Sender: <xms:LZzMavUNOPNfW0dNfzBv5Y8LM25zezHtaX7ccbQty30vkMf9j-vMEg>
    <xme:LZzMaibj0hpCvI3686VaDjdfdVwU_NXGBCrwlUjthQVzjkMlPRm2na_fu9GH_gXIu
    hcLtY8FqXAqUoB7ff5gpTUqGuPUxMi0joUXk26l0AV4cRQaWQu9tgY>
X-ME-Proxy-Cause: dmFkZTEThxgyF43rNUF63WV4bfNwDlYm6E/t3DdUkJCiSwT9/QwWB1XnBUrlCTGx97rh1I
    npz2tTJ4a0lrG8k4Oz0TTr50lcfntge9RrFesknLGLVm3Z5sD1122TDLKaJ8XrcAuCG9Ce
    MWBqR9l+GV5c7yrLZU/XzlqBLHbapJ/xDrzzH277B4CK9igCgegAb9COr44/dmo5BVOBXr
    6x5a17wXNSBgkNc8kJZqiZvsCet6DptiUbWF9fKonF3aiqe3Zq4x6vJ5nRPno+DIeJ2s1z
    Vql+lpbk9tIcrTdMTGRCUtMiy45MOhetpXQbCLz8Qm1tJpgBjf8rt4eFeDfpQRWv4EOndC
    /g/ij8LClT5b5XLIiDbKG0ZeDFsqe8Z+cC5svW/8oxrWeym5x0ZF/uZCqI62GLdSMHcHDy
    lfNlDmYSW64uWCu0CMqEOY7G0b5yjA+8upIoAj3+EY7qL2gU4OTRC8lFuBUUfq/OhDM5t/
    HlVKz0zogM401WHfUzd7Yn2GZ+vIaNlrU+4GqCoQ43JxdhdW/6ixX3FaTLXpUrCBTLvtAB
    0bVObwDEhG6triZyke+hGmVMbW7GtjbFP4y9Xm+ZPEjvuO+GFaGerdl6t1k9qpAeXR+bEY
    AbATUY479uH6ATOaR/S3r7KRrHGY6zLZwKxrYADWgrmno9b2C1rhvdXe9TYQ
X-ME-Proxy: <xmx:L5zMav2__LUY0IJwjhxenhX0N_Nx6e2IWy0TOjBXO0MF26zxP8vv0Q>
    <xmx:L5zMapArh4PeVYHY4ECNKcWexlTJcOS7RlXu0Ps6G7W94lPdXXEyRw>
    <xmx:L5zMau5ieYjom-Q6hguJUKmH7hRltD1kQgffx3hXbj4ZGzlkdJr_Hw>
    <xmx:L5zMaqL3xsDQeIDTQoCuCWc5QJghbbpCs8Ou4hFgR0UpbPW9PEMimw>
    <xmx:L5zMavvXzofQL89lQSs0B8HleVYplt6-kViKH2AwnJmu9xlWkX-1eVdG>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 6AD4BF80086; Mon, 12 Oct 2026 04:37:01 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 12 Oct 2026 10:36:41 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Ard Biesheuvel" <ardb+git@google.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>
Message-Id: <cad3ed39-407e-49db-91f5-cd36f052ced0@app.fastmail.com>
In-Reply-To: <20261009143438.330265-2-ardb+git@google.com>
References: <20261009143438.330265-2-ardb+git@google.com>
Subject: Re: [PATCH] arm64/mm: Route faults taken by EFI runtime firmware to no_context
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 9 Oct 2026, at 16:34, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> When EFI runtime services are invoked from a preemptible kthread, the
> kthread runs with efi_mm installed via kthread_use_mm() and preemption
> enabled, so neither faulthandler_disabled() nor !mm applies in
> do_page_fault(). A permission fault taken by the firmware on one of its
> own (TTBR0) mappings then hits the 'access to user memory outside
> uaccess routines' check and oopses, without efi_runtime_fixup_exception()
> ever being consulted.
>
> efi_mm has no VMAs, so there is nothing for the mm to resolve. Send such
> faults to no_context directly, so that __do_kernel_fault() can recover
> from them as it does when the call is made with preemption disabled.
>
> Fixes: a5baf582f4c0 ("arm64/efi: Call EFI runtime services without 
> disabling preemption")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/mm/fault.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 0b52557652be..db308fe01c4f 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -40,6 +40,7 @@
>  #include <asm/kprobes.h>
>  #include <asm/mte.h>
>  #include <asm/processor.h>
> +#include <asm/stacktrace.h>
>  #include <asm/sysreg.h>
>  #include <asm/system_misc.h>
>  #include <asm/tlbflush.h>
> @@ -621,6 +622,17 @@ static int __kprobes do_page_fault(unsigned long 
> far, unsigned long esr,
>  	if (faulthandler_disabled() || !mm)
>  		goto no_context;
> 
> +	/*
> +	 * Faults taken by EFI runtime services firmware are never resolved by
> +	 * the mm (efi_mm has no VMAs), and must reach __do_kernel_fault() so
> +	 * that efi_runtime_fixup_exception() can recover from them. When EFI
> +	 * runtime services are invoked from a preemptible kthread, neither of
> +	 * the conditions above applies, so check for this explicitly.
> +	 */
> +	if (IS_ENABLED(CONFIG_EFI) && !user_mode(regs) &&
> +	    is_ttbr0_addr(regs->pc) && current_in_efi())
> +		goto no_context;
> +

Looking at this again, I wonder if we should just add a comparison with
&efi_mm to the preceding if() condition.

