Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44212DCBFA;
	Thu, 10 Sep 2026 07:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789025927; cv=none; b=M11qVdGniBj8MaJnskOL0P0XcG3j3hfUPY0F9NfFfAn05RvDT3qyf0xyjZFi8w9GUFbqKkXc5L2qCpXKLxrWiB0CT2pa02PTSB4F1rPeRW6v0fTHsox5ObgIBHW3TtqursKSynOSMkOZ0Pny3yhOxt34Ruay6BCi5sJDp4bRdps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789025927; c=relaxed/simple;
	bh=ylLPjfUmDp5OgakHE/h6+iUXPwleRmAymyHsUJs3oGs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=QOzwsCtz3n8/hwoAWfusWaPVCoUnYJHlsQz1vFUGg5NJ/6Jpcrxw8VAHS3HaNnm+dTkCCz/dEwTSzrhYgAiKYgCrF7FhDW5tE2lP6p3IqMRR+walvy4yE+RGnJ+s4C3F94Zza4hURX3DoLDRPCe5tpI7xRGb5EXZWZl0yEWzXRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sb4B1RUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sb4B1RUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DE31F000FF;
	Thu, 10 Sep 2026 07:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789025909;
	bh=2niUt7FygR+JTfvVu+m/W5AWpF8tk+eb/4AARp/D4uA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Sb4B1RUBNjUThJTG4q9JTuZLcCxKBmhGXV/knS1bRh8qy/Klj1FuccHUclx8PjudT
	 OvdvHlBPjuNNt/BIkqB8Ke4mOvo9kCG+SQtKefKSSBUDX+g7YozMJGdWBwEkdnR3oW
	 iC51CDjowALobShOD6ARkfUdTa/j3Ne4b26f4Py3QopDiiO4ahMIV4LwUl3KonwPQV
	 g6rPNziSzFLmo8C+XGeYeLPeieFfmP+/4nUHyqK5zl7XguOgNS4o1S+Qqeba1SikOr
	 7ta6H6e5RQGrWi2L5xiXg0HJAs4Lw+P6BQBmRfXF1KAJLfYNUzIy+Dp3uo4GIoHkhg
	 tCI/BbSlKySzQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7808A198003A;
	Thu, 10 Sep 2026 03:38:27 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 10 Sep 2026 03:38:27 -0400
X-ME-Sender: <xms:cl6iarw2VZBrmk0gKEYfWlEPrBWMuY4q2ywrBVdJFayN6sT8SIMfXg>
    <xme:cl6iauEJVFzEpJyCSbE79IGbRHu7zPjkvde5g4A_wRtwGlTmHqE2951bQMCo4CdoV
    k49Nv0E5x9Z-qwYAIPRQ6r7NBCNKUwHY-LWOYM6gFHoYDNSj7sLO_6d>
X-ME-Proxy-Cause: dmFkZTGY5RmXDWSkj7iEa3+1WOsxhNyYaxceSoq7uj84XkAKgZ8MGJegpiDGKUQgMiuuLS
    /X6Tvxsshu9cepb+dX+XWPytiE0R2WUfJvNNGCilKV3QiigGflvB4B1GBhxw2lijhJGZmZ
    t5KmP6jMDKb2FoY5xte9z3yHBFrrAcMfAEE2FsJ/AdH8vQWA/kQbcyi3i04f9JgLpyCpCB
    p9KyrZhTsGJCVT897jqkk56gqqTAAr6iQxV936j+j58qKqRJoEqwdsXyaxGCL4fFZ64NQi
    QUlAq0IWh6nPJD3PQ7zYUAxysUQ8f56q+uyjNCQmX/MX3cuLnqI7TOQO/8QexIqGB1eafh
    V89YPXu9fhmTC61CI+FmDsHdGsqOXByM7nGhSsGsG/k3r16w9SBwjKXhyE32rspXoqkypT
    Sx85E1ybdPEGMAzOKz8LxTX4I7o3jIV7YghxJs55aF5AIEpA5Lw0O1JP06dp0jh01Te0NZ
    8TF5XWV3N1hnTy0Imp6QoXWGHKCb1HBn+EJz6AGpkjvAIpMOFh3hE8KRE/DYb3WOgNl2Z1
    MTiaoRs8z/D1m7Uzi9gChLWDGyYrQ83FlMguURYOKtilPQ5ecT3qzL7Jf3z16NlwD7RAMN
    gh6FMZuHy58bxkRgpsGTg3mz6r60blqP0CtAZdQxZxkQJLOsKuUF8BKIhUjQ
X-ME-Proxy: <xmx:c16iavZho8pF1cBn9XSt6KTJc7TA7Su9zpx6Jf3Zv1aJc6VYgZxOKQ>
    <xmx:c16iap0H8gJ8HeMO8N4r81C4q1zty5ZxHlwi7jDMM5bY1lthKG1WIw>
    <xmx:c16ialdfi2a_Wdkj_eDowDS9TyO8ZCFLCOKQV2kHIeoEYV0-ogTPmA>
    <xmx:c16iaqGoYFIJJE33l40WiDqV8AF99h1vstdjAx6g_SrMCXOqCpDUvg>
    <xmx:c16iam0FJ6Bn95k4OMyW_vkHjDpmRuv9On4R6guwa9blRW8V2IGJJ1Am>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 7C466F8007D; Thu, 10 Sep 2026 03:38:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 10 Sep 2026 09:38:06 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Danish Khateeb" <danishkhateeb03@gmail.com>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <8aae5b53-fbaa-43b1-97df-283730aeff8c@app.fastmail.com>
In-Reply-To: <20260904153131.134383-1-danishkhateeb03@gmail.com>
References: <20260904153131.134383-1-danishkhateeb03@gmail.com>
Subject: Re: [PATCH] efi/capsule-loader: Replace kmap() with kmap_local_page()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 4 Sep 2026, at 17:31, Danish Khateeb wrote:
> kmap() is deprecated in favour of kmap_local_page(), as described in
> Documentation/mm/highmem.rst.
>
> The conversion is safe here. efi_capsule_write() maps the page and
> releases it within the same call, on both the success and the fail_unmap
> error path, so the mapping never escapes the thread that created it and
> the stack-based unmap ordering is preserved. No atomic context is
> involved: the page is allocated with alloc_page(GFP_KERNEL) just above,
> and the copy_from_user() performed while the page is mapped is fine
> because faults are permitted in a local kmap region.
> efi_capsule_setup_info() also runs while the mapping is live, but only
> reads through the pointer.
>
> kunmap_local() is handed a pointer that has been advanced into the page,
> which is fine as it masks the address back down to the page boundary.
>
> Build-tested only, on i386 with CONFIG_HIGHMEM=y -- where
> kmap_local_page() actually establishes a mapping rather than returning
> the direct-map address -- and on x86_64. No new gcc or sparse warnings.
>
> Assisted-by: LLM sparse
> Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
> ---
>  drivers/firmware/efi/capsule-loader.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>

Queued up in efi/next - thanks.

