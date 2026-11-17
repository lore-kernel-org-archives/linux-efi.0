Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794903941;
	b=3YWuyN79oLkG3+vJRV+jp0MbNIxZNaNIYn7rzlo42WZJv6r6Seulm1MeHZrm7ad7GN57
	 8c1kiK75KePQOq+7bNW3WOOkbLgqy9olKA5t8iPeLATMpLOnblDacFvx9XtAHylIH8T7K
	 BdYf5FAzKwEXDY9pG0foWWMLVdnJw5N/r5xr0BMwxBHtzGozRJJe+pvoRoBydRRc2QZZb
	 xfrpEqW2Ci/iprg9nXgxa/GyYeVJLh7TBvy/a4v0uOKlmTJPATADA0YmEGwgaUyLkX+fX
	 W1F403zrwp0AE4vKc4hQuQgUQ26c8RmDIy6IlY6pZCK6Hrr0LTu6zTeycZ7csgyCFBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794903941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
	b=bL+60XYdP5oiWJSHuFTvlfTSH/9SiRMxyKykbFKd3jof/OF5uRV2NoIO22t6ObDHaZ1J
	 dQggtgmJOlupQwQUtE3Z2xmJWCm4yG9qiR8ekexfAGac5HqQpcqjQdJZid5ntgjhVHG7E
	 AxbzZGfe3SbOHJQ7fgtqQTklYHDbiT4SCRlRLl5BuA6yCYqnf2/fwVZBXvdo8K0EWDI9d
	 oUs0DPITlfMT9fTBaPpEH5Cmr63pvdPB9S8mXpdMLd2jQx/txVXHbzA7WYFQrIsXfhewv
	 uxv3DMkokkGMrEsZWzOOEcmre9ZeVkxvQg9/TOUbbsNL3Gv3qOpiJo7EVjdVS7OrDqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="QoCmkI1/";
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBAA606A337
	for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 08:25:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FBAA606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QoCmkI1/
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-492690dd5daso4102928f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 00:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794903939; x=1795508739; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
        b=QoCmkI1/XbLLMuB5pWQjj6w7lhYbbqiM96jQW+pj9RZ000aRRl9S7H2qSmbtORMNOo
         ePt1TXAWzVIR/TrMeI58Zu3n81XgIdPHavzyhyljr/3uEJYZwsW6Sg14gd450d308jE0
         RrvE2vSlthe4MhW9V05IsJzW8g0CM3u+nfQ1hkfntpYQW6a4z4zmXmxD0w/TiuzDbd7U
         U8xZ2FexNWbZhSQ3d3pA0tlH/f0MOfn4O69UeuIyRM8vQ/YXTKpGPDyGoQczoxEfoynP
         BDcwZppUf46pJGXZ+RH52kug0iZSl25eld2NGIqCa+XVs4XFwFr0CZI1pzljVyhbNHw0
         NmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794903939; x=1795508739;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
        b=0JVxrNirgMYTRPV9NdxSoe3FAJG1E2KvuwLRGBmRlXTE7YoStsUNNMdw6YQXyNTj5G
         oa6HlUW19n/U1tZ2HOnuFaHeFb4KvFptVwcs/4WSbm8x1kiM+7W97cNDXNqPq+ICseNY
         lN0AZqLf6nJmSzXLzyDqIwM9usOOJp6Hu4KpiOB54AgvjqwbtUVu2edeto1OI4jDKsZ1
         VZ3qVVLoju86e2pu2gb4Kqv3OT78UXPSGT8Z7ZegVVpKPjRhqy83seJgvAH/jqlHgvje
         GIijCfvW7q2htQBlzmtS43rcaZRcNo7f2muU3EexNf38aUBY8gJ6K/zokjFAGM90Aonp
         60cQ==
