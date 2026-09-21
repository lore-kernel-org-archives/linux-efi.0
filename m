Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE65D514742;
	Mon, 21 Sep 2026 19:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790018090; cv=none; b=T1L9U2pQrZuKxZ+TOsJl/wssKa/NINRJdCIis6lT4FS4a1ll8EtdpVdPZdSKWpZauu7nvf3NhrNit3b7EV9C7p91cLfyuV4cTnFTpKOPDDIc/UKg2gMc2N5wSakqP/ZiLcFu4euveOkI4kYgfg6XUkcBdI999S9EtxQfJF0rdNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790018090; c=relaxed/simple;
	bh=9s0W0k+uY9shGX5XQPu4OZkZ8A8sGtI9MBOeqdn//fE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lw3PwFvMCUiC/WHrUDrHA5QLNTP3D4yetpEbhh8jGHzNsOKP7RM+rp5qb40BN7M/b1S5aPmzaRJP/WdoNyFgCyL95m47G8OBL67evYhG/ugQjnubEtDUyowCbeswfwtJQMWfGwmtqi3d9f4xQ++GgdpNRT7iJYTFgu0/Vt7N4Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=cW2+Zr2q; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="cW2+Zr2q"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 4BDD51A0E97;
	Mon, 21 Sep 2026 19:14:47 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 048A15FFB2;
	Mon, 21 Sep 2026 19:14:47 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6ECE7103291F3;
	Mon, 21 Sep 2026 21:14:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790018082; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=IutRmbTAc6OTvvdgkkZtC/X/ZDcjhL+70GUhz404HHA=;
	b=cW2+Zr2qQjzlC4iFQcHd3Ap/QXCbm6L1q3tAeZhMjT6iTN5mSiGylWSUjF4Q0sQA79HpQM
	SvXwowpuCCT0SB3QG6Rj7vLrmmzrUFHCnZtU/yE7ATDGmegYMQfAGu8nHY3I4OnECi29ui
	WKRe+8WdZPzzy7nJUaONze1+F+O30gnKKV2KGYZo7PAAmFMbV5Xe/JtDSRFTwBYWwGx+Lz
	j3n1JdC/BVbXuGNFfx8D4iHAm53OaLwQfuWMk0VIkFGmk+EQ5S7p+46pC1VkQo0u1dRNA6
	2yR0uS+h9+30mk5FP6swueqif/GIqbIFHFS/Vbkw9o8uq4QMOcSdVGv+K3Ouqw==
Date: Mon, 21 Sep 2026 21:14:39 +0200
From: Alexandre Belloni <alexandre.belloni@bootlin.com>
To: linux-rtc@vger.kernel.org, "Johnny.Fan" <johnny.fan@cixtech.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Feng Tang <feng.tang@linux.alibaba.com>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, cix-kernel-upstream@cixtech.com,
	bob.zhang@cixtech.com, jie.fu@cixtech.com
Subject: Re: [PATCH v3] rtc: efi: restore alarm support with runtime
 capability probe
Message-ID: <179001804425.244067.16576957362126597621.b4-ty@b4>
References: <20260831140014.839222-1-johnny.fan@cixtech.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831140014.839222-1-johnny.fan@cixtech.com>
X-Last-TLS-Session-Version: TLSv1.3

On Mon, 31 Aug 2026 22:00:14 +0800, Johnny.Fan wrote:
> Restore the EFI RTC alarm functionality (read_alarm/set_alarm and
> procfs output) that was removed by commit 18a3510bc87d ("rtc: efi:
> Remove wakeup functionality").
> 
> The removal was motivated by the observation that many EFI platforms
> lack RTC wakeup support while also omitting the RT_PROP table, causing
> the wakeup capability to be incorrectly advertised.  While that is
> true, removing the feature entirely also breaks platforms where the
> wakeup runtime service actually works.
> 
> [...]

Applied, thanks!

[1/1] rtc: efi: restore alarm support with runtime capability probe
      https://git.kernel.org/abelloni/c/b430d1f6d80c

Best regards,

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
