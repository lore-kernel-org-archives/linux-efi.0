Received: from schou.dk (schou.dk [139.162.133.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C4A36A02E;
	Sun,  5 Apr 2026 07:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.162.133.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775375825; cv=none; b=Yr+SKGG7SYWWKf5cxGT6INoTuZO6EdtxWScCNEhKBuTwHBNeu1qP08KGnjN8OyTQ764OvbfgJhQ1Kyw/9OhpR34RlCgvoTONVlSz6bJXceD5JEpE6bPSeBG8W9PUGnXeMoUMTpbsMXOE16EEep2tFx3PMbjPDvnsW42PtspU3Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775375825; c=relaxed/simple;
	bh=Ly+PTX6QxGocmzlJNyctO2o6vwdGS2uILpaWxGHHNMg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=h/yS4tz7QS4deIwnYzI5uSgKMemRa6Ue/E2NEkedfwswRkOcgzTtj5ZojtPLsEaFCDVrXZ7SwO4LRAjtiUAW/Sxth+dupKE0lnLpPfGUCzFaQmutDG8xLWYgedNaIov2BNm1uj7JoXH5tkWLB9ahxAE7Ab7nRIV+bFbKaPIwHh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schou.dk; spf=pass smtp.mailfrom=schou.dk; arc=none smtp.client-ip=139.162.133.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schou.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schou.dk
Received: by schou.dk (Postfix, from userid 1000)
	id 711F39EF47; Sun, 05 Apr 2026 09:57:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by schou.dk (Postfix) with ESMTP id 6DFA69EF40;
	Sun, 05 Apr 2026 09:57:02 +0200 (CEST)
Date: Sun, 5 Apr 2026 09:57:02 +0200 (CEST)
From: Hans Schou <chlor@schou.dk>
To: zhang <zhangweize9@gmail.com>
cc: ardb@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: EFI stub: WARNING: Failed to measure data for event 1:
 0x800000000000000b
In-Reply-To: <76B4E7D1-5977-4E40-B68B-801306630B62@gmail.com>
Message-ID: <eec547e3-d463-b3c8-ac85-6965a6c9e4a1@schou.dk>
References: <76B4E7D1-5977-4E40-B68B-801306630B62@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Zhang

> If your kernel version is 6.16.4 or higher, that problem should
disappear.

That sounds like the right solution.

I have now build and tried 6.18.9 but that did not solve the problem. I
still got exactly the same message.

> I just searched online for your situation and found a post describing a
very similar problem.

Yes there are several work a rounds to this problem as I wrote in my first
post, like enabling secure boot. But I don't see these work a rounds as
solutions. The warning disappear but the problem is still there.

I got rid of the warning by removing 15 old kernels from /boot which I
didn't use. But if I for some strange reason needed to have 19 kernels
installed
(I have now reinstalled all old kernels to see if I could reproduce the
warning with 6.18.9 which I could)

./hans
