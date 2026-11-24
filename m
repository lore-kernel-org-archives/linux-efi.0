Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795516139;
	b=KLefG+8mCc8AwRNrM9PBbX3cF3GLMuayf8Hun/2cNoOHQwvX5cAdiheEfIDCQvM12IQY
	 amSLOIlMMORgjec/B+lJAXOc3K5n5B5Aer1qzzSKJYyrd/sV3XNVNmAliMqmW7UP52jyy
	 dJ39UMaCh/Cs249fGu0n/XAmAa3dYpU6c8yAcO1vAtJdP+8SX9syHa9FS84fXZg5w5v7z
	 ReR4q5/DB1w2g9m2wHgHZGfSUy+J+z2nwuSUwVV4AwfoECxkca1W1ng5+lzOIg35h9c/X
	 Z83bf4DK7DMVniQve+r0ai/Bgy289G+2lO4/EcP4JM53t/MTDePr6drCqed8oKWXQhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795516139;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=SsE8tNJAwqmZZibomeCnCihBIx8lYVgcQl1vfpBEb9c=;
	b=hg2G/kBOsAVw6Jdl/VVwkEm6CM8QKJXzE3uytji5xOChmoQ1++09Pq3yYHbqBQwXHmVu
	 gin4DfJxaODtU6U4nq3qZioi88l7qGGHSO/varzHsXPIYAZQgT8ijPeM9RwhPBxDhMtgM
	 dnWI3A5e9b3j9cKglb2XMwA3x3MgEXsBPjNTyBQ6hBpBckprqXur4lugYijQ6HL6q5bnt
	 W3YzZHrli7oyjWuKtFGGtLAfjw7UEpjsBzIaBLRs4c1LteWlbgvIPfE399NLvMfCezw+d
	 9p1fbySECCyawySCaeU9xBIhlhl7YphpEXbSNS+kUdFg+9bXUVhce17oTud2N9mGKuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j5r7pOz1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E9E606A31E;
	Tue, 24 Nov 2026 10:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j5r7pOz1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612BE1F000CA;
	Tue, 24 Nov 2026 10:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795516139;
	bh=SsE8tNJAwqmZZibomeCnCihBIx8lYVgcQl1vfpBEb9c=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=j5r7pOz1dZOWu1FsqC7tsQ+yL40chp8jTYFKkNe2a/RkiGzHJKoBqZgzmqgi3bnXf
	 KRPd94sshA0mF4DkZIjUSCbtCMwoE5Pc6Em2pBq17Xj0+XObBcp00ccn5USbfSw7JP
	 U9P4c2H8kZ/zwz5FkcnvACvZnryQoIZk3kiwe8TVPdrHQRJuSL0TIk26YKKYNR4bUi
	 5aE2MGf5cyAZvjPbXzgr0ANebefvSK+9uWuYQLcovsNyIwIE+QOw7HoagOc3635zqt
	 s1dnM5JDaIDaMJ3484l5OSyhWf4JhVrTtTC00XSCwVNf22rbd05juU+Bkg71bpEGyg
	 QnDVOm38qmhZg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 85FDD198004A;
	Tue, 24 Nov 2026 05:28:56 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 05:28:56 -0500
X-ME-Sender: <xms:5mYFa4Tw6uJRtAOHAHQlAJOy-pNHp2w15DvU-oKThjSfD3t2Qkmopw>
    <xme:5mYFawnUXb_xU1Obx4Ce5UxK8-TjAA_K01LnbQ2_1rXeZn6zPxcZom89fgjvPsqzk
    jSlXFoBVcobsOQOwtuLK4ZquR5nTUANfOY95a8EbkfPf8FS-iDboFL->
