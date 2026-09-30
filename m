Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311FF17993;
	Wed, 30 Sep 2026 06:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790749948; cv=none; b=ngsFR+u/Hgh3zvwDC2kqzSw8hoLdez2pv2CtanF95f/S+oiB2jQH6536Br2T4TsdXm/PMe9X0eubCoSW1xxU4CX9ndLIQkznQCPXJ++xou48CtWGIxvVtZkd9T/ipWuHo5RbVNUlE1BNXfoX44kVCor++mjm8laaULXn8iyg8no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790749948; c=relaxed/simple;
	bh=eFtUtl6SLsJqHXXEehv+b+KtE6uoh1ODS6Wrquueuag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ddtrzyEg+2C34UiwonrNBZSOfxf9LVWrEMB7AwXN3twPRkJyO9KSqjKuh84jlGDjSsgZMkyP9ARtRZEL27OrlzUfxvv5SoLoOzN17hD56S48OtCMVfFfYWPZfHWUpiSJCMJl6srG1WuHso5F/2ijt+mZ0UsMsFwNjbzOLhDiBMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=toSHRJxk; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=8HlXpSje; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="toSHRJxk";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="8HlXpSje"
Date: Wed, 30 Sep 2026 08:32:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1790749938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T/SLGKfgdmqcL6U0YQyjgyASYicfKjEaFyiocJsK2QA=;
	b=toSHRJxkSWbDJKmQymXY9+lda4Ikt+dQTUTGco8Lkyhy7fISV3nKIy50Lm4tKmtOUj/Wu6
	hmAqeG/xsBwiu5xEjdvbLLeHON/hed3bcHlC5WZFOBPeaz7fhQ+AjgrIu+5nMRfCL/3xPL
	gipWOyqBgfbD9Yacq6n3mLRM+J3zM+ikH4qAoCvIV4vRS9lrIrdTB7ym4e/rRT8aPCdvtA
	U4c1xoZ0yyyBZrAZMyWEvO0gFm73a0uTUw4XYMvjQavhV66imFyKzLhNI/5EqCyuWnLgvm
	FHM8EQu9e4nPOYD0UM86pEHujJl2f3xBPHo3A27tTd61+LuhqG+1t8fXwr9KVA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1790749938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T/SLGKfgdmqcL6U0YQyjgyASYicfKjEaFyiocJsK2QA=;
	b=8HlXpSjeFlfwM9vzrencJvRY8E39faY+URYvp5VOmRfBgsqQzJ7Im1FqmH+gVkwJpo88pO
	9A9OAh37lGZ34lCQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Prashant Singh <singhpra@juniper.net>
Cc: ardb@kernel.org, jk@ozlabs.org, clrkwllms@kernel.org,
	rostedt@goodmis.org, corbet@lwn.net, skhan@linuxfoundation.org,
	rdunlap@infradead.org, lgoncalv@redhat.com, 93sam@debian.org,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v4] efivarfs: add nostatfs mount option to skip
 QueryVariableInfo()
Message-ID: <20260930063217.eWGJ_JpZ@linutronix.de>
References: <20260928203445.72318-1-singhpra@juniper.net>
 <20260929074312.v3jT8uel@linutronix.de>
 <59d5452c-42b1-4784-a593-5e549a2a0f12@app.fastmail.com>
 <20260929151401.doOQX7D0@linutronix.de>
 <20260930013500.10273-1-singhpra@juniper.net>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260930013500.10273-1-singhpra@juniper.net>

On 2026-09-29 18:35:00 [-0700], Prashant Singh wrote:
> >could this be, I don't know something smaller not including the
> >commandline where I would expect that people know how to use it.
> >
> >===================     =========================================================
> >(no)statfs              Control whether ``statfs(2)`` reports the variable-store
> >                        used/ available. Disabling it skips the EFI runtime
> >                        service call, which might block the CPU for a few milliseconds,
> >                        reporting 0 for used and capacity. Enabled by default on
> >                        PREEMPT_RT.
> >===================     =========================================================
> >
> >It might make sense to add this knob to Documentation/core-api/real-time/hardware.rst.
> 
> Thanks, I will use this wording and move it to
> Documentation/core-api/real-time/hardware.rst.

Please keep this description _here_ where you have it. Once this is
merged, you could send another patch, extending the documentation with
the statfs option (I think the workqueue change is in).

You still have the problem that someone reading the variable leads to
the same program but this requires a privileged user. And if I am not
mistaken, someone sent patches to have efi-runtime runtime disabled/
enabled.

> Thanks,
> Prashant

Sebastian
