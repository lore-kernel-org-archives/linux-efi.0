Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794529377;
	b=cJ8Q7HCuiG/O5ESY9NLMipq4UeLt8X4MR4fxJi+xWutLuY1KawwoEt8bQQyxXKzlXaH1
	 pr5bGOepE2GMWbUEUecjrAuSH1frupMs69Kl8Ty0Ms2cENq48AUI9E/xeASwGY4gn7xmA
	 dnoPKMdTpPcSRYQtWwbTt3CzETFRE8edA3GODPK1gUWEktQks/2dzh13V1DECpUc2NSWE
	 GYJJob6S5VROjFm7NXLRhH7OGkIEPg/iUJaIrc0qLNMNtlAg44ySWGuVfmhWRy7VDGnwP
	 9z7RFgaR9h4qAoc+LwtZTBCF7p5cbImqXB2E4xltHi403xdsLu9cRzEIJIF+QdphqeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794529377;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9FK97fhuGKTMRboFLPBAjOwcVQv8QY3oYEV2n0PdB/c=;
	b=Ycq6Ou0lVOpwYf8GWleY+rl3MFRA2VMNbSXO1q4kplB8RuoEmLR9cM4dMbL3vPXVMXju
	 3DOxa6MH3OPeXo8yS0vy5CwLSkMkWYYt3lV0nArqj90iv4jb4BNbDFK+R65QPO1A5jGZV
	 EL+YdOSUiJMz+seatvhMYPhEPy7Wc3ACSwaTKuk9nZteLYLI7g1SW6x3pCPvo38DE2glI
	 pcVSJ0UOR1T7L5JQ0h38Svacok0fXLKZJZe5glCsZL8D6pQ0YBhqcuPFyab/woagYRIFH
	 h0MbXOUBJ+6XqVGesRiiWS2/ft7ty5kElb+zARpy7nhr+lwBwFjZdZxdme92OknHMBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IbjI3liT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDF0606A327
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 00:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IbjI3liT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4399A1F000C4;
	Fri, 13 Nov 2026 00:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794529377;
	bh=9FK97fhuGKTMRboFLPBAjOwcVQv8QY3oYEV2n0PdB/c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IbjI3liTInOWkeyVU4xSHMr0qnLVasjtoEu4EsI8OBt6J7sxNSkAmrtnCzcbm6gU0
	 nnY4TvaRNEwONPdEhTTzs9oyo0JBmjipDDYfcUQdqEyKszrQY27zvCBAcxdNTlQbLv
	 80Q7Ttl26x3AIfy1NVPizueLWmTyaTWSzonZXkznfNS2yWNo7OQUxK/lzDra3uUsDD
	 3i10G5Xifk8UBA5Yd7M3v7RCjaK+Q7USReOsfIl7GZX7Ehy3SL3/quOw6cgIgFZAqi
	 2SWxU6EN3f1iAzoN+jpWqvMypl1sQZfs+6ERVlZyhMS8rp662EglX2wKhJwOsGY1rL
	 PaTG1jIs96E+g==
Message-ID: <sashiko-outbox-211988@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/10] x86: fix duplicate extern declarations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Safocl Stollmannovic" <safocl88@gmail.com>, "Ard Biesheuvel" <ardb@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org, "H.
 Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Pavel
 Machek" <pavel@kernel.org>, "Richard Weinberger" <richard@nod.at>, "Anton
 Ivanov" <anton.ivanov@cambridgegreys.com>, "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-efi@vger.kernel.org
In-Reply-To: <20261113001432.128201-8-safocl88@gmail.com>
References: <20261113001432.128201-1-safocl88@gmail.com>
 <20261113001432.128201-8-safocl88@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 00:22:55 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] x86: commit message corrupted by shell expansion and inaccurate
  for .c files
--

commit ef771365acc78fbcdae41e8e72ef9a5cfb5a3f35
Author: Safocl Stollmannovic <safocl88@gmail.com>

> x86: fix duplicate extern declarations
>
> Compiling a kernel module with a C++ compiler results in a duplicate
> echo =E2=80=98extern=E2=80=99 specifier error.
> This occurs because the code contains , and
> expands to  when processed by a C++ compiler.
> The  specifier must be removed.
> https://bugzilla.kernel.org/show_bug.cgi?id=3D222257
>
> Signed-off-by: Safocl Stollmannovic <safocl88@gmail.com>

[Severity: Low]
Was the commit message corrupted by unescaped shell command substitution?
The terms "extern asmlinkage", "asmlinkage", "extern \"C\"", and "extern"
are missing from the sentences, and a stray "echo" appears on the second
line.

Also, is the C++ module rationale accurate here?  The kernel does not
support compiling modules or internal headers with a C++ compiler, and
arch/x86/um/sys_call_table_32.c and arch/x86/um/sys_call_table_64.c are C
translation units rather than headers included by modules.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113001432.1282=
01-1-safocl88@gmail.com?part=3D7
