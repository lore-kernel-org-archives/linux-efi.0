Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE12B345CCA;
	Thu, 24 Sep 2026 11:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248844; cv=none; b=PzYQmUS8Z0YjHIjSTGFX5Gr6r8cHAzB/V0X4JXXNvUtbfKOJzbzo7RfxyOlD1e+7ukJpt4CeRHbJpn5/XcTTQWPuPrGjcV/Q472V9j8IoVesw8uPVzGlQF+Ysf5tFxJPF+XB7IsvRas6VtXOmeSCA8ClUeT+/LKJMZ1qt609Lyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248844; c=relaxed/simple;
	bh=yGq6jFcpBFFx6CsudYgDQSKkCZk6t8NYGt5rAsRafzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rn75ZSXqcm3bsKt62kmFsqfCF3pQnznD0n5MXnBw696YC5OWfi9It4Mf3IukNNdy3bs6BLQ7Y7dKYjhhvsowgheBctaadJc2dekzLYV+ALarGMV71ZzLJW+7YiHZN6CQooeG633NMTeVSv1uupA4XvphxBHgC0RYwsGGTwEFr2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=qy9Nytc2; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=ms+bdBL1; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="qy9Nytc2";
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="ms+bdBL1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=O60QNrfBDhwmpEFr3dBSj1xPYIcsj3539P1OBpzTDiI=; b=qy9Nytc22DTgI8DQyhvwK+U9F6
	y8pq46jSEiU57a3wvOpbQkna1SbOsDkFfvDh8nfwfj02TGTptEjEmrWyUgLAwZ94fdpgIT/rWIxzx
	sj6avv55Pgq+ztuKJq7/b+ioQiMAtTennnwhpEQCTw/XcxVRpgq3IcIGaG+ZD9P8FZjn8VGYANY4T
	cKH0pBshYkePQ9+dUJhiFWZ9vHfdixlahvroLb068vnaKf4RAHK++lQiEsnZ8UMe3Fy5o09AQ0Ce+
	gFZT6AWNb+ehyX5jfsHs7VXAnvQSyf0mzif6jUL9gJm3ELfg5QLY6aoX2UIQypKm2wAh4Ze+gzB57
	fvy6ha+g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <93sam@debian.org>)
	id 1x9hUp-004UVG-0j;
	Thu, 24 Sep 2026 11:20:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=debian1.93sam.user; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:Reply-To:
	Subject:Content-ID:Content-Description:X-Debbugs-Cc;
	bh=O60QNrfBDhwmpEFr3dBSj1xPYIcsj3539P1OBpzTDiI=; b=ms+bdBL1Qc2jnBMQAqlUzzqnzZ
	WTywAihc9bn2lEiPOrwY/96gJn5J15sOGsNK2rR/NAz5QGqRqQAGJH08vm2e20f6iMsB7l7sDK90o
	U1DsjjLkH1IYbqKUQRk1q8GeK4BPr0cvQaWxjeBkhX6CiBPYf3TPaa6YEhCoEzqhfUeQK+B8RSoZR
	zeyrmBK4/JRssKKh0ucKjacfFEoX17wxEqijjdZ41ifWDGnlqNgEyMhFRX3lf61qwoIQcDlr+rgyL
	KG9Yp63k7PhzR3k+P3oKmCTBQYDcY9PkYGjmlRSoxdGFicM7llqdgijGe+unavR8/SAqUnY3HHrM1
	2vWRC1JA==;
Received: from bsmtp by cheddar.halon.org.uk with local-bsmtp (Exim 4.96)
	(envelope-from <93sam@debian.org>)
	id 1x9hUo-005JU1-0h;
	Thu, 24 Sep 2026 12:20:10 +0100
Received: from steve by tack.einval.org with local (Exim 4.98.2)
	(envelope-from <93sam@debian.org>)
	id 1x9hU3-0000000DbrR-2fHl;
	Thu, 24 Sep 2026 12:19:23 +0100
Date: Thu, 24 Sep 2026 12:19:23 +0100
From: Steve McIntyre <93sam@debian.org>
To: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Cc: Prashant Singh <singhpra@juniper.net>, Ard Biesheuvel <ardb@kernel.org>,
	Jeremy Kerr <jk@ozlabs.org>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2] efivarfs: add nostatfs mount option to skip
 QueryVariableInfo()
Message-ID: <20260924111913.GN3447081@tack.einval.com>
References: <20260919044124.8268-1-singhpra@juniper.net>
 <arUD_p0Vn4qyBH_e@redhat.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arUD_p0Vn4qyBH_e@redhat.com>
X-attached: none
User-Agent: Mutt/1.10.1 (2018-07-13)
X-submit: auth config found for 93sam@debian.org, using mail-submit.debian.org
X-Debian-User: 93sam

Hey all,

On Thu, Sep 24, 2026 at 08:05:34AM -0300, Luis Claudio R. Goncalves wrote:
>On Fri, Sep 18, 2026 at 09:41:24PM -0700, Prashant Singh wrote:
>
>I tested the patch and was quite satisfied with the results, but upon a
>comment from colleagues I ran a few more tests and noticed (confirmed their
>hunch) that fwupd complains about not being able to get the free space in
>efivars:
>
>  # fwupdmgr get-devices | grep efivars
>  │     Update Error:       getting efivars free space is not supported
>  │ │   Update Error:       getting efivars free space is not supported
>  ...
>
>I was not able to establish whether that would prevent specific operations
>due to the HW I had available for such test.

fwupd will refuse to do some of its updates if it can't read the
efivars free space, in particular updates of the secure boot keyrings
like KEK/DB/DBX.

-- 
Steve McIntyre, Cambridge, UK.                                93sam@debian.org

