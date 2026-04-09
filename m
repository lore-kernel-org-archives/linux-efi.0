Received: from schou.dk (schou.dk [139.162.133.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2549734CFCF;
	Thu,  9 Apr 2026 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.162.133.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775752987; cv=none; b=TBpPNjWLOl4LJRddnXU7NDDWw4GqAz/LReoxfBJnvEqoCorFOmF98nqTyPtEohH9ARSrkx09BGqmgt7W9w5IOjGQhh/buGZk0Mj/dEzzOI+JPCrJDaEHfnd84d+TWkOOVhRH2vlchtm9dt/9UB8xDtCLV3RQqtA3qV9uvVsMOy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775752987; c=relaxed/simple;
	bh=9Bsvg9ui1tfC15HVvX9E/fGH2ZBXYkBVn7Tb3tm990k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=dRfNKCaZiYU1NiIolfuy4qHDbxiSKdW269Wj7y9ngMRjTdW8QxwChRPTZP+w+Urt6bts/oirv4kUlOikRjuaKBpyR8TNs5tUtaCGFVsG0UOfgYw8zPmVlr9fiZ1sxb/rq09rYHwO1c2Cr2a2plPZBjftdj7D6+qg3tzFRIDGbw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schou.dk; spf=pass smtp.mailfrom=schou.dk; arc=none smtp.client-ip=139.162.133.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schou.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schou.dk
Received: by schou.dk (Postfix, from userid 1000)
	id 5079F9EC56; Thu, 09 Apr 2026 18:42:56 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by schou.dk (Postfix) with ESMTP id 4C25D9EC54;
	Thu, 09 Apr 2026 18:42:56 +0200 (CEST)
Date: Thu, 9 Apr 2026 18:42:56 +0200 (CEST)
From: Hans Schou <chlor@schou.dk>
To: Ard Biesheuvel <ardb@kernel.org>
cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: EFI stub: WARNING: Failed to measure data for event 1:
 0x800000000000000b
In-Reply-To: <85ad7864-6ea6-4d78-97aa-f67cbe4eb22d@app.fastmail.com>
Message-ID: <178ae1e6-2d6f-cddb-15bd-edcaa428573f@schou.dk>
References: <CAApBw345j80D3hvYzc47Wc9aDpr+HBJPQDpyeVZhvQ4b98a3QA@mail.gmail.com> <85ad7864-6ea6-4d78-97aa-f67cbe4eb22d@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 8 Apr 2026, Ard Biesheuvel wrote:

> This is a harmless warning from the TPM code in your BIOS.

Yes I guess so. The reason why I posted this message was that I saw a lot
of questions on the same topic in several forums. The T thought it was
time to report it.

Just for the record: I tried to so how many kernels I should have
installed for the message to appear:
7 kernels and you see it
6 kernels and there is no message seen

As a lot of distros only have 2 or 4 of the latest kernels installed most
people will not see it.

Thanks for looking into it and I will leave it with that.
Case closed.

-- 

./hans
