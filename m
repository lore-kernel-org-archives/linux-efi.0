Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001016;
	b=0UuUhHBKTsIft/yxl7qN4Yx4sXAAi0ybVOLs21wPhR6CPDIRxFq50gWF/MKS4qZ0O0nn
	 Pj1SbyAhlt7sAmo9oo5qwIByUiAzX8y/Kdun+gwumSZCOng+Az8btBMycD5flWZordI/D
	 7R1sMVzLZ5/W7QrbhEtWGpPPAFPtpJCKLZNyfsKXqEsDxe6geJzpse2rlcmR+4RBYxsGl
	 6SSBz6CgCO+Vndjd7wztRxw05NhQEbz4W3lxPtWcrEYg9DDxYOvtx/Ls13i+s8DnvmDoE
	 HR7rSSm870UtNxFHwhsF7UdgnGswKcfhjqplPFwkgZwqQ8IgvczQLc/zS2rZCoTkjEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001016;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=h6c56GT5dZlNnGdRFZuOaR/Ayh1c+jZksN9Ebs1SvYQ=;
	b=lHaK2CYc/c10Zt9dEQX0cgrUE+3Y0nbqPlLhLH1mptJ/8MXqfoYf3x8hrMY3JlShwSHg
	 wEt/RSGZhNX/5QS/ljIPk1RxXhJmvduzGEe3+l4V/bWWPVPDirujVrCjk6DQWIwvfTXQF
	 ktJrehW4DJTS2M0WNB1tbxxyzlKpWlM3wXsNn0oHSjEtbY9ldnzPc+nIXWmd/kM3cscAs
	 sqvYAxdON7D3W8LNxUnwx4JwtnnFXmt+7uMKch9NJGiix1kGEicAIpZpdg6n82x9P6FFD
	 ClwMaVQsufNpYyE3RqLs9KeMm3IMj/n72zo/CEtIySL4cPNdMQkQcvx2Z3FAIJZeTdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UvR5lEin;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E12F606A320
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 11:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UvR5lEin
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1031F000C4;
	Wed, 18 Nov 2026 11:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795001016;
	bh=h6c56GT5dZlNnGdRFZuOaR/Ayh1c+jZksN9Ebs1SvYQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=UvR5lEinR/ZxBKNvTMqyeIca9oIRlRYm74h0Q+eHeK2wH0g0ZGbw9NlrUiDBDuXRa
	 UqLbuJVjxYoOetryJCXTVgr6u1UjHth1GXq9Z7yRsxxrXWP4dEzNfCcOCPOCTbty7H
	 L2cFA6nBFDVxkU8sJpfVun9/bNbA+g/9bgFYTBTUGNv/kaF86vDzU2G672xs0r8XoJ
	 ebk6cHmf8McidA2XEJ+OAhf86R99NkOvPvr1k9yxqIPZiCC2eR//EVa3M7HPhJGEAT
	 1MJsAvzYo2ujhMQrFzBHYMDWLazQ8gbFgOrEKO3g+JnjxAVTQ2fm0vX7TH+B80+Y6g
	 GHNwrTbJz1rDQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 1B7F4198003A;
	Wed, 18 Nov 2026 06:23:34 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 18 Nov 2026 06:23:34 -0500
X-ME-Sender: <xms:tIr9ahZq1ocmpwxIXhf-F80q3Uqxpfl_nFNfgz_Fky-D8gIOqkC8SA>
    <xme:tIr9ajPDcTWR7KOSvCXjEwIlgFgnKqkA1FyuWOro1lgXSPZHYIxQiMKCjFD9fuQ66
    coK_Rs9DxYGrPH8Eyyvlza9o6XW9bGZDs64K7ycYcFeMDe7pwsblQM>
