Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794563701;
	b=g9Utm6KOgMCCsX791wfc2t+aWXPPKx7HJXHYDy8F6ZMv1nBslJ0AAxQE033fIxOb3R2O
	 SWQ656136OII9AOwP+3B731gyntqKddpF0zSUpWGSdxQFvvdcZA/Pu1+DuNMSt3xKzMT+
	 IDuM10wwSmNrxsGlQJVAfyPevyewxHnfavIfoaSzYha/VsldcCQL7SPPvLANGm0YpUmPn
	 1q5c68VhH5GLApP1o7o9/GGyInIFOJsHy1ygoldq0wSMMVs9npplZA9uxoUxvOt7OGo6Y
	 3q07QJLpbIHkpu6/ZjkssOkLFLwZ4LhDmpS6gS0kVGsBRfi8JkuMkk4JHfve2vMD0LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794563701;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=G8DmFU4pJwAPCJlqHBF8SKasEEThxtJNlC1sg/CSkLw=;
	b=FrSBHAMesmZL8isI7XuCdW3JZFCnV64N8sN9kJtnN7UtRRXYiefFkerj2Fm/CElRYhXk
	 1EBxz67KV4uvzmxNT5+oCSFWCV+i+N7g1xepOW6EeIjmxerdw3nmKDl8RvVBGLetvrBfV
	 ZWIhtyKmFdMq7q68tllQrEte1GobKvvXNEkwBVDhAkVHepf/qUolhOHrUv0/xEWIzuCuE
	 goNtFLHGw4o2HQJs243dzxxn5b91cfJ1TYlecrS/mr+F/GbrFSa/hmzOrQC+tIzgss3VV
	 daDC3SFW6UEDx3r9od3AT86BEbCV/B8udExgrqpC1+SzJhjRJXZyGfvlxRpypah8xyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=sk58W6sW;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CE760A260D
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 09:55:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49CE760A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=sk58W6sW
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso169260166b.2
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 01:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794563698; x=1795168498; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=G8DmFU4pJwAPCJlqHBF8SKasEEThxtJNlC1sg/CSkLw=;
        b=sk58W6sWmN4ERo+6S+koVh/BM/TVuc998Smvb7+dAHAHasLoIxA1PyH7SpTb2sphTs
         qaL8BceJIK/C5zTluK59TXAg0t7i18MIhSXKzAc74GDtFkVBtJ5XexxofTn2ErTCpEyw
         wBL0ZIwSoD+QdFLNUYuAtp3uhttIIU+8CcgeY50Q9BuPcdVkRSxffNnvhBi5q+TOT3Z0
         N0fPVcnw8avDa7R0wdKzwUNoVC/3vPRCD1SmgKjZfrkNv7BBIugYP8aqCryl3mRTzhIm
         nyzLSOhSkS/Bye+QA00IM2MsjhnUA408QIyungJaHYxvuyXbuTeC6K0dJcKnUnQNsCLo
         BJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794563698; x=1795168498;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G8DmFU4pJwAPCJlqHBF8SKasEEThxtJNlC1sg/CSkLw=;
        b=i8ke90gKbRW3XXW9vNZo20jM1FR09RieLWKY+xwp69BgQEZQo0BXUBpjF12UzssgHJ
         FQ2KqHMhW4SJfp4kZruOOm02Gz/wOkWT4mXStzfMFnso93MlSZi+FHU+2w7eplNWadEg
         r/PXqofxHIhcZTQrAzGUaqAJHtaY1vDDVzHfenwOixUdiVY/WIbfwFoVKkCp+4BILO6z
         4J0y3pSII6bpwwr0Lvlo1KomuwwmNVlZe+cckbWlvQUcMWshTYS7Kp1oUAgxafeT8Du1
         19RMvxC4x9t27E/CrMCtfduhiREvBgKPmncsLBr4RbD3p8mtjT8TOrqH+Orp83/+St7p
         LlZg==
X-Forwarded-Encrypted: i=1; AL+hErGmLJGzp3YHwGobetmvzgh/8gca42LGwS/XKmXFgyErqve4ZugV45GUJmDuTSAWZudqmSV5IzTTeG8=@vger.kernel.org
X-Gm-Message-State: APuU4Z9GFE2sJ9OO7LaDbWYqZQn9qlxrewh1dW5U9ZI60N2BmH/JiZZC
	vTY5qpLPSoFifQAHRBDatu+XJbFGgQfTDnZkyRgUvcIvAIvPkl/Me6gh3f+idUxO9WVd
