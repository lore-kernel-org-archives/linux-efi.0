Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C48D361DDF;
	Fri, 27 Feb 2026 17:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772212477; cv=none; b=Dh1gahmTYSDhgUJzeBBAVnTJ9YC4Dlr7isVuickfE97vX3scGwYcHmMEeE68eqOAel9VZKUJrfFQfC02VbYy52IJblu/STLKTopeYQS3asSP1nYslFMOFh9WHzSEY+z6SyZs3sogTVUrnQMMYdopAZ8obGkkY6yf7g2Ka4aAzf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772212477; c=relaxed/simple;
	bh=Nq3e5rr9eqP4frKaVBR1bUzIcrN1fo3dmGe77WArFgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DTSTA0D1cN5zDk+1691OWoAIezdWRoVig7v5BN8HtD1GOzI5Sj01NoermypJCQR3V/IVIYtDBvmt4C9KqfHLVv8salxl4PHTBLpUIox951cb/fIpqDcwpbCosoMmVucC5CEEeUzl41DhL6hPxhpmQY86Q++LuDm1FYMh6JRhedI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=RaIuikwM; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=D0MpFwEX; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="RaIuikwM";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="D0MpFwEX"
Date: Fri, 27 Feb 2026 18:14:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772212470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nq3e5rr9eqP4frKaVBR1bUzIcrN1fo3dmGe77WArFgw=;
	b=RaIuikwMWgHZ/FeytgRzQ1DqPBy6vmwawbRVGiKQ86wFPAK2JM01GjI0393COhe1a5YCEj
	70AlpUw83sd0GSKwT/wbLTq5WPMYP4pwlIkGsFzQ6go6aFKwsxPJ2KC7Bh59Goid8BMAlT
	XArushhFyD/1Biw3XPr3RUVLpGImr7JuwZj7VZUrCbx+Ce52mYcCWOW+OJ7AdsvwA9BwYj
	W+TVfovRe8DqvXxEUnxeSXQU5NP0n6YYOBjS/g7Ym/TtcxCz6FyTUvk5i1paQSIIUP7ScM
	ZmvRlID6Kqn0c+17sUJTJ+vkhDxwhqi1mvDL7csR9+i4vYcRtE5mFiJcB9+L4w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772212470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nq3e5rr9eqP4frKaVBR1bUzIcrN1fo3dmGe77WArFgw=;
	b=D0MpFwEX1l36OSYhxDLXfFqjKpfX/1UJq1ZMQ8Kwl6bJeg3Ql1w5Fmo15qC77yZIE0l6ex
	avGuuwL/Ms3XAEAQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH v2 1/2] workqueue: Allow to expose ordered workqueues via
 sysfs
Message-ID: <20260227171429.-Fwih-F3@linutronix.de>
References: <20260227170103.4042157-1-bigeasy@linutronix.de>
 <20260227170103.4042157-2-bigeasy@linutronix.de>
 <aaHQjt8bZsFLBwfh@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaHQjt8bZsFLBwfh@slm.duckdns.org>

On 2026-02-27 07:12:46 [-1000], Tejun Heo wrote:
> Acked-by: Tejun Heo <tj@kernel.org>
Thank.

> I can apply this to wq/for-7.1. Would that work?

I think you need to take both since 2/2 can't be applied independently.
Maybe Ard is going to give his blessing ;)

> Thanks.

Sebastian
