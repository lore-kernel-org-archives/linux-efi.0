Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F70D40F724;
	Fri, 25 Sep 2026 06:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790316857; cv=none; b=S1R6A3Yn3c6gd8gG7TIWQenwztLdKr8mAxpEt6pPNSzW1ODTzDft2Dj0O7+ucj4GAzgz6SjehSql57QAJg/EcIuNNLvuJUAll89+nLpjUllOLs0AqI0F2XFbclx4Oh/HDqZriCl7Pn7a7vt748v/gHQs+JNNmRMJREMxroQnq7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790316857; c=relaxed/simple;
	bh=zJPVYut3caqV+BupQglYKFwx8NCPvWAjqyqRdOTUaHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sDDDV+zCdgr35DWNHPUxNwEkdidXmNBwUBbuz6wi/GDRb23fGrmXKpG5P8izsBWEQ8x/TvzrEqkgasydzjGOzEeFzVTH2narCXsroGqr9clOfS/GT6lYHAzJdE4OlJBQK6QDD4szTBAJdj0LSNOjyhHGPOfcQ7OooaCIUlwz6JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=UL5H20c8; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=b648NJ06; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UL5H20c8";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="b648NJ06"
Date: Fri, 25 Sep 2026 08:14:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1790316853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+9t0kxTYJaraIMrfEqcVi2n0bhKkI1NpUKQYTTJwJiA=;
	b=UL5H20c8pe0C3qusv5XX1mo+I4zBXKKS320j1shCqc7ov+H8lDM7SXQ/4LMT10xrtAQxXX
	vO6BHJb1Qll7ZKK5bBFjD9HoNAMaeed8Z1PvImisuq5o8cobKA4WCJKqdQh8Bm8wfRsvKL
	SDhapMikKeY+ccjQUHKD8CyjCQtZ5GiJK/NBo1Az9zCuLh5RcFo9UqElTT2HPHepA7AC1W
	8VQVxGg3DRSnOiEBjXrAYLeMC15NszklfuUjZg/xwkfZuRq6xKFbwZKZ0UjXHHJPqgO2aF
	pMga251v2F5bPbmTHOLVLQjph06IY9lSK50+YDVeim2pJLfX+eRL99x7cIQZ5g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1790316853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+9t0kxTYJaraIMrfEqcVi2n0bhKkI1NpUKQYTTJwJiA=;
	b=b648NJ069Sf+pwW33BuNO6uws6R1OlRZBUaKyGv3pPXp/Xt80RMmolfwQ0Uk8220YySjsf
	vFIGXzcHKp4EJ8AQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Prashant Singh <singhpra@juniper.net>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
	Steve McIntyre <93sam@debian.org>, Jeremy Kerr <jk@ozlabs.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2] efivarfs: add nostatfs mount option to skip
 QueryVariableInfo()
Message-ID: <20260925061412.Ly5-sosB@linutronix.de>
References: <20260919044124.8268-1-singhpra@juniper.net>
 <arUD_p0Vn4qyBH_e@redhat.com>
 <20260924111913.GN3447081@tack.einval.com>
 <arULLk3ERQmADDBU@redhat.com>
 <0d23d4f2-b5b8-47c3-a676-f6ec72ecf45d@app.fastmail.com>
 <20260925014528.2015-1-singhpra@juniper.net>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260925014528.2015-1-singhpra@juniper.net>

On 2026-09-24 18:45:28 [-0700], Prashant Singh wrote:
> On Thu, 24 Sep 2026, at 13:59, Ard Biesheuvel wrote:
> > On Thu, 24 Sep 2026, at 13:36, Luis Claudio R. Goncalves wrote:
> >> In this case, corroborating with Sashiko findings, it is necessary to
> >> have a way to override that default in kernels with PREEMPT_RT enabled.
> >> To be used where this is required for firmware updates.
> >
> > Indeed.
> 
> Agreed -- and thanks Luis and Steve for catching the fwupd impact.
> 
> For v3 I'll make the option a negatable flag: "nostatfs" skips
> QueryVariableInfo() (and remains the default on PREEMPT_RT), while
> "statfs" forces reporting back on. So on an RT kernel, mounting efivarfs
> with -o statfs restores the free-space reporting that fwupd needs for
> KEK/DB/DBX updates, while the default still avoids the preempt-disabled
> firmware call.

Having -o remount,statfs=on and remount,statfs=off working would
probably improve the situation.

> I'll send v3 with that change shortly.
> 
> Thanks,
> Prashant

Sebastian
