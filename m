Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975767;
	b=BNbKg1YQ5lDIe/deerp1PgunN/I6LZ4afGnjQCsy6GHVJ6az9ZXhThhP2MFHxV1tEZdt
	 Ilk0StmcUm/TuoUqnc3YfgeQWjB2i97UOYUKDwOVW2mEu6WnPeiICOgrCmgrfdyBOdDKY
	 Q7pk9X055ceui6ZuaH34Hxs5CZB5/zogYa2K2ol6hKqpkT7rpdDZ/hKw6IgiQa31yESDc
	 zKTPUc8dQl6ZsZ6Eo4iQBALp7/xfbNJMG0UWbaRiutEhOdfUj4pCxv6H8CJ5llkmHFPj5
	 WgmbHWq0oZG9M2l9v0lW1AVM3breDzacqdPtSQip6EnYK+YksyCNHYcJM5bFg/+fqNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975767;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Od1x68R8c3AJiu0H1ikFF3XxZZhgOVLWJP+1o+BxS4M=;
	b=pFlZieW546REW6RaAvprBQA//LN40GlRaf3gJr8XTbvBWgsoGpFoacDQuLoq1i2qcQ6J
	 39HHIuxNyOTIi40q9srdNNfd+963irJDBfwhUKrabcirUAVDC1G1x3/IY/P2jpVlmukX+
	 CmyiewH/sT+h67XWJeS8ClJjK/tYdzxhkaS+gXYlxvzulz+TWfVw7b/gvI7tAEKwKz9Ak
	 H5W5N6TB/z8Ld2CEiyCAGimEa5U7cHzzNcfa6TcfDJzo5p0Gmjov3TUmobEPwFkpC2IkF
	 tRYF+IQP4sf4T6qhk+4XS4NztJnyjw7P9+3x6c/Hgrayf72uXqPtnBdr7qdj7gvDNPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VtEJlKdA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FD7606A330
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 14:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VtEJlKdA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D15C1F008A3;
	Fri,  6 Nov 2026 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793975766;
	bh=Od1x68R8c3AJiu0H1ikFF3XxZZhgOVLWJP+1o+BxS4M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VtEJlKdAMZbV1qA9YvmNT+GJkwzPvUesfZzcPenvriVO84yr7H4ppRHM/TcyBPhFa
	 cbOiV2oPOApbj85Xa3edkFx2uqWbEY1CymnPPxLW7meO+WZ48R3EN3ondq+6haW3QF
	 XICkp01/ymqh7lI6lc9bEsifI62Qi9omJo2SiJhZwpLg/nntpN5vq4H3QWTdiLBonX
	 g79s1Ard3fXJiboMW058jiCsAhfZBcpz6mlEgi3Bfdtc2svMvygF8bpJ7RNXOJiUGY
	 xr68+ba4Ask8VOID56/8Yp00tkYvrqzidL4ci87wqQYIMPNq44Bsojaq6POuRafhE6
	 D6kyLBJO+Ea4g==
Message-ID: <sashiko-outbox-201592@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/5] efi/libstub: Make efi_remap_image() return
 efi_status_t
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: mark.rutland@arm.com, will@kernel.org, catalin.marinas@arm.com, "Ard
 Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>
In-Reply-To: <20261106141936.2744481-8-ardb+git@google.com>
References: <20261106141936.2744481-7-ardb+git@google.com>
 <20261106141936.2744481-8-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 14:36:05 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] efi/libstub: missing Return: section in efi_remap_image()
  kernel-doc
--

commit 87d3e561f50dd1226f0d061af43fd4aa4ab0ee9c
Author: Ard Biesheuvel <ardb@kernel.org>

efi/libstub: Make efi_remap_image() return efi_status_t

This commit changes efi_remap_image() to return an efi_status_t so callers
are notified if remapping code or data regions via the EFI Memory
Attributes Protocol fails.

> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/fir=
mware/efi/libstub/efi-stub-helper.c
> index 8e43eb3f418b1..b2ad081cf324c 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -698,8 +698,8 @@ efi_status_t efi_wait_for_key(unsigned long usec, efi=
_input_key_t *key)
>   * read-write/non-executable. The code region is assumed to start at the=
 base
>   * of the image, and will therefore cover the PE/COFF header as well.
>   */
> -void efi_remap_image(unsigned long image_base, unsigned alloc_size,
> -		     unsigned long code_size)
> +efi_status_t efi_remap_image(unsigned long image_base, unsigned alloc_si=
ze,
> +			     unsigned long code_size)

[Severity: Low]
This isn't a bug, but now that efi_remap_image() returns efi_status_t
instead of void, the preceding kernel-doc comment needs a Return: section
to avoid a kernel-doc -Wreturn warning (make W=3D2).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106141936.2744=
481-7-ardb+git@google.com?part=3D1
