Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792649145;
	b=5rtNMJC5Ctqn0MLDA4t92pmWb5y4vh6RfZM5+L0zpPAGX7wiqGi3OF3fs0lk0Zl998fR
	 9+4JcKVZYA6QSwf7f7960zOcJLX87THwxMDZ8y11kv+wmdNLc5Pe0Kb1B1wQtLjgcGW54
	 qLZ4Ra/yZgPEnIcZUCndyFRkJ/qxtnzuDuBPTeVfeDgbdSNcDz8JTaRM7QgEhuyD7p8oV
	 qBIAnpdFdk+PmM3NTKwrnbgHf92I/QBkjOlTuy0gvIqur88bQnBXg9Bo7HH2Q1nvviKPN
	 FP0p7LQUnVCgYzdvFQ7xyAL25f62ZoOAUiF0UIFjUqlNfKaNbtyUPeUu+gE+Q3cEXNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792649145;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=iP4AVkHj1vVs4GKmhu5BRjV+em6C3v1oHesjAHsANOg=;
	b=RAxDX/vPTqZ87rzxarWjQWq3sm8bmuaGY024ZjwrBx3/CwSZHFP7UZeVVrz7qVmivqMH
	 r+l2INv/mxAOwBcGQaT3ctsXW+eGn9w6rdgDK59lwGIrySjE8niFZcEKrStVYiNr8tAbD
	 BIXMTmLDntlTuDrR72H/A01rzu0tJXvvakVT2oQdz/X1FQknlQvFz+PebH4woAdCyN16O
	 wgVKyPtOM/igz1XR0KxZt6ckoh0m6VTecuk4g8IF/1GcsgU20cx2xJL52QwHWT6ejsIDd
	 f/NCDzy4aCFsFEyxu6tZnp2yLfoadKWW/G9JXL/nZZ0xMooy0sqmILrWYjSoZBJAo1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D0HP0OMG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11D5606A319
	for <linux-efi@vger.kernel.org>; Thu, 22 Oct 2026 06:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D0HP0OMG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A18B1F000C1;
	Thu, 22 Oct 2026 06:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649144;
	bh=iP4AVkHj1vVs4GKmhu5BRjV+em6C3v1oHesjAHsANOg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=D0HP0OMG/p47NEfefL7dEf2mUpOhAwtCvQfVHAYXavAz8z27n1Ptr/ZQe8hCBka+0
	 kpucKG3GyeuS8Z2X6ElVYHehXmr8pGTQZif/POWyvjcFC7cbfSh2YYsZcgI5pwm+c8
	 COiHo57dggoq+DZ5JWGhcqPT4JWMNGrNat49/N4DoDiU7cnP9qktE+o664oSmuYRfg
	 W2jQzmaGTR2ntQxN85i94JC4asK0L/UlXGvAzAupcxTqCalA92YZqJ+fvqyGec2wPA
	 TAPhiVczS9G00EMW+WMCbZlJcB9L+Ph3vVzCgAnPloCHgEMMwGmOIPJQ3otGc1wD2o
	 HHIdtlWTn9/ZA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 90AA81980052;
	Thu, 22 Oct 2026 02:05:41 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 22 Oct 2026 02:05:41 -0400
X-ME-Sender: <xms:s6fZaqCUct5c1thVTLqr1fORiJ0xag2YKGaS7Z1I2Kne1UvNSDhIwA>
    <xme:s6fZavXbX0eN09ydtcp7xtRvbiLj_Xt7GILf4qG8J-_PAXbAuROn-1r-5Kn1gN-wT
    IUKX59pasoMBkcxa87gKd-VkEmH4H9-4spVlmeawj_vQk2dBHNGOhXO>
