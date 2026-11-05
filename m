Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883195;
	b=NWOjLYH0ci4BEF7cgPRd08Vp+9DrHC2ZaOZoz6Y9OamLxwwHttxtJ9jFAYGHRtnKPZ1d
	 a6m/dJju3+Fqg+LueEbL/hd5laKeqcZqW7AxwPcuwUJIviI7XMhSGTqjHv48IcoXoGj3P
	 1Nf/vKSHtfuK7tk3uCPzfWek7O20krDPRDiLfL8+CIWVXDgsJxo0NMLfh9pWQTqys+D8y
	 Ue2oJJPTQwGWOgs2GtVxHN0UQRilIeijWQZKAk/UDS01j7rJEp5vjUr17UiWiJTdlV273
	 10vR4v3lOpvazOJQ4DGhf9xOiCHOGFInCfjwZTkYnCCoY6zufOG6ur/Msx0O/1MLwWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883195;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3EMc1b5KEH9cVXiMGA75dD7QU3+3/XGYyYWj4dXStIU=;
	b=Il8OmFUTXiFVkGYre3XphzKRJnSdvTb0v5bJyjRNtXCHpBzOV0r+WxcOUOaHj71MniQx
	 M2ZvtxjHYyVf3/Ef2Sd3MuP69OGpb2LbHdhQfSSlOlJru/4yCTumJVtRxa8VdUexaHmxd
	 kc5EydaX+e3T7tUMPdAj8pe1O5loysiqoXHJfrlE+OShFJEg2glbFMctiuWF3CK+JgdVV
	 MAk5EIg8JaYneqtny6ONr/disWmetq/jq2lPoVBd9NKRUVckokjhTlX4zkvj8NPNG2fBu
	 xTfT7iHJZ2hknS0Gp0+Fr6LrPyqp2Uzl85l8CgXcnEYp3yrq7wNlT5l96gtl7C+r0IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AG12x7tg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4619606A328;
	Thu,  5 Nov 2026 12:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AG12x7tg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9AA1F00A1E;
	Thu,  5 Nov 2026 12:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883194;
	bh=3EMc1b5KEH9cVXiMGA75dD7QU3+3/XGYyYWj4dXStIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AG12x7tgg25+b9BGhXiSz/ofPJ4/nOOi9uaGp8uGSrgkfC6bThURnEzl370xiLQpC
	 6muAHtivbUfevoV3luEzApxkC8XXfAHuDlJqLtaVtu1OONXVixuRtjn5c1UD9JIbh5
	 byWnONieIPW8PfllGp8EESZ/SwNwqh+z+bUeOFhSUE0oNulQ0zcu+Pv5pPKNy1VA/v
	 PXcbV0RACErEMoyZsiEx6uq7lKwa1pq0Kc38NlHNoFAHt2wIyJj2a0fiHRBcgHX0Jt
	 UBIZMH7O7j5NDtS3xfVZrECjEHi7M1FxaeHxqmkQ+XBWSr9qt2j43IsF7RzChgfKCz
	 qsCOafVsbDhNA==
Date: Thu, 5 Nov 2026 14:53:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org, chenhuacai@kernel.org,
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org, baoquan.he@linux.dev,
	ruirui.yang@linux.dev, guodongtai@kylinos.cn, kernel@xen0n.name,
	graf@amazon.com, liukexin@kylinos.cn, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 4/8] kho: Add kho_disable()
Message-ID: <aux8MKSzObmqUBta@kernel.org>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
 <20261029172956.20791-5-dongtai.guo@linux.dev>
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
In-Reply-To: <20261029172956.20791-5-dongtai.guo@linux.dev>

Hi George,

On Fri, Oct 30, 2026 at 02:29:51AM +0900, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> On LoongArch, KHO state is passed to the next kernel only through an EFI
> configuration table. Only the EFI stub installs this table, during a cold
> boot.
> 
> A kernel entered through kexec does not run the EFI stub, so it cannot
> create the table if the previous kernel did not provide one. Without
> the table, it cannot pass KHO state to the next kernel on a subsequent
> kexec.

The idea behind KHO and liveupdate is that the system uses kexec + KHO for
reboots after the cold boot unless a new cold reboot is a must.

Doing one yes, one no, breaks that assumption.
 
> Add kho_disable() so architecture code can turn KHO off when the EFI
> configuration table is missing.

I don't like a global kho_disable() API. It's ambiguous and fragile.

> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  include/linux/kexec_handover.h     | 3 +++
>  kernel/liveupdate/kexec_handover.c | 9 +++++++++
>  2 files changed, 12 insertions(+)

-- 
Sincerely yours,
Mike.
