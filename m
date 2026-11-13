Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573510;
	b=TWBEjGu5Sf30Onu28QqUFBeeI9ddulZ/ZI6oSSGN2MTjZ5ctUdz4zeUygdM2FqN8zf3d
	 fvgaevB5GBxEgyINLdv77K36xKUFd3NNLDuVujwOos9H55pNTA3h5RugAh+wN0IsF8iSn
	 ZuHHuB/QDOOsCO9G2MYwm84zDz8LcvbsrmjNA6gRwb7BX16Qs2zvnLI2Qf2UH3zRyi6oq
	 jGMH8JNbF4MI0WGIaTUXx4QfoyUX6BhphYLbt5bMNvbQt1OXXmn7l5BHuvB0EV+ZGIH/K
	 hhOYmzNQNKzsW0JGpeoHF8qnsSlwazzcl7pN14tk4MjniSYHTG/X8B6sTVB6oEW3L0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573510;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
	b=FUnH2D95XuRDCQx5kALO5y/9jPquj7RJ4jtRBPFZyi/2f7BYR+J8kjbm1cUVKTGiYAIm
	 u3yFQB3LqdSUJ550hj+GIAYJ26zi55FNdmk2WvGAPw7pKpXS/X4m+jgT4p5E4nHYSvahp
	 RdgUhxbqQGz7F+nL1tGcyED++9iPPrMWhjaV6STbA/W9cdbXvv9LX1RfvUuQaa4a2sptG
	 YWR1QsQJ21DMfBLrWv6XtBH40dchUHsiGjtzzJDPUPml3Hl04aYHYJ9LgpiudpXUBL+f7
	 +/0WVboJ2LTyMPzLbwduQ55XwLE4JQkq13PRQVfQZhKMuuyA4G9mlxp0W/sp3OtruoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Bz2+TnPI;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAD3606A339
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 12:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCAD3606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Bz2+TnPI
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so9108235e9.1
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 04:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794573508; x=1795178308; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
        b=Bz2+TnPIApHKvsf08kyiSuJZ5AWViHONwTwuNXVAuo2u8JGXjKnEoxSd3hG/r/h3b1
         tdsUEBtaZSOWfU3+mD3LjyqvBKt9Vc6RBsvkZZTD05u5eCDGhnWto1Wbu/C0r64DVVdd
         h2TGnt6meedDH7Iwjf2Hw2JxWOY8jwAvEAcAC10FURsf5jjp4p/KJzFYjzuPwuYFNKea
         Iij0h8HoPs5opXKf2XwMBJpd5hsYSV0+BHP/DvKdCCgwNFtbeIFAwqDf2ag0NBOCbqs2
         OXWiZmXbdGCixyOlqQBMgrkFkrhg1VmbSdmvvBdeQ4Vz+QMvhYl+k9AO6FJ5UW1pg6b2
         DVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573508; x=1795178308;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
        b=lU6XujZ7pcKzjTwbLdRuCGTorSEn5t+nGW+H2EVEdXZh6kuWbDyffsJbTKsTHN5SYQ
         z5QMS6vezzVb1ttr2N1W9cw+4OhI/uvhWr0mPOelir6gDtPKbsBZ0EwVIOLk4ZlSbz9P
         NNUwIN8wF4kw38mXVR+VOfTiMI2Rstu1aLrQsUPFlOOnFX36aH5VMs+OrCTOQZHgspc5
         Tveb9cP/asrKBsLq0cQfX4pgKeeqXyU8V3oqApwwXpU7nNHO82pAUhqGSsKFk38XMjVX
         8fFIFiLAaUMPtzfRDKpjajxhx+l8sJxw6Kqg6BYoMLiX8qucT59Wcfh1lCQ6XrH9e+8q
         18tA==
X-Forwarded-Encrypted: i=1; AL+hErFGfWa/J3fwTsW+bSbiqkvUoGW/20t7G9EinG3GzqqhUYDK0X/TgZpuk9c910MmPXY5sKi/91i7/3w=@vger.kernel.org
X-Gm-Message-State: APuU4Z/76d3YubJ/dDRiNW9RzvnARZkwl6FOhOUM1b/PQQt/Sc/EOM/4
	EenSZau1+4r60MR/xR5HDub2IPJos2ebcRS/XgBw5rvY34LubxY5oAQOkMCFlv2KX2K4
X-Gm-Gg: AYBFou2QuNzEHusmZl2AJBs5R++1H1Fpo4o0PJI4ZLKYpE/flfffs3kiNPok0yQihXo
	Jkf34t6dAqsWhKyleh9zQPREBmeuowItStpdxXhYROTuM3F2HsCs4f0cbIeDfCz6Ay1WtlwOHCX
	xwwr0eGKT9I40Y7l93R63LsPmnHqbTutPWWyIaGj0rwG643+1Tg6vyEzvKNk8ZnIezUnPIM6FjA
	0YkbXaPF08HmAh8Nbm4AloP8q8emWIaX125aTHDlS4cP8NPJf/daMcx+8OeEKzz9+pqyprzLd9N
	pKfcRAIAfYPmACGhS8AwmKiDx+6P3FO/FpnAUrUKEH7DR3K3I4ucYlWy1PD4JJ1MRuRrR+tEOmC
	9+qgF4dC3FbUZp+Rvb0aRNGkYLk9g9eBR0Rcx6ZfBzO/TNKSGEuzqokWJ+Yd70FJ7WsbegKHzeq
	oR3Ns1aPnpNS9zWCDWxRvyt77i9ruLcOD8KhwhQBLu2BMT+KW1YLFt5r5lgsag2omnoegTWViYA
	lSmrES+N40gNG5hWYrGUsGn1Si/EsMQJ8GnF5B6SZXZ/ZhIyv7YoduK5Sj70u8/1H8B5R1VjznY
	oo3nL4Uq6s6ZFby9pY72E+t09eZgZw1hLOQULPMkIYgEht1wOmy5c1ZeQ7yh6F8=
X-Received: by 2002:a05:600c:a596:b0:4b5:d95c:2380 with SMTP id 5b1f17b1804b1-4bb55a86fb2mr24790785e9.11.1794573508217;
        Fri, 13 Nov 2026 04:38:28 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571cfa2esm48348475e9.2.2026.11.13.04.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:38:27 -0800 (PST)
Message-ID: <28a33fa649dcaae2eadcc934ec49fa591ec1c283.camel@amutable.com>
Subject: Re: [PATCH RFC 20/41] apparmor: use fc_init_pseudo() for apparmorfs
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
Date: Fri, 13 Nov 2026 13:38:25 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
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
> Initialize apparmorfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. apparmorfs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/apparmor/apparmorfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/apparmor/apparmorfs.c
> b/security/apparmor/apparmorfs.c
> index a99366467217..351ea3a7120e 100644
> --- a/security/apparmor/apparmorfs.c
> +++ b/security/apparmor/apparmorfs.c
> @@ -21,6 +21,7 @@
> =C2=A0#include <linux/rcupdate.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/poll.h>
> =C2=A0#include <linux/zstd.h>
> =C2=A0#include <linux/string.h>
> @@ -263,6 +264,7 @@ static const struct fs_context_operations
> apparmorfs_context_ops =3D {
> =C2=A0
> =C2=A0static int apparmorfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &apparmorfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
