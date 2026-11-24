Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795520323;
	b=Bj76im7prmzBtWbCzU6p//iGqF/VhioyDSmYQG3JbFSFeTIpBKFZniT6u2niirS/F8Zl
	 DWwLU4GL3ogQDnYTf9sko/IgQ2twxvJtccanOGA50dh43WEbN4YsREbjYQ0sRVXMQMvhs
	 x6nsPJqfQp2XzPRmeGhi5Ts14ZKMD5JMi8QQnF/xmq5s4eCvwft2G/cLx2VIi2JfiYscD
	 ERGy32pQNLqx9eGGDNvTrF40LETJNeL+7Fti1So+pY9ySaY94PCi99Gy15MxeqE03zYNy
	 4Za3wDqfbjhB/kXeCK7M835j5/+aI1HMaFBHucoRqbWchMXtV2XsklLBXhPnn1TWmyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795520323;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=ABQKVhyl294KKPWOJB2LpLQRmzI66sryw48z0Ejt/g4=;
	b=k9jHMEMXtLPH/Dk3e/pUYOrz1bUErTCnaQBzvXfDQ7TU8IB+tTW9++1QdFOIwCSCgNAE
	 v8z8WEwKlM+WzRQf6nIbCqfs33ZsJ/KtvfJhp1zeR7OcphUkl8wZ3dvqrru8Kw8xdGO4O
	 9jz06a47rbyeeA2NewxRwWHvI8ZOw62WhBqO1eu/BpC5YIv6m1A1071wCXFUpSFCWKKAG
	 hLk/wMbuZbqSjIgffYelednRbTQdkKuvua+Ie3BvSERfi7FyxytaMPaPqogdgAId0aXh0
	 7ffCWzG5eTpAaKnme6X1kXzqc4zsbwlU/W3QgB6yQMGTL3+AiCu26JDvsJa52UDnlNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddfCxFmp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D99F606A327
	for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 11:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddfCxFmp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8D61F000F0;
	Tue, 24 Nov 2026 11:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795520322;
	bh=ABQKVhyl294KKPWOJB2LpLQRmzI66sryw48z0Ejt/g4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=ddfCxFmp275OO+8l8zunn6/sK/8EY7z2z7Gc0dTRsc+vdcx4VarO7PtCK9mMeRXN5
	 UF/U8X+OmCCEC/ALGlVsVqeFp0KEQyRndqW6MXjvx8CiMLfL4njf0PDD74nSP7O1Qd
	 fw37y0TEBmdtwtg0MVyaUEJguFFiuFwcrFvZ5cHLm3yLjg54M6D2Icen/aNb25CyYC
	 gilVooernoEDyQzTWbEZsh8P0caU1QkuKKFNoYR9E+ggMaLfqFrj7BWp7w+KVefLxw
	 +N43FxrSoozCvHTGojkZHtCNh9AzsN+CkhDCKYJcRfC0s07j8I9ZH3XGh9dZsbHBz/
	 ZAyJZQeyfpblg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 4E17D198003A;
	Tue, 24 Nov 2026 06:38:40 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 06:38:40 -0500
X-ME-Sender: <xms:PncFawP3pPb6bnyXZxUv12whf9yVOOGzh9MUlw7Q8vG1MXusX3rP_g>
    <xme:PncFaxyyfGZ_jbYSKsyLeBOwgfPvc9-mRXmQiKA7rhgMJsjYXhlBZ6iM-RQojfNwa
    xD3BjpVsjSwQ6PfoAZsYpWwiHf89h6LOy6mG3whQl9F1Elxw4rAEA>
