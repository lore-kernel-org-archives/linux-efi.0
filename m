Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704297;
	b=jkc9O3eOA7vgsxRL6ueVnJfUhFrTGc6wy7Jwt3uQshJh0aV4n2ok55cy5gZj6Hz6FdA1
	 0joTDNfsSjRLLZ7gkdDXYaXIdSOSwM49YhCFmDkBsbmXUqQAOuXj7palk51/dijUnDmsX
	 bOQYhHhuaR2t+3m5wIiq71zUbsqZG6/C6irLoa2ExiuKt0QNAQSOXb6/a4UTwS/R8lEpk
	 oexs1piB9KkZqm7m1wQcJ9inVocAm1qpb1n3vQahwBGyg53vVy5/4hGqB6teZRaVDUxUJ
	 BF4wUo68o1jpvPbOz6tpGjncg+FlqAHcf7FNkcOSIY/4HLvJ+pygcT7XvFBxstlXqdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704297;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=s1k9jwR9uYBykaap37kvFY66tPX/046DsSECGuk7lXo=;
	b=zOj8MLcTfJVA+tm9ZsTC8jpSr/7nRleceTGYo1DZU4+ipGrDrTXwyXBQOcvVDn3gh6MM
	 5ioKrMgDPw0Hc/LEuQyPxrMUp1j7Bp4i7og+5bEgJ0d7kMfaJB0jYVjUaeMwkEz6JEJd5
	 cl8CfnaWjwzn1RtuZHcsWQYlbW4sPGaDhf/ClkVoFjARYF4tKHEziEjwgsro6P/LGvqrO
	 8yqabRCheJtGCnaehxo4X8DR2jDBspA8In5UHCoSR0yTqGe+00Doum/FCCY9jBj3pER6R
	 5NXXie9Fv9dxF+8r92TWU8bLhJgPILdbyAJTD0dlweSSRTQwT72AG+hGWpH7Gzj3/9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RTv7s221;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE60606A326
	for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 14:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RTv7s221
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7C81F000D2;
	Thu, 26 Nov 2026 14:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795704297;
	bh=s1k9jwR9uYBykaap37kvFY66tPX/046DsSECGuk7lXo=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=RTv7s221Z19s5FSW7lxjLnVzl/8cXRUIubBdHfxjexONZtracFVvc8PaCmkgtcXLo
	 m/FKs8MNCt5fnbDdO6m5HvOKxkQ3FFYLpKzbkr0kqDglOtEzHzwaBXHZCLnHblMvAp
	 x2OIgWUJN73CtOt/XYSA0KjqqGhsaifiOOrxOIrcj2p2gSYLiiif1QKgtIt2RmbiB4
	 XFrEvi3lMHOPDTs/G+WHoq4ddQRhrdKWWvhh+HYHAgmHcMKLpHk6YkF86czdy4KfZ2
	 xFiLeOEYEVs6x2g5Yzeu1mXXTmSQeg1vk96ZsmnPYV1RBOU+024g/didpJwl2zqrHW
	 77/0b9guVomxA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9D61F1980070;
	Thu, 26 Nov 2026 09:44:55 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 26 Nov 2026 09:44:55 -0500
X-ME-Sender: <xms:5UUIazjroOeS_NsqlK_KvoNCmuF0--07hyj1FC9-zhKbtGmErI9d6Q>
    <xme:5UUIa61KB3aNNdub0HDwCyq7kZbjzWjdFjHRJO6uDyWHj0CztMtuX7IXWpiWulGq1
    xIAOJhR4Svby19-zeq3RAs0_PioAyCe4OfJNkKVbBwj94R8Qlb3jn_s>
