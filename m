Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795068700;
	b=f8lrBIGx10wY2AzS2BIhBtEz16Wv9REAkOZpcmCFVTJXdcxweEicaEZA6wwueZfMgBsk
	 A/m/KLNnsaBRChvLCnbHPPEbC3E2XZBu2ceUlnJOo47HvBLfvlsezEKPT9GNidbV49Z+1
	 BRW2ES/A6953xmyQZaJovXgEJ6TRgukGiqiHVDchPZVn8lPDrXcUG9eGVBkYOYeXcG6cm
	 CGd7SFCJzFDHB+gIdEjmyNnHuQ2oSkyW7D6In8lkTrI+mgxMePYBG5pm8C1cRa2JJm6vW
	 bPKjt2QWtSmGSh2iVyb7ey/fICH3Vv+iA5K5AvpzBr+HNUa4hkyJZm9W0QurTo1FTGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795068700;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=+i7fLpQgbGWXsa4bKAmBMh9yPr9gG6NW6Mco48SKmuE=;
	b=KILl0d2BAdbXvqqxVXY9BWBt8c5sFJHauIPp+qFK6J3JBkQsJVuUcXExwQ8l080g1Eo7
	 lc7M8KvWBnkun70FgQQYrc8TRs++CMRUrUGktE8cNr0Y9qThcxPC9A27BzvC7ri5JzVUW
	 lDUwG+PUVh2Fs/NZUb5LmzIP/oNl/ZNIWZf2RBDJ/QDqdb/JI02/y/EqGgh9IfOJkOno8
	 rFV0E6nQ0oQ2K8S32zCth3R7CFuD9aqvXG9CQHEKMdUAYveVdncPycK2N1m+4Ch4Vfzw/
	 +ArnzSgPUKTZnZ946xL8x0EmP+vAvoPlgPVQcXZE+7m3tGw0q5zdx+69fIYclLCgx8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=U4mnEIRn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.43
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66369606A325
	for <linux-efi@vger.kernel.org>; Thu, 19 Nov 2026 06:11:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66369606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=U4mnEIRn
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-67be4f2f4d4so2138295d50.2
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 22:11:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795068699; cv=none;
        d=google.com; s=arc-20260327;
        b=c398wyiGrYA6CkZYJQjiJ1otIg+pxeqx2kPXksyzvbEPmmh3wb2zwrFjf2EJlrMT7Y
         vswopogJVZfPQA71AMuebwV4CFh/8UbgMmPvCbQghHK7xhkoWTyqdtoPvHze5S/7hhi0
         mywimZD4Dzk6sQCBHc/8UQPJtBY0rJDrNlyBYU/uACoZxApF8mN9anJybJoplXPipx8+
         6BC1XMEmgxt9ztRrXBZsPMDhRRjSqIdnuEDCcnTiW45bxP2eWVymReg2Q7xNVlpePMDK
         Xz83rxACUapspSmSwhXHn7Af9TCfUm+QNqH3njQ3Hv3L5eXE2FBencB6pLMN4bxRLJkE
         Lzww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+i7fLpQgbGWXsa4bKAmBMh9yPr9gG6NW6Mco48SKmuE=;
        fh=/NXrfDfNSgwsPthBjOzdVDeFiY/eMb+dOVbgHaVecA4=;
        b=Shm/QvFbnAp6PDnBtdJ5hNTx1H7TRvKAn+uk5Vj8gxUQwobaXxkZ/oFVWxU3jQvtX/
         0172cUSkP06m26/Ut3x/XkInQXnJDIPuMTorat+SSNi8nFYz7it212tCosQzL6zLZKff
         ioEkkLfOTbfuoW9cGxttE64y7WxBRXphDoof69ZkLYOeQwY6B89Y3Pk+BMLKr+jXG25h
         UYodtngo7MNghT+kdjaje3sxIKXM06EGFJN2Cog5+hSz7fU0fGicl0q/shGnyHRnmZk0
         6H9xsLuoNQcaZk1VR6aOCcSNsDARMb+vRYth6x/Uy7hhRR3WjXiqTET/gnrYEujjgpmv
         4JCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1795068699; x=1795673499; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+i7fLpQgbGWXsa4bKAmBMh9yPr9gG6NW6Mco48SKmuE=;
        b=U4mnEIRnOIJzuc0QmHuxU9tV3N4an/q6D1UgnsUgZemoxg1Q88SL1yGGAlc/jmxEMq
         7kFSMRpo4TnTvtl6trNPHFRR4ABXgRNScK+szwWRTISaA4ejH08dW+QLHc1umkXoEBGr
         uJs9+lwqVd9qAXrYVi92Pf9eiaHyX/40a6Odb0LtGWI6MqEu8q3Qy9PZkIO9nf8pOiYi
         CQcI84dqINbjZk7l1aN0pMYFSZQSBL69onhtNlz5LSOhG7D1NfVhISitmaw4SqlP+MMp
         fGqTQ9HuHZv5SCdk7+DSLFuok7GFgjD0TErBfWJMZe2odqBSiCJR23eUNB/6wAMBmRNJ
         mdoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795068699; x=1795673499;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+i7fLpQgbGWXsa4bKAmBMh9yPr9gG6NW6Mco48SKmuE=;
        b=boEWLBNIsHJ8vDN/orabwbTDVqdVch/jpIF4D7KyLs6V+WC7tjUAFltjeRwRh3IL1A
         UAtiO69PskGCg8vCq8sOt6IQItM6hwB9vGQwBqqOa6lHROw2V0d7n9KHoTYDXOfYGb1r
         3mVM8EmTWh8N9Wge54Kavfm8vnOQsn3XFBVlZz1Tv0/dExQKDFGr04ONHQ2Y7NGoXLoT
         TlQKlL+N18U6LZk3uboYGGC1N6NwXfTSUbfxz1ZK8v9lMkwuN7V4VzyYu/fRaLcrWhiV
         Vhk6GsYvlqob75H2fbSJI7KlktDACkKI89GCiZl6bNO4PFxty2eFUYJVP1jqvzqBx0WZ
         +1EQ==
