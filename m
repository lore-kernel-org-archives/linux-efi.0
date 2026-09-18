Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBEE4CDDE1
	for <linux-efi@vger.kernel.org>; Fri, 18 Sep 2026 10:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789728347; cv=none; b=md9N4NXfoxvtkYlaTFYuJ4LhPF9IooD29ykGX8LLgtciDqz8fSlz/YKoZDnanw+XhXuMgHJdRBOsUEoihIIp2OY9QxSmoFwl9Wn/oiddilVOdYDP1bVHLWJCK6SNI+6GJFq3e61SYOr3J2qjoex7Ws2jxz+VEuEWidhsu06zw9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789728347; c=relaxed/simple;
	bh=OBcOp/WPJUNNLN/BRBCXm/SoZaor2Seoa/7lsBT1Hso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7c9homSMzp9Pt4rZf1dvJRMzOfaztAUzr48QfgO6Z3U+pfz+KodfGYjX/re+S2TGZQhWP5p6abth18ox0mM/BS6waY+4VRuIOSAaprkJ49wV6elT/qX0Z5t7O9rVjqWBmCsKWch/vcPg3lvibxpfeTzXO/xiWKcxB+9g/QvUNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IGT+qmnt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IGT+qmnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D4F1F00893;
	Fri, 18 Sep 2026 10:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789728340;
	bh=gvpSan5XjPhNav3uVBE9Qs6HjPGUXqwmidavf1fwncc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IGT+qmnt3n2iJq0xcVCvkENF2bJUVA5+cTDfuG51MHQEV03kA0kLt+qroZ9Oma/dO
	 1/XVdrOxvQ5+afcrDLdCeHW827yXwNoNCoT6/h9mfHPR6LAP1YZ5zl8WOP+heAd0aT
	 eR55f8EQp1P6iBahJKOnuGJ4lw9Rcb1S8fM7JV0TRBunc17l6lsqkfnRhWv715kqrU
	 L5YX/pl/ZiGUymKOI6s16FIBReJ5NzwmaswFytmeoZ+Sd6R9l/WC8b6Y6Y+mislu7t
	 M/LcKiHWu0rgJgN+J4YJAlyPTCd+NKLEoS2f6W21ifaC3ID4ggP2G9w9Z4tjPbaY7e
	 h5BpKbY+otHhw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id D23091980052;
	Fri, 18 Sep 2026 06:45:36 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 18 Sep 2026 06:45:37 -0400
X-ME-Sender: <xms:UBatau9tN7S7U8m9_h0-tjVyhjlk0y_dQIP2kp3Se1In7vicEsKyig>
    <xme:UBatarEIk2NJYVoXgE_Dawg1IVNkmRyC1yqGIFPXM-XMF419DX2Uko-gQR99aGEUk
    uqBKrTvKf_ydbn6KZS33Jge6OcaQOWclIw_lQG2m1CzFIUziJxcIVJ4>
X-ME-Received: <xmr:UBataodKUUOCCnwEpEvX_pKXap5zEJGbTUmYAGLJcDA6Qi-Dy377zobrqmY>
X-ME-Proxy-Cause: dmFkZTEMqhg53C+0NEgCpuWcmLSSu3/F8LqJMGboCPM8ZwSPXAwB3mOihVIGD+2f92ed56
    seYnaj9BBdBf55nHh4sKRgzANUJ2l0mCehMIwWwxTKVSuY56fUjqpIaZi9l3vHx6XmlsyG
    xuosTET7Dcp4FSY4bBNYDWf7705AtfypaxZPPzL8J8rzCGvRFwCemJclAppafKCjxlcklW
    zD9kvXrg3rxzL0RvarlNCYBzqMyTABDtZzr511c2MfphoBlSOi/Pet1ZD0TGFYsugQG/LM
    1eAo6AD4kw3JVdNNilHH/1YANA54m7tmC/ch/s/MCsNaXmxoV1yuQRIVS4CYC/t/F9Ddow
    Dm9dMq22OR5h/7WidlIAm+3CrDVAjpMXfD+7ncnV699j/sl7uUPP5Af2eIdYdB7rcKhpNG
    tzSjcpodvp1wZQxyE/t7OEh2iY4lZo9NPYI94jbQydWthrfIBJ7UxBZq5wIal+iwLlnlQd
    I8TmSAGbjCdM2fMRBhVtR31DjEtDi3PH31ZBF7eUazFKChyUYu7BG/GgKZHum5u8g+CxY6
    M19YxKzXAMVd1XKuh6elakVEOs9z9sNxrL2QeejPoNt9OOXHPWrKxkuvsIB7yxnUmltfbh
    xPvp6pgPcGDhj6dt9gg3k0ZKm0mxhuVpxpKCprdBRLbj58+/27mFCNL1sKuQ
