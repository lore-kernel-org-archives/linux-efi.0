Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF7A3AC0CE
	for <linux-efi@vger.kernel.org>; Mon,  7 Sep 2026 15:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788796692; cv=pass; b=GpfaibbYJ/XKLJNSJGPM+KEZWtea9voBVCse25LxRtYxTvik/uPl2DIrySzQIFzE/Ufa0U0nEuBWN2EbYObYcWgQTDXRd0vkMooboSa6VdzmRap6u4tB+b1SXCaUcTp/CjKo2FeY7L5NTbVWEuDnZNSpLBH5lfVA6WIOpzcOiE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788796692; c=relaxed/simple;
	bh=Rs8D6euDZzTcW61TMY/tcjJU4GeLI7rZpkYbKx565Qo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P1ovnPDTn/GLYNQQgG1AglhK7uL+zP51NvedPTW3ECCmJsjdap1isjqHcFXEC1ryVWNLjxpejp3ZcGcp7/fqOaa29XcrSu770STJYfGl1lJE9canjmMUx1L6tfdE6sDLUYrF1hywJ/+qn07wDh4JFV2D06Hk8dbPMQJozq4yOnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BE7wg4P6; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BE7wg4P6"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8726acc5eadso24346557b3.0
        for <linux-efi@vger.kernel.org>; Mon, 07 Sep 2026 08:58:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788796689; cv=none;
        d=google.com; s=arc-20260327;
        b=rXPzPfO/qs/AjemllF1GMCLFWt3twy4JhPij7PdIRceOA5CARqRAliqk2rYM903lVA
         tTzzuXllUEtT9qSKAmtiP/Owf0aQhNfkfVEBKOmYN0wFfqaXxr9A/8TaX6hwRu9nmG8s
         1PcElc46Sg3C5bF2hKqYYmVNHnIi1j7iAd4E8HG40g6ybhj5PfrHszm5kCouaQ3vLwSs
         lOLMKxh2E6K5lBqOoAr6aW1kUUvxYOcdyYXRPCP58qvF6NupCjcpN9Y2SZ0UUSw8H64q
         Zq/Ju4a5VZCfTw//6LpJhYspLedwe+fcEPYvW+pnMU74bLmxbiFL7DmznYVMaw4lIPeb
         ZeGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=nopJoLIJVNXWQLeDX2Hcvbg342jeNYWKWWtajWtfO0w=;
        fh=e2T4PPSDbA6XS8wKsJLb3aUsN3ABdZrwmBtWLcruDdI=;
        b=TLKeEXQYqaD2w0s8H/T39Dwdqj92RzI3s3BfBi3DGrbB9KUeXnZXzqbie4lBTY7YSV
         uH8HWUxCT2hOePglklAxqtsyO5PUkAYVVhOLGfdmtG4LwcR6dmx3OEj1tYngfgyRfgup
         61XHqE88nde2j3lbo4v8k2EN22dvU7wZSA/ii2a6jD/RlKgblRTld13/QxX+iUbqdCOw
         8HPRaWkDCZariaL/xitoKL+y3fNMamWg76BLzMBX/W7WmYV8mMlErm9FxYMDiplbvcRQ
         nVQ25sMeXzRznBsre7zzK1/dCPX0UzpvVDogX4P5Ru5EUjSGi/lzMJsQS/ypUVAmdg8E
         qx9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1788796689; x=1789401489; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nopJoLIJVNXWQLeDX2Hcvbg342jeNYWKWWtajWtfO0w=;
        b=BE7wg4P61rtRrpCjhDri5gKeyy1+PPBfaD/r5HnTWSDgOOk0DN4wYIoUD5kKYJ/hk4
         Xfi5FP4m4hZ2AYI951XlqruwSGLAGanWCzEA2J3mGutidrhKUh4SQNqybOY667ZbepVh
         sv9RaVlDLBm1mu/M6lfoEl0Uo41D97cqSGkPkrBo7ynSK20jcFT9W1cmvjy/57UzdKmM
         thAlOiEBseHUUcH35thUKacDDqv102mZUvOajUbx/K4H2UM3JFgRHGETOaXU43mbLONV
         2g5Li4Rb8bqwGK+lrmfio6QbJeZP6I8RYBT7KFYztAMgE7q/MOpvtmOUtrDjWezSDXUz
         Ue0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788796689; x=1789401489;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nopJoLIJVNXWQLeDX2Hcvbg342jeNYWKWWtajWtfO0w=;
        b=WU2m94/yBhsxJsWgKQWPQpXjBuSYH6y4DJuTqx0a7hT82YQ/hcy075Iq1BDHoO/6Ou
         GXC2FQRszNuTaw3OyS0vhCE66X4WzYnEVIkoV6aPUozeImjSV37qvju+rh6ZtEgwUwvW
         6gkYkO7AP8KWUrZ7ozGdyIzL1QxrYEDuGqG/tsHkl8JTigwxfk1R+UZ8KDqnNQOZpmr/
         sTLhrXsG4qjRxqwiOVo5ozRy7w/ua/6SyDOnKXKWejWfO95zNEy008gTsc+2/Qx7BDtF
         ffPEuMXhmYPaImmIl5c1evtXVYAeVETW+vfgAzIUdNkCbinXic0cvasF2GHQNCiVNgCq
         B53Q==
