Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0FD3C3F7C;
	Thu, 10 Sep 2026 07:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789024521; cv=none; b=h3JAvpXxNtnwmVKkpAWkGixDrokDRyo+niPSdFUHzNxs0gym+0z9XzLdyT3iAAVKYoIf9zXKRS7zCKmc5reT5bQKbSmR0drXakAUMAxmc6PCbVoh7w4dyyUCavYoJwnMTUKCVVza/RWgcfMnimaZ7piKHAkHfxRlge1hC7ZnLX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789024521; c=relaxed/simple;
	bh=VDba2KPI6PbIxGphZ1yBNvVNqGQKmRohnd/1QDsjCBw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=tz7bz9NQ0VuBBX5h8nbhFvSEkthgyoyeweCPWinmaOaO7WuOb08Zgx70mSQpw1is5wpq8OPaWcMmmJcSiqge4vKPjsyKl3tySYfb6fRGgJIRxzi6FNSyYewg3PQJtm1fi9Po8Jp2qXfF+q+MAiruWY7WAq2D19qonOgQlHn2Owg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=APd2mcwW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="APd2mcwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0A51F000FF;
	Thu, 10 Sep 2026 07:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789024520;
	bh=Q75KCh8j6/6+Ddg9lRQqQ38mf+VZPu1fVc1oyTeyH6g=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=APd2mcwWC6jFrZb3ZYm5Wb6CR7p7YbfxZ6H2XXSUbhGdcaxnqat3yVOCiTAyFkppK
	 ZDdtI6ykEEweTWhgceOaPRYwf2H/Is9gsEBM2hCaDcXlg5QGM3qmb9jANAioxVJtGt
	 a5glWVFESrgfCU9/cP/pgwuxdfjFRLOnXcIlgC1JyCkF0krXKelDE1Fpxkj5Ss90gk
	 p3rSm4o7IUPS/PcgZW+NBVQYbcVv9w4keF4fCoL72VwNfaabWT9yxrE2l8uQum9Kum
	 MhQQGUDnxCJKjPOuuPbH7n08rBVxGLsZwy1IPm6Ym0Yvh7LP/fyeUdBTbQ6to0d8u1
	 9zpsyPtS+yCWA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3D481198003A;
	Thu, 10 Sep 2026 03:15:18 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 10 Sep 2026 03:15:18 -0400
X-ME-Sender: <xms:BFmiao7cl-lvhT4Zd9fsPFky86zRsRf7bwmzmcRoWGqyhLROAaM5UQ>
    <xme:BFmiaktQRzj3THpZ4E08qHZsXgpFM275MuEwYYIoOK466MubBfvLofGVcD1egiP4N
    ShDMzcdnn5fDeo6z6a_RdFAbEfOW0_4Ap-UfiBE7Y-LF0iqr3urisCe>
X-ME-Proxy-Cause: dmFkZTGW+YhjjkjTS38oi2r/IMw6wNb7QjhILlkT0ga6/LtmwLm3ag3xm+5goBubsLkohH
    mw3+UXmZ5fzPmUvpCAfYL5OBuHzZJBi1+uKCwpEK4rctEw/UedzqNK3GhjKqm1OA055Xrs
    FuR7JF+UmPTmyoHYcetL8ui6FcxvhY82xRCqtTIL949ZqdrQsYbOucSHEN2/NtbqVfFcmR
    oB2DXeKxKHPrBuTKVAGiTGU63urdC4LlAk3mO4ecPqHKjl6bU7hc9SVN55NHv4keDJdOqZ
    3cP8XZ2u/bkTwtl42DKH4e5mpJL1ZtSvdhqoIJHfafes5TWtLePS6Yy0yEL3iAkaycHGZk
    +aqNet/7rWDXYDW7zghuOfki8/AlxRj2Gd/If0fN5/uc+AGlqEfEFZGcWktZMCTzInxgeH
    UuARZabNlCnsj3ihjp0Lrqoo/s9V6Hv5uE/v0VGCQh3CkLSMi5kqqe2tRed7JY6R1IS3oF
    WrLJrcJWqhLYHKLgcAZ5OFpQa4wNrIvVDR6ZEUB4isMMoNncCOm8Hdq9YRru8bjVBjaWLw
    Hiz43dJ3JbRDMQdcK84lDOpFm5jUeIQ6xIdmjoJdzJHJLeJ7434K3mfFQHMLNh5r0Vb0uF
    AfvwlK2rZgESDxQ/UnUP6o/5uKuY79xzVAhdEdyRySl30JZ5KZX9HKKa7xAg
X-ME-Proxy: <xmx:BlmiauEHpaUz1iTJTOAtPiYW7i1cTiRvRdl5sKhHInBVz7aw8s1pmQ>
    <xmx:BlmiaoTawDHzx8GF_8TxlMppgssllaEBOFbEtyFEPUaYNCl3gORNow>
    <xmx:BlmiajvqWLPdNaOq9R-8hMoXyppp64rrEBP4NKBvOLDcbAR0yB2uPg>
    <xmx:BlmiaoL-IU8n5Rp6wqF6xpj_M5Q-WVPqJ3gW867mQ5oJffKFJ6fkPg>
    <xmx:BlmiagmEveA-dj56E25vxF9ARR9XOWGFkAvw9pum3utBKnosBWVDlXsV>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 86327F8007E; Thu, 10 Sep 2026 03:15:16 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 10 Sep 2026 09:14:56 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Heinrich Schuchardt" <xypron.glpk@gmx.de>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <49225810-ec79-48b9-8d36-dff7296ef4d8@app.fastmail.com>
In-Reply-To: <20260910031853.15236-1-kmehltretter@gmail.com>
References: <20260910031853.15236-1-kmehltretter@gmail.com>
Subject: Re: [PATCH] efi/libstub: Fix efi_set_event_at() parameter documentation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 10 Sep 2026, at 05:18, Karl Mehltretter wrote:
> efi_set_event_at() documents ids although its array index argument is
> named idx. This produces missing and excess parameter warnings.
>
> Match the argument name and fix the adjacent spelling of array.
>
> Fixes: 8c0a839c2bcc ("efi/libstub: Descriptions for stub helper functions")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  drivers/firmware/efi/libstub/efistub.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/efistub.h 
> b/drivers/firmware/efi/libstub/efistub.h
> index fd91fc15ec81..049263a541ae 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -224,8 +224,8 @@ typedef void (__efiapi 
> *efi_event_notify_t)(efi_event_t, void *);
>   * efi_set_event_at() - add event to events array
>   *
>   * @events:	array of UEFI events
> - * @ids:	index where to put the event in the array
> - * @event:	event to add to the aray
> + * @idx:	index where to put the event in the array
> + * @event:	event to add to the array
>   *
>   * boottime->wait_for_event() takes an array of events as input.
>   * Provide a helper to set it up correctly for mixed mode.
>

Queued up in efi/next - thanks.
