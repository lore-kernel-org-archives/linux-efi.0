Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564237;
	b=IyNdsxjJFMrZ4SpMhEutUMjuO0uRyJSbt4c5HqCkImpD9RAM3qp4A654Z6Nudox6Zrt6
	 z0zAHDzRZjEnIukH8PPV+tf7EDl9lYVEiAargW8+8PbU9Cjo/lgwD75lWVBkhzcFIabGC
	 gAfYv24Y4czzDSWIGk9xUlWZJkdCoTmZUgOJxqQz86Ix3BzYzTDe5Y7be16PCGnjO27gy
	 +Alhw2s1IyM7kE6zV3+PSMRZLbWDxZhqwOZqyhr3DPmslEk3NeOVbxk+RuUUxcQ6yP5xC
	 xMxpsHw9qcRo1zi4YrS0CcETmsnxgTzZJ/Ajssd/7/RaOVC0tuk2ax76wFbJipiw9Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564237;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
	b=jEUkruWdVh4PU+ou0HD3XDBTSkZnOZHF81A7hqe1qcCCMUWBOd4tbQUzyFlnDK62JNE5
	 NGgo4evHiPXqu0CoCYK08C1TArJtvmElx5If/Gee4s6UBtKmbsp11+qKGjh/pwpNyn6QL
	 s/O/hHfAYDZi6wEw4yhL1LFkS0IW7e5dmzuPBiSmSDT2xZtO7MuAR63ZYzVG6CP/kbyV1
	 BjU3Z+FNj3yPTriBR39oyAl4j1O9zHbR0jdUFpMLay57xEoUUcaTLO6bIKp16ENL5WTbj
	 gAW+cQWioB8AAF8VCLi5eprbc2ueeFN4ooYd9daE3dzu7qeOSojoUwJ1I+ro8w71XnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HmOhZp1a;
	arc=none smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E085606A31C
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E085606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HmOhZp1a
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b56c428212so1145030a12.2
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564235; x=1795169035; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
        b=HmOhZp1aysVRSGcApaAZDLI81xyeSldeu7ePLUPKkH54FsFfnK+QDVFY4+VQQZDD5I
         H2HloBZm5LZmO+0yz1W9rfEhaL+YICMUwpLNmuFaGXNfAv5LYB2fsAN36refSeHGX9fO
         cryYVQ+kM2KCw8u+OcP3112ltvgpCHGvfl9d9GfdLtqmNcwNDmKz3KTPAT46qO03zj8M
         uuWZNkUaGTWe7Ooua9eiEAKQiiHx3qf0rn/l3lNWMOa2sfege5hzg+R5XNTSj8AN0bpY
         dCBAZCrR4vjcQdomnF2hzC3FA98LaruL1WYTiCQ1DC9kzlEXZqoLyeQdM7U6VrMRD1VV
         Lr3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564235; x=1795169035;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
        b=cwW4ZhtwsK7oze4+AJNklwMuZ9soFF3/h4kyVg4tPwfneQQE7N1ti3U5pr6VPa07IW
         06CYXyDZoppajmEhGuSMrTeK3yq2xDe2eN1P47x9Bi3+tLs9TMZgKT3H60swq0lL3tLX
         3CxdlsSm4pEQZt+0DObIXJ9vHRqT8lD0VNX4ScJaJgAftHF4VYPfPzIr9nhEdns/OGqy
         azmA+LVtbwUTILHpJ/4MwOq8YqYtbeXZv2llqdhu3+Bc2jw4cw2WvmaqoUFdG4LvjzMf
         45VE6SDSzgKe+lV2VR9095UJfgcvlamMHpQMj7Dw70/ChFbIOuM6WfxbbTxOeGSxhNuN
         ALHg==
X-Forwarded-Encrypted: i=1; AL+hErHTmfB4h1zTf8CjtIbzSqM/73z7N0V1p4WOV5TLhHYEvX6c9kuht9tPpFA18PkhjiyUUKpyidCqcMw=@vger.kernel.org
X-Gm-Message-State: APuU4Z+iuzsYmJ5D/uutKbquLqKkFdxC1VmNhbqEfXNQShIg09DuscMj
	jxczQnwdEj+PT1RZ1pqyETeXmhhVEJ2Lsu6sFHeGfguJ19TX/okMhOHIZT8xeLnCWD/Y
X-Gm-Gg: AYBFou39XF50UXQuebKUUlSa7bN4CFNNak4/6UL/v04PvkDvto13ETeM4vhwgXu3DuD
	0qz9FRzNb0nWE2fJZs1LRgW8BZnH7rjlNz17cjvpYzdP3tSdDii1bA96Zy2bkTkxaiNXXGEzc0V
	ENCmlHDhczsxPM/s/tf+W78ar2ESgNwYrY+zjJ2aSHUSevk9w4Pn50bUg3rYF1Jpg3y5JeEfLR8
	gZEB0PjTpIewQlS7H20kZBNJkg7PtFly9TBpdGgZA8NcfKQ/aK6uEsh/nWIH7dg+U3iMU6Cd64p
	sAn9Y1laCcKMEtUkTadKmDm4f+93RRPweSNwutecdkBwGz92iGpW6af5p3CHmKG4SmCED6gtn2z
	oMBwvwsRG7IQVjhMru8Wkw3ElU5yiIlJRaZr/xyIqT9/AOSGZaYUfgJsU76oQPirzZRjoxKemiZ
	VWzfKSBbE93bwkRoTxUXyRvcq6BKBgRm6QUe4tFfHHO7xGSlcduIuu3WavlsVncb97hsujOzgNq
	oMbbdeLEz8nPXa7D30bst5FHDz4IzDcOg/LgNh8dmXvChHGxH2CKvQFuYI49VpUNZvdxq/yOHkH
	T/CLLKoCGW1HH2hZd2TqvY+GsctzhPyLSpWlS5jfA5430udvwS58958hp0rXgrM=
X-Received: by 2002:aa7:d556:0:b0:6b5:96e9:ae97 with SMTP id 4fb4d7f45d1cf-6b7c0ccaafdmr1234919a12.34.1794564235160;
        Fri, 13 Nov 2026 02:03:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23611casm766458a12.9.2026.11.13.02.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:54 -0800 (PST)
Message-ID: <16dbddeb5cbb9613dc806b43fc681eb26aa3b0dd.camel@amutable.com>
Subject: Re: [PATCH RFC 10/41] nullfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:52 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
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
> Initialize nullfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/nullfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/nullfs.c b/fs/nullfs.c
> index 319c2f5c5a67..2fe24cb97160 100644
> --- a/fs/nullfs.c
> +++ b/fs/nullfs.c
> @@ -2,6 +2,7 @@
> =C2=A0/* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
> =C2=A0#include <linux/fs/super_types.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/splice.h>
> =C2=A0#include <linux/uio.h>
> @@ -174,7 +175,7 @@ static int nullfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	fc->ops		=3D &nullfs_fs_context_ops;
> =C2=A0	fc->sb_flags	|=3D SB_NOUSER;
> -	fc->s_iflags	|=3D SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
