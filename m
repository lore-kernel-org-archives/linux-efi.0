Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565073;
	b=F6pfplXu02paBg1J6UAjEzjDoXjCZZfVLJ33LLBrHOJ92S9C6K5PqvkWfU8NJgXuln3Z
	 VVFifzKXVui5taI99XdIOgx7BgtbBYpeylWm28hRjC+wiK7LRHhgRFyS++BuDFgCGT2u0
	 MAL/YLYaIMIyNPaLq0fnKJkK3eRa9VT2f0p+iR90ZzG2VgWNJ7erSkhnX3mXe9BSsM2x1
	 TK3B8w1ka/hqQNcy9QRPvB3RPlfDODtjdNB/73nsWAHxsH4IgMcnY9u/Nuud5mFFG++IU
	 hAm03OIBfAcZT7sIKD54rixvuBjQLmRseHlvdltNa+llQfO9rhJ4kjPTCWYbafSflsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565073;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
	b=2cXZLM7l2MXSIIYkVFSYT/RHA+ljYOgIZsc/k439OP2bNIfXfauZkDhIa+RpgFoPzisa
	 nPwttXKqzUc4hh/bd1e6FWGWe6Yysx7aUBZ3rnSqCKelsTi6STGkm4M5UXNoECAjRVxHs
	 lYz6/4joCMOSMXT+6i0kz8wILRXdcNkZvoGz+x3yLwvMaGhJCxQ/x3gUPzr0xX7Yx9ci+
	 v6Ilo9few/i5ehR+6loQsWBIB1QtjUF82y6Nzt/0zQ+DAC0rThCFgW6ojQJ/KnENfsyML
	 kPngwko1wXT2sVcPIkEcO9UE8I5284dp053KisAm76nZrgduoc+2ioCRIjWFbbUCgpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hEEG7fG6;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBD7606A889
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:17:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EBD7606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hEEG7fG6
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso10283255e9.3
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565072; x=1795169872; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
        b=hEEG7fG6RzQkOoGSL66zkn+hWpy0b8TxpW+CxGFBwGxbhLfdgmFqwESmbjaY7MScGa
         1TTEC4ZDzMo/nTmQbATUq4OC5CVK8FiegRjrCOceUr+V68t+3IyOPEhrmauT/typpuMH
         7BtZ7bLX9twnpc3pST7EzNdPnkg3BFhqHXhYG5RTwPNXEKUOMAEYxir+CLBCGEbp4xnq
         ot2tG8XA7sYEn5cZCga4RcL6w3I4tCQX2A1rGgTmCQohN7lvb4NCOhavzOt0i7fRXz7K
         0fiOYrUI/s1Mo3f+qCL5v2ciULr5WU1WUhy3OFmgCMCM2mU4bZM+JgAT1J65gELN03wt
         2Tdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565072; x=1795169872;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
        b=wQHNVN9slv49ZkFCsrFf2R236uti3/IJR/zQnXOIJZxHei1FlzICEwuI3niJDegU6Z
         EnznFNwdyUoS5Vas5hTbtfjqLzWtlc+jDXsELH4Q0mULIywy+FxCCLnj8kvN6Q1YicEG
         VK7up2PPrueaes+xJTZuojzaOac1IWRnrGuDpYfHwVeAS+N7baBEYrGqEdAq7rVp1O2q
         ToNQbQXInVH8w3Yg5IB2zhraFHFd+Y6iiVKD9ffuBLq2clUoAxYNIJDogANqQ5wZQPfE
         KTMmE5rDee+WOcUyxPIViKc5mgiCyqaqruOJ8CFGI8aB7FDlFXIdI24Fv3M74ttCXYAM
         nS2Q==
X-Forwarded-Encrypted: i=1; AL+hErEnLDyqU14VBCysnHtKzZWlKpQS7CcCMWl6wEsTfMqwV+DFfHIkQ+oXzRDyRp6kmyH7Y7vaTcjo9Rs=@vger.kernel.org
X-Gm-Message-State: APuU4Z/MhTX/D8TifE2XaiMjQtd5G+TLkTrvHVXBi9q2sjNmEHlwrSGw
	/lyIp/95a/UYMJdBsyagMBWrnafBfra+Cq6qENn1o3OtipN2rAi5Z/pNPsFtn3Xp3Ruc
X-Gm-Gg: AYBFou0i3SM073g5xavYkWBzIBqhhwo6M+FVB5H7Ncm7eQHtxD49NB9hIE5g721ve9Q
	BNjyl3Xj8wrcSDa+5JwZANGE5V01mumYRnSB9LNGhSUD87FDpRom0fKUe2BQm2yL77NGXHuxvdF
	ovQZnHbp9bWeudMvHYfnOPHLtQ7FBC2ivMC4UQ4qNCdtQljsOmwgSTnKP+zjOQquLx0zblXbjWe
	TL/Y59dypGwkr/H5bU4qmYbYtCvFA6AEbfR+mvnMXvPQ/C5e4BKyf2pGy2MJcTFBcZVsrLoR/fF
	hrB5Memd7KpDWoE2nGcg29AcLeRi7uOJVZOw0G838iAkC846JqiqVb4lWiO2pJ7Sb/3sYfpUtoH
	NxUQlxrbBPysjfwqp1HbkN06sVkSY3vme7IUC5JWN2Z7tT52+lPiJ3NGQN3l3gR807CaQNB5wrz
	i1WxJnEv7Pmadl22XBcAEJgju9qjbSTMzOtQTYflP6P/FBCkQC6nwuAhdYuyHZ/TY6vWKqSlZRu
	WVSKagz1nupGx40Beb4ysCyAZMH3KlqyFgnGU/xC3SmTSzJA0jmZaLlSiLJwo9OCv4Affz6GfNg
	K+g50uBS/zCfddZoqsaiJSFb0+aV/7pKelDQNcL1XF1HE7pAabZ/sO6Xnq06BLo=
X-Received: by 2002:a05:600c:45d4:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4bb559f6f31mr43851425e9.2.1794565071804;
        Fri, 13 Nov 2026 02:17:51 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c7da37b19sm3937770f8f.5.2026.11.13.02.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:17:51 -0800 (PST)
Message-ID: <7cde6f3091f9d90593e4a6441723b6b889cc4024.camel@amutable.com>
Subject: Re: [PATCH RFC 35/41] zloop: refuse zone files on pseudo filesystems
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
Date: Fri, 13 Nov 2026 11:17:48 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
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
> zloop opens its zone files by name below the base directory but a
> bind
> mount can put any file there, including a procfs or sysfs file.
> Refuse
> files on pseudo filesystems as zone files just like loop does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/zloop.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 65634a39b0bf..dcc06dd47b04 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -1137,6 +1137,11 @@ static int zloop_init_zone(struct zloop_device
> *zlo, struct zloop_options *opts,
> =C2=A0		goto out_fput;
> =C2=A0	}
> =C2=A0
> +	if (file_is_pseudo(zone->file)) {
> +		ret =3D -EINVAL;
> +		goto out_fput;
> +	}
> +
> =C2=A0	if (zlo->block_size) {
> =C2=A0		ret =3D zloop_get_block_size(zlo, zone);
> =C2=A0		if (ret)
