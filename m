Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D534AFE25
	for <linux-efi@vger.kernel.org>; Thu,  8 Oct 2026 14:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791470620; cv=none; b=P12tJKLu6bZGT/czwVuD1e5eGJDIUlSKFM+ZgaPBVhjeHZ71PMGFfzMcUHOMJwTr2OoMbMeR/VeZd3mXHgS760xqd9AnQ+yGBULgDYtqVSw5J+mesZA5uJ9A9u8YBHe8/XRtiktDWZJ3vyZPlUIRnefTAK5mUkMjQg1o1epyfIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791470620; c=relaxed/simple;
	bh=yde/+5LcQoOeRRuVFg6M0zfcbx+JRpuc+eBL1JOnXGg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=uLRLpJ0gsMaHtbMheLlOzcOq6+03+Jn7NzTIdmgEun53gqJgR2abGKkHSOtRdVlvAbI2LEZInvNggYeGzbcqOBzh3hkJ4e6BfFyv7weVyVglfGTBDma6cB+9OV/znw4hucqOCJ5/EhkEA+RjApBUZBQdoUAgh7kl3Cs5u3sU0u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aP1It7DP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aP1It7DP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7ED1F00893;
	Thu,  8 Oct 2026 14:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791470616;
	bh=7uOTQ1zSN0z7Rn1oQH6H1RzY+ERxySKobdm9Rl2nHfU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=aP1It7DPCrIMdFkdblgnMKDvFt7KLo1gQtO3du63W1C9VLGlJfI60IKWCVfM+E/Lb
	 6GFwqytavh4Kl57EHcZQ1mDXeCmyPYJuXS+x2pwFBGmJhX8CBgklWra8GFwLY0yDnP
	 VUjHYVEwx5mVBt/i7mkZqPu8/CLrNWc/xCx2+oNCzWub9m22WnZyhu6IRxXD0vgbs/
	 a68eZsLTlyJlBAnRdNAj5kvWMdqXHa0J2guDouIcWDiVk1SMcqyVGKlwcvCP0Mb3Z/
	 BVe0FH0274mebxwcZLAbh/aU6EpAs17MGHeYwy3TM5d3aJgeksUyXMyQyMd5PnIZrs
	 loQl00Xn/8pbw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id F00E1198003A;
	Thu,  8 Oct 2026 10:43:33 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 08 Oct 2026 10:43:33 -0400
X-ME-Sender: <xms:E6zHarU2u8vRSLjo8VAUSohrBwE9U3EBsC4RdR8buuSDAC8Ueb7alQ>
    <xme:E6zHaua8RzJIskHqMh0dfNFdIA345_M6dUUjASJO7FJyU739ne97ouM_Rh2u4Qu-x
    kthebfPSNQMVScOF_gD0p3ClaUiN8EE0mMK3kFALEjCI0bDUsbf7RM>
X-ME-Proxy-Cause: dmFkZTFLFdKRhLlrwTLld4Wy5+ue4G3ql742LJUzSxdwwyFPrUuXhuYXx1lwJPeWTickYH
    Tgv/MSlKKx6Td3p8bJv42iB4/T7U3vr3Trz7BwNIgpquWNijRyc23PKDK/qFoYIIj2gHwk
    t+LQ310KAqqtJTt8v8YqH8FPKmUuavezeULfNoLP7hIFXsiIk08mtpm14CGs23/9P31oxP
    V6iGIORVZ0TRkkY5nvgOQOvm52JfeAVU/w4szt5HvqUgvfGS6bM9pr7goD5IDia+VLYAmc
    PoXzIxjCPlIhYoT3y+SOkxZ+lwkTYWFGjDMOI/Wj3qrSOiaWu0E04B98xG+1LpMfCbpVAv
    wtzCrGkgg1C6vx8b5i95bsAM79pwvgW1RThVmddTf4HMRZuBFtRR2TeDp7lJ1OIK3Fmksm
    R1gsIXUGpyWQOgXqYsq4QnEJ1hvEmvMZ5KvPykRK6K5QnlWk87U+b+xu3HDpD4KV2+owAi
    0JgkqV/3kz+nkpOJercxkOAsziGL2cg7F5IRr2ygqMkiTYJW9n5K/wGHH++z796K82K6GF
    AOvUIUOhaHlOizyZObBe4uyf/3bcPQc8lw1QtV0n7DiiP/xk0qQdLAyrGEXDbtGz6yL9R2
    J2HijVcfCbKnqWwGCJsqLPMRI1Q+gz0atfEE8U8J/Ez0KhSds0cqn9bc6Duw
X-ME-Proxy: <xmx:FazHaq4iMK2edHhv9xCbhdzbexPdBVyTRyTKfVmH4gW1iZRhNiWdLg>
    <xmx:FazHaldVvQtgn-UHB0A9DZbvMxuJOIkaX5g_Rbx-6D1xqe9Q8INM5Q>
    <xmx:FazHaosWCH-96-sqVyADPPZ5vDl7Q__PpQOR-tbmE4J0WsdSbKXgIg>
    <xmx:FazHatlM1dcnPHi6PwjSaAX5COxKNGjw3ulIPy7S-Kpklaf1DX8i4g>
    <xmx:FazHajS8gViJBAb-_b8-7IXtTmBwzzew1Xm3_ccNenXJilkFDF28Dhie>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C0189F80096; Thu,  8 Oct 2026 10:43:31 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 08 Oct 2026 16:43:11 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kees Cook" <kees@kernel.org>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Nathan Chancellor" <nathan@kernel.org>, "Nicolas Schier" <nsc@kernel.org>,
 "Nick Desaulniers" <ndesaulniers@google.com>,
 "Bill Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 linux-efi@vger.kernel.org, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Message-Id: <31318d3b-1738-49d2-8017-d4ebf98aa22f@app.fastmail.com>
In-Reply-To: <20261006204210.i.137-kees@kernel.org>
References: <20261006204210.i.137-kees@kernel.org>
Subject: Re: [PATCH v1 0/3] efi/libstub: Build the x86 stub from KBUILD_CFLAGS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Tue, 6 Oct 2026, at 22:42, Kees Cook wrote:
> Hi!
>
> The x86 EFI stub builds from its own short list of compiler flags instead
> of KBUILD_CFLAGS, so options added kernel-wide reach it only when someone
> remembers to add them there too (e.g. for -fms-extensions). Swap it
> around to remove unwanted options instead, as we do for all the other
> architectures.
>
> This will let Clang's -fexperimental-late-parse-attributes reach the
> stub build so that __counted_by() will get parsed without error[1].
>
> Thanks!
>
> -Kees
>
> Link: https://lore.kernel.org/all/202610060642.7C4125F@keescook [1]
>
> Kees Cook (3):
>   efi/libstub: Declare the x86 stub's assembly entry points
>   efi/libstub: Build the x86 stub from KBUILD_CFLAGS
>   efi/libstub: Disable kernel stack erasing in the common flags
>

Thanks. I've queued this up but with a tweak applied to patch #1,
as it broke the GCC i386 build due to the fact that 'asmlinkage'
evaluates to __attribute__((regparm(0))), and apparently, GCC
still thinks that differs from a function without the attribute,
even when it is the default. (Clang built fine)