X-Forwarded-Encrypted: i=1; AKwUvBzCUPpF8DlJxT8+6ILdhGqLReYY7va26j/X/TQGbtHbpUbSJ+ga3qmRQESleS/2CmqTuwYVxSLLnF0=@vger.kernel.org
X-Gm-Message-State: AFuF++mnpbsGWVJGTZcCjxitePzopqw2EX4nFDe55L2PBFbW5TbZ3rld
	xN3PjXsCCvuvK3JIkSt9lXSXgVEvPdBM69oyhNWNxiGv1Q4IuZwD6KG/QmPQFDZ1S4DUI1qAoG4
	PjFewACL8w8ponvaH1D9mV2nQDyp9AtntbRimfxJKQIfYfOFZuTQ8azy7+Q==
X-Gm-Gg: AYBFou2UzpTs5hY8cNMmK6vsROCu5jcOuAbwFxz+WKfPMRwLjrM6id5CpEWlZIqhgHL
	A3uZzDI8m0gkFPjb6dDNlUcISVw+UAcBrWo/ad3SBIRO1qrZ0Q6u/+dL/QbfrmzdQotUz56Qkfd
	9fugFw6PnM8cxKmBixkhPpfi7iFFLgyLhQOdUeWSIASaK3ZpMc9yFAyGajR22gg2eosblDd4ZZU
	n+R9QYJ9Vh77TOCw7uhnBzGQOSyUQ79ojdt3waUdPdpl7x+DlwvxuIEczHd+SogkLhuybaD6bW5
	VxDMpVrvkrsxYm8slF6+ComKKgXsHLzrRCrLKbLmOZCXstXsHb06DFzSCjg2kPK7N99Q+kcSG9M
	DFlxvM5Af4i3ehFkFfStM8NBviMNDavc5B2eq8HH3/wdpfJqQ1v1IbsEaQFVA+0tgV2bMPsEEOy
	rUFERxPzY3z0okS2KQ2d2kfTIvbbqlKY/qpoSQbVCTBSjpnB70Cy1NhpjKEVkJy3cOQMzQZc3FM
	gI5AX3YYdXARDhzOwStqNE2p50E8VkB8Fh9/Kl/5oJ+Wo0RqFxdBFrBJUae/3J+EyBrOGdYy54v
	M0OnHyuk/+rWS4ZtbZp42KP4LvGl2blW5NcUDpman8voDrsaCs8nRn74awl+HF2lw1Mf6jh94r1
	ffLSRBAUdJXZk1GmrNSPA/vd+jMEwLYB6lf52RGSIVCM=
X-Received: by 2002:a05:690c:f06:b0:81f:e7c5:f420 with SMTP id
 00721157ae682-87128eb5216mr102573537b3.20.1788796689408; Mon, 07 Sep 2026
 08:58:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1788259938.git.jasmeet.bhatia.us@gmail.com>
 <a9e23066-aa75-44be-ac3b-9a15f4cf6047@app.fastmail.com> <DL6NCV1KQ9F9.6K6XZQCS4AF3@gmail.com>
 <c3ca811b-a6eb-4f4d-bbb2-4feef02e3db2@app.fastmail.com>
