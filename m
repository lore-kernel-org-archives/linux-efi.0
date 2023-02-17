Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02721C05027
	for <linux-efi@archiver.kernel.org>; Fri, 17 Feb 2023 11:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjBQLue (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 17 Feb 2023 06:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjBQLud (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 17 Feb 2023 06:50:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37AB5BD86;
        Fri, 17 Feb 2023 03:50:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5E043CE2F38;
        Fri, 17 Feb 2023 11:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEC6C433D2;
        Fri, 17 Feb 2023 11:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676634628;
        bh=4IWmFISaxKmIBlvYi5tinpHd5wzh/1iH3X4fDAlUEA4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=hvqRlujjx7SyYlN8zwMuR8MyS5x3afCa9htNftsvYhvXgdjM+eJs3W6FvcAfEvMTs
         B2xJl5+Vzf5+xEqQsYX4lIsIoy1UL5ai1FnC2Vr87Jq3TEnY00014XAtshfbkBbmh/
         4TqxLO5mZhGhDTejP7yzImvphY44i8QpnXV7Uyw8529xyXBfSBMdRE3+7IIggrr9vk
         iqnV072FlQ/8Xe3E7l1HCLFb/0FpzP06emc5k1VV4xKCe2jAYdV8dahU0SRJUVo3W/
         eD1rUanrQnJd1tdtOfRHiC+WvPjUDgZNVzAsYikguJtD8QQ6ylWuDciSAvdh8NvZHR
         ujl+4RIevBkTQ==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Alexandre Ghiti <alexghiti@rivosinc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Conor Dooley <conor@kernel.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-efi@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH v4 1/6] riscv: Split early and final KASAN population
 functions
In-Reply-To: <20230203075232.274282-2-alexghiti@rivosinc.com>
References: <20230203075232.274282-1-alexghiti@rivosinc.com>
 <20230203075232.274282-2-alexghiti@rivosinc.com>
Date:   Fri, 17 Feb 2023 12:50:25 +0100
Message-ID: <87r0uotsse.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Alexandre Ghiti <alexghiti@rivosinc.com> writes:

> This is a preliminary work that allows to make the code more
> understandable.
>
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
>  arch/riscv/mm/kasan_init.c | 185 +++++++++++++++++++++++--------------
>  1 file changed, 116 insertions(+), 69 deletions(-)

Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
