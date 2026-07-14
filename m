Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5C22820A9
	for <linux-efi@vger.kernel.org>; Tue, 14 Jul 2026 06:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784011829; cv=none; b=J8HLpadPmqIyfJ8reQHctUo3pXnryA1+uYhfqs314RDT/MDMPoXcgEhelI7iAR0b2q7eMEYh7YvVyvd0DSFmFqJZbPzNexhklB9oqNlHhM5PPEtv8X1IDUkfSm+abWlb6ELnrsmGYS2bieMeMJoFdQTgJ5qwx1wcveltHpmaGpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784011829; c=relaxed/simple;
	bh=ODOeTv8ifn+Ve4jLum4I+HGltlQdGF5cVx3pYzEmfOU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Szaf/YIVbFesJYaBb6b16vTYHoWV8bpIf7NKLmI4YyR51Zx68kP+wTkNhslsEdON6AkWfXx+bgs0idgyjZzTPd5FKPb8CMNbAWYYozZwSzxccl5QFKd7a9PGxHS0riBHraXvxXKorwiviUHz3sN9hAOZVBFCITNjWeknteRUVY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUt8Ebo1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUt8Ebo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40411F00A3A;
	Tue, 14 Jul 2026 06:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784011828;
	bh=JyAG678m+YwrtXtYdyzcpVEG0hMDNAJwePvuO9g/pQU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=mUt8Ebo13o4Isf0YxclhuzLnzBZH3nQDM/w9NdYPCqONslc8pwjFf6lD7J1e+QWSn
	 Rx5iASNUWKqUCrwGSO7EMTd8RXvpOB3qThXJL78PsojS78H1kkjHlZr91PPzUMemSM
	 Uv/FmAWj0tvFelL/n2Qmzujq56pCikJqS6NRRYod/bi8maei8B2V9laynJVLAASois
	 8xpkDd3eFzkQKnvLRd057q9NnaGSQkbEL3aJPLwUVbW0POWQy8WbN5ACJw1WwX50Wu
	 igNiHCEzz4u4Zlw3ysvxWOGzw2NRqzVrjLjGCNiIbXeC9myKQ6KvuPNapMckCinRq8
	 mlba8Q/0AL0Hg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 06A96F40095;
	Tue, 14 Jul 2026 02:50:27 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Tue, 14 Jul 2026 02:50:27 -0400
X-ME-Sender: <xms:MtxVamqDxfTTohf5CW4Gjc07g4pK5JAcGbhGPX5aO4B8SZbMZqywqA>
    <xme:MtxVavcDcZm4OH2WrxlvOLEbe0CgaWQi3I5YP4gQlL-UgqabUrINvF9tclMejWSJM
    rtSnPJO2lIqBDzdbGcR-s2ncoy7lkLXX2Dq6nv93kLFgDG99f06NgY>
X-ME-Proxy-Cause: dmFkZTFg8O4rJgoKhbzwEk3E0lidUeLXlejQ9N1lpZLysgTIadVkPzBRe1X3bAkqODe8pn
    3/FbHWbdz3I6wSCLx5lCdo7AWiGLVNA2YO6WlKysjFSioO2ebX5s8u6CxCSao2oCIpKV2l
    OmsV9HaDagobofupelbJSgqmE9ZoSJ4TIRBmaQIVBrZdBPBKMOyPTdFPF4hHHR9kE3UsqO
    m7LyRmoUaco7kmVKS2dLQR89/MpLfCT5nob1f8lf0p4Zcetv/QmzEz3Kvbcx/Usqsgyl3r
    cSeNKp3S+Diyd6G1cvh4wfSPWnR5UejdezKz/Fxq3sbswFCSI9+Njf9FBvEuNS9QEPSmbX
    qMgz5VvxPRhN20ej5hpYxqODYpLRryhXlfdkA8QwTtxTom5qFvn7xJIoVxCtwWOlHTg92C
    p6/jU3AFcXCRQmCJprbrzzKZ5g6sZfKpsb7hkDunopDA8P6BxlCw7i8fFYkUmag4qIOks8
    aGB/Ivby+cLyMeBMftEgnACqmncQnCUrrRuAB86byNWAiAhzge6YlZAjy/2xk0U9Exy9/l
    M9zQjubvoxXjVBTZryk5H2BidXH6EqNFhGxhQzMicc16rNeO+0G0qfuxQqUZvG3/iZT/OW
    ToECsJQypb27Q3vBVLYdUPFk4vA2iQMunA5/7rroTes14fiTe3Z/QOlV6eIw
X-ME-Proxy: <xmx:MtxVarW1Ie1rnJmwkIkybTJleYF0CL2hdaJhRLgaDXF3bA41VIOh3Q>
    <xmx:MtxValL4fYIyLdlLsCHi9lzMKDEo0eUKKZ3nlnBf6i-xNpDufb4a5w>
    <xmx:MtxVattNIDz-chNraUUBpx9GVPUc0DvqTzHZgIaEQckcUHkyeHeucg>
    <xmx:MtxVaiIhPsOcMlvqbTL8O42Wh2fy-LzWwEpB9fB0garpKpkpDmJdUg>
    <xmx:M9xVatOoBSubfs27RjDORz0CfTy8nM2c-ZJvEbWFzuJ2zc-Q7Y4sTpEt>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D86511820082; Tue, 14 Jul 2026 02:50:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Ah8xpA7k9IQZ
Date: Tue, 14 Jul 2026 09:50:05 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Breno Leitao" <leitao@debian.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, "kernel test robot" <lkp@intel.com>
Message-Id: <a0e0c0af-61b5-4198-95a9-98f79d772946@app.fastmail.com>
In-Reply-To: <20260713-efi_fixes-v1-0-cdde378d9df9@debian.org>
References: <20260713-efi_fixes-v1-0-cdde378d9df9@debian.org>
Subject: Re: [PATCH 0/2] efi/runtime-wrappers: fix linker warnings
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 13 Jul 2026, at 16:06, Breno Leitao wrote:
> When I've submitted my last patchset titled "efi/runtime-wrappers: bound
> the wait for EFI runtime service calls", I've got two reports
>
> 1) efi_rts_park_worker() loops forever and never returns, but wasn't
> marked __noreturn, so objtool warns about the unreachable code after
> the call.
> https://lore.kernel.org/all/202607100848.iWPxdkhX-lkp@intel.com/
>
> 2) efi_runtime_lock_owner is optimised away under CONFIG_BUG=n, leaving a
> dangling debug-info reference that breaks the link.
> https://lore.kernel.org/all/202607100518.uMJJPDfP-lkp@intel.com/
>
> Patch 1 fixes the objtool warning; patch 2 fixes the link error.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
> Breno Leitao (2):
>       efi/runtime-wrappers: mark efi_rts_park_worker() as __noreturn
>       efi/runtime-wrappers: mark efi_runtime_lock_owner as __used
>

Queued up now, thanks.
