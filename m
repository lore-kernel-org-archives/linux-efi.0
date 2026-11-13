Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564841;
	b=yBxAHaD8ZFnsGA77kl5Z73uOgrQrPSmpySaIiOaUxn3OEiUwb1koi5brgMuU8menfUJu
	 lJZE4hfJinAueNDTlKWuT35BEIu3XO5Si0iNTzqBXiHjsV3NVrPy0T2t8LDOtvp0rV5ZM
	 99WUURawxeXcgE8gBJLIoGwdTZPIu0nJJBjwESK15otpb6yTjFrTLDp2oWCD9l3VRhXLZ
	 nsiPREKKv0nuQy4W0xpGdWmwPf6NeUelgopBaTn1meLmB9tNEv/7/8DgO9Qf9q8w4Hhdx
	 LRkLcbuWcOIDTWHJZFmJD29bFLwccrCTskbhMENOM7QtaDz+pCSbvRUTBUZn4/FBoXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564841;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
	b=vYJb6dcH1bS0ZQOf10tnkJOSLT1sRJLKCOMhWASNMHQVZSj5RE7SMBskvIs2TiGP/oaE
	 OmCJNj9/BA8dPW87OmxKpuEjRwfh0jYcUNsQrE3pgNtUDUgkUX1/2Wf0x0dakBdukEigb
	 sTHNajhSKZIptdDw2LPKQzGtMvIdw8h/AAFGZFK8/SFP2uudTAI9xJw9P2vV7+VOFATS5
	 am7wVRL7WC2yqYhwgxNTDnt45Hucw21coGA4nH8SckfEYzLwsIjrGbXqJbEdUXQFpvgwQ
	 tC834e2Dp0qNZ0BxfFYGJsDu4Rb9kouXcncJ9FZ26DFBd1WNGd0O9qJaBrIAzdbWKug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fgkfOyvU;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E1D606A88E
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:14:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48E1D606A88E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fgkfOyvU
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48dee593f18so1055768f8f.3
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564839; x=1795169639; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
        b=fgkfOyvUu8xf6W8q9zChbNscxyQBBGlOoHgKBKJ1BkQkWvPVGihrF+rRK/++Rh9GyG
         JHspcfYOBNPixo8oPKNP4HMqn4Pm5ECxNu6WadiPSEV1Ef7s5pMOTmdpp1h0qheNYCAL
         reGCPjjBuRkeLgJtvMnJj51efD/XBAnW7OBUZupe3DEOpiY9mIzToOLvbGpl9PZAiITD
         ja/hKOWfLJ2HwVqW5WbU5vpLe4u/8sEd47rKsdelsOgJDSYM8eMKS9Bg+p1Lcupp+2o7
         A8nYundFQzH4qm98PvOkGZvKdsA4h3jxn0f8A/jmsMNUP8nMz4irJ6DT1xabl6IkGIEw
         iw2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564839; x=1795169639;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
        b=kTNCZgLlKrlx2TRn7n49FcDExy/vRgE9FWRdaX9clp6YF+XP3FcrNdKT3PwCdWGdXg
         ZAUpY2tRMEz6QRlvqzE73oAFwzsXL7cVAmOltkrSa7YRsLKTurPGARJFD+bin1U774FB
         hawcCedPqCKYt4eQGgddQdeP6lMuuoXsNLNMVGpArV86E1LHMmkPr5u52GEMjs0a3f7H
         uR3kytF8enkQuK22+t88gopfqi9aePa198XyuDGWiH7PmbEVE46uzRtmLhlZGfndSjzd
         yNbBuZFvOdQHCKJ+2LrD7c6/BevVIWrndjUZSnrT1SblnmiaSBsvuVz0V1VvDv6Mv1iB
         BZPA==
X-Forwarded-Encrypted: i=1; AL+hErHWm7I+RO8bwFCrksgUcbogXK3+t2yztBMJbD/USGeFdUqU+0HlyC9Y2QWKEXxqknQclcEbcJ8YXOc=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Ae/yJ8YPE3Shcepj44N4YP1B7rD2WN5qZf3eDcACxiw/RuCNw
	RTaGX9aGNujEWDbOX9kMxhyR0Im2d1ySl8ezsNFnynOloW2iUJDblPa5bkmFLe/ebqU2
X-Gm-Gg: AYBFou2tl/v3ZnJ2ioiBQ/FtSMhtlT5WYnQ6Zb9Wx5suzyDvL1Ck14OXEGoY9YES/nT
	egkWInhBLOH536p/dx4a0snRmZKI3X7cVnJZxLwjQspe5r0WGSev4J0Ak+O2AXoRC8uZ1NPqLEU
	QvvMCYaYm+pPNaXMpVYCm4BUPvmkqxJzenrzxTJ6rkftaS7G0XXjq1ntVMaJGQkfnW4mgx8S9dG
	/94YyCHcm7876WezZcv+0LseFXjHt8/tGo5cYsgSshmTFv3IDLYy7Q6aLy2Jaanpom8F0PKCD9s
	jZ6eU8EQsz5J14bxrcJFS8NhsGRTvCm2h3uNIcRKGw2b+oCtELrqAIUidUwfkFfuriGse9MbhkH
	+2icA/F/g67fFiqnZnFG5VW+6rVtLLAZX7Aq/wTusK1kBb9orZizFsr10rwTMkraz8M7JpUtY3f
	pfrJ/5arPyGE2jYI9/gHK3nOHi4BE3+odoIw0gIiyX5ZcUtEf+G2Q19I4tzzh2swwjCUfHtuoi5
	VKBkTuxoOmRcsatb6jOAQBJ2X3inO+cNaW7qwXLFxv0BtBNkRrg97M0K6MqIAjoH/C+JU2hV4ln
	y/x/oiFd4M1N50u9V0lvhw0F/xVSR4XYYKOrCWZlNJoiKnnZZ0ZokClYaGsnuNQ=
X-Received: by 2002:a05:6000:993:b0:48f:bc59:ab9c with SMTP id ffacd0b85a97d-49c6fd932f0mr4358101f8f.12.1794564838578;
        Fri, 13 Nov 2026 02:13:58 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49d673ce75fsm190118f8f.55.2026.11.13.02.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:58 -0800 (PST)
Message-ID: <77855be3fb9f0e1888c6dddc56d73a1683c820f0.camel@amutable.com>
Subject: Re: [PATCH RFC 25/41] pstore: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:13:56 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-25-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-25-4c998976c6c7@kernel.org>
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

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize pstore as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. pstore never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/pstore/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index cf499ba72702..4658561cf90b 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/ramfs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/sched.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/pstore.h>
> @@ -491,6 +492,7 @@ static int pstore_init_fs_context(struct
> fs_context *fc)
> =C2=A0	ctx->kmsg_bytes =3D kmsg_bytes;
> =C2=A0
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &pstore_context_ops;
> =C2=A0
> =C2=A0	return 0;
