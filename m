Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564190;
	b=FHFlGn1OTTciY3h26/KiOyShWtEBjOPzjiG5uK0Dmt7thFnOKkYF8acHOcZP6Hl5O+p8
	 Hruu1+DwppvzX5SXw7rRA/xxx+pdmndGFJnrPuf7CVJfUfLF8GohirbxJfA5Ox1zwzEva
	 Frxu3p/fArVeIRmA7mbPnIoOY09847fMrUVBm+y5wJzVAdc4Kjl0zWAMrsFLnLNdKHWB4
	 vpnLC4nFbF3buiDrc3n1ESuzgr0Q2XTVx8v4GG+h8r+t22nLHL+uKvxgl6FbGCFqIC6S3
	 z2Zv57YGrTP5+YTDav/2LhBUxmsSVGVNXM+upYYvzuQYU4IhSqYMSGdbdVF2d9J/8LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564190;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
	b=BSVln787fq1p4NQbxaGmVeB42uIH82O2kNmt6F7eyCJBjKWHm9fc3IveKo63LntPc31N
	 BOSleHZYNpwinq4IjZ/15dgD/vMbCWZEuXnBGbCJ5o2xBZHrCOwb71bHAGTioMRYo3CVr
	 A7oY0ZCMD8gB8Dvt+t43NJMnfHRlNsZgD+NQ1pEaIXas01SZN5CNx5AniKlUjx8/fu33h
	 yOlZGeriQ7tjwNEbTk8uDQ94yRrq7T4zscxUb6hmNCCB2LB3htaEwcZvq/gkkiTF2o7vM
	 HSHbI2WAeRbz4Ra0MTSOz6VsORhTVXoMh2JwKHwJ6DaQyCj+MOs9oPhL+qhv5cu8L8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PwLaWWEZ;
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85418606A8AF
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:03:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85418606A8AF
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PwLaWWEZ
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4d473cfff6so128195366b.0
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564188; x=1795168988; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
        b=PwLaWWEZlovk3BcnO0ZG64105bcHT1OuSddm6BbnvIqxbrPzt9auj7esmk6BNbh6fX
         VcVz0Fb5EO25ZFbwJkkdsGMVKdakOQPzqU2f6LPhtUiDBhEZmXH+cAuxyn5j0/PSwsaT
         RO2aU2TU8aCmd84MLoXz7vnHjZWZq5qT0/Sc6gtTAg3UhyfQddRWFsH5ep7YUVPW4oOS
         ZJYdPFjeA/srAxsT7bXr7CLtpXwYO3HrhRePJ9C+1IlKmxOGPfhyvFsMUb4DHUYdYyHA
         n68GAxpj0xAii+OfqqKyb+8UpP8WFZF+WeKZ9rpWrZ/4EfgHnKqz0J1mnDjnDglQmq1u
         ISGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564188; x=1795168988;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
        b=2qRQyNE168yYZXi/YNI4GIOYuNzYdWzelE/9h0c8Fy8U7ssFAHF3a7IeGFovfzWTqL
         ZgSxenfoWlLIJ1+rfnG85gKNSJnfbgfniHPRuSWP+FksPH562QhBo94IVzfWG2PCZyMl
         AVR3Efl10EcFsKuVQgw4a9yJj7rJBIRutZGuoL3qjgL8bmnZsDF6NoB+1aY+eLN/nVUp
         3tgx8J/5UOApQKU5Mqq4/O+UnwRppVt6i267tsnflOTcMzfTbnVfQmDk601UF33DAkoK
         rQfYgHAsdKX8CJ53E/wZxUvBwtImAvlu4PTiqRO/ZNo74mKK+43tSZjH32fJFvJZ31qr
         G3ow==
X-Forwarded-Encrypted: i=1; AL+hErEeo7u46IdCRRg/diRt0gDNVHCTpn0eZ99fqCvs3vTi6Mlt03BR/AQ6f67XEeC2fIDOF/GYYt9Tsw0=@vger.kernel.org
X-Gm-Message-State: APuU4Z++Fk8VSKCqjzBXxp7xGWj4A47aY/S99BFFK41u3I4bjFSayqU8
	MMycYPEpT9jjzVBWgdm/Nqy7LBc683c43V7Nzg3bjnU6Fuure2AZdpT2ZGDiy1MPB9Ge
X-Gm-Gg: AYBFou3kS+ZKVUDk+8KrydwBy5dYoo3uKBvkNvAxvfgzu3oNsdKD/LEpYjzr5/UKekf
	0sHBio/Amgq2X6gtivEhDFmfpCFgqIpnD7Lqvr1rRCNRF6sH7jOAVlGKHbbuSgSkzzudSp/4ECI
	voN6FSprvPXtnn9BkJZq719oDR86tfHFbBIhQK8lMwuFRKhpC31nD/0TWvdFFPQtqwtN/mnKvQC
	dBm539DrXusd/FNZdWFiuDJLrQIn7r/cogmL1rX14l6K8eqqOFMvsiUpm9ueV5xSiW/WfQBhLJq
	54+owaQs3marAhaPfCO+Jy7ZhuyMhgIuKnrLlpp+dHAUTOva6B5zjsVcaNdfMDRIJB+xQAdYtVr
	5t/9iVLd8PGoiys7wO+GpFgU7Y2mVQN8/aNWDlDDW6WURQAv5ZTieynSJFFvuaU60YOfOqhzLx7
	DLh9bE6k/5En64jZ0BKF/195D+YHwq9Ej4wVefAQlz4w9Jt5G+U3l4d+qvkxGjf16spC8cHgnwt
	vStTfimt3PUqPXkie6HDPn1/u6QSZkYzFghzwBcpGCfg0FtwGWtn0Lf2+6LK1VmaRWWW27Cd+m9
	vh/zNO+GRFwKzhwhyMIqPsVkzJf9Kh3FYcITY7lh84L+oLWL
X-Received: by 2002:a17:907:d12:b0:c4c:b4fe:c9e8 with SMTP id a640c23a62f3a-c50963dbee5mr161853166b.38.1794564187801;
        Fri, 13 Nov 2026 02:03:07 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b3dbaesm74933966b.32.2026.11.13.02.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:07 -0800 (PST)
Message-ID: <fffc4f7f87fd5f03d1ef409df76f71ddad552213.camel@amutable.com>
Subject: Re: [PATCH RFC 07/41] binfmt_misc: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:05 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
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
> Initialize binfmt_misc as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/binfmt_misc.c | 5 +++--
> =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index d945b4f6e158..7dc233becd98 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -22,6 +22,7 @@
> =C2=A0#include <linux/file.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/kstrtox.h>
> =C2=A0#include <linux/limits.h>
> @@ -1575,8 +1576,7 @@ static int bm_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	if (user_ns !=3D current_user_ns())
> =C2=A0		return -EINVAL;
> =C2=A0
> -	/* Never exec off this instance and never let anything stack
> on it. */
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> +	/* Never let anything stack on this instance. */
> =C2=A0	sb->s_stack_depth =3D FILESYSTEM_MAX_STACK_DEPTH;
> =C2=A0
> =C2=A0	/*
> @@ -1660,6 +1660,7 @@ static void bm_kill_sb(struct super_block *sb)
> =C2=A0
> =C2=A0static int bm_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &bm_context_ops;
> =C2=A0	return 0;
> =C2=A0}
