Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904007;
	b=4cM3UhGSgiizZqbwEpWU/HApHH5T6bBm9GzthnYoWtixXGx4tgjhBR3cebnQPWwWY+8z
	 H4+9yNiMGvXXHT1loy5W+RXRYygIcgGMZjfTzHyIpaR6wtQX5DwI8xA8wS7tN8JtLfqve
	 co7NzgzLP/qbu3/IjgkJiqcXqHj0xMKQyvetOHek2heV2AebPUYrrottu5uu3X7HG+X8c
	 5BMAeClGBGZkzRfibIafx1ZIryBjWDRWaBDiXYdG2vTQLC1uDs5OB8MlUqn0+xDtltX2x
	 S0quK1N5fUZ2gy8VEP7myG8dzAstSyLIJ/GIIR8W0tiIRCee3TRUgwIprByQYM+LVVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904007;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
	b=IgX0XNMzWEHHfNtEf4Ms397goo0Ioo1GZ9PqtZNQL83MJ0rl09WWzrKqz3s8b5V/Y8wL
	 XXUlTgFnLHms57/5xbtg+M/+cDKfxs/DSy4yxpu6eiLFCavOcnKi0pYM5DX5Yb1hyBHGu
	 YCI7Vs4TkjmVw3Zy1QyNcs26C2mxUaD/G6NZEil+YjiqCFdsQeR7GTToj0Wzh0UM326xE
	 /4yWn4UkzvgfhaUeXb3TmVMc99zQNaT6BU28f8a3d8wipvtQIKHta/7VjVE63U3KXGmez
	 DgStPFWnfRU0OkrmrSF86lBS/ZA9BJ1hVaBUwA/IM1SY2BZK5JWQXZjT5g6glApz8lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Bh3COd7Z;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4764C606A33B
	for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 08:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4764C606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Bh3COd7Z
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-490d59c3f0aso1759280f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 00:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904004; x=1795508804; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
        b=Bh3COd7ZzI6TmZdb32Fg462zWvuh7WQNnrUpXucHXcpV5t+t8gMfKKxOWwhkcHBcNt
         zIJKpUT9Ten8K9xmb0ZHj3p/ljeyNVefWtOpjWCo7Igmb/P1wzmYs63YOxLg7f+WXmDC
         wf3ao9cg3f1DrvZE/oBKoQiWFPBKSPnWk+jCT2CGoQgxeoDuJREjXd8oRMM0GizRyDLq
         q7c8W4Fdq61I08pJrjWNPm+S1jXNjmZ2MpEutx4SYZ/JoE6iRzvUZ/uRuGO7TyWDBzw1
         OlncqX8aSwrA8zDhY0Cn+N6eWM3qFfFk2ULf9A0Yk8lhKFDJjJXQbcxKbI+h6RZ2p0E1
         0Fcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904004; x=1795508804;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
        b=BBPICtsOd7u5rhuWBkC07rpfRdu0KOsh0rFq9nn0Ck0BIT2IXCo7MIQFS3VN7u+67k
         vvN4/rIk2bKdttJ4IEV/c1UM91KplmGm1qlGhuDA1Vp/6tbd1mwXuLEnzciD5OWNzX/Q
         Ur0ITZGCGwDOl5ZNm5xDkN3i40H35Sx3r68bz2jqnPEWbjcZANyPqZMrnstEKy9m3X1Q
         eLdgxyw7cqKfBXdpnwpDW8Uxet5LvtCbHDuS6sG4ijehKRly/DC5lM5ycko5oGh4CaOj
         osvlOJHG+34EEgmlu8VIzUgZ87zv67FJzTOmBSDnDQa8SY/0LkRQEGVR9W9xviQ7GpnJ
         lY7w==
X-Forwarded-Encrypted: i=1; AL+hErFt/K87POJm7THE6pqGCIHklhhjW8LeILOfzHk1ts/nNLPvo/fAtI5VD+PEK9fbZaakZ/whR48Ujtg=@vger.kernel.org
X-Gm-Message-State: APuU4Z9b+ICJVlWH8vWIJCPzP2xdvcGmdMdZAUEdFwL1Ly3bCi6bBXac
	XDKPqYmNGGu6ISJ2tU+b5DMCbxvPTavN0A130K9xAd4vrm2PsLIWtPPZ5mfmy44fSRkg
X-Gm-Gg: AZFdTZccTA2mkFEmy3kiPhr3+jH0gbLozs7egjLVKc91Q3W+znyPeYG/PnSEl13j2+D
	Gg07afSzIfsSWKWwexKu5tmUrhUHCRp+MTOqKOOTpPZ8VZXxw7Sinr1UKwq+kk7t5zA/zdOGSPt
	L9swwXh+lcC9NuIk+qmrFGAM21i1pdSL2DNF13K4JlL4HIEV4jpFkxSrprdy+TZXwc8zkkV826n
	IOEeNiWrUhw5nYZaMY8q5ZV/1ggHyG4i12V0qByH9aHZOGYs2p67oaq2iZNV5Qr3ELkecq5WtyI
	MSCPyxrI0c1n9Kay2eJMr7IFPhAFhkJ5RjdMESeroa4aHtcoVez0P3l5p/1uqFmvMhbYcn3dKR0
	CgRp21CK2NvO+vo/3J4ArgqMaSF0kVHTyhKVneL9LXMyj84kkWM2UVQ3sksncIIowblxilrpeEn
	Z88LLdTWetY5BQ4W1GbRbUAdTcUnjJFYYXaApdXkuXZym2IOKVVci75Cd8y3BM4kczhv12XOylH
	5fr75jFCrSY7P4FTU2L40Pse09MypyRHqYGL9FLiurj7FuQYSDNTctLE/eUeze5tIJshZPnVqbO
	7M2P6hRgpclm4SUMvJw7+JIMcwALcV5RMSy7mHLgNWEH+2WLMPD9QAepN7Oxt8PC1vYwWQ90X07
	bTeORkL7s0E0EsiZSu3aodvXq686CS6n1NgimOwktCgw0i8j3NJ++pavz
X-Received: by 2002:a05:6000:2009:b0:4a5:2e5b:51c2 with SMTP id ffacd0b85a97d-4a52e6a947bmr243585f8f.29.1794904004601;
        Tue, 17 Nov 2026 00:26:44 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a4de4cb1c3sm977858f8f.8.2026.11.17.00.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:26:44 -0800 (PST)
Message-ID: <c43d70badf41f62f8e149ac024bab3df979fa756.camel@amutable.com>
Subject: Re: [PATCH RFC v3 11/44] failfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:26:42 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
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
> Initialize failfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/failfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/failfs.c b/fs/failfs.c
> index 437cdc981c2de..f03334f361c0e 100644
> --- a/fs/failfs.c
> +++ b/fs/failfs.c
> @@ -3,6 +3,7 @@
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs/super_types.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_struct.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/mount.h>
> @@ -132,7 +133,7 @@ static int failfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fc->ops		=3D &failfs_context_ops;
> =C2=A0	fc->global	=3D true;
> =C2=A0	fc->sb_flags	|=3D SB_NOUSER;
> -	fc->s_iflags	|=3D SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
