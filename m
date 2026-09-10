Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDE939CD1D
	for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 07:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789026249; cv=none; b=U3XK5YngWCUrQCr4LU72sCVOfb7EAbrt0b1MGHpRAvi2lZIWGrYRv79P2zj+QYAdRDRbrMdcAN7R0reUrhZ1oGzg33lWi0wfH6VcFML3BeQpPAwFTF5uszgroX+9FjOky0AqTbsPFqtgl21AsbYAD7Fy+An2barRCLj1goCUf9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789026249; c=relaxed/simple;
	bh=+TzsVF4Sf+laEColmGzdaySxxrb8mVMEFLeaCwCAGxU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=hAIyHF7wwx6PGyIdQdHAi0kdV7711lv3qUThdjKyRqcMCP739R7mb0h2/z4ZCnLolm0n91umo3WWzUo6KfViBPBSkY7ZBB5brcJ5y1679ljisZKQ3H8hsu59x0N20MvyFqub5gZQ5dvGhOVMsU+6GPJGqBbiwqXPxdvKhD+vzSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHTwqcx6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHTwqcx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F801F00898;
	Thu, 10 Sep 2026 07:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789026247;
	bh=b6OpRuQYvAAGOb22ASjcA3RaqhNtPXU8PoMlJBJ1q/Y=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=nHTwqcx65W/Rjk0bw8h5Q3nnn+H1liybwRD5yWQMYGpLqMYLQyY/6WeQAbfAsRth1
	 xuuts9PxR784Y2wMPYq5CK46lHGex5r6ZRfLXHU/cDAgKXVUzFFQKklcWue7EHoccm
	 s3DTnLj+FhGeE7YBNwq6xG+TYrvu7L+6+wUUkbYf5vSiiNY93u55CzQKVYl3TmqLfJ
	 ofz/iqrdxdR09LEnT/aYThNMsqYEyXtPgOnWDNOpgT2MqvJQlCZ7vd0BDNhnKgCfZS
	 ihmu5ySx9HXu4oamZM7KL8kcoq/uM92EjRCg/gwZNcHtiJwWYQEJ6o94yM0ZJ6U3/I
	 zbL/WXKUTA7ww==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 330E3198003A;
	Thu, 10 Sep 2026 03:44:05 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 10 Sep 2026 03:44:05 -0400
X-ME-Sender: <xms:w1-iaowRyeha88iqqUIB7qbLz0Wp7THB4uvbQ52MnM9pKHV6g8o7Eg>
    <xme:w1-ianEU_zOVf6JQoKXuDyc5rkSdEoBMP77Yi5E6QYVwjZ4buR5BVxnizgCtt2iET
    KsCWQqNzhgW9liCnsVHUJFBQgHSkOP_KuLNr6dNSzmn7JS5hzmFsQBk>
X-ME-Proxy-Cause: dmFkZTFDBlCYWrFxP3XXlINjjr6BqUytts/FxhOMA/3y+VJKIaUZPfC7jiKmFkswLGU3ek
    dvSFXzBwoV5ySuIMuEA/wmxcMGnWs8YDPFMkmSYYeVNgn7BYd0pn3kHqNodJW1D613PQUI
    2AJ3N0m8dMbbRoaSHs0tiC3wjfE8+2RcEMc4aj/xmNBS03y7lDoxX/UfGLMt6WrDz0xRCg
    S8YHXu4RXHv8LhOjBwoVjlMDmx6zbFjuXsWMegy8seOyxA8/IW+5Ium9vp+20+X0cG03VD
    Gdnk2Xxvhk9Hx9sUhwTP+/lPxjAFU94DMvnlhfZYm8mhbS6RLC7I/Vzus3TMSLqYJChhGE
    BvnP+SFBxu15EMzNcd1v1zzt+wAwF2U3ryWQ9r3n2Znrmg6yR7U2y47ymE4zJO6MA4g854
    BM/nol9YOzM+wJrXYiIXjSSryVp+ln1R/m3egx2JCCwLIvt4AXsE6BxaMYdpMGyPPoAq+Q
    sM+vgahXRj7EC4UwxYhEoUqdcoi161tTL3LzM6SGUAIvUb5KclVm6up5PxnOUuZqx6AeUc
    rfTAJpXbrTLBnaaiRnMy+dEaJmQBunkcG82jszXw58kKy2FxPrQ8Nf/Q5+lndFVrQzdrFX
    VQDPRrY5Y/9iqmJa+zPGX+rH0nqj3G+ilyhKwDJ9ewQZPevhQU2D7QWDVEtg