X-ME-Proxy-Cause: dmFkZTGxQNlVVxf5rzruqHNeMamFc70jMWRzsEXCXiLEDDkHNg7dSEv0cYugMIKTevMmX+
    lg8UAZ9I1ffD+/UdXKzy/mgm8RSPCm2BCLtBrMf/cJV78tplpY0gzL7ifqTQpWODpq8AcY
    7rkeyN4sHZBP4+SRrYOYgGoXLErpfWKhDrJ2pRHD3rDTQzV2mr6YhX+IooIjajukHmN78E
    s8T744HKuyUqrPsJVlvp5Z8kj/xF7h1TAVjx43qjConhj29VO9oAXGPwElSpelCkpjfhSH
    OP7MCCSr6VMjRUI+S7xN5i3ctnAWAQg2C0DKIany/XvhHFrrl3g2jA9k9jd6noeXRp4+pP
    jwnc2/dZDBpOcAn3lNt9n7B6oLN4ekF4kTKOl8Z+Y30t9bUvn6A+YDox6Yc+hc8rmpfnCi
    rY1fEekdW2qUjIhKFrHJns8GVCuGhPLGhWKyZV3z879NN8BRR5zec3qp/pxPZHmMXzZ1E/
    lRuykNHv4qgLsAZrtnGNctM4idEcUwbx7SOR3qthoM9Iz7A86iT1Go0jXWt9leDd63xvOK
    f4lOZW0dbc6ABQ8b1bImKiUry/QKr90+OaCI0HAAc3UTwK/PLLeMqTGJjiQ/SEimq/GyGp
    gZ0nqv99uqj/X8SNRWaT2KgCVk5hOiQocEloTGs4uOxt+mbp5XZQl/UgGmWw
X-ME-Proxy: <xmx:6GYFa80L2Lvn02VE4r7Su6Tcn_Dedc1xUgzha6qZHx_6F46H87at2A>
    <xmx:6GYFa5U4YbuVMdUQcGafVvVAqmygW-gghWdAVq3-e_BzGzzA2ECffw>
    <xmx:6GYFa3LR2mvcWSUhHJODeTUTzAfxV1Qn9M9xW74Ztf1AIi00Xrwc1Q>
    <xmx:6GYFa70HHwQrtSWdqMIMgK-0fMQTgg0_3FIOE0sqBZHb_gPTGzsJug>
    <xmx:6GYFa97tGvLDAX5jZI-9E6cYkI_uo6Ioi2-R0nCKC9NCDn9Q8HFs00dI>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id AC271F80093; Tue, 24 Nov 2026 05:28:54 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 24 Nov 2026 11:28:34 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Zhang Chujun" <zhangchujun@cmss.chinamobile.com>,
 "Jeremy Kerr" <jk@ozlabs.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Kohei Enju" <kohei@enjuk.jp>, pjones@redhat.com
Message-Id: <a3b9592d-1a89-488d-b61b-ac5d49aaba7e@app.fastmail.com>
In-Reply-To: <20261120081540.1870-1-zhangchujun@cmss.chinamobile.com>
References: <20261120081540.1870-1-zhangchujun@cmss.chinamobile.com>
Subject: Re: [PATCH] efivarfs: fix off-by-one in efivar_validate() variable name
 matching
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

(cc Peter)

On Fri, 20 Nov 2026, at 09:15, Zhang Chujun wrote:
> From: zhangchujun <zhangchujun@cmss.chinamobile.com>
>
> efivar_validate() passes utf8_size + 1 to variable_matches(),
> including the terminating NUL in the name length. However,
> variable_matches() expects the number of non-NUL characters.
>
> As a result, exact-name entries in variable_validate[] fail to
> match, causing some variables to use the wrong validator or
> bypass their intended validation.
>
> Fixes: 630ba0cc7a6d ("efi: Fix out-of-bounds read in variable_matches()")
> Cc: stable@vger.kernel.org
> Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>
>
> diff --git a/fs/efivarfs/vars.c b/fs/efivarfs/vars.c
> index 6833c3d24b54..9f18bf48615c 100644
> --- a/fs/efivarfs/vars.c
> +++ b/fs/efivarfs/vars.c
> @@ -274,7 +274,7 @@ efivar_validate(efi_guid_t vendor, efi_char16_t 
> *var_name, u8 *data,
>  		if (efi_guidcmp(vendor, variable_validate[i].vendor))
>  			continue;
> 
> -		if (variable_matches(utf8_name, utf8_size+1, name, &match)) {
> +		if (variable_matches(utf8_name, utf8_size, name, &match)) {
>  			if (variable_validate[i].validate == NULL)
>  				break;
>  			kfree(utf8_name);

Queued as a fix, thanks.
