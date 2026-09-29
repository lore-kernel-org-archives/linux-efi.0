Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D41D5383F8;
	Tue, 29 Sep 2026 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790694855; cv=none; b=FtR/iWn7KN3Z7SVFXPjUXEjo7kkObYp+MpWl8j6yxIifhSGzAVv9x/eMJ47Onai+xL1PXJ3++2UcTLSjgiQ75NdoAugIrNg5GGwTLf0NXcPS6Tc741Of4zarWU61+Q+tQA3VFK/WxYlk5ISKLxRMWmc7szgstQBHikw5kwBXC+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790694855; c=relaxed/simple;
	bh=XEtGGorji3NtkUx1Ni1j3Vf8MbEwOxKvWSr7f1Dxavo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lwXyrFY4tCrfeUTDx8u/1isCdlcp1nYeadcZuiIjwQF4chwy+4hrnFBEmCkKGTXYGA9/m7xiXhyOvfzYcA7qt7hAAgQ5ybTgrLyusKieWor5aXp9tKpwVS03vPrUn4QsYRhITxAgeJwW6ikKNgTtfUd2E+FwP/sYf78+7NDJbAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=EfBvsUkU; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=VFjjYzNh; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="EfBvsUkU";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="VFjjYzNh"
Date: Tue, 29 Sep 2026 17:14:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1790694843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pkQpYFiMxSAX1DzMvKY2lHJd+Uw2ccGZnZL7SuyrGMY=;
	b=EfBvsUkUz4qh+/XUVEPUlvuwAyW7wbF7E8uDLnTyznKk2n4rsH5/IVXa/H5Sp9kYt27TmQ
	Bu2IK+yy4dMQ7sh38j9m1ef1ftagXFU6MjIo2CMUQuW2Pr6PYka1E99Bp7CIZkTSA/Eoui
	fq/cMZPvEc26JYKhe2/1NCiAY9OVF3uSNlDkQgGa+XJyIWcAvWNpTiPPIg57j9D+QcOB1A
	7XPjbY1aVlJZTh8adcwDUw+9AGp9qgORO2T2w9GCQl9LeVNtoh+8jclbQrzCGBnzpMfWdJ
	RqFD58cMxM6UkL2sSq3Uz+qML61ntsxXadYO/6U/mz5drfeTQ7nzVAsOg7Yddg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1790694843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pkQpYFiMxSAX1DzMvKY2lHJd+Uw2ccGZnZL7SuyrGMY=;
	b=VFjjYzNhNXdMOYOJdjTGaz3xpdUVT/yPc+R1E41OoqhTIHdrpWfHY65AGjhV4AI4PgRCEN
	gsW+CqRESCX/b0Cw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Prashant Singh <singhpra@juniper.net>, Jeremy Kerr <jk@ozlabs.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Steve McIntyre <93sam@debian.org>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v4] efivarfs: add nostatfs mount option to skip
 QueryVariableInfo()
Message-ID: <20260929151401.doOQX7D0@linutronix.de>
References: <20260928203445.72318-1-singhpra@juniper.net>
 <20260929074312.v3jT8uel@linutronix.de>
 <59d5452c-42b1-4784-a593-5e549a2a0f12@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <59d5452c-42b1-4784-a593-5e549a2a0f12@app.fastmail.com>

On 2026-09-29 14:22:31 [+0200], Ard Biesheuvel wrote:
> Hi Sebastian,
Hi Ard,

> Thanks for taking a look.

doing my best=E2=80=A6

> >> --- a/fs/efivarfs/internal.h
> >> +++ b/fs/efivarfs/internal.h
> >> @@ -11,6 +11,7 @@
> >>  struct efivarfs_mount_opts {
> >>  	kuid_t uid;
> >>  	kgid_t gid;
> >> +	bool nostatfs;		/* skip QueryVariableInfo() in statfs() */
> > Here and below you add a comment to every change you make. What about
> > focusing on the important parts, that deserve an explanation why a
> > change has been made. For instance why nostatfs has the READ_ONCE/
> > WRITE_ONCE accessors and sometimes it does not.
> >
>=20
> AIUI the READ_ONCE/WRITE_ONCE were added because Sashiko warned about
> potential KCSAN splats? It would be nice to mention that.

:)

> In any case, KCSAN is runtime instrumentation, and efi_reboot_required()
> is only called after all other CPUs have been brought down. So if anythin=
g,
> this should just wrap the read on the reboot path in a data_race() so
> that we don't trigger any instrumentation inadvertently on the way down.

Right. So if anything, there could be a data_race() in one place instead
inconsistent READ/ WRITE once as we have it now.

Sebastian