X-ME-Proxy-Cause: dmFkZTFR+pwCH4Jkqo7TrZP06wxT5ArJMD5r0dWWU5tsBlAXr+vN/V4bqjkR1v9E4NNLcC
    hX+u7qY6qxhTd5Mo/9k679ni9lsQHgQ5ovWLCya94hwULz0lN1S4fziBVYl0zwEE03vZW5
    HnT/6oic/daFioWCdu5/5zVxLOi/fHWlA5PmrgFzXCpDOHQX4poq2Brkcs+GiSJSNJfmW+
    Lv+e/I1MY5UiLyVykzK7vNP2mr29dHV0oCDsp5HXqqCZA1d84mUNJfviDDeZ45BSifMI5l
    MunesqkVHDK2kPQC7Onuh0dWiqMOB73nJBkszoqgWDzShYEb6iN3Gzovd7amVl7N4FVBq5
    7iv9koEsQbXImZWSqR0CVW/GMIijvYA46yzRyIkGlLSZzFldVLWeslPW6UoNiajtP6TnoQ
    GVGKlOapXkSVJgEgdCrx+mrWD+Z1a+HSgMq+b+j+301IlN0PDVYaew5PF0USiY6IUZatJq
    BHWPXGJXc8S7yrvv5caO5yBrFUKgwmVaQV2w+WvdRuud8sD7noR9bHLLcQhIS6cHvsWS3J
    TokAJy83SVYL+JiuluRHTOqw1uYle6ETbkLqJezq2ujXxIhTs4UlIu6giXvbP8VNmknVLL
    TTBM9VmtMpw9fiBS9ZH3kkcKahGOLA68nAn0+DUMe45JzysHyjxb7BakuksA
X-ME-Proxy: <xmx:50UIa1jcpp757eEySbS1h-Stb1TDNtp8lytqbW5iuIpjFXhx-Lyl6g>
    <xmx:50UIa08AU3eif_K2L7ENvDOZYWuSPWIIs6fIX_RzbytzpP_Yr36euw>
    <xmx:50UIa0GSejmNYrxj9TewyUf0W09N0LtD4dYvLfMAPwcpeXE6n1yCIQ>
    <xmx:50UIa_mvUMmHJhaRYAgfCbZ13Z1YTxu9bKT53WV_sF7OrsXwiZs4WA>
    <xmx:50UIawZ_REgSAEznCIMp0x3r1Riroon7n49stcMnPpHROLlHy1EXV8Dz>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 98EA8F80093; Thu, 26 Nov 2026 09:44:53 -0500 (EST)
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
Date: Thu, 26 Nov 2026 15:44:33 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Dmitry Antipov" <dmantipov@yandex.ru>,
 "Huacai Chen" <chenhuacai@kernel.org>
Cc: "WANG Xuerui" <kernel@xen0n.name>, linux-efi@vger.kernel.org,
 loongarch@lists.linux.dev, "kernel test robot" <lkp@intel.com>
Message-Id: <97a95c9d-6736-4eee-ac9d-cbfb47d60492@app.fastmail.com>
In-Reply-To: <1ae25bcf-0d13-4aa3-aaf0-b367444f6719@yandex.ru>
References: <20261126124145.876953-1-dmantipov@yandex.ru>
 <534a9786-8594-4f0b-8ce8-ea1844581c0b@app.fastmail.com>
 <1ae25bcf-0d13-4aa3-aaf0-b367444f6719@yandex.ru>
Subject: Re: [PATCH v2] efi/libstub: fix building loongarch32 without zboot enabled
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 26 Nov 2026, at 14:16, Dmitry Antipov wrote:
> On 11/26/26 3:53 PM, Ard Biesheuvel wrote:
>
>> NAK to the changes below, they break zboot and need to be dropped.
>
> Hm... I've tried a few configurations with/without CONFIG_EFI_ZBOOT
> and found no linking issues. Do you have a configuration to test?
>

Build the 32-bit vmlinuz.efi (EFI_ZBOOT=y) target for either architecture using GCC.

But actually, let's drop these intrinsics library routine. I'll send out some
patches that fix this in a different way.


