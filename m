Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA71EEC3;
	Fri,  1 May 2026 05:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777614851; cv=none; b=tfafZz95E94bwzPfhjhuHioQZUjR/CCCqmfAjLzTCvQ2w0GHkJXePd8kjMTjDOPN1Zbj1qZ0Xy6uiZVprpbAmffPTOoK6cXnuUJmzWPKYtJgK4leypQJt8ngryYIoU7pIIwPjLo411BeYqJSLsSycuDRLFaVCrv057z6LUibd0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777614851; c=relaxed/simple;
	bh=zdJD0d2yP0ul7+/knz4VgP8fWmFl1kiEx7wl4TYp+Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bZrsEMHEwZ8HzqUu4I/XtDhRohLFz3klrs5I8jflfiP1a/txkbIL9PpegXp2e1yocFtK/HBmRrYP9LMzeWQgezU5CpGmKfv70zaHfaf6150qP4ZxpOtwfQ/SKGYan8hqTl1mCgvGl7KsISjUCJqusj9FyaP/Nu+UNiSqY7kER4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DuAMJJ+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DuAMJJ+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5BFC2BCB7;
	Fri,  1 May 2026 05:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777614851;
	bh=zdJD0d2yP0ul7+/knz4VgP8fWmFl1kiEx7wl4TYp+Xc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DuAMJJ+xujoLJrRPTZhSIeSaLbGl+wvvNn1tCmgUNR71GmbDWlSMBqPpxQT2wmA4Z
	 d4L2u7kbQvWY2+iwwvW0JFqO7h7pPKvMAsruI+3dhFxP1FPltvROZHpuhwv8g7vIB3
	 snBoMMOeX0l5AP6tym7T6RS0REYw4bWZqWxGCZKjkM3ZJZW2yPBjmyqQ10qV9tBNy6
	 0ZLAVBwMB/A+CwcRc5kiEjfNOcloofZp+UibbFthTuPXzMzXVW2WZfJwJilE8+8uKH
	 1FvMrtvfG/b1iW/g8CIlBZ8NMjJUjtBzFvifiIKKqAqXhurtvfOHwNJouybG31tTjx
	 pRnXDkkkqONLQ==
Date: Thu, 30 Apr 2026 22:52:52 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ivan Hu <ivan.hu@canonical.com>
Cc: ardb@kernel.org, ilias.apalodimas@linaro.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/efi: Fix graceful fault handling after FPU softirq
 changes
Message-ID: <20260501055252.GA35316@sol>
References: <20260430074107.27051-1-ivan.hu@canonical.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430074107.27051-1-ivan.hu@canonical.com>

On Thu, Apr 30, 2026 at 03:41:07PM +0800, Ivan Hu wrote:
> Since commit d02198550423 ("x86/fpu: Improve crypto performance by
> making kernel-mode FPU reliably usable in softirqs"), kernel_fpu_begin()
> calls fpregs_lock() which uses local_bh_disable() instead of the
> previous preempt_disable(). This sets SOFTIRQ_OFFSET in preempt_count
> during the entire EFI runtime service call, causing in_interrupt() to
> return true in normal task context.
> 
> The graceful page fault handler efi_crash_gracefully_on_page_fault()
> uses in_interrupt() to bail out for faults in real interrupt context.
> With SOFTIRQ_OFFSET now set, the handler always bails out, leaving EFI
> firmware page faults unhandled. This escalates to die() which also sees
> in_interrupt() as true and calls panic("Fatal exception in interrupt"),
> resulting in a hard system freeze. On systems with buggy firmware that
> triggers page faults during EFI runtime calls (e.g., accessing unmapped
> memory in GetTime()), this causes an unrecoverable hang instead of the
> expected graceful EFI_ABORTED recovery.
> 
> Fix by replacing in_interrupt() with in_hardirq() || in_nmi(). This
> preserves the original intent of bailing for genuine hardware interrupt
> or NMI faults, while no longer falsely triggering from the FPU code
> path's local_bh_disable(). This is safe because softirqs cannot run
> during EFI calls (they are explicitly blocked by fpregs_lock()), so
> they can never be the source of a page fault in this context.
> 
> Fixes: d02198550423 ("x86/fpu: Improve crypto performance by making kernel-mode FPU reliably usable in softirqs")
> Signed-off-by: Ivan Hu <ivan.hu@canonical.com>

Sorry for the trouble here.

Can you check the Sashiko review at
https://sashiko.dev/#/patchset/20260430074107.27051-1-ivan.hu%40canonical.com
?  The two things it found look legitimate.

- Eric
