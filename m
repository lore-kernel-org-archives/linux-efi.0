Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795162817;
	b=ZB9YXA4vthlauEip25RHPhiTJL/xvLaT6tZ8RQEeXEaSxgPHXgrL0mDdiDzHTFFy+gIO
	 2gIclBHRR/ePGh83V/pMyAzyjxiVu5Ip0gAMZmmYcOo0PZ27u2b4xnoe5pMZdyaDuY83q
	 D0T98ozdT3iLDZpf/GV0fYbH0RJbs+8M8s/TkpnEq8I2iF6KfeMzeijIy51ivzEtifUQy
	 E1Ne2VHeUuwN++ngmMDfYrtizscPf2W5m3J0lSaWmQQf0ml0FZ4yPoMm5MZ3M3yyrelta
	 asAcL4OWjnpSZmGonbBmyIi3DkO/7t+FE1D8HdasCp06+io9wSjz9rTZL2Z59ah5BQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162817;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=YrezAQ7e02vT8+Swx+rmAAedFzytCEs8zwyhSyPMrmg=;
	b=a/TFbIGG5Hnm7HK+U0GaZYXuLsYZ9AaTr7DHqJ1AVFofkpHNCjxH4ntkv1NOAgoC/std
	 3jGNNfENKQQvQHFKdEHCRLVm/xrsl0SaPCBpy0m7+4nRK9IUPTha+sURgeEcQudAruuya
	 PBFp3GaUQszlsAVm6RHmBwFiee5xy8b/EzZb8EtKcHOEwSUwX+u6T29JsMPDI+PR97f7t
	 IJoGV2B7UxMMDbyHPYengWLuOHtLR6uxoh5rqhzQn3FOkZK5LACswNrKq5EwKBBzhAwIY
	 tJ7PWm7nAAOkDTRr1hg1oRpHvv2ecUzDFicThs1ebRJ9SxqEC2V/p5gmk7d/15MmtOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fGSf2Yiy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E576606A339
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 08:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fGSf2Yiy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5431F000D0
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 08:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795162817;
	bh=YrezAQ7e02vT8+Swx+rmAAedFzytCEs8zwyhSyPMrmg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fGSf2Yiy+uc/qp81wK0iTU5kiKISZ5xng2yOJ0qfzp/x7fM5F3xnlDjRHwK8nv7rF
	 v13YU104O6c0yC4YigW0XT8hH7RXSrLkOkBcofghiJIDZzjUHBrhuAZHqMyGunZqKz
	 nmvDy4pvhhxNlIf9YYMfKSAQVtv2y0Kqtd0Mug9TBBrTi1PGolQlDmLwLsO/NtQsv+
	 eerHGkSer9N63JJ0XOa91S3jwLjFIPn7JgAqjMM0gjW3kCcK4ELht1UGsG8Aeme/Zo
	 jfioXx2ZErAxlO/wfuh0zLwzf2B8oHZ8OPj1BqAbdcmpXVbIpAbKOjSJOx2cVZKujM
	 MBoXYqyDVoaQA==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b8b20b2538so763567a12.3
        for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 00:20:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErE6XpN9m1uSi1Dz3qRxdcHya6eacxX03vP+PUybWcZo1xUj34dD0fie/y8uy5m9bPMs+vcIHSSpdnM=@vger.kernel.org
X-Gm-Message-State: APuU4Z/8axaUc5l9V4xJtg8LgpxnDNukLW0l6QQL7kBQLDxiTvTL3Opm
	gm5N2EXPbJqodQP8vogwm/pjg9jPuOmoagcdsmiIE9ydCOl56vh5hZTzNiyLu5vtBb1r0uf1eP6
	cFWHkFKBy8QhlxqJLPmIEJPDRLQr5Fzc=
X-Received: by 2002:a05:6402:3608:b0:6b8:77ad:62e8 with SMTP id
 4fb4d7f45d1cf-6ba37ee17c3mr1286897a12.44.1795162815520; Fri, 20 Nov 2026
 00:20:15 -0800 (PST)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029172956.20791-1-dongtai.guo@linux.dev> <20261029172956.20791-4-dongtai.guo@linux.dev>
In-Reply-To: <20261029172956.20791-4-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 20 Nov 2026 16:20:06 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4A8gYGEMkbPk6MEkjLtdEe4OFwBUkERvdpXjiXfriuZw@mail.gmail.com>
X-Gm-Features: AclHuK-h6bybNetTU_MMXuMJwO3eew7bSt_laDSgKQt1od1cbyCQa8XfhqZT6Vs
Message-ID: <CAAhV-H4A8gYGEMkbPk6MEkjLtdEe4OFwBUkERvdpXjiXfriuZw@mail.gmail.com>
Subject: Re: [PATCH v6 3/8] kho: Include linux/mm.h in kho_block.c
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, ruirui.yang@linux.dev, 
	guodongtai@kylinos.cn, kernel@xen0n.name, graf@amazon.com, 
	liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have applied this one as a preparation for others.

Huacai

On Fri, Oct 30, 2026 at 1:30=E2=80=AFAM George Guo <dongtai.guo@linux.dev> =
wrote:
>
> From: George Guo <guodongtai@kylinos.cn>
>
> kho_block.c calls virt_to_phys() and phys_to_virt(). With CONFIG_KFENCE=
=3Dy,
> the LoongArch implementations use offset_in_page() and page_address(),
> which are provided by <linux/mm.h>.
>
> Include <linux/mm.h> explicitly to avoid implicit-declaration build
> errors for these helpers.
>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  kernel/liveupdate/kho_block.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.=
c
> index 0d2a342ef422..0d56891b2f4c 100644
> --- a/kernel/liveupdate/kho_block.c
> +++ b/kernel/liveupdate/kho_block.c
> @@ -25,6 +25,7 @@
>  #include <linux/kho/abi/block.h>
>  #include <linux/kho_block.h>
>  #include <linux/slab.h>
> +#include <linux/mm.h>
>
>  /*
>   * Safeguard limit for the number of serialization blocks. This is used =
to
> --
> 2.53.0
>
