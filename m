Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574565;
	b=4ZE3rJJswoH7GsAHSn13WZ3nN1OdoFpqy5tR8lRW5VEgaXqVBLSHME3wsY6zsCNhRnPE
	 Q55aSbQR0d1oX8CdOIvzPXX/WGhhrevwQJuOcx2O4MS+hEHNvXzE6DT5gBVPb8g6ZNDHk
	 F7WZPi/Cn5zEaEAkId+Ptr0AF/vgr9M5ZQYEXEfvpevqMHwPcM+4sKpJANGhR0ZuBQ23b
	 jmRtn6XKRY4L8QpxsQovVCBeeFE9/UoSATTa+WKUWzgELSG80B/X9AGSO6kTEGZ868PKQ
	 PHTIsKbdAzm4pkNPFhwx6yXVlxYZvI9yPO7rRQLR7RKI21v8mSTclNEQKEJNzB50qZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574565;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:X-ME-Received:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=4tSzNT5XSWSixiegslDJk3QLG0Zr8jciuO7mZR0zc5I=;
	b=Qvw3QcLC2KVifWAZUoqPgUBdfmR+ri1kfnxk5QYBjHgvoB6sEAMsxhrJOyHISeeqIH/k
	 nAYAwGXVsWUv/DfB5QWce/9QJ9mO7OpbisVxe9VSdJmp23pJc2xHwPFKFOdq0xqemsHS+
	 1yxfBL84YL+kpJSUFHSf25rJlFD6V7RxAmfBeK2s+OumbzSxfY1OrufVOYhvGxwrQvwHi
	 ialyJUHNbxveIOKd9OCNRCAREZXTCAELNNDya/mS9/CrOYiNQ0mio+evfZdk8/K7Dilne
	 ce2ghbjTgG5AGSXCDF13/iW5+nCt/hdX/PlUw25yKV6xxGzhFsSojtqwOMQ138tTaVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Id+sGUe0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A01A606A32D
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 12:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Id+sGUe0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36E91F000C6;
	Fri, 13 Nov 2026 12:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794574565;
	bh=4tSzNT5XSWSixiegslDJk3QLG0Zr8jciuO7mZR0zc5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Id+sGUe0QBD/OkZXjgc1hm2SvJNlJoPdPHq/1Wff8N3TX8R4uIqunp1wSNQAsyIqR
	 QS8SHYNss6MPlgSMKycZZQXF9UGCuIWC4stmNt493OzRn7zd6BEbWfd9hRlv78KihF
	 ivUmfGgoQ9pcZmkR1PprIozlWeZx0Lr8nQE0Zk50SyQmddpGCNuId8CqeU4t0jtPbG
	 g+eub36cc3YL5FkFoSA6OZcCZ2G+dRzrNRzP8Xn1zskdDiwb4FEE0wIT2o0bPYjf5H
	 q+X3cg+QTQfSw6ayAFYdIrGuFXeNQYormJNw/sm4iBGfVzvAVPA0CS2NB0vs3Ye2pe
	 HJ0SGBROq3TwQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id BD18B198003A;
	Fri, 13 Nov 2026 07:55:59 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 13 Nov 2026 07:56:02 -0500
X-ME-Sender: <xms:3wj3apbkmeonf4y5wE7ksEA3GtTBf57EWzkWE5neafKKC3LIBFU7qQ>
    <xme:3wj3at7H_CSaBiiK8MxPCWEXxuf8_32SjEpBm7p6t46otfyshxxW0DySGHZC2nRx6
    o3CnKqCMg3AcqUsOLjzzWxJ3gE-E_jODyZZW59-0WOiS1ywFfQoHSLq>
