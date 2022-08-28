Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012A7ECAAD2
	for <linux-efi@archiver.kernel.org>; Sun, 28 Aug 2022 10:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiH1K5M (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 28 Aug 2022 06:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiH1K5K (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Sun, 28 Aug 2022 06:57:10 -0400
Received: from xry111.site (xry111.site [IPv6:2001:470:683e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690AE240B6
        for <linux-efi@vger.kernel.org>; Sun, 28 Aug 2022 03:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1661684226;
        bh=IGSuNudLxVITaM9dVf7l1zpWZPYEEnK4nFuKlwhTNfs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PgIixvY3ur4rZLumC36mWbJJ8d58CAjUqDuy7hm0gyHr9JahD4aydYfvLdajEt5Fk
         /XFZBG/sNhaLvk9jSNmRj3opYPN2nUW+g5MqxXOfXWYi0HGNPUcHWAKi3as/px6iAw
         IPyvBTMbZpqXr5IPZOBGeqbgs04VFDM2Tlzyv+hE=
Received: from localhost.localdomain (xry111.site [IPv6:2001:470:683e::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id 620E566851;
        Sun, 28 Aug 2022 06:57:03 -0400 (EDT)
Message-ID: <1a3c7d9d45da2c5ddb6f559adde053fce6db68a9.camel@xry111.site>
Subject: Re: [PATCH v4 9/9] loongarch: efi: enable generic EFI compressed
 boot
From:   Xi Ruoyao <xry111@xry111.site>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Jones <pjones@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Lennart Poettering <lennart@poettering.net>,
        Jeremy Linton <jeremy.linton@arm.com>
Date:   Sun, 28 Aug 2022 18:57:01 +0800
In-Reply-To: <ec399503712be2d79bd1ab789452028c1fdcaa32.camel@xry111.site>
References: <20220827083850.2702465-1-ardb@kernel.org>
         <20220827083850.2702465-10-ardb@kernel.org>
         <ec399503712be2d79bd1ab789452028c1fdcaa32.camel@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.45.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Sun, 2022-08-28 at 17:52 +0800, Xi Ruoyao wrote:
> Hi Ard,
>=20
> Should we also add
>=20
> --
>=20
> diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
> index 063a578bbdaa..6ee3d7826893 100644
> --- a/arch/loongarch/Makefile
> +++ b/arch/loongarch/Makefile
> @@ -9,10 +9,16 @@ KBUILD_DEFCONFIG :=3D loongson3_defconfig
> =C2=A0
> =C2=A0ifndef CONFIG_EFI_STUB
> =C2=A0KBUILD_IMAGE=C2=A0=C2=A0=C2=A0:=3D $(boot)/vmlinux.elf
> -else
> +else # CONFIG_EFI_STUB
> +
> +ifndef CONFIG_EFI_ZBOOT
> =C2=A0KBUILD_IMAGE=C2=A0=C2=A0=C2=A0:=3D $(boot)/vmlinux.efi
> +else
> +KBUILD_IMAGE=C2=A0=C2=A0=C2=A0:=3D $(boot)/vmlinuz.efi
> =C2=A0endif
> =C2=A0
> +endif # CONFIG_EFI_STUB
> +

Oh, it depends on Huacai's not-merged-yet patch...  Sorry for noise.
--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