In-Reply-To: <c3ca811b-a6eb-4f4d-bbb2-4feef02e3db2@app.fastmail.com>
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Mon, 7 Sep 2026 18:57:33 +0300
X-Gm-Features: AcwNN1X5lVzY-VVghdr231z6GdYRJyb_3-BGRdPWok47tN8y6tOFHleN_U7rMRw
Message-ID: <CAC_iWjL9jDsRaU7kEemYfwk292Nxa49cK0Rq=81pC=FWNRDhvg@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] efi/tpm: Preserve event log without changing x86 E820
To: Ard Biesheuvel <ardb@kernel.org>
Cc: "Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Pavel Machek <pavel@ucw.cz>, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, 
	x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ard,

On Fri, 4 Sept 2026 at 19:39, Ard Biesheuvel <ardb@kernel.org> wrote:
>
>
>
> On Fri, 4 Sep 2026, at 17:45, Jasmeet (Jazz) Bhatia wrote:
> > On Thu Sep 3, 2026 at 7:18 AM PDT, Ard Biesheuvel wrote:
> >> Hi Jazz,
> >>
> >> On Tue, 1 Sep 2026, at 13:34, Jasmeet (Jazz) Bhatia wrote:
> >>> The EFI stub currently allocates the TPM event log as
> >>> EFI_ACPI_RECLAIM_MEMORY. On x86, this becomes an ACPI data entry
> >>> in the E820 map.
> >>>
> >>> On a Framework Laptop 16 (AMD Ryzen AI 300 Series), the EFI allocator
> >>> can place this allocation at different physical addresses across boots.
> >>> Since x86 hibernation validates architecture-specific data from
> >>> the firmware E820 map, this causes an otherwise valid hibernation image
> >>> to be rejected on resume with the following error:
> >>>
> >>>   Hibernate inconsistent memory map detected!
> >>>   PM: hibernation: Image mismatch: architecture specific data
> >>>
> >>> Allocating the event log as EFI_LOADER_DATA avoids changing the E820
> >>> map, but doing that alone would regress the kexec corruption issue fixed
> >>> by commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event
> >>> log to avoid corruption").
> >>>
> >>
> >> As I replied in the other thread, I am not convinced preserving the TPM
> >> event log across a kexec makes sense to begin with. This is the firmware's
> >> view of the state of the TPM PCRs when it handed over the system to the
> >> first OS.

It doesn't make sense imho. The only thing you prove is that you
kexeced from a 'previous good OS', but without knowledge of what that
OS did before kexecing.

> >>
> >> If the first OS boots, loads a kexec kernel and then boots it without
> >> measuring any of that into the TPM, the TPM event log will match the
> >> TPM state, but this is meaningless because of the missing measurements,
> >> and the attestation chain is broken.
> >>
> >> If the first OS does perform TPM measurements, it would need to record
> >> them into a log and pass that on to the kexec'ed in some implementation
> >> specific way - it cannot use the existing TPM event log for that.

Hrmm, that might be problematic. The EventLog needs to illustrate the
state of the TPM PCRs. IOW replaying the EventLog in memory should
match the current TPM PCRs. But that also means we'll have to teach
kexec how to properly extend the PCRs and update the EventLog.

> >>
> >> TL;DR perhaps we should just discard the TPM event log reference from
> >> the EFI config tables after consuming it. Or add a special case to the
> >> kexec code to disregard it.

I can't decide what's best here. IIRC we don't expose the final event
log config table in systab right? So we won't break any user-space app
that depends on it.  We just copy it in
/sys/kernel/security/tpm0/binary_bios_measurements. In that case
getting rid of it would work.

Cheers
/Ilias

> > Ok, honestly that makes a lot of sense I see what you are saying and I
> > tend to agree. I'm treating the copied event log at something that
> > survives kexec in this patch because of the corruption fix so I'll look
> > at dropping that LINUX_EFI_TPM_EVENT_LOG_GUID reference and rewrite this
> > patch. Hopefully, that will avoid that x86 E820 instability as well.
> >
> > Appreciate the guidance!
>
> Please don't send any patches yet - I'd like to get some input from other
> folks as well.
>
