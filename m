Received: from forward500a.mail.yandex.net (forward500a.mail.yandex.net [178.154.239.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5856D39A804;
	Mon, 27 Apr 2026 08:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777277840; cv=none; b=Zo1xQLjEzhBgjI+HO1UW5FTDOQ+jzbQVC9/zmBiwre86BcWq2A21kPBLOG6vl8r7YPUMCT0q2kQKJBZCa114nd+z7I6m9r1XnE76aECDblillwiXzY+K6WtETVW8V01jYGdRamPti+S/gF95CX3g3zNY35N9o7CdLIn/dd4VqKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777277840; c=relaxed/simple;
	bh=bguIh7S91p2DCDtxXX7BhTfTOrelXjmYTi2yJflThDg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OgTnWKFSKSBd+w88b2iAq8L8tuMG+omSXkV6KOA1Az2wd5sODTMdApaQfhkVjNguQl1DqE3X5wJPnK9LaJsntQRSVyZy6pBkfdQh3gypPyajZ5ysl+DdVaTNPXbBB6YhHLqrJ1NRMU++5y169LFPIzOYnJJR6qVf+W32Wj5jKg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=kx74GM6m; arc=none smtp.client-ip=178.154.239.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="kx74GM6m"
Received: from mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net [IPv6:2a02:6b8:c18:31e:0:640:f144:0])
	by forward500a.mail.yandex.net (Yandex) with ESMTPS id 81879C0AC0;
	Mon, 27 Apr 2026 11:13:24 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net (smtp) with ESMTPSA id KDTCRrjSvuQ0-3CY91MG5;
	Mon, 27 Apr 2026 11:13:23 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1777277603; bh=bguIh7S91p2DCDtxXX7BhTfTOrelXjmYTi2yJflThDg=;
	h=References:Date:In-Reply-To:Cc:To:From:Subject:Message-ID;
	b=kx74GM6mfiZoHCwDnVaCKFWQ3Loq9lMSRWEtNL9JgTJeoy5v1unbGsiybMz5o70Qq
	 Rh+fvprK3YW7PKcd9vtVX/koi173Jb0B8M95qwj7+2YVdKqlYU2NDSRAt4qIwA8TQz
	 67tlQ+eHioA0ELqVSI+ZzAgV0hN74yEs2T/o5xGE=
Authentication-Results: mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <df673a44d292bb3df498b78a8b637f880e28931f.camel@yandex.ru>
Subject: Re: [PATCH v6 0/3] riscv32 library enhancements and build fixes
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Andy Shevchenko
 <andriy.shevchenko@intel.com>, Charlie Jenkins	
 <thecharlesjenkins@gmail.com>, Alexandre Ghiti <alex@ghiti.fr>, Ard
 Biesheuvel	 <ardb@kernel.org>, linux-riscv@lists.infradead.org,
 linux-efi@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Mon, 27 Apr 2026 11:13:20 +0300
In-Reply-To: <20260425143631.e20246946f59925c5eb8dc22@linux-foundation.org>
References: <20260425185151.477442-1-dmantipov@yandex.ru>
	 <20260425143631.e20246946f59925c5eb8dc22@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-04-25 at 14:36 -0700, Andrew Morton wrote:

> I didn't upstream "lib and lib/cmdline enhancements v9" this cycle.

You don't have to upstream v9. Because v9 is v8 + initial RISC-V build
fix, which is a part of another series (this one) now. The proper sequence
is v8 + this series.

> So can we please sort through these things (and the AI review) before
> adding more?

Not sure about AI but hopefully human should realize that I'm not an
expert in m68k/sparc32/xtensa/csky/[your favorite arch here]. Enabling
and running the test on _all_ architectures where it is expected to=20
work requires obtaining (or even building by myself) a cross-compiler,
setting up the kernel and QEMU, etc. I've spent a reasonable time with
RISC-V and ARM and hopefully set up a good starting point for=20
m68k/sparc32/xtensa/csky/[your favorite arch here] maintainers, who are
free to incorporate the test into their target architecture.

I'm going to fix everything I consider reasonable, submit v7 and give up -
because without even a single reply from core RISC-V maintainers, this
just turns into an endless brain masturbation.

Dmitry
