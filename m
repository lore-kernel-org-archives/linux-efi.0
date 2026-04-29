Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317982E7BD3
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 07:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777447954; cv=none; b=Q/KTcvocsh/uOsDp5igubMYytzrWosv9nTkJiJwxLw+rK67lOgZMFL6MS3J/yFeF8dCiF1MldUXTIBBeS8D8KC8b5QUZ7DIhThHKGV2a1c55KRXF1oNcxZTEFbUhqMcy80sImo7IOggR2BuSVsnqK53rXi8bX31NS/ByeAr4bRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777447954; c=relaxed/simple;
	bh=cWQcWwhik7lek2Yw0FUs7I8TtELtGOIMSoywqoUicnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O3KM2BKOl3Cgt/buRS5iF273wvVJOKoCs9/BC3oRBaJSvkr/cyv44IhE+ckV/Da7X44cwdhIBNYo1IrYl7TG/3iHSBdKkTaCONyqXjOCtrishyl+qGAIakhUraxIytgC3rsjOeQGS4QgzAVVl4BRPfhud657zrk+G4cTsPFHTp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqejpYC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqejpYC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC03EC2BCC7
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 07:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777447953;
	bh=cWQcWwhik7lek2Yw0FUs7I8TtELtGOIMSoywqoUicnY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lqejpYC2Sk4ySZqAFwE83qU0Wp3BmHZsG3T1Js6ClupTjH0xF4i6ICog4GgWzuJ4J
	 lqsAkXdiJg1+DkNI+5QPg5AhgFBHxjqh/l0C9nmgJXPWaNV4qkOMdH2iTqeTlQJMSs
	 3QYxG/v6lyGsZmsApFKZlmV3Wfu2VGX8/LWBsz6EG00gLdjvpVhJYOF6cXsjMKofPn
	 URJQPpHSz/B7MaqLQaktYTNK2mUOENf9xvfdv/yTZL1830ONfBBvG6BMUrXHCBTVOL
	 +5M8QFUPjvccOF2ryzwYLWMkyGSQ60ZQgzj8IFYhLyW2ZneH3f7d2nbmnzbVpP/RN5
	 8Y3G8CxGfgsGQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bb962ce4dcfso80139766b.1
        for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 00:32:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8oJ4om5lJhlxiYeoE0PxXH3mvhIquW/bNEGQPm+LlANeBySBs3F42KW0Sf3m/X2VI3+fFXod/9Png=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRMDkP0zLmZNjdV9QfDXEM1fOlQpM+RsD0qd4aGFA3V/17WEdZ
	EPNy6THaLMSUdktYT7msH8o3EepH3rW4NBxB4xPozrY4ZTKkRbooskLxmcx+lIV0g/yBAZPUF5q
	y+Sotu4KsLwWEwB23uBqXhSCPM0O98z0=
X-Received: by 2002:a17:906:6a1e:b0:ba5:a3a0:4a3f with SMTP id
 a640c23a62f3a-bb804a29530mr426323666b.35.1777447952371; Wed, 29 Apr 2026
 00:32:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427084721.40535-1-r@hev.cc> <d7197b01-9b7e-4f0a-bcd2-9d6d894e8cd9@app.fastmail.com>
 <e631d1e5-3f05-42ab-885d-4bd660612d63@app.fastmail.com>
In-Reply-To: <e631d1e5-3f05-42ab-885d-4bd660612d63@app.fastmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 29 Apr 2026 15:32:19 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5w=UmtZt_JCR=BvZt-+F9usnmjh2dMBLHzeiE-7xBddQ@mail.gmail.com>
X-Gm-Features: AVHnY4LI_z65v5Ok2OKBZ-AfV9iDHSzl64zVNLt4Gg71gQxkrxPNW2EQDJ6AKds
Message-ID: <CAAhV-H5w=UmtZt_JCR=BvZt-+F9usnmjh2dMBLHzeiE-7xBddQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v2 0/2] efi/libstub: Ensure instruction cache
 coherency after kernel relocation
To: Ard Biesheuvel <ardb@kernel.org>
Cc: WANG Rui <r@hev.cc>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	WANG Xuerui <kernel@xen0n.name>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 28, 2026 at 7:07=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> wr=
ote:
>
>
>
> On Mon, 27 Apr 2026, at 18:11, Ard Biesheuvel wrote:
> > On Mon, 27 Apr 2026, at 10:47, WANG Rui wrote:
> >> Changes since [v1]:
> >>   * Move efi_cache_sync_image() after check_platform_features(), match=
ing arm64.
> >>   * Add "()" after function name in the subject.
> >>
> >> The EFI stub relocates the kernel image by copying it to a new memory
> >> location using memcpy(). On architectures where the instruction and da=
ta
> >> caches are not automatically coherent, the copied instructions may not=
 be
> >> visible to the instruction fetch unit without explicit cache maintenan=
ce.
> >>
> >> This series adds the missing call to efi_cache_sync_image() in the gen=
eric
> >> relocation path, and provides a LoongArch implementation using the iba=
r
> >> instruction to ensure instruction fetches observe the updated contents=
.
> >>
> >> [v1]: https://lore.kernel.org/loongarch/20260427034451.717817-1-r@hev.=
cc
> >>
> >> WANG Rui (2):
> >>   efi/loongarch: Implement efi_cache_sync_image
> >>   efi/libstub: Synchronize instruction cache after kernel relocation
> >>
> >
> > Queued up in efi/urgent - thanks.
Maybe this series should cc stable?

Huacai

> >
>
> This breaks the ARM build.
>
> Since LoongArch is the only remaining user of efi_relocate_kernel(), I'll=
 move it into drivers/firmware/efi/libstub/loongarch-stub.c first, and fix =
up these patches accordingly afterwards (no need to resend anything)
>