X-ME-Proxy: <xmx:xV-iauBjo4lb-I-mvIQ-kOy8t9ODB1_6SWv4y4omMsyPNUZdZFCArQ>
    <xmx:xV-iao98bspWWGzcMRKDY89TTf3N6SkHzJR2yYLHSbMA8T2n37f5VQ>
    <xmx:xV-iaiR_zhOrjns82DP2OFlGJD_CFJOWsVUMIy7_3icnlRIc4fSrqQ>
    <xmx:xV-iakVhItqUHg2xHjCc3gvFxonNALpL6HWYVn9pny_M85mNlCh8yA>
    <xmx:xV-iakShSbkE6v_lQqAU7PcqqU7A48eghpQcPmX27JFXy-RSOIq50C1o>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 7C8B6F8007D; Thu, 10 Sep 2026 03:44:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 10 Sep 2026 09:43:43 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Thorsten Blum" <blum@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Javier Martinez Canillas" <javierm@redhat.com>,
 "Thomas Zimmermann" <tzimmermann@suse.de>,
 "Lenny Szubowicz" <lszubowi@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 "Francesco Pompo" <francescopompo2@gmail.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <7df8a578-06da-4769-9e9f-f8765fb87e9e@app.fastmail.com>
In-Reply-To: <20260829212037.335569-2-blum@kernel.org>
References: <20260829212037.335569-2-blum@kernel.org>
Subject: Re: [PATCH] efistub/x86: Use struct boot_e820_entry for size calculations
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 29 Aug 2026, at 23:20, Thorsten Blum wrote:
> alloc_e820ext() and setup_e820() use sizeof(struct e820_entry) when
> calculating the sizes of boot_e820_entry structures.
>
> Even though struct e820_entry and struct boot_e820_entry have the same
> size, use sizeof(struct boot_e820_entry) for consistency instead.
>
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/firmware/efi/libstub/x86-stub.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Queued up in efi/next - thanks.

> diff --git a/drivers/firmware/efi/libstub/x86-stub.c 
> b/drivers/firmware/efi/libstub/x86-stub.c
> index cef32e2c82d8..ae2481f8a4c3 100644
> --- a/drivers/firmware/efi/libstub/x86-stub.c
> +++ b/drivers/firmware/efi/libstub/x86-stub.c
> @@ -648,7 +648,7 @@ setup_e820(struct boot_params *params, struct 
> setup_data *e820ext, u32 e820ext_s
>  		}
> 
>  		if (nr_entries == ARRAY_SIZE(params->e820_table)) {
> -			u32 need = (nr_desc - i) * sizeof(struct e820_entry) +
> +			u32 need = (nr_desc - i) * sizeof(struct boot_e820_entry) +
>  				   sizeof(struct setup_data);
> 
>  			if (!e820ext || e820ext_size < need)
> @@ -684,7 +684,7 @@ static efi_status_t alloc_e820ext(u32 nr_desc, 
> struct setup_data **e820ext,
>  	unsigned long size;
> 
>  	size = sizeof(struct setup_data) +
> -		sizeof(struct e820_entry) * nr_desc;
> +		sizeof(struct boot_e820_entry) * nr_desc;
> 
>  	if (*e820ext) {
>  		efi_bs_call(free_pool, *e820ext);