X-Forwarded-Encrypted: i=1; AL+hErF0XLpxfN5stOmlyOwp9ifO60Ll6tP1DUwqbbbGKmm/kXck8nIShKUthWwnlRkmFD6xjuecjeq/cd8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/3/GxgTv6mu73o4dYA4tPTvDtoIt6TuNhlTlQc5u3ZhD6Q7Uui
	sY25IqweEuCFq1Ro+VMrv1dfocwalRai1vfAq//8d/9/Fzx5fix9+PnMNsV5ki+9BbWbwfeYF4o
	7TD8ImmNB27K6IeK5vxX9cRgYUgoW2OOr8eslVbqv7fYW31Xr6oCVUXY=
X-Gm-Gg: AZFdTZcCS6Br3wHEPaDWAk/XW0Q1NeH5H7YbwTK7ChjpXNf1ANKppUb4SDAxGqjme+v
	iZrWvPCX7bNB1rpB6QJg8ViVWWJ+YnDTpSVvWuAAtOft4PYbqAd9uoJmQh93rp9pn9LcD32rlmR
	UwPHiO4FMYN0l2S+koTtO8iFuyHK1BLxOe+KrZffjsEhUnxgQcilxRCj3yjYEUBeZkkH9C2LKqh
	fRYnzhWwmZNUl2cORlTD1vR/jXDtftzkkDChhCtgRJYwEoX5KJnsFqzoVnT9OpNzIWA2pQy83o8
	rQs3RT75mrHWn7Tb9HGgk5bBmd1VXUXslLtgqNJJIXruygc0q9hxgTP675Yk4bGbbbzKdEk5ZTp
	6txwn0apSw5aVIZozIDwlnEVoil5rRhc7S+zoI9YrGRDqA/1ew3x18bLIGOKzfH9oArezfZY3+z
	7BUqMDXaYe/j73X4cLA4nS/IVPVvTH3c8CICHyuXetkixXTjjFS2lxyYIqeYdEPdj+PaXiMhaSY
	JRWrdSvC3jjHhb92PpuV7jG5MDopv+pkoVBfjaqiTrmsAlMez2NSwU+wnMdl/Hyn7NZT+qpG3W2
	FX78JAHfuhqg4LX4U05PyEEjm47EjV/YDcI/OgPK7QMoeEb3LSQY/fThG9LRolvpJpr0pi7gJGI
	D9KPIYvffI0GpmvD5KUYp+bq7UukbqdltAap+uQcqzDMY1rmhKPcIbmyxmR0gwOPCcEdmFKbaOp
	/BuZXGvu16es94yAhYR+uQ4y8sfk3LFSAgA3dSTrFgYPoim+aKkrcBUCr1PziddGk/XTLT
X-Received: by 2002:a05:690e:158e:20b0:672:9f72:7c0b with SMTP id
 956f58d0204a3-67dd404ae39mr1379048d50.109.1795068699305; Wed, 18 Nov 2026
 22:11:39 -0800 (PST)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1788259938.git.jasmeet.bhatia.us@gmail.com>
 <a9e23066-aa75-44be-ac3b-9a15f4cf6047@app.fastmail.com> <DL6NCV1KQ9F9.6K6XZQCS4AF3@gmail.com>
 <c3ca811b-a6eb-4f4d-bbb2-4feef02e3db2@app.fastmail.com> <CAC_iWjL9jDsRaU7kEemYfwk292Nxa49cK0Rq=81pC=FWNRDhvg@mail.gmail.com>
 <b66f68b5220ddcadddb41340d3ea3388@gmail.com>
In-Reply-To: <b66f68b5220ddcadddb41340d3ea3388@gmail.com>
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Thu, 19 Nov 2026 08:11:03 +0200
X-Gm-Features: AclHuK89rr8JCP4LjUM9lxwdzxvtIWH4RA9tyZloAfhEcmTE7ZH1lrQpq4myxc8
Message-ID: <CAC_iWjJ1L5MYWy2vHG3AHYcfqx7urJmaTYP7vuyvZm8GSnWCDw@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] efi/tpm: Preserve event log without changing x86 E820
To: jasmeet.bhatia.us@gmail.com
Cc: ardb@kernel.org, rafael@kernel.org, pavel@ucw.cz, 
	linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Jasmeet,

