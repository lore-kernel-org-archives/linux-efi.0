Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904114;
	b=aVedCrmyxFpOmCks15bbzbhcORVgv5qudwDeS2FuiNNsYDEJuVXt3gqpwBqJL8aAUp7I
	 0GEiXW2lK4xpLzf9vz9FB3twrEEZUlu+/uiK9ZGuC5xH2nM265oQT2YkJSic7PjGhXQw1
	 s6j0+ynXL8Q4QWdWIjo1ZTWeYcdRS4YxMlk/izkRka/grFwy6SZxjrarGntrohMkHSb+q
	 SuJhk9HcXMsqvlmNlh1etoYypGvqaB9dQ7PMxHOSOjzv4csnKxBQSwSeurvf5q3SMaTE6
	 lywJbvnZWwqrzB5AAl+samxjxjKElQnEK7811oaxeHulTbZL7dgLTNkiJylNoCXonXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904114;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
	b=JVjPYD++RY08n2uVa2xE2IgtDWnCDmS4KVBml2Qt+3ZWXrEj+EZeFYBOMx1JK7UUN+D5
	 5/93/3OIa/LTufHkU3BiwsE5FJSUL2XS8yARv0iJVN6GvABUl+7a+WcPC/aw8ObCLZeBG
	 83jDxqu+x8I6iGtX0Jdpudx/9cREZspGCb/qE5aco9PI+XgCQwU65mu5b64qGMbwBPnjK
	 hWJkDvd87vdSKzTczHVOxnNuiBaqhKcd6BjYLo0G7lCiUCe08mznOE/V47bNsfJyhLSIJ
	 fvU0GmlfPik/7THQjCigX2RyJjFBEqkfe9vVqGPWECHPg3EDUG1uJ1zBLAYdZe0Fq2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="lDHE/E60";
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E9260A2601
	for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 08:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5E9260A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lDHE/E60
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso36239945e9.1
        for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 00:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904108; x=1795508908; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
        b=lDHE/E60fAF7y/GcfWe7zssqpibfABjaDWc4DbPAbANFwY7mipSCQzk/tGna/Yk9Yp
         5M31Ja6Q4S90Eg4jWdoE2GH6TurYV9Y9Yxd6SoBGFySZlSGgcD3Nf8Ac20Morq/IEeLi
         HZNDCkpilOoqmPVEk/N5paMQG+RjNO9OhPzIDtVn6k+5pNMY8rSlnV+zGCrptyxwBw8i
         uHdMwH/Pby0zhrQLCKl2b6izfUmExSZrUoQCnWP4NFP78u9vhGGyVwUcvE3no1VAV9ln
         DDlxdlg3j7mlBLcF1wQFzdXfstbmRKgVspXMjOajtHMeg5NsSNAba7k+RMZ1HFntU+s+
         8A0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904108; x=1795508908;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
        b=eeO9/oXob3prjHUHsRn0yEbjKy/PzTG87TZTVijsk8cuSdsDdx5586nIpHm1qDtN/d
         3Vs+AUM6BBGqcCpgDahtC3h6ZkoikziwLMxyAbcV9OCfbWoBg2pMADL45vQP18Wh5C9b
         sxHpGv91g7n3qJk1kfkSZ42a0LqC/sSlNXLPQbVqQJfw19bwBzn6trB0NJOyz1DCWqah
         0U+AcGGLrOHQuP5sR2L6WJJpXmaSUJEXu6IL3Q0ExU6VksjNcI9ApxUYpMLLRMH9JPxy
         cAuOAlkHIYkt6OyJa4n0r0DYxOaj/Ez/dx+zYp4UIu+S65K9Kl8rbpbyF+tZwFuz9t8J
         xumA==
X-Forwarded-Encrypted: i=1; AL+hErHoE5MuKruMA5bEK+TWjvxuBa6G3/9rblqmVYqj2zGaEQlU5sEjFRdoQMrLwqSGwwRfd/crEzUYzxo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9vaWU8hOXpNzn4pkHrS+qPIXgd8hy8LSBM7WeTEBSMslQLRgHX
	kfRSKon8nwOLrLZ6ppWpoSqDDNvs6D210VXqDxArgawPDmO2dnKag3mZcK1q3OgTQGNm
X-Gm-Gg: AYBFou3iFcXKzmTFZ3QRs30RW73M2QNeSOq79rFE4ExkRnEyaKhG9BSXURlWpDq6do9
	eqe6TtRgD2kRCsxKDamDnZFyODA3pAl0SydTJqpYWaBWk2azluNXbm0JQn7uqG8+nlEVIllm2UO
	m22U2vFTfXieltryaXKcD9QqhfnvbWoipGf/AmYGSrrj3J03uPtkbgwB0L+EZqbXSN+Wtjp8VEA
	Y0UmLpFgQHYNGF+T699e/h9M+/CWQn3KoIwK6wZdQaQRdXSNyIQGPj/NFXZT1M7ZIxRqt8QsIc/
	c/pM6q8YfRqURvMRNaw2TJLz9ZHTnC17MgJ55fwDp5B79ZuOD9eXJsLwKe5cKoBein3T+s34Ykn
	zj0nmAgNY7Is9DsulKZSwfjkG861Uhket/wyJPBtjD0uoBwyCqyx4/jf558cup0HCyv96HGfvrY
	IRYGTzgTi8sZgYs+VPaC/I8MxCBr/nAZE1JaSa0bVXcMNTH9t4boetNrSBYaDBA3TKLobdxSL7x
	9WA5spZnthRR+e/LCBiWLLyruKOlaLwU/2CCPo6NWcjsVga6GCJC7I8lrJ3scbddiHUnX9kXxSY
	An0SyOxYYAwXLtDujOiyoFrtFnaE++wxe0TbdxZFrJEyp7ZlUGCLMdeTFYasJhA6RxOiCnN5vZY
	LzFL0WUJE5dkBakzKgP6RnAQ20+ZVwFEFs2cISUS0Taqw/y3pCHPlsVTi
X-Received: by 2002:a05:600c:6286:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4bb55a5d634mr255399085e9.5.1794904108278;
        Tue, 17 Nov 2026 00:28:28 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78422d2dsm75197335e9.10.2026.11.17.00.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:28:27 -0800 (PST)
Message-ID: <afc070a816e3ae5eb3c9e2d62d4f25c59ee61df2.camel@amutable.com>
Subject: Re: [PATCH RFC v3 26/44] xenfs: use fc_init_pseudo()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:28:26 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-26-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-26-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> Initialize xenfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. xenfs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. xenfs maps the xenstore
> page and guest memory through privcmd, both data.
>=20
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/xen/xenfs/super.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
> index 37ea7c5c03469..aba7d038ed735 100644
> --- a/drivers/xen/xenfs/super.c
> +++ b/drivers/xen/xenfs/super.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0
> =C2=A0#include <xen/xen.h>
> @@ -80,6 +81,7 @@ static const struct fs_context_operations
> xenfs_context_ops =3D {
> =C2=A0
> =C2=A0static int xenfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &xenfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