X-ME-Proxy-Cause: dmFkZTGQ3AIt8NkRlhwKOE2eLriF3euVo9ccg3+yQhNtzKQQDQ+5Y3+pVP1WbG+Z1/jm/m
    OdOoypG7G2yzbPAnAmvhBZVk8MexoB6VPdpuUc94cvmZ4OUYCqrg/nTCbYWhsGiKU29yLu
    ZTjc8AxSoKJ2+rnXmW2kfu6GTB5ccVobPoBfmn/zj6p5tp/uKeLn8f06SThNTSxBptz9Tu
    h3NY/5+5Gl3cyD4mZWe+byhNpgaSKxYCUlVcFRFoUHN9g/RN4lN6t4TcsJQvTjRG/tt9c1
    e0lTTBn99Fgy5hB8/NrRerA4AwqUoON9QpWPlpOxpa7feHUvFvmtL7TSqPDef9MH7sb8V6
    CTDFCKAdCwCiCkWcTT0JDFFm2zN9JJmX4pT9bBh+jvVXUkNAdHjpjjaGX5YmgCrMDYWzNM
    YMY7TMRH/K7PRr5zxW5YjiTu0KrklU2/Bp3G8vTbexb7rBNnW/uTtnX1VQPjD1ula48yP5
    M1iVExLoD58Sm9RFIVv35757JSzf9rjS+XNVAZ6wxmIAWf8WpYrtHSkBxX2UwCJI2ijSiS
    KraXsoNvCeK2auoRyrm2LVqvbTE5LIVAd5WY+FSHQ98IbKfPZ0SxMC/xIo9hHF6YWiUWhx
    KyyV7V4IqBnPkmVJrEB2BFdAL+Z+n0AKDbgUEWjDDUJMlb7Xs0P/mW1GGlYg
X-ME-Proxy: <xmx:tor9aumJ4c57iawxLzY_XPZWkNUNz59dudMW98kvKLuACKHX5gegdw>
    <xmx:tor9auxnt-ziUJMO5RtwehssH3ehYOed5lhUYdNWDrevxGe2yvzAdw>
    <xmx:tor9aoOPPl1KyXkXsTlPgS-my2KkEOJ8m8hxWGFcYWSBcUeMCCVp3Q>
    <xmx:tor9aioOyMYsWqlWpcEvVR065RjIEMlVn-sphs6kYQq5l8EmEuETTQ>
    <xmx:tor9apEeYyNfzzLEPqzMCMNAdHsRvKmOOGj2I_38veWoLSsgUk4HrGF1>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 9FF41F8008E; Wed, 18 Nov 2026 06:23:32 -0500 (EST)
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
Date: Wed, 18 Nov 2026 12:23:12 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Ard Biesheuvel" <ardb+git@google.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>
Message-Id: <f15c5920-a624-4758-bd69-221d658d1ffe@app.fastmail.com>
In-Reply-To: <20261111091843.3621782-2-ardb+git@google.com>
References: <20261111091843.3621782-2-ardb+git@google.com>
Subject: Re: [PATCH] x86: Make the 64-bit bzImage always physically relocatable
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 11 Nov 2026, at 10:18, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> On x86_64, the physical placement of the kernel is independent from its
> mapping in the 'High Kernel Mapping' range. This means that even a
> position dependent kernel built without boot-time relocation support can
> run from any suitably aligned physical address, and there is no need to
> make this behavior dependent on whether or not the kernel is virtually
> relocatable.
>
> On i386, the situation is different, given that the physical and virtual
> load offsets must be equal, and so only a relocatable kernel can be
> loaded at a physical address that deviates from its build-time default.
>
> Clarify this in Kconfig and in the code, and advertise the 64-bit
> bzImage as loadable at any physical offset regardless of whether
> CONFIG_RELOCATABLE is set. In practice, this makes little difference,
> given that it defaults to 'y' and is a prerequisite for EFI_STUB and
> RANDOMIZE_BASE, but it will help with some future refactoring of the
> relocation code.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/Kconfig                   | 40 ++++++++++++++++++------------
>  arch/x86/boot/compressed/head_64.S |  4 ---
>  arch/x86/boot/compressed/misc.c    |  8 +++---
>  arch/x86/boot/header.S             |  8 ++----
>  4 files changed, 29 insertions(+), 31 deletions(-)
>

Ping?
