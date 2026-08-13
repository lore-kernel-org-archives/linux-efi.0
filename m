Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9980848550D;
	Thu, 13 Aug 2026 15:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786634891; cv=none; b=BVcp+sw/rhBBE76exWlPMoiRvTs7eutZZIXvgTsoGDS5UVKvxt8ki0OWpGs6hogWRV9vrbgZovXabLwHlDyy4ZPrZOtBs+9QkW+nWPI1V0wmcklc4HZLCAKlMmuXQmGtDGyzwLl2Z6o3SPN+p0wECWn6y5KpD6KKOdkrh36vegQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786634891; c=relaxed/simple;
	bh=7Ye05oEwq0rBP+SO1zNSVW8GqrXzisGSDp2hg4zer9I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gfgePVUdOZchDYYBThmd4Vxs0Oy1bGdabWwDSE7Ub4suuzVhT3gqn5Q98bjHG+DM8G4aGFLAQqG6QnZU2Ra5UM8aTlUv88rFbTM4GOhpXbyhaFjStz6LgKpy2fAUWcA434PPX4uhwagsz2TE6e/lxbjEceGPLcw4ttdxGZWrYdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=heQUmYoM; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="heQUmYoM"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net BC835408D9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1786634889; bh=qVRpckEi8M3RGXpcyKaTknYqIEBsqHrZyu1cIn1LCaA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=heQUmYoMt4jWOg5Zq2KdxS19awWIgQUdZDMEj9GZfv2zFthlp2WDGhcW38kwXCuqm
	 wVI5RP5mlRkxDkO3vpSf3ufjDfhaXPIN/0cdI8yEDZiS2OHDKn/J8fSM4IkxkSGUAi
	 VlWssZj5Q9VYWSu5v+f5iy/Ybmh9FD1YD1uyxXCvByU0eMy/Iw6WyRaMPzC99PsKUY
	 qBmSu/DnfmeCbBWuXAjXnEfG3ZekZxDTVK4+6AXlPws8S0WDlm8dot7zksAKXvatSn
	 aKq0RmQmUPncuC6Ml0+hXHQvvoUsfZkaKZjNyv4SJhaiqN/vLBVXfcU/ypp+43jYdx
	 IEuy3DKkH5fNw==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id BC835408D9;
	Thu, 13 Aug 2026 15:28:09 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-rt-devel@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-efi@vger.kernel.org
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, "jenswi@kernel.org"
 <jenswi@kernel.org>, op-tee@lists.trustedfirmware.org, Ard Biesheuvel
 <ardb@kernel.org>, Clark Williams <clrkwllms@kernel.org>, Jan Kiszka
 <jan.kiszka@siemens.com>, Shuah Khan <skhan@linuxfoundation.org>, Steven
 Rostedt <rostedt@goodmis.org>, John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v2] Documentation: Extend the real-time hardware bits
 with some firmware bits
In-Reply-To: <20260813082400.h3MRgRPg@linutronix.de>
References: <20260718175041.QXn9iOFK@linutronix.de>
 <20260813082400.h3MRgRPg@linutronix.de>
Date: Thu, 13 Aug 2026 09:28:08 -0600
Message-ID: <87h5kyhwfr.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:

> A gentle ping.
>
> On 2026-07-18 19:50:41 [+0200], To linux-rt-devel@lists.linux.dev wrote:
>> I have been reviewing how OP=E2=80=91TEE is implemented and how secure=
=E2=80=91world
>> invocations behave. The goal was to determine whether an OP=E2=80=91TEE =
call can
>> delay the Linux side and introduce latency depending on the time spent
>> in the secure world.

With RT stuff, I never know when something is deemed ready, or whether I
should be the one to pick it up...  I have gone ahead and applied this
one, hopefully that was the right thing to do :)

Thanks,

jon
