Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564785;
	b=g8CyPNlyBfLM7dMD1A6k4fpCTCVyz1fYj5LEDpaTxopQgi0CosDz1li8m4uy0fy4zqfX
	 fCELN8Xg/ZoziOxHguQMtiMzs9wvUZK22Sw+glCksgEPvvgVbCoZL6vbXOmwtwcqXhWkc
	 HxYWeMX5PhP0AOlw/s2HMlKF0a8W/V7cpx/7f78m7+KtetQUX6vNCFuF08BgJocV+Y26e
	 C3Ol2PIH91F+YTO+W3cUiBMkgP3X7NhbjLWe/6Lune/HC8UOyYQPXgCEP7kmrbnC1H35E
	 C8JeNt5jQfOyRYGlFn6veICH8zU7ZPJ59jfNy0ZMygewuIhFGemacfKGzZY+99cC/Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564785;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
	b=AkAKBm4nbv8HJsr81UvZuHDz1ELQ2IdOZEneVBso0OdznVATTQk/WeDplVbu9vc69Etz
	 gTQTZW6eIgaMvN9NU8hoSo/SloVCdvJ3+KAYicvxnXV+Mh29bjnYbuUwTaIJ1MFF5wA8E
	 48+ypYz1EGgCRiHC/zcD8h7vBzT51nskjyzne+7/7kMlA5jMzPAA1ok5izEsGBgJu6rXh
	 O32iLta2IBPxiO3ZnC3NywXUsEH2Upikvi6ciG/T4XexbHMSvbsV0MFMHYuu7n+0zYpCy
	 5Ud1a62HZnOwc0XZScWaGvyppGFLlEwf3R5v1QelrwDtBanFjVTuz70djIVP9eXBwcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qhgXZLcH;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B928606A880
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B928606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qhgXZLcH
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso13116875e9.1
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564783; x=1795169583; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
        b=qhgXZLcHEG/xp1ftPxi4Y+VtkR5xPsdZusiH6E7v1UVOpu+pQQwW0vkLZszWZiEzcA
         +BIaLUI7scE4yUL73wk7QDgrWayWPrLwdz+Upaai9wvZdfIC4mpAyM7/MboFd4cm+sgl
         6S6dsMSsgGsAMWrOW2SdAqPT3x/sY2fNDxpywpmU57N6cPKU4MQNdvXTLk3fPNzTNPjQ
         TN2vMd0rw8z+5ZJqFwtlFaNorLJKFpgZtePYZzAG9uux/UTV4iwPxrV7Aluh/WlU8Te+
         mKwCC2bzY5T7ZateqcC/h9wnCcfLq6dmSfmWCE2kpyRSPYXephvqiHzXHW2gW5l+Jqy/
         ZrPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564783; x=1795169583;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
        b=2dkPccpsPj8BlRmnzJu7onIh3V51pXvuzfqs4O9eQEcldvR93J/7xVITChDr0Jvqri
         qDtnFVq1YTNnHY3JjPloqIV9KSiX8xgvS0UWIZCvlogpzxQaC72cw9JcXJTj5eGpr+8s
         f/GO6/Dql/DLoUrCaqDZUnMu82N7H+u/aP5v02/tyMJVKNuPTIT+EdpGY+44bO60uvbn
         polNQuAb05r6nR6tw9ojZZ3bgHDJ7eoqdpJOkIaYrbS42MA+GwKoNCo8SCeaJA/JoHRA
         XsEgQ4ZuQANX5c8CREL0CKyTWwBwua95I4UGPUy+geJ6P1etHuuySr2wlKCt53fjMoQw
         Qzyw==
X-Forwarded-Encrypted: i=1; AL+hErGQj3GhQ7Ed4BwOcMdaUraA4CMqjVJqSGMLsy5nf/B//+x6ikRhDpwgsn9sSkyrPLgdoTnxTx1Utj8=@vger.kernel.org
X-Gm-Message-State: APuU4Z97GgKpZTG9mFN17GQElOkAvLgvoxwPvmNSpD+b63+N8950UOp/
	xu7gzdeNBeeYg58gfJ0roNizy9EROO1aQnThWUeSkTQADyO5VR62PcG8YZx0w0TKrzch
X-Gm-Gg: AYBFou1aMJ1xpqJU5Ic79vEyZX4C3eLFhE2DVWZySdkHia40+5vaWJBOzIcPH2QbjG7
	NpMwIEMP8QK9fMjq52+1VPNP286OHuB8C+ZgJ5xhiLA7IuxSBu2sziq776F7ONLFk3pPjPi604S
	qr5RyE7XX/UpC026Gr6vxR3GG0AzJ1QynI+CysSGIoGkwNuh+aPxboe6mJ4VJQYAGoOt6uI72qq
	VQaQXppB2RowjzhUzEpEnZymBumb69MvC+0ZoK+kBeOCr5+Mq51SZ+o2i8TNyELa/hfvhlcqx8i
	QIlEe5cKfgsRf4ZVrZJJgBUmfXulH3kvqOrHNoppa2BcE7/QWccnh5efDwudDJAWqZ5iGBG6XRy
	DTjlZwohdwtWmSYOZr10+ITdjs4jvrAXJXWx/rAi/+nGCjWyTi28Yz5qS49RcPanTjZMNHg7MiB
	ij3YLqP31LDpSYW0SXxrV0EmfPTodLip9rbJb7d9tlkepevc8kP9vddFkoDtouv7tUfPLXoiar8
	sB2GlggKh2rX3TuWtkxWw8Ckt0Pn0VRrdEEyPJfzYGbx60sd17aiz22QkrnooO3AfXX7bDFz16s
	/fVkr4TWf1copiDjlfUxtVwSDDbxLghL/6aNsEaK0tnoii7OVCot9fe53Qfis0Nz
X-Received: by 2002:a05:600c:4f90:b0:4b7:6c16:7b43 with SMTP id 5b1f17b1804b1-4bb55a47602mr36814615e9.10.1794564782834;
        Fri, 13 Nov 2026 02:13:02 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb5d2872edsm4056955e9.12.2026.11.13.02.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:02 -0800 (PST)
Message-ID: <94dfa5ec75f4479663dd79f3ce05c1dc6c080185.camel@amutable.com>
Subject: Re: [PATCH RFC 22/41] sunrpc: use fc_init_pseudo() for rpc_pipefs
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
Date: Fri, 13 Nov 2026 11:13:00 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
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
> Initialize rpc_pipefs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. rpc_pipefs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0net/sunrpc/rpc_pipe.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
> index 9d349cfbc483..37277a6d2415 100644
> --- a/net/sunrpc/rpc_pipe.c
> +++ b/net/sunrpc/rpc_pipe.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/fsnotify.h>
> =C2=A0#include <linux/kernel.h>
> @@ -1181,6 +1182,7 @@ static int rpc_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &rpc_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
