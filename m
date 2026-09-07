Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959CF481648;
	Mon,  7 Sep 2026 12:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788785940; cv=none; b=EDuDiUvhsL2qynDD0SqEYYFU6T/SL5QxhkTdMrS89U+W4hHkekszWIJhfmN/QWOHWgfWJgfcleO2X5sNfeR7IJPItIYsyYiQIOFvXghpOXPJXwVWNwPzyoOtyPkMIRJvIB6SsM5RSOMiZWiKEHug5F/bImsumQEkknEM7p1ZKzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788785940; c=relaxed/simple;
	bh=iHdOkbIKfr7/ASq37mhCdAbaAVm6/fScVRomtNzy0Lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gO037OoOl2iPoTVLsERdPuNqZLTT25ZgbtGExVh5wC6C86rMsQVnBWrTcn7K6cWcyM2okjqjMIgHTvMvjINputwzA9VckwQKG9d30iiFc/KBmRpIVBlAQ20sCaZvQuoNVTFild/iyAP6A6PgYUnvspBvTxBTbXGANpSY4hJ9yqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=oUyzEpfT; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="oUyzEpfT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iHdOkbIKfr7/ASq37mhCdAbaAVm6/fScVRomtNzy0Lk=; b=oUyzEpfTycyS0r3ntkq/mfmtZ/
	cACWtCsHksclpKdb2/Fem9oyipif1F7zu2ixiszE1Q1feq0ilyPydN3B/RmwreNRX5HszgbhKNkAc
	tFrE6skJR2a+Cm6KowL++qdXCcVeBSdBZ2dCA+p+5N7EQeP6bOsS3CazzRGe7bNIZUE0M3fUjlprz
	CbW+Kd5mo4yyFK/fbpB7Lcii2axsrZke086LQhpvNWwyb6kw7Tw2OXaPdC4HvOnlrE40O1ioE+MG2
	39aAJ9smkmAJ95p0PPpjNbxozGyVwUVBV1lW0ipBDTYEW3fX3xEn+UT3ukorZbDtEkKHzOQC13yzW
	Rj5PmdAA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x3Yvy-001WXe-1k;
	Mon, 07 Sep 2026 12:58:50 +0000
Date: Mon, 7 Sep 2026 05:58:46 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/5] efi: mm/memory-failure: keep hardware-poisoned
 pages out of the next kexec
Message-ID: <ap60qTdp1Tpu9oLg@gmail.com>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
X-Debian-User: leitao

Ard,

On Wed, Aug 26, 2026 at 05:03:51AM -0700, Breno Leitao wrote:
> Proposed Solution:
> ==================
>
> Carry the poisoned frames to the next kernel in a new EFI configuration
> table, LINUX_EFI_POISONED_MEMORY.

I'm updating the series to address Kiryl's feedback, and before posting
the next version I wanted to check whether this approach is fine with you
from the EFI side.

It mirrors what unaccepted memory already does, so there's nothing new
here, but I'd like to confirm you'd be Ok with it.

Thanks,
--breno