X-Forwarded-Encrypted: i=1; AL+hErFRGewGwFkq/Zo06OoVxIjwWP7QvwcRbFp5Tq1dvoE66vdoHI/I9m09hYW9DrqKlWEPYAuyPhMD+BE=@vger.kernel.org
X-Gm-Message-State: APuU4Z9d3WzX4gW5L+jOT1VFdRDpYBEySqX30OcuAej53rKfJU9Za121
	vwDivJStwfY8Bsd36iIOm7Rf9YvIhFC3reV2zvm1SdHAjlmYUuhXkxLcBfSpWw7RP757
X-Gm-Gg: AZFdTZdMWd21Px6hbSq8cnHQim2e26JxJuiIZs4MnzsQFCG6Mdyu6o9uh8NZahRN3T1
	r2FsBTKRBQ0R4Uxd1qluJD9/2duZlOWp5EUxwhKJ3ezy/XY3uaoQjnyTaRN/qW9fFvPxnHM7k1c
	KKm35b6rezGKHyk8K8KwfGEBF9HJLD+mNJhF+alVCDQm9czVUUgTv56DSmBsTGoDmS2aJWOSn0y
	M4oEJhRXLEb79ra19odafxqS9xyxKLw6TcjiROoEJaRDG/HPPvzFWScTCxog5pZq+mnybyD/q8J
	4+gQgfz/QpkmRcApyGG/2GgVr0jmijwzKzYMCSfH5SU2hkz40I6s9/ZAc8Qd84l1KAVLFpZK6OY
	7YOb6UvxgHbN+OXc8h4vMnjjoUcwPwuJg9qFDVfWcQ18Qxioy4r1FJWM7+2CE/RIIzlUzsW5Rqd
	S8+FvIUQgpkRvX/LcyTnX5rLrgfGfZf+co0hzTFIUJaeoRIY5KUCPCL0+Y0Ld9DUsYel35GeyRp
	UmmPRCTzzMWazpjqaVwiDGMaifhdY2VEjDXkogQpebvif0WW/a7EH3XG33jaCtSSZwKb720xxjj
	gpTO441IbTkv4IpLPieBz+smefiqdVbxBioTYqqvhgykwkoMpIMM1yz1Ko5VINazOVrg585MAJ5
	gn0PATHRbWLuCvA4UEZquvjW7gKrlF2GA8OG3jc+X9Q0FSxx4UpZkUgq1nrKqmOnFClYxbrZlC8
	pwnQ==
X-Received: by 2002:a05:6000:2084:b0:492:46e:d4ce with SMTP id ffacd0b85a97d-49c6fd932c8mr25238543f8f.13.1794903938925;
        Tue, 17 Nov 2026 00:25:38 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5ff2be55sm26907832f8f.28.2026.11.17.00.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:25:38 -0800 (PST)
Message-ID: <a9124bf1c858cef3e8ac06b1b2396dcb0e19e2a5.camel@amutable.com>
Subject: Re: [PATCH RFC v3 02/44] nvmet: check that the file backend
 supports ->{read,write}_iter
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
Date: Tue, 17 Nov 2026 09:25:36 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
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
> The file backend calls ->read_iter() and ->write_iter() of the
> backing
> file directly but never checks that they exist. Everything that isn't
> a
> block device ends up in the file backend. So a namespace pointing to
> a
> file without them calls a NULL pointer on its first I/O. Only
> buffered_io=3D1 gets that far as the O_DIRECT open fails for such
> files.
>=20
> Refuse them when the namespace is enabled the same way zloop does
> since
> commit 0c10f8a1a7ae ("zloop: check that the zone backing file support
> ->{read,write}_iter").
>=20
> Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/nvme/target/io-cmd-file.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/nvme/target/io-cmd-file.c
> b/drivers/nvme/target/io-cmd-file.c
> index 695963dd932ee..dfa8aa46188c8 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -47,6 +47,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
> =C2=A0		return ret;
> =C2=A0	}
> =C2=A0
> +	if (!ns->file->f_op->read_iter || !ns->file->f_op-
> >write_iter) {
> +		ret =3D -EINVAL;
> +		goto err;
> +	}
> +
> =C2=A0	nvmet_file_ns_revalidate(ns);
> =C2=A0
> =C2=A0	/*
