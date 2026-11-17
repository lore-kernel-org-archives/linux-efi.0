Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904350;
	b=wgpfDA5eKUnlNg2E2WZcsyRkKxLD8QLzQqvXPkYk52a3cw0UhcWRCHeCWVWTdNT5KeH8
	 LPnefV8JLJHvOiZE6NU71k8kjO0SbBKTbwi3DdkHHY6vqQev26Fs3gm89GFz9VYJ5EL2e
	 xKs6kqJ1QlxFIuSLIPxAWKmEuczKI/SoZue0WGL4sC3+SrEGHTTtD8ujFsxlrfd3qeEK1
	 HWGgVZ+p3gChxHeZagvz17HfTEgfSUc79VsjjT6efCF+hsppSlHVfxIjOKWhImiuZnkIz
	 M2vk7trKWU2Yuv4JhgoyGw+kpj2SyvZ2dUuW2S/lrgrcs8vmMdgW4EUi6AO5jzjPXnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904350;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
	b=E2lo8E1uG/qJvgTOjV7DvfVCcPrYVOtQ4rCPLAsNepiqxPUR7PYwpPbG57ZyMXoetRw8
	 6/SbAhDFkvKl9TI25KALj7RuPnkmMV77Rj9b4nFi4KrPWQ2o6DrqtySlja9nE4yJk0P0k
	 Yvr9+8t/YudzpVh8u8WxNqRdn+T3o4YWVsRe4vEgNKieFfS+N/RuoA/bHXPMVx5YozM0r
	 vwe0IZQgMIlFqoKctPgLuAohSuUlK0K2t0+473lAFOw/Ryon1WlkJkmeKtijAT0k/sPDb
	 PMTYtMwECmimoqTveIu3JKwYoZg7C5qwkP7R14X2NFT8X3WxLz4vl39cjodYswUSmCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EFPX8Vuf;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41B5606A89B
	for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 08:32:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D41B5606A89B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EFPX8Vuf
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-490d59c3f0aso1762457f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 00:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904343; x=1795509143; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
        b=EFPX8Vuf7iz+NzEUQG+pPgjK/MbrESqv3n9ATmra3Zopp4tpstszPHFfE2sR6EI1XH
         /MuIqTxoWkMXSLrvcYnqUGQvNVGY6YndEf7Smwels/t/G0PiJAqa5YTB3/XSR2c5vF/4
         5S685rADCuM7kD+KTHsn5xD0Bbvj+kfNJN7h3Eeu6Tgpz77cxc6E5ixV5T0A3r/KAOuP
         +pclbSVYUTOzYQ2RRiRVVs4C5Z7y/NhXCRc6Of4Q0fL8jD/Em4FfidsaQN0h6TdkChBo
         DufH5bn8tmF4fp27j4WWCE7M7sjar8yCORXmuz1wFPQxfWworU2xHCWyEC/YN83R4E+t
         3i9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904343; x=1795509143;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
        b=HgPAR/P9p8L5ZlMue73AQ5Wu6LkPTFzqBd+byzr0vdzV/Y6YAyVn7Nl2wfx7P7dftD
         KLvvWSgcFlCjn2W49kUvk4dTXvdqx0oUbUexmUDH8hNT+Ogp+PS5NGvaEYFNO9m8FxzV
         9UNz0mjF1crdg0O1Rwdzu8fg26GGYmEALpYpp/mo9pmfFHk2Wo0x4I6U0gSlNy/Xlp2b
         yC6SC/O/xRxuRrK32So/d2VT75zyd6F7oGbRmbaSrnnanOZxKrUU3sAklW2P/GBND3s8
         BoBD/X88u52Fpg4XURhsSF6cZtVCtOZyFKNAfCoppA2BzSdxU5TBwqvb0lGCp/spARbr
         7d0g==
X-Forwarded-Encrypted: i=1; AL+hErGgz6jmcmrfve5I9lMIf3F0YpYBbBhcUsJLQFNrd2bNzJm7kHUhDfiUWYkEr2jBE2Ep5qY54K+GsbQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z+PaoPjV8OgxLQYN9diTHSMemNVUvdAzd3jfC04P//zbgVlcH8b
	D8wpQNJxIWhqz8pF8QIc+eH21G2KmguJlLbQ9oWudGzyfbJyk2vg6MLLswDnOwsZe4xd
X-Gm-Gg: AZFdTZfcnN3+4bwxMW44/dXj69/QWP1HAoyu9/7mgmLYrqnIZNudYAASs5Nl1J9uKY7
	ZlG67fSDurxwX4X+H8hyQY+0MaFhPVOOH1r2ls0NvPwM/jq9Osm3R00OwfFezKDkXqHZqEeOaQL
	jB3YqG0LkVIou56diHwTZp4+exIk46w4P+lBCmjbM4e7YkbQKNc0kmcMscte2qe1XVzkRZ1t26f
	DyGxtQPQ2q+HGZL7i4IEq3G8KOb3slfB47jRcMFJejc4GUU7xPSZrI8Wblu4KwzG24r2upEsmNW
	2oiS5wG32rmKeK1AxeWBrb6O5Rtu4A3KY2Os58PfpwXjNY/2XI7hut5VbIquEENf2k4szJmrHAl
	unrkb0eBcsvPoug1KOxmt1otRSQgEHUKGSYWiwS6yeOtWTqLQv3eNxl1Ne+/puLPgU50WTGNS3x
	kXMTrJFtzlYghietIAbOCncl9bF9aftrvYVl5kg+ihXihXNQUpJwxOh7cPgD9TSqaRtJwgGirXa
	qgoBUn8oOMhPeII7ojv8XoSx6A0XcBgyhQsAb4lSDl6pTy9SQRbecLM0UruiwGS5Y1N0fKgAwBu
	wKniXDst1XMv6QSbh0PYQ+29+uDol+3ehH9TSUYZRz1WzpCM032Ux8Ikh3eCve5qtY2CL1bqgSb
	mD7taTwMjjFGJnm5CYCjv+MJtEScRbfuKWyc1OhnVj/pCCVAZu/ilWh1o
X-Received: by 2002:a05:6000:3108:b0:48d:f9dd:e3de with SMTP id ffacd0b85a97d-49c7353c415mr27089117f8f.45.1794904343236;
        Tue, 17 Nov 2026 00:32:23 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c608d10b2sm43646659f8f.44.2026.11.17.00.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:32:22 -0800 (PST)
Message-ID: <fd39200976086130cc82d59699a988fc3e0689cf.camel@amutable.com>
Subject: Re: [PATCH RFC v3 27/44] openpromfs: use fc_init_pseudo()
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
 linux-kselftest@vger.kernel.org
Date: Tue, 17 Nov 2026 09:32:20 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Initialize openpromfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. openpromfs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/openpromfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
> index fb8d84bdedfb2..6cd02d456bac9 100644
> --- a/fs/openpromfs/inode.c
> +++ b/fs/openpromfs/inode.c
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/string.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/slab.h>
> =C2=A0#include <linux/seq_file.h>
> @@ -419,6 +420,7 @@ static const struct fs_context_operations
> openpromfs_context_ops =3D {
> =C2=A0
> =C2=A0static int openpromfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &openpromfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