X-ME-Proxy-Cause: dmFkZTEG+JqeNQanrVPdZRYIGPClXPZdjYqmnC18pn2a0pJiffnGPLt3F2ZHBJaESEW0o9
    g0H7LZ1xcqzY/LTc4mXt5AcX7SyqFeBKltNpWt71RxoDKcxb+UoPc+yrATx87d3BigrtnD
    x+Ab3bcVr0mMnb1eytpyJfDfcxAiksW+fvB62xPxrLFK8szALdnHBvLdBGYyRtOC+rI2Lw
    MiAS0ewoDA3RMjNN9LUd4R5FZ801GDEDin34Atelmpa3jhvNVa8LMGe5L/qmp5CchEZqMe
    q1Gpjf5vLshyPEPKrmtnCyIdFybZIMZRzpIlAcmTkx9NJZAzXAFgEzStDZ4eWRGIRkrCeV
    1wEHwL2LcnSGxVM3XUpyZhvz2a3dcvWT4X4kRrOo+tWDX23D7lUOMVUnQxoSG4JAcczMCk
    FnHR1oBFdS1ONCdWRwwcYMG/v0D7FlDI8nwqPXZB5Dbjj+EZP9JqvkGRzWTl6+KbxchJTL
    sKye7AEEZjhWh5iOz8uP+6N2DAgoP2uY87JldC5wT9OVx8MQfX8iEi3m1XcUMbtHXERqLb
    P9uHAloxbyQXOAWjMU0xHhx3omPdItmoEqd78cYocMO5KwplJKGH9VbxRy06/J1nTO62Ku
    MJnsryoh9sNFNG6hGmMJHVBN8A7wQMMTwUMWnMTFZovpoZwSusCPzt6iEY4w
X-ME-Proxy: <xmx:QHcFa5yBgLXL-f3xC-CoKbnuCA5mbJTxq2IkG3J_mquV6Q-doTTeAA>
    <xmx:QHcFa4VSYg75ZJ45AxhxU7sYrFBWzbQRz83Je9Jab_rMqPzgXZhOlA>
    <xmx:QHcFa5heKXKNkSFEQnkq636Ffx8U0qj8FNA-OdD1Y0YSazfEfmEtLg>
    <xmx:QHcFa4D0oj-qXX_Ggh-uvxmmHSJ-4D42_UkL8wsvmWcFEc9tIlQOdg>
    <xmx:QHcFa_uoSw6afJO-ZWTprK_em1A-ReOWigUK2QAymHiBWiM9LJaHgbSN>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 782FDF80093; Tue, 24 Nov 2026 06:38:38 -0500 (EST)
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
Date: Tue, 24 Nov 2026 12:38:18 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Sebastien WENSKE" <sebastien@wenske.fr>, linux-efi@vger.kernel.org
Cc: swenske@veepee.com, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "James Le Cuirot" <chewi@gentoo.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Message-Id: <37c38d1e-03cc-44ae-b617-d45fbf80acc5@app.fastmail.com>
In-Reply-To: <20261012133712.618913-1-sebastien@wenske.fr>
References: <20261012133712.618913-1-sebastien@wenske.fr>
Subject: Re: [PATCH] efi/libstub: Allocate the INITRD table in ACPI reclaim memory
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Sebastien,

On Mon, 12 Oct 2026, at 15:37, Sebastien WENSKE wrote:
> Commit 6e62d1c6f2c7 ("efi: Wipe INITRD config table from memory after
> consumption") makes the kernel clear the base and size of the
> LINUX_EFI_INITRD_MEDIA_GUID configuration table once it has read them,
> so that a kexec'd kernel no longer picks up a stale initrd.
>
> However, the stub allocates that table from EFI_LOADER_DATA, which the
> kernel that consumes it treats as ordinary RAM, while the configuration
> table entry pointing at it survives kexec. A kexec'd kernel therefore
> finds the same address in the configuration table, and clears 16 bytes
> there again, in memory that may by then hold anything - including the
> kexec'd kernel's own image, which kexec_file_load() is free to place
> there.
>
...
>
> Allocate the table from EFI_ACPI_RECLAIM_MEMORY instead, as the stub
> already does for the RNG seed table so that it survives a kexec reboot.
> The table then stays where it is across kexec, and the wipe always
> lands on the table itself.
>

There was a report recently about EFI_ACPI_RECLAIM_MEMORY being
problematic in combination with hibernate, as those regions tends
to move around.

Can you try this fix instead please?

https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git/commit/?h=urgent&id=6863183e8b65e833f8140e20d526282a725e040e

