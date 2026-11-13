Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564808;
	b=PssoIvrbFxneQKfpyL/JpCF1ReQWtaVgMXj5sDm0kUJ27Oz48pf1qKe0yz72/qcew5JA
	 vu/6MtDKr2ZOASSBFHBBoFl4SfXhKqK9sdQALHFkulG8dximN/jN2rB+AwCOXDziF0WgS
	 /qhJPWCZbYUoITpkt8O784bQMKg9scCkkNJCQrnwhG9Uw5SaIbPX1Xw6p8hq4bPguBd9o
	 wx5w+YxKdwjltTv54nTij8gWbcn+arfn0bxulRbThZVYpi/W5xHMwW7umQy/i9Mk0Cmvb
	 tfmJFh2edFh+fBHzHZgsEGPettk3QO+nMaed50lnLHp3Z/1saH58zDaIO27+m9JN4Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564808;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
	b=Vck2FKiqxZio4DoDUL4hnCEGbsiBsYarfYWEYDg1sMtLH1C5L6dBMR5u6rvN5nKflQ4j
	 dgaVhl1G2GtoKIlINZ2fCIS/aAuKYSTdbptZrCQ5tqliibk3XnxDBvP8bEfSqMVjB4E1y
	 rE8rEBao4DDrVxLL5qorpWILmwDcuxcegAFYl7Ckeu5L3wTfWSWAqdScBlvQxCCA+C9rE
	 J3FHP7rosS3rZgXdrW2K794vffb0vvfEr60s6Dl+6LeFT9uNYHBsSEJBEVaWPWqw/0YYS
	 KFsTz6IjzJAFbmiLU/VONWMPpWwGoEaJgJ20f06/Necjk0BgWVHqv94PFWSq6DkpKIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rqBNEWhe;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8213606A337
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:13:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8213606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rqBNEWhe
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso10630845e9.1
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564806; x=1795169606; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
        b=rqBNEWhefqtER2dpEJNVPTElbe19fVdkNyIzbVbNULqUnWk9JP4TtodfrAxZg35Ufq
         +ciPTMXXDC3Fn73QdDq1nxL10hoZ0LEMTSuk+HTluWLCH3mNQBpp5ecm/W/Lr1PQghIv
         NQThaRjLVubmwKFzY9W4H2pkvpw752j1vTd8XwcKuq70wsUgwzLrChjclsxLFe4j6CXh
         P2+zI4RYwkyiSmtYnxi7mmM5Yw0kfqLENKBervoD5JNkytp6QIULxp+qmuf3k5WOFN+d
         HC6ACfaHkSpUVoBZwd9XYoAangfmrtxV8FymQjjH9iY0qoozDauX1oxEdXhYxV5zTWYW
         c/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564806; x=1795169606;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
        b=iZ5QQ0jmfHpMkg/PFqKjUZwdQU2K20YqemVwucqALP7/VatN5GdK9m12vE1jGM0roA
         catbEKKMdMDXQ26bcqXcCjYSZ1MSwcit5T9mSjvFXTxcycWw6kstiK2mD/V1SN5oPco7
         lq4S7TGnFCrigTIjHk0f01ev8uE17b9sUuO6RRQDI4e8f/jiAz8icrKO5WfVBMq8N3dN
         LPagT3rH97/eqUiQEuAzRv+DAUnoX0aMtrJBlpvIhJ1ej2E/yRf0TejM5t6gsh7VQtX7
         Kno1b+FaqSeqAWteJbGJT90on980rruMTsn0maSn7nz6QMJ+Om7XZSwnb1HlMdzkyszZ
         Mo6g==
X-Forwarded-Encrypted: i=1; AL+hErHewzcEHnnsi0GJ9+MZ5i2jKdm9Bk44STFpiZGUzftzTT8Z9FMpSozCiJtaz5Ylrh6eAjhwhGUcIu8=@vger.kernel.org
X-Gm-Message-State: APuU4Z+jurVoVj4g0ZKgewVLE19Tn3wLGZCGFeKyk56EOTO6NFpuyg7L
	csD3OB/7M/t3KIh52rs1WXSjXsyHPpA4sDIR5uqJqPTLHJEBb1JGrufgwoGxVb/eTiSA
X-Gm-Gg: AYBFou26VRbPKAWOf2p+mIyO0xvtF+e0aUVZkCrlv8Q73kg9geUdsRHl27OPuNC1xJ+
	ckJWSfTX0j8oTMDKmSKQGC05lISkKDnZJoEHRG4KyFZ37WNanCanD3sDRvh08OCd52P25DOrTJt
	oGT2/L+gsEutsa17ruot4pcOc0lm79kOOXrYf0MIVLcRPJB/CF1MeP3fbNA4LY2Z41a4EKU3QoN
	HXPkSL98+Tv7932blI7WtXxVS5xbYSadwxrnszZVi3GugUO9O40ild7EsG2DcB0ObKKix7C1BEX
	+M5r4aStYHbBDNnd3tNCLwc7B93RDNqTCoeS2SPE4llW0tEYpuAlRUh6BZHu1aB3PYiN2PDPNMa
	m3wAMuspuj7lquYxSpM6LuMN19MTELTyK1Ywfvz8/Ckn8oSocVQeawZBOmRVqG4mPjOm38l6tZp
	zGH5wf1uDlS76PnqhQxlvyuA1ZNFDzc1GbyfXY+Vl3Q9oumR5NH0XRouavF9znVDQEP32Es90zP
	lWGI/BfHE200NuvFtAtXXSdBn2glaEVMmxhCmF7JmDo7qyZCglFZngJK1pXc1cFMRy+1xi95R6s
	yb8r0E02hrWi//8gP5eS7AVkM87rhiL1tHPXwQml2AeHfmXxwuNi1NIgwnHwozw=
X-Received: by 2002:a05:600c:45d4:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4bb559f6f31mr43583035e9.2.1794564806374;
        Fri, 13 Nov 2026 02:13:26 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c609c8a77sm4362275f8f.49.2026.11.13.02.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:26 -0800 (PST)
Message-ID: <23edc29c421f5d4c1103004f79e104e9f94d42c2.camel@amutable.com>
Subject: Re: [PATCH RFC 23/41] fuse: use fc_init_pseudo() for fusectl
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
Date: Fri, 13 Nov 2026 11:13:24 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
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
> Initialize fusectl as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. fusectl never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/fuse/control.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/fuse/control.c b/fs/fuse/control.c
> index 21ffde596d61..4497362e7df0 100644
> --- a/fs/fuse/control.c
> +++ b/fs/fuse/control.c
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0
> =C2=A0#define FUSE_CTL_SUPER_MAGIC 0x65735543
> @@ -334,6 +335,7 @@ static const struct fs_context_operations
> fuse_ctl_context_ops =3D {
> =C2=A0
> =C2=A0static int fuse_ctl_init_fs_context(struct fs_context *fsc)
> =C2=A0{
> +	fc_init_pseudo(fsc);
> =C2=A0	fsc->ops =3D &fuse_ctl_context_ops;
> =C2=A0	return 0;
> =C2=A0}