On Wed, 18 Nov 2026 at 04:57, <jasmeet.bhatia.us@gmail.com> wrote:
>
> Hi Ard and Ilias,
>
> I wanted to follow up on this discussion after a couple of months.
> My bad at being slow, at keep this discussion moving.
>
> Has there been any more considerations with the preferred approach,
> regarding the EFI TPM event log reference and kexec?
>
> This issue is still relevant to Framework 16 owners and the temporary
> fix has been confirmed to work for other users despite not being a
> proper fix to this issue.
>
> I'm always happy to prepare and test any patches once we decide what
> direction we want to move forward towards!

Ard suggested we discard the EventLog on kexecs and I agree that in
its current state it doesn't offer much to security. Is there any
specific reason you want it to survive?

>
> I appreciate you time and patience!
>
> Thanks
>
> Jazz
>
> On Mon Sep 7, 2026 at 8:57 AM -07:00, Ilias Apalodimas wrote:
> > Hi Ard,
> >
> > On Fri, 4 Sept 2026 at 19:39, Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > >
> > >
> > > On Fri, 4 Sep 2026, at 17:45, Jasmeet (Jazz) Bhatia wrote:
> > > > On Thu Sep 3, 2026 at 7:18 AM PDT, Ard Biesheuvel wrote:
> > > >> Hi Jazz,
> > > >>
> > > >> On Tue, 1 Sep 2026, at 13:34, Jasmeet (Jazz) Bhatia wrote:
> > > >>> The EFI stub currently allocates the TPM event log as
> > > >>> EFI_ACPI_RECLAIM_MEMORY. On x86, this becomes an ACPI data entry
> > > >>> in the E820 map.
> > > >>>
> > > >>> On a Framework Laptop 16 (AMD Ryzen AI 300 Series), the EFI allocator
> > > >>> can place this allocation at different physical addresses across boots.
> > > >>> Since x86 hibernation validates architecture-specific data from
> > > >>> the firmware E820 map, this causes an otherwise valid hibernation image
> > > >>> to be rejected on resume with the following error:
> > > >>>
> > > >>>   Hibernate inconsistent memory map detected!
> > > >>>   PM: hibernation: Image mismatch: architecture specific data
> > > >>>
> > > >>> Allocating the event log as EFI_LOADER_DATA avoids changing the E820
> > > >>> map, but doing that alone would regress the kexec corruption issue fixed
> > > >>> by commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event
> > > >>> log to avoid corruption").
> > > >>>
> > > >>
> > > >> As I replied in the other thread, I am not convinced preserving the TPM
> > > >> event log across a kexec makes sense to begin with. This is the firmware's
> > > >> view of the state of the TPM PCRs when it handed over the system to the
> > > >> first OS.
> >
> > It doesn't make sense imho. The only thing you prove is that you
> > kexeced from a 'previous good OS', but without knowledge of what that
> > OS did before kexecing.
> >
> > > >>
> > > >> If the first OS boots, loads a kexec kernel and then boots it without
> > > >> measuring any of that into the TPM, the TPM event log will match the
> > > >> TPM state, but this is meaningless because of the missing measurements,
> > > >> and the attestation chain is broken.
> > > >>
> > > >> If the first OS does perform TPM measurements, it would need to record
> > > >> them into a log and pass that on to the kexec'ed in some implementation
> > > >> specific way - it cannot use the existing TPM event log for that.
> >
> > Hrmm, that might be problematic. The EventLog needs to illustrate the
> > state of the TPM PCRs. IOW replaying the EventLog in memory should
> > match the current TPM PCRs. But that also means we'll have to teach
> > kexec how to properly extend the PCRs and update the EventLog.
> >
> > > >>
> > > >> TL;DR perhaps we should just discard the TPM event log reference from
> > > >> the EFI config tables after consuming it. Or add a special case to the
> > > >> kexec code to disregard it.
> >
> > I can't decide what's best here. IIRC we don't expose the final event
> > log config table in systab right? So we won't break any user-space app
> > that depends on it.  We just copy it in
> > /sys/kernel/security/tpm0/binary_bios_measurements. In that case
> > getting rid of it would work.
> >
> > Cheers
> > /Ilias
> >
> > > > Ok, honestly that makes a lot of sense I see what you are saying and I
> > > > tend to agree. I'm treating the copied event log at something that
> > > > survives kexec in this patch because of the corruption fix so I'll look
> > > > at dropping that LINUX_EFI_TPM_EVENT_LOG_GUID reference and rewrite this
> > > > patch. Hopefully, that will avoid that x86 E820 instability as well.
> > > >
> > > > Appreciate the guidance!
> > >
> > > Please don't send any patches yet - I'd like to get some input from other
> > > folks as well.
> > >
>
