Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1455A3E0C4C
	for <linux-efi@vger.kernel.org>; Mon, 10 Aug 2026 14:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786372659; cv=none; b=jdvec54LNJHOr2nkpCJ3p6lmZ0uE0WKTsXpwgquhPjH4h2SDCQcM3SS/CDSFa2mMkEn95FlYM6W3ie09LA58QX9I3JhJA5239HVnyCKGVnAWDNxdBk+KfNpnrQtHRcrY8BXsMNADiNw8RVd3dpBviYvpGO7kPfCBeb5xHX+T4tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786372659; c=relaxed/simple;
	bh=DU7dD+AstrqC1zsE15YqewWXhNipog3/YOKaFtBzP3U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kt95ZKEDRQ5nKUQBkCpXf8pwzLnNIWztKDySB9h5fRdCQq/BkuVBTl/mvj5dBLgpiJIf4V4CuGoutjD6yNpHVz5djeMTYQnL6cwRyrRc5jw8/x7ncE6PWs78xJyi+Btk8XjhtwYDLzrMufXfG9UXiDFcrr0tIZw0Op7GHRWvT2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SArZK5TH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SArZK5TH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB45B1F0155A
	for <linux-efi@vger.kernel.org>; Mon, 10 Aug 2026 14:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786372657;
	bh=vAZICJ1VL+Q4P+HgVltfFci9gRl+OP2pT5x+XsJhMII=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SArZK5THaqvLXQCuVVrc4Xw1j9zygKBZI9iYjKiiwBan6sDfP+al+k2f3fu/kYx4L
	 a/Ccl5sHHDhzybny8B1waIRawyLjQrXfsKP5gX4l+3eJTqaPLs12CclPQr7DklcoWZ
	 WPJ+4ZLPPhstBUJfYMaBlNcWT8cP9GWF4gVIYvQhXL3kqcsSxcNWNuyMo09atlZdrg
	 ccX8dM8oBl5XugXNdUSVXwYJ9NcP93BpFoTcxUcp9jImtkyRSNJrtrkqCbRPZEh7uq
	 zCfbNYkxR/JHphaH2+GBlHe+vMVPtXSEM5LcFNkNlYHWboqquri3GpcaohpeKDe4su
	 82BK15pOrkmTw==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a28cbdso3080888a12.3
        for <linux-efi@vger.kernel.org>; Mon, 10 Aug 2026 07:37:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RruJN9tKKmxCqqW1x+9Ig03tGX8LhcQeJrCWPjg99s0b3L3mbzRLHwkP0xSDnstD4fDsVssrBUwcos=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQuS8LzjWZ0O+huUOspjtqn/gE/H7G3F9gz9Wh3COu4UyzihY0
	8hS0RXMoNX5YAe3peGYAfuERLEU0ijY0mxaOlicu7WNSlkx512+K8Fp2Gqz9s4P93cmIpsaoy24
	Li2hXkgLgpV0/CtFqjpOBt21tT3KXALs=
X-Received: by 2002:a05:6402:52d4:b0:6a1:df2c:cfa3 with SMTP id
 4fb4d7f45d1cf-6a1f23c2558mr10654266a12.4.1786372656379; Mon, 10 Aug 2026
 07:37:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260807103714.33074-1-dongtai.guo@linux.dev> <20260807103714.33074-4-dongtai.guo@linux.dev>
In-Reply-To: <20260807103714.33074-4-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 10 Aug 2026 22:37:25 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4pK10ONo=viJyUJBiiFb_7pbB9LaNkQWH=83r+7E0iTA@mail.gmail.com>
X-Gm-Features: AUfX_mxGX4Nbr4LsOBcUqni8J7T0qO-yPY8u3j28Wab2hCSGdEOhPb7Wq76lg-Q
Message-ID: <CAAhV-H4pK10ONo=viJyUJBiiFb_7pbB9LaNkQWH=83r+7E0iTA@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] liveupdate: luo_session: include linux/mm.h for
 virt/phys translation
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	shuah@kernel.org, ardb@kernel.org, guodongtai@kylinos.cn, kernel@xen0n.name, 
	graf@amazon.com, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org, 
	Kexin Liu <liukexin@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, George,

This should be the 2nd patch.

Huacai

On Fri, Aug 7, 2026 at 6:39=E2=80=AFPM George Guo <dongtai.guo@linux.dev> w=
rote:
>
> From: George Guo <guodongtai@kylinos.cn>
>
> luo_session.c calls virt_to_phys() and phys_to_virt(). On LoongArch with
> CONFIG_KFENCE=3Dy, these macros (in arch/loongarch/include/asm/io.h) expa=
nd
> to offset_in_page() and page_address(), both declared in <linux/mm.h>.
>
> Since luo_session.c only includes <linux/io.h>, the translation unit fail=
s
> to build with CONFIG_KFENCE=3Dy:
>
>   asm/io.h: error: implicit declaration of function 'offset_in_page'
>   asm/io.h: error: implicit declaration of function 'page_address'
>
> Add the missing include to fix these build errors.
>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/luo_session.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_sess=
ion.c
> index f38b5b18f3f8..31490ac7b63d 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -94,6 +94,7 @@
>  #include <linux/kho/abi/luo.h>
>  #include <linux/list.h>
>  #include <linux/liveupdate.h>
> +#include <linux/mm.h>
>  #include <linux/mutex.h>
>  #include <linux/rwsem.h>
>  #include <linux/slab.h>
> --
> 2.53.0
>
>