X-ME-Proxy-Cause: dmFkZTGejHTXrWaje0jvkvcP18Z4kYP9Z9nzvJ1wxkLZGqWBup9Pw/LyzhCl4/ep6WHOAp
    M2bACzw4FQPWYZL9VP48W9F0zHYr8gq0X63K3G+tQ0EY8JVTPrnA8iwJ5//pA8WRvDYQ1e
    j+2IAIiM3aNuiwzjO+amOCdsjVAZQ3GXvu8sNm648QKQj6jpn9JnEjHEm/SLU18uLG/QsO
    a2YY2VENDpk0aj+qjTcJfnc53AcWnANOAaHb4ejdKxHMQbwZF5qOzTQqmm4GBodXGQj1PR
    7EWQF8YynpdVy0pyPcvYYWXwW5ICw97eTE9R7hSPi3IZ61GiB36NseTfsn8nhDVVLCpuKo
    QTqK6hMyMLCY4m0iqJsp1K9/NjLt+0UFVHlI2eubfm30wW3idDU39rPoufhwB6RHG6CIo/
    1IUfR4VYot/efnizyFo8zvVwlkb5LC/zkrHeF1JoQi4FyKKXAvCmQhsYes/DVTrSy29jVD
    HPnnKv2BQEUpQZuFbJDkMwwOgdvGvFhXdGSYC/3B2fGUrY6G0F06XcpltCdL32o/dliKyi
    2N55wsWSOHCTYwW3IV0zPeixcRcj3C4FKYbSSoKFTbpHK+5Hdk2NwE6gJue5WKwl4QtFCi
    KHMFN9fFeEyS3cCrjiSmlVHKyX8P5rvBR56oG5MeNz1h24pZbmM9gvn3Fvwg
X-ME-Proxy: <xmx:tafZatmeF6MNmH8oqFm6oYsbE9GGiKudNyW-x6dAUT1YjSs8wUo0hg>
    <xmx:tafZahCpQwqrxJnBVE43IKsVxeQRJFjvHaKCBQtvv4zG-ra_5GFfLA>
    <xmx:tafZavMd7mxWviBEcw3u3OmaQV4_z20a79akhK87bJi1kiPPr1s_Ww>
    <xmx:tafZaoOYxwiqPIyfa4EoJHth8Iy4CSyrL60DEGFRiAiQnIK0qfEFVw>
    <xmx:tafZannlEzp5YXxIRMsfVDOqX2oHeaJXhN0oDn_mdfTgWmBAu2Iixq8O>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1D3FAF8008C; Thu, 22 Oct 2026 02:05:39 -0400 (EDT)
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
Date: Thu, 22 Oct 2026 08:05:17 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Hamza Mahfooz" <hamzamahfooz@linux.microsoft.com>,
 linux-efi@vger.kernel.org
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>, "Kees Cook" <kees@kernel.org>,
 "Arnd Bergmann" <arnd@arndb.de>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 linux-arm-kernel@lists.infradead.org
Message-Id: <13d53e6d-9fc0-4926-b8e6-3ee75ea82660@app.fastmail.com>
In-Reply-To: <20261021230503.2075618-1-hamzamahfooz@linux.microsoft.com>
References: <20261021230503.2075618-1-hamzamahfooz@linux.microsoft.com>
Subject: Re: [PATCH] arm64/efi: only disable the EFI runtime service that faulted
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Hamza,

On Thu, 22 Oct 2026, at 01:05, Hamza Mahfooz wrote:
> When the firmware faults while executing an EFI runtime service, arm64
> recovers from the exception, returns EFI_ABORTED to the caller and
> disables all EFI runtime services for the remainder of the boot.
>
> That is a rather big hammer.

It does not just return EFI_ABORTED to the caller. It basically does a
longjmp() out of the faulting context straight back to the caller in
the kernel, skipping all execution that would have occurred on the
way back out if the fault had not occurred.

Assuming that the runtime services are still in a sane state after this
is not justified, so I don't think making this change is a good idea.

Do the systems in question expose the RTC via the standardized ACPI
methods as well? I'd be fine with some logic that avoids rtc-efi
entirely if the RTC can be driven by a native ACPI driver: that
seems a worthwhile improvement in its own right, given that EFI
runtime services are evil and should be avoided where possible.
