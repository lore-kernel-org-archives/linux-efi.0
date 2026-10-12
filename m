Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABCEC3E4106
	for <linux-efi@vger.kernel.org>; Mon, 12 Oct 2026 16:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791823396; cv=none; b=trtTMcT4xkB2WukUjJmiOQuAtUjyHr4WEwsbz8B5PBTEbO8vtM2om45/fa1s2K4xmXKMuTG8s4/530F4oU7BWlQ+0QBNMs3DxmK5bjkCz/rE3OfwcvjPItUots0Lchh/pIIwn3ZXexhXGF7lcMANxfGubzO7dB74TXmepPbn9Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791823396; c=relaxed/simple;
	bh=dqVwho3wSVvQZgAokcn4jjb79XN9d9Foz5x+55qbQpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nEAXAtLklIdd5KV/gOWa7rycoFtXrsWH2+3mvcjxlrbmgiEtNtllLVpTvmE2Zf/FOIHZXVbhOyJGaMYHQy3x5KaFRC8ebKsCtY/gU2GJw67i+yow7ISHleTEQHLCH/Z36yl+nibRAkHx7ZWNMkrbcob68EozZpX4aah/unM1cEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZtyBj70Z; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZtyBj70Z"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C360F169E;
	Mon, 12 Oct 2026 09:43:09 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE77C3F673;
	Mon, 12 Oct 2026 09:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791823393; bh=dqVwho3wSVvQZgAokcn4jjb79XN9d9Foz5x+55qbQpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtyBj70ZwScQeTCYE+1raEHOLvUwYWLNhAvAI1BwhPOfvmkLe5jGivcocs5elo21d
	 1lUz1JLk3Bo7F1hQA0IDZf0ppexcY7RaGnQ2ESyoVj+ziq+vhcjDKIQW09IRjZoP7V
	 29Y3MuX6ihR+kYtn5202yLOZId7OQojex3IFT/Ag=
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-efi@vger.kernel.org,
	Ard Biesheuvel <ardb+git@google.com>
Cc: Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	mark.rutland@arm.com,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] arm64/efi: Clear PTE_WRITE when applying EFI_MEMORY_RO
Date: Mon, 12 Oct 2026 17:43:05 +0100
Message-ID: <179182338471.868934.1416736534098174257.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261009151600.351766-2-ardb+git@google.com>
References: <20261009151600.351766-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 09 Oct 2026 17:16:01 +0200, Ard Biesheuvel wrote:
> set_permissions() sets PTE_RDONLY for regions that the Memory Attributes
> Table describes as read-only, but leaves PTE_WRITE set.  PTE_WRITE is
> the DBM bit, so when hardware dirty state management is enabled
> (TCR_EL1.HD), such a descriptor is writable-clean rather than read-only,
> and a write by the firmware will be permitted by the hardware (which
> marks the entry dirty) instead of faulting.
> 
> [...]

Applied to arm64 (for-next/efi), thanks!

[1/1] arm64/efi: Clear PTE_WRITE when applying EFI_MEMORY_RO
      https://git.kernel.org/arm64/c/215d7b662273
