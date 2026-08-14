Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4E139021F;
	Fri, 14 Aug 2026 09:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786701520; cv=none; b=fffrJ8PMbrqtq6DBuBPCjsxOWqHz6Dbn0a09kFDjVGO+ChgTMetFAeJO9xlRqnFvH2SBVTsd1ZUJmw8Au84sxTfafGC/imlKDS6KLkZ9y61lAvq2sO/6BnneK5ZWRma5TZ+SpT6p3u1/bCW5A0JC7dguSeqEhfm4VLvUqmZ3GCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786701520; c=relaxed/simple;
	bh=7vCYeQIgOx3/IUurbjtR/QSxekNpzh6f2ki5pn15E4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujHftuQek+KKNjgTyv/346QYHRYfUD67OufVHtaTtpqZRWdST09xuUokqkhuOaHFBz6rvdq3jr+rSv3Gk5am7Zr3mStTvOlaqcNyC8pqEXyOP5OhraUCLn34YDNPXKq8wh4ezQIG5wJYbeHXp6cZmdH+ZBgwkOzi2VYWzoVRRsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=KPwjjmOA; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=SD+7rnhy; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="KPwjjmOA";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="SD+7rnhy"
Date: Fri, 14 Aug 2026 11:58:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1786701506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FxWpvadK3n6moVFqr6tu+oa5IvKI8pRrhdl4IxiG0Es=;
	b=KPwjjmOAAsDjzyu/Gp2Is5rLKWk09wmmsGGZ9DATJ+IesHwSwsi54lqppv1egnGRaCxBl7
	ST66EfYaHfepFz0eHteV3IWCOIW56EJdSMhHg1PM4wjQXqCwOhJhMzpD/7zyyQuTK2nC74
	pD7NNSe7e+IZ3TBFJdGoLbkxnIpUz1SoNVY0Sg+54CiV2OW3K0bQ4NXa4v5oHm9YDMqLWX
	NZyvryIU1QexdjbKQCnfTLgYc0/uwvFgjyg5Z+HBqtGDtcfV2ZrB55CGHgJSTMxgKRbu/z
	jbE/FQn3TfUtf5u0F6KkqCCjlGSIpjGrN2b4gz3O9pGvQet34C3AkPXxGTS31w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1786701506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FxWpvadK3n6moVFqr6tu+oa5IvKI8pRrhdl4IxiG0Es=;
	b=SD+7rnhyFkknUKZPrIyp/qa1/O3UO5dv+//xZrPWMAe18wi6Xoi9dWFWAZ4ruBrBnFYqxK
	rZHGYxSXaEUiBMAg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-rt-devel@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"jenswi@kernel.org" <jenswi@kernel.org>,
	op-tee@lists.trustedfirmware.org, Ard Biesheuvel <ardb@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v2] Documentation: Extend the real-time hardware bits
 with some firmware bits
Message-ID: <20260814095824.yyCVtcMa@linutronix.de>
References: <20260718175041.QXn9iOFK@linutronix.de>
 <20260813082400.h3MRgRPg@linutronix.de>
 <87h5kyhwfr.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87h5kyhwfr.fsf@trenco.lwn.net>

On 2026-08-13 09:28:08 [-0600], Jonathan Corbet wrote:
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:
>=20
> > A gentle ping.
> >
> > On 2026-07-18 19:50:41 [+0200], To linux-rt-devel@lists.linux.dev wrote:
> >> I have been reviewing how OP=E2=80=91TEE is implemented and how secure=
=E2=80=91world
> >> invocations behave. The goal was to determine whether an OP=E2=80=91TE=
E call can
> >> delay the Linux side and introduce latency depending on the time spent
> >> in the secure world.
>=20
> With RT stuff, I never know when something is deemed ready, or whether I
> should be the one to pick it up...  I have gone ahead and applied this
> one, hopefully that was the right thing to do :)

Thank you. RT wise there is no dedicated tree so I always rely on the
upstream maintainer to apply my bits.

Here, for v1 I wasn't entirely sure if what I wrote was entirely correct
but then Ilias and Jens gave me a few crumbs and I am confident that the
document reflects the reality :)

> Thanks,
>=20
> jon

Sebastian