X-Gm-Gg: AYBFou1lwJ7x8K/z1o1uH8z18DezkR+xqbNfNrxnn9q3vfbMSIRUidXUN3O2eML0Bpr
	qnsaRxQks+ngg6zOvG8xf4aUOJzWXv3datgVkHUK99UGzCyYb7OtdudoRU7KHpcmn98rKGwYSL8
	Lri7fVx7iqUuJm3LKEGS8zSDOg46GC6tIM7smJJfV4GLk91iolig5JplOZ2LkyGzkNriIu8TSvj
	XhhBHo69wP0anorfDlbqHi3h+S1794t0I7jKnuBLLZpoJ+QMDeIGALJ8hck9yqikqTRTxOHyNd0
	uNfpNLgucSjLCk1XitxMLgK07KXgPQgwQmorT8elKsoXUehyaADWK8mSjTg5+euA7YhyTGwNYif
	wbvmUr96RFv4Ueh+mdLNri2DezJN1BD8++d/S1+/RH59XjhOa3NA7b245dru7Daep2J6wynOvCN
	5PTB1M/QtaJ0PkjM04M4fHh8yngGDxe/JN/bmCksEY8QasXvfmF3E7K03PHJ80PVtzx4hIGK8Fv
	ELNoZNwnslhJBWQJNUmr40///wyxwsbqNSZtEhe6MaISdk829aTjS/KH48xqK4xRAyELB8/C9pA
	qeVgUyuecmYs1yLR3Vaz8/XKuhkhXkI7YnLPEtMaVHKlXFmVUha/IHKOLjscDTA=
X-Received: by 2002:a17:907:ea93:b0:c41:4c20:5a80 with SMTP id a640c23a62f3a-c50963bdb9bmr198299566b.44.1794563698514;
        Fri, 13 Nov 2026 01:54:58 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c50957c6c1fsm75151566b.0.2026.11.13.01.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 01:54:58 -0800 (PST)
Message-ID: <b42c9f4d29a9cbea66929c95cc8f736f12703c72.camel@amutable.com>
Subject: Re: [PATCH RFC 01/41] loop: refuse backing files that aren't open
 for reading
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
 linux-kselftest@vger.kernel.org, 	stable@vger.kernel.org
Date: Fri, 13 Nov 2026 10:54:56 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
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
> loop_configure() takes any file as long as it implements -
> >read_iter().
> Loop itself never checked whether the file was actually opened for
> reading. Buffered I/O went through vfs_iter_read() which refuses
> files
> without FMODE_READ. Direct I/O has called ->read_iter() of the
> backing
> file directly ever since loop grew support for it.
>=20
> Since commit f2fed441c69b ("loop: stop using vfs_iter_{read,write}
> for
> buffered I/O") buffered I/O calls ->read_iter() directly as well.
> That
> commit was about O_DIRECT handling and the FMODE_READ check went away
> as a side effect.
>=20
> So whoever can set up a loop device can read a file it was only
> allowed
> to open for writing. Open the file O_WRONLY, configure a loop device
> with it and read the contents through the loop device.
>=20
> Refuse backing files that aren't open for reading. Loop always reads
> from its backing file so a write-only backing file never made sense
> in
> the first place.
>=20
> Fixes: bc07c10a3603 ("block: loop: support DIO & AIO")
> Fixes: f2fed441c69b ("loop: stop using vfs_iter_{read,write} for
> buffered I/O")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/loop.c | 3 +++
> =C2=A01 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index a3325ceab484..c96e35c3ef42 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -528,6 +528,9 @@ static void loop_assign_backing_file(struct
> loop_device *lo, struct file *file)
> =C2=A0
> =C2=A0static int loop_check_backing_file(struct file *file)
> =C2=A0{
> +	if (!(file->f_mode & FMODE_READ))
> +		return -EBADF;
> +
> =C2=A0	if (!file->f_op->read_iter)
> =C2=A0		return -EINVAL;
> =C2=A0
