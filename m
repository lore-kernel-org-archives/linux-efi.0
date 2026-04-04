Received: from schou.dk (schou.dk [139.162.133.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3D4279DCE;
	Sat,  4 Apr 2026 11:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.162.133.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775300824; cv=none; b=NoDs740IUHkvK78jmuAV5cfK4y9KTnjcz+vGKwG6/d1rnMHvtLHOVRqUWbKs4AqsIG5K/dCf5HvzbfLlnbtbzg+ebCdORcqMje1ZPql0LTxwG8K4gcQEHQu5FI3i7ujKqk+dVvd1iDUgezyvyOY5zdunqc/98oqG27wW6wRAokM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775300824; c=relaxed/simple;
	bh=pd0Uuy8VXvK8cK71Oi9YL+GdcVxYeGoSqHrmodNmW1U=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=KRsPVshXN7LZF0Te52ijKoykNEwinKMs9sN0OM40wtvwr2eh3InkfsQvaxnnVo7gc8yVljRVmb2eqx1612SsXDmmWsqzbmiK1tvN0vI3MA2Ih0wsxHI6cOeYNMtZb/RIyHXIVhVKDx17JLb0s7MCwsZVFZ1A6yqutL1JQ26Fmu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schou.dk; spf=pass smtp.mailfrom=schou.dk; arc=none smtp.client-ip=139.162.133.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schou.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schou.dk
Received: by schou.dk (Postfix, from userid 1000)
	id 194D09EC5A; Sat, 04 Apr 2026 12:58:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by schou.dk (Postfix) with ESMTP id 158369EC43;
	Sat, 04 Apr 2026 12:58:53 +0200 (CEST)
Date: Sat, 4 Apr 2026 12:58:53 +0200 (CEST)
From: Hans Schou <chlor@schou.dk>
To: ardb@kernel.org
cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: EFI stub: WARNING: Failed to measure data for event 1:
 0x800000000000000b
Message-ID: <7648e713-ddb5-e42f-c715-73c097d196d8@schou.dk>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Ard

This message has start showing for 3 seconds when booting:
EFI stub: WARNING: Failed to measure data for event 1: 0x800000000000000b

Afterwards my Linux Mint boots up normally.

Linux p52 6.8.0-107-generic #107-Ubuntu SMP PREEMPT_DYNAMIC Fri Mar 13
19:51:50 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux

GRUB 2.12

This warning occurs only in several different events.
It can be eliminated in different work arounds:
1. Having too many kernels installed. 19 is too many. 4 is few. Solution:
Remove some old kernels.
2. Enable/Disable secure boot in BIOS (if posssible)
3. Having Linux/Windows dual boot. Work around: add
"CONFIG_EFI_HANDOVER_PROTOCOL=N EFI_STUB=N" to GRUB_CMDLINE_LINUX_DEFAULT
in /etc/default/grub.

Only "1." is my own experience.

It seems like this situation happens as a combination of GRUB and the
kernel.
The kernel should not be able to see I have more than 4 kernel installed,
as at the time of reporting the warning, one of my the kernels are already
about to boot.
So it could be GRUB which gives some extra parameters to the kernel when
booting. How else could the kernel know there are "too many" kernels
installed? In that case the bug is in GRUB and the kernel is just
reporting it.

By searching internet I found:
* First seen year 2023 (kernel version not reported)
* OS reported used: Mint, SuSE, Ubuntu, Ubuntu MATE, Kubuntu

If it's due to GRUB, I apologize for the inconvenience.

-- 

./hans
