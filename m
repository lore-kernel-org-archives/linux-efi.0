Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A64918C933;
	Thu, 25 Jun 2026 20:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782418497; cv=none; b=TKed5htUuyESqTUFoIivxX7s4PdNiofkEkezMHvw33lNfjDk5c4O6oEdUXQ6IdOxD9xyna446bKtR+epROs7wOK6CeUC4GokiEkTqWLa9AaipxuQlMh1Fx6nGMpJak/dJx09ARn0tMmlUnOjtqakxuB4ybBhhvUfugm4Y4RBv2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782418497; c=relaxed/simple;
	bh=wZq75Qj71Iqh0UgcYccUJY0GJRMgaRnNeSxEYh69W3g=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nHasNQvOJUwRRChwQh+cfXI+6FNeMu3+Y6IHVrHQaioEISM4dSjlwFt7IgfTlpx++ZYA2BkzpswZ9qzxbqiOOqRbJP6p0R3XjtL6fRUdboirTdbM5or2G6ot1A8+tuaxgZD+zQ/tZ4XrhuThikkHxv9k5ovi8+1rygWkshnLv1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzLhRwL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzLhRwL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E841F000E9;
	Thu, 25 Jun 2026 20:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782418496;
	bh=cPmr9mqHehuH/8SL5EU6QQ+XWWK8jrMA1RsYVuKM7PE=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=fzLhRwL9+cBtKC2y8H6yxrFXyLco1lzXeMjs1ociwQZqMhP/fHHVGqzbmkvmHGM/j
	 8RaL3mJjYI5AWnTuB7x1GNwPjRK6wH1/pVVxAMvlMT9+g8Ikj2qLqYq5t7eYcKdn3w
	 B2PikCanp9CecXtcTQBQ7JhKojFMnbPOU1ATYYcxkGMBO+ghOsWpn3hdGfkivQfqu2
	 E459XqU/tzStlO2WbRYAzF+KpeCV/4FszJXHKgZoHbaRjPTfpTbthezxW6xc07k2AZ
	 HKku2LuVXyux7iGCpEqIKUqeVnNVFbvbCCoOBYMjzR8iUtAZ9o1A1O/MBrFtGM3JRg
	 9kkjLZx5DGlkQ==
Date: Thu, 25 Jun 2026 14:14:54 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Atish Patra <atish.patra@linux.dev>
cc: Ard Biesheuvel <ardb@kernel.org>, 
    Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
    Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
    Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
    linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org, 
    linux-kernel@vger.kernel.org, Atish Patra <atishp@meta.com>
Subject: Re: [PATCH 0/2] riscv: Use EFI runtime services for poweroff and
 restart
In-Reply-To: <20260615-efi_reset_shutdown-v1-0-9414edcbbab0@meta.com>
Message-ID: <0167594c-0c54-cbb0-a981-26df2a5bfb3c@kernel.org>
References: <20260615-efi_reset_shutdown-v1-0-9414edcbbab0@meta.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 15 Jun 2026, Atish Patra wrote:

> Today RISC-V always uses the SBI SRST extension for both poweroff and restart,
> even when UEFI runtime services are available. This series makes RISC-V prefer
> EFI runtime services for both paths when available. The reset via EFI is
> required for EFI capsule updates and also documented as a preferred method
> in BRS 1.0 spec (e.g. URT_030)[1] 
> 
> Behavior on SBI-only (non-EFI) systems is unchanged.
> 
> Tested under QEMU 'virt' with EDK2/UEFI firmware exposing runtime
> ResetSystem().
> 
> [1] https://docs.riscv.org/reference/brs/uefi.html#uefi
> 
> Signed-off-by: Atish Patra <atishp@meta.com>

Thanks, queued for v7.3.


- Paul