X-ME-Proxy: <xmx:UBatakkaOwDtWO2ER8JaTC7pS6cVboqwZ9PVu7gndnBC3sFTHFmKTw>
    <xmx:UBatavpm2mjsK7QrtSQGpHMkKpUwIMOByMI8nLljP9QnOV6FEVazNA>
    <xmx:UBatapGYYbM3AOMciPm8ySD9ubMjVTW1IlWgyKrTN_-MLUNtqH7j6A>
    <xmx:UBatatRAdwc91jL47iaVSxGGqO5MoRc4LErrz_SSRW5rOnUEqjYa9w>
    <xmx:UBatanOFHyEXS2NWVl3ehmFiWNGeZcftaEv9v_aMWpdGtklJ1QZLgDOc>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 06:45:35 -0400 (EDT)
Date: Fri, 18 Sep 2026 11:45:34 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "ardb@kernel.org" <ardb@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Message-ID: <aq0VWfqv2_SgOvV9@thinkstation>
References: <20260914183745.37538-5-ardb@kernel.org>
 <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>
 <aqvrUeIfpE4D-Ol0@thinkstation>
 <27b267cdaed0c46146de4af2db8362b61e0b08a3.camel@intel.com>
 <aqyd+rhamNei92Nz@yzhao56-desk.sh.intel.com>
 <aqzMGEVpDRPUyPUA@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqzMGEVpDRPUyPUA@yzhao56-desk.sh.intel.com>

On Fri, Sep 18, 2026 at 01:28:56PM +0800, Yan Zhao wrote:
> On Fri, Sep 18, 2026 at 10:12:10AM +0800, Yan Zhao wrote:
> > On Fri, Sep 18, 2026 at 02:29:55AM +0800, Edgecombe, Rick P wrote:
> > > +Yan 
> > > 
> > > On Thu, 2026-09-17 at 14:32 +0100, Kiryl Shutsemau wrote:
> > > > > I guess the caller could care about TDX_PAGE_ALREADY_ACCEPTED errors. But
> > > > > SNP
> > > > > doesn't do anything for this case. It seems like part of the problem is that
> > > > > we
> > > > > are passing errors back that the caller can't feasibly handle.
> > > > 
> > > > Maybe. I don't understand SNP model and why they don't care about errors
> > > > here.
> > > > 
> > > > Do you have a proposal here?
> > > 
> > > Yan pointed out that future TDX modules will not take an S-EPT entry lock on
> > > accepting a NP S-EPT entry. However, I think this won't prevent guest caused
> > > busys on re-accept attempts?
> > Re-accept attempts may occur due to:
> > (a) two concurrent ACCEPT TDCALLs, where the one that arrives slightly later
> >     returns either TDACCEPT_ALREADY_ACCEPTED or TDX_OPERAND_BUSY.
> > (b) two successive ACCEPT TDCALLs on the same GPA.
> > 
> > Since Linux guest always invokes ACCEPT TDCALL before a memory access, and
> > accept_memory() always checks the unaccepted_table->bitmap before invoking the
> > ACCEPT TDCALL, case (b) should be impossible in practice, right?
> > 
> > Is case (a) a valid scenario, and does it actually occur in a Linux guest?
> Case (a) should be prevented by the unaccepted_memory_lock in accept_memory(),
> right?

Right, for accept_memory().

The lock itself is dropped around the TDCALL, but the range stays on
accepting_list until the bits are cleared, and the overlap check is done
in unit_size granularity, so a second caller for the same unit spins
until the first one is done and then finds the bits clear. Both (a) and
(b) are covered there.

There is a second ACCEPT issuer that does not look at the bitmap at
all: shared->private conversion in tdx_enc_status_changed().

It does not need the bitmap because the memory came from the page
allocator or memblock and got accepted before it was handed out. It also
has no per-range serialization; mem_enc_lock is only taken for read. So
ALREADY_ACCEPTED on that path means either the guest converted the same
range twice (a double-free class of bug) or the VMM acked MapGPA(shared)
but never removed the private page. Either way the page there is the one
the guest accepted earlier, and the failure already comes back as -EIO
rather than a panic.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
