Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A017642980C;
	Tue, 16 Jun 2026 10:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781604829; cv=none; b=PVbMI/qXN/T2iWB4P+vJbxm9vADN2Vh2iOlGDoZ5hVbius7Mn+McrjWDN6LJSmxPVHdsTPCes46qwe7BqU5CvWFvvsSM78YGIiW2GqE1PMNXFfF4JvVdGc375zqoA/nHiJRmAkT4Imq7spKYMuUZiVDCtRTsxDtZS1n/7NThqkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781604829; c=relaxed/simple;
	bh=pRZ9Rw1w58yo5YdWK/Xt8RTf1o9s+khBvebtbKNnkks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fw7x3LKZB/eLI4kho9M3Cgqdo6+USTqpyI3i1sxMzukUvfgrq5N0uj3ZpuN8Yjcs9P/NLB1HKSNZ/If/Epid54A2yfCqzEMNiBadeDABRHPnNpWlfX4MQgh2Tli0EfqC6xzuxCRrB2SpM5ppMfJAR1fkHnAd39IJq/q1fXppEFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=piYoPXub; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="piYoPXub"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LA1q19T6vLOVWMEv422pRG7vweImDg/QGOzslI5IfeA=; b=piYoPXubsKeUIOthAe3s6DEE+R
	LCrmhmmX2GS+Cg2TBMHQsJ+QIxzp+B+QOavbl3Xh/ZaPGDaHxPW2SLoW0HFHR72HUh+aLBhjQCzOs
	s3aBFE1749/57QU9cmC1AinO3WPV0UrzrnX03bJUd/h7hoZpwD7Iu/VYBaWlD6acCfDdg7wmocWBQ
	MuCMFE3GVkB0niWVCLs2xlv7VXJGtvqCJpsvFLMlpseN3BFGMIMzoLBpaSjt8OIcFJ5EW0iQLwvdO
	xuawiPq5XZJcMtWHqVHIMZAvagOjrJJGCxGwa62i7s96AuC/N3pBATtF5dLDvGLoNSWPMTkfKthr3
	WuYHGmsg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wZQnI-00Dlys-0l;
	Tue, 16 Jun 2026 10:13:20 +0000
Date: Tue, 16 Jun 2026 03:13:14 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <kees@kernel.org>, 
	Tony Luck <tony.luck@intel.com>, "Guilherme G. Piccoli" <gpiccoli@igalia.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	rmikey@meta.com
Subject: Re: [PATCH v2 6/6] efi/runtime-wrappers: retire the worker if a
 wedged call ever returns
Message-ID: <ajEfvzYRh9oUJWDf@gmail.com>
References: <20260612-efi_timeout-v2-0-f714bb016df6@debian.org>
 <20260612-efi_timeout-v2-6-f714bb016df6@debian.org>
 <b3780e66-dad0-4f39-9dc6-b74f23fabb62@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3780e66-dad0-4f39-9dc6-b74f23fabb62@app.fastmail.com>
X-Debian-User: leitao

Hello Ard,

On Fri, Jun 12, 2026 at 01:11:11PM +0200, Ard Biesheuvel wrote:
> On Fri, 12 Jun 2026, at 13:01, Breno Leitao wrote:
> > +	/*
> > +	 * If __efi_queue_work() timed out and disabled runtime services, the
> > +	 * caller is gone and efi_rts_work is no longer ours: park the worker
> > +	 * so it never signals the stale completion or runs again.
> > +	 */
> > +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> > +		efi_rts_park_worker();
> > +
> 
> So one thing to note here is that the arm64 version of the exception recovery
> (in efi_runtime_fixup_exception()) will also clear EFI_RUNTIME_SERVICES, and
> that will occur before this check. This means we will park the worker not only
> on a time out, but also on an sync exception in the firmware.

Correct. Just to clarify the code flow for a faulty EFI:

	efi_call_rts  (EFI faults)
	-> __do_kernel_fault()
	->  efi_runtime_fixup_exception() == true   (clears EFI_RUNTIME_SERVICES, rewrites regs)
	-> __efi_rt_asm_recover
	-> caller of __efi_rt_asm_wrapper ->
	-> back into efi_call_rts(), with status = EFI_ABORTED (and EFI_RUNTIME_SERVICES unset).

Previous it was completing (complete(&efi_rts_work.efi_rts_comp);) and
disabling the EFI_RUNTIME_SERVICES

With this change it is parking the workthread with falut as well (with
EFI_RUNTIME_SERVICES disabled).

> I suspect this is actually what we want, but it deserves to be called out.

I think so.

It would not be hard to park on timeout, probably adding a new variable to
track "tiemout operations":


  if (!wait_for_completion_timeout(&efi_rts_work.efi_rts_comp, EFI_RTS_TIMEOUT)) {
      pr_err("EFI runtime service %d wedged in firmware; disabling EFI runtime services\n", id);
+     WRITE_ONCE(efi_rts_work.timeout, true); 
      clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
      return EFI_ABORT
  }

Then Worker tail tests the timeout field, not the bit:

  if (READ_ONCE(efi_rts_work.field))
      efi_rts_park_worker();

But, from my newbie view, you want to park in both cases.

Thanks for the heads-up,
--breno