X-ME-Received: <xmr:3wj3aoCjT6qOBmsBWaEBbadIi4IKYX-_viGElTeJ1FBxXk8-jPLWXELZq88>
X-ME-Proxy-Cause: dmFkZTEALCY8BjEB9962J19+FFzaFn7/mDszJU/f0IQoJYE08F9eNi9AROuRlq7pU2+FXD
    zoNVXqKBs3ph2NtrQiIbObaLyrIngOHx7B+sdK6iQ+jfItZBvkvsFLopEHbvs6okBQgb5T
    T3FhlyqhoGdVKxR9UvwevmGemWC2pw9RXWPJmT/hEImGxMrfJhZLPtavP/c6QdWQg/A6b8
    X5O11D6kkCylwxWMIUDUmx1JRIy29fX8Rzvm50e/adyzuWb9S0hJRhcuwm+lPAtw8FuGn4
    rju8p9vVIWIvL96aJgoJcn0XKhXQzZ1uUAuAH7wCb597h85mktgUj4cIXuqKo5YXHCqSYw
    ObzBzC+xeGRFdSq8OK9Iw179SQq7JXdMgizRPjcfc7bMNY4T6epVxNLGOJxv3xUQSLR/64
    Zxw6vhBrfWdMRycJp9of5fwiEuNbYcgfNCpCp0cn3gxt62aAog+aWCJXFmQAiNZCZkWG9B
    lWC/3udG+aiOLf/DbuEx2ykJWJHQaSgwcHKmqXrBVIxChV1yPNGmyFR+DbWWQVtVmpRQwj
    NtZPNHIr8/CvIjr/tdwg11qigVVQJPIqaWNhPn6ysx/4QZa61YdCJv4sA2APKR+gfMKL8v
    obEc1lTb9YEpWYZIrpyfGF/TB6GjA8e8r0Isgz4pTIYFCflmX0V2H1dmabRA
X-ME-Proxy: <xmx:3wj3ak6FPmng3aMbspqR6Igf0D2sIbQk1-6WorKrbKKADDHG0AAPMQ>
    <xmx:3wj3anJXJB8Zybw1x9dD0vuFCyrMwqOETaiw83FKYEJZqKOlm8gtEA>
    <xmx:3wj3aoxiwa_YTR87D7tSQQJSTL7TiZczR50Ez5E-b68EkZsa0J6kjA>
    <xmx:3wj3anFPKaQGh8qkS1LHsQZRjpVPAb0cT7GRfwH9jf9WeNj9M__Iug>
    <xmx:3wj3aoklSg9r9EGOP_SJS-KycWDomPYN6vpd9TXmeUML4jPK2OXNFZsy>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Nov 2026 07:55:58 -0500 (EST)
Date: Fri, 13 Nov 2026 12:55:57 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, Pankaj.gupta.linux@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/unaccepted_memory: Do not accept ranges that are
 no longer E820 RAM
Message-ID: <avcIhKCXFo8Pn01U@thinkstation>
References: <20261113105554.199912-1-pankaj.gupta@amd.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113105554.199912-1-pankaj.gupta@amd.com>

On Fri, Nov 13, 2026 at 04:55:54AM -0600, Pankaj Gupta wrote:
> Accept only whole pages of E820 RAM, and clear the bitmap bits only for the
> units in which memory was accepted.

A bit in the bitmap covers the whole unit. If the hole doesn't start and
end on a unit boundary, the unit at its edge is only partly accepted, but
its bit gets cleared. The rest of the unit stays unaccepted and nothing
records it.

This kernel never touches the hole, but the next one can. memmap= and mem=
only edit e820_table. kexec_file_load() hands the next kernel
e820_table_kexec, which is copied before the command line is parsed and
still has the hole as RAM. The next kernel finds RAM with a clear bit and
uses it. memmap=1M$0x1fff00000, then kexec into a kernel without it.

On TDX this is new. tdx_accept_memory() works on physical addresses, so
today the hole is accepted together with the rest of the unit and the
bitmap stays correct. Only SNP needs the direct mapping.

A unit cannot be half accepted. Given that, should we go with what Ard
suggested and refuse memmap= holes in unaccepted memory instead?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
