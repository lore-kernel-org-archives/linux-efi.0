Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B79622689C;
	Tue,  9 Jun 2026 05:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780983111; cv=none; b=ra+Pw10baXpmw96PpXWzK5JpEcN6VEjgEWO6WaH/5ASR9LxiI1Z8L2s6fFemOKY7foOeXSxDxlGs3A+G+ynZP3rPYzG1S7HziSfdLXt5sTH8ljwOEsExOMIiI1dlxALhFM6F9qrGGVFJuY1E0jz042HdxsmryhYKZ9M96vQtycE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780983111; c=relaxed/simple;
	bh=N1tSz0WfDaCJhOS0IGgSj9qi0hu8FB5rtygEVzNePOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJ8bEemvhMSCz/I2OQxRFY77ml+daAmus4dZ0TgzOc1APdBpSbxlb5p9Tj2fn6XuXGRxecVSX3AtL4w2dFY9U5CjoPcrOBTFFJdhWq2yk8bPf3dRptXqZCAn4GIW32BI5HdfP4xOS+3l8SoduArmgXWKBGS3yUds9Dzsr+mL1/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUojIW4+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUojIW4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D771F00893;
	Tue,  9 Jun 2026 05:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780983109;
	bh=4nHhNOei7QNfUzNrgd6b9zKAHktqrjJSs2tQI7XWv90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HUojIW4+spXliS/WJ9e0L7NRKhF43nwz9aw6NUlkgYwKcPTg2maOoeUcdMDkZXrl3
	 EAecWoTuok6//TMhj/wDkVEsx6wjgJGqGaAS09ejhEghuKdQy80zYGvv5CT8tXBo61
	 vR69FojFHwv32I3+mgvzzPXqixHjLsWV4DNdSQQ8=
Date: Tue, 9 Jun 2026 07:30:51 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Markus Probst <markus.probst@posteo.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jiri Slaby <jirislaby@kernel.org>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/2] serial: earlycon: add uart_clk_freq
 parameter
Message-ID: <2026060957-chaperone-tarot-d548@gregkh>
References: <20260609-acpi_spcr-v2-0-3cd9a3bda727@posteo.de>
 <20260609-acpi_spcr-v2-1-3cd9a3bda727@posteo.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609-acpi_spcr-v2-1-3cd9a3bda727@posteo.de>

On Mon, Jun 08, 2026 at 10:40:21PM +0000, Markus Probst wrote:
> Add `uart_clk_freq` parameter to `setup_earlycon`. This allows the
> options string to be reused with `add_preferred_console`, while still
> allowing to set the uart clock frequency. This will be used in the
> following commit ("ACPI: SPCR: Support UART clock frequency field").

Ick, this is bad, now you need to look up what this 0 is as a parameter
every time you see this call.  Please just add a new function that takes
the new paramter, don't abuse the old one for this.

thanks,

greg k-h
