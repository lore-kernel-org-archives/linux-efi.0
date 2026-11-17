Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904088;
	b=jc80kaPv7++i7RyvLTLDq6l+Oux8L0igyQXYFd81fDY3DZJK7aknH6UAufzFx3EvZOpS
	 z3jMen08BlfTHAQ8oQjDpXeQ3WXlaHilhBEW+5yXz6edYGwkM0i/A5vDROj/AclfWGhgh
	 Pf1roFHuycVCsAuFz4rM1Yb1T7iwRcs3imKXbxhAPZCnrnhGRNNz+1KZ/gMxqhkqUuvr5
	 lioiwtTA9YesLL24k56MVmXtzkNM0mCXWqgYHzNBd0jpdmEl5DABRSiSf8FGSNrIL7oZ4
	 N5Fn+v1BmPnggpauEHh01RffwpfG7HPYTOlFrkouPEUJGYkoNE0W04KeA7VRQQeYyRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904088;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
	b=YQM/nGPdkO9+3eaW1UxL4fqXFZokLnASoUd1vCWSln0yHn53Fd3fUJ0Flx2xkVk/RJKv
	 BzssdM1VFz9yvtYuFhUgix42Q/nTN6Qjkcl1xhO/nZUsgvcabHLe5An0aJYgVXFZ37Aw0
	 lPm2mfRcB6N6/tZ6k7B0Fo/Z44YciPB3arD72tHGRVYqF4omz31EwmZ87rsK9Qw0qcCdq
	 AF+2NTLdVre4OAX0KJUZNzHRY7lFuIeQ2FLEJF4A0+N3qLQCCrjcYw7MxLCVByN/SGKCH
	 l758LdOITXHnZXz8TRUGIX/eAThMpwkCauRs1a7Ps0ul1vyiuV9JETfFQ437CM8ugYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=G5kPAzk6;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC6E606A8A3
	for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 08:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1CC6E606A8A3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=G5kPAzk6
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso26232745e9.0
        for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 00:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904086; x=1795508886; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
        b=G5kPAzk6YKyHaocuCdT5IFslrUJH5/ldhNVhV6xYWUthrOIppv7Y8kBtZdevqAkpzI
         BDRFsu2jrF+YCozPia7EV1j3KLeZC6Lnc8BgBdPYFaePytvbOESC0m4eRkryqhoEbPxE
         WM5n2Fa2IGRg+WkSIkgfyoTemIrDdEbfzZV+2Eacmamzzj+t+HuCPRqV+GPswkKxuMa/
         2fm9UdrHUV6v7jtlgmqycAcrxGUcSbURHcUFMMj9LS/XjgTFJtp8hDDDARovdS596Fjm
         xwkar34XXNuYsLWY+RNo1AZ45FE/L69efZRvwjPbSAF3CGRgr3AaMHZz6Kf/cz8pCVs/
         RhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904086; x=1795508886;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
        b=bb3yZgulDcGLsNDUPFbBDDHgpQ6cTg/BUXaMX6W48xNjh6FKC+syOtZx0D1HRCQxdE
         VNs455wMP6HUe88bVo+9f2xD09TTDUsmVSfE3ENF1nvsdpcU8Rxke7Y9ffrMvzn7ilHE
         RE0+vetclBh64RyRbYtPWZb22TP2z7sepMaF3eYe2om+NNlc9AVLB0FPjHM9964M8WDF
         d8CyXEmjzsx0dSxXGc/EA9jJCZTFnlKwV/7kh2l5cYtFCi7/+6SUamdZ3ZsYDJHynNdn
         5S8oxnQvJwgtHYxhXz7xMz/82iY15ozETodWIuxhj7TL8goJFTxzVUXlmTIkaa4JSsyV
         SxAw==
X-Forwarded-Encrypted: i=1; AL+hErGKFYeaDKHWUVTbddPbXa2W7AoBQPOz53v578l8NG2Rq5DTWjPGCfyx5ybXSA55M29LN2Y9EUGt+Hw=@vger.kernel.org
X-Gm-Message-State: APuU4Z/nyp5e3D9Rq6HNFzXMna/bBd0Ur/uKkMl7ZA7T4n+dKwcaAzNv
	BmukXy2w/O9btCCl5wSpB2C+e2Mq29ibfDNzQ4RaQdbmKOV0fSoRwdCzhd6bKqcti4d2
X-Gm-Gg: AYBFou3Clwfr6Th8YL+nqyAaFrn+2jWqQU7Y+LNIdT8JOfgJeylsDS+eBMiCPTlCbJQ
	qj290G4wFXzoGDsMZqqNxG+w9vJUOzv1ngKQn4qFWnx3iryaWBpdcGZZh4QH8w0+lji7Jp4xLBV
	G2HPdcxASNlJRQZ/hffnwZs7gxKpagKrcsQjOru7WtF3lJ9L/V1fIEW1dr5AG5LNf2tFTY7m+PD
	lOej8yA90UHB+UdB9JpoLkns+1Bf0ltK29KGBGe6+K5P/1LVWlpKpdOc7gxlQ/77tVIlBVZ2DLb
	H+z9+sirwq5uYXu5htLZMKUJMTrMeukhrtbE/SdB+VGumaJv/kEZirIguATEDFt2ec1Q+CYMFH/
	fK7sClvF7BSf2dFw3kIEUAEesZJIM9W3TbY2Yuny44Iizfz7FgHkP/PkqkRz78EgKTsjNvzGy1b
	NrbDH3xd6LuRSvVP5Jm3pMJULJocvHOoPE3ms8fzZDNwoZTrLoOYVtvCEU1HlH6dzgdnjqhD/TD
	zPNSQ6K1nsVglLroAKW8HVe4OPGcVeqhVG69qsH1DGzuFd1dZTu47ra72vUVAPuMgz0+9Wp1OxC
	uFl8M5ogq/W4m2FXA8aTB9XpUtbHJDzoDeErMs463tZNtfDsPkJmANhi2f+ITGEH2Lk+c9DGPKZ
	2KoyaaewEswsegn+X7K5LkQSkRQDXX15jHfQ2vJEe/EGD9eSvSla56iLF
X-Received: by 2002:a05:600c:512:b0:4a2:a9:ed87 with SMTP id 5b1f17b1804b1-4bb55a5aa47mr209766355e9.19.1794904086313;
        Tue, 17 Nov 2026 00:28:06 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78418853sm74782845e9.8.2026.11.17.00.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:28:05 -0800 (PST)
Message-ID: <fa0ce0f7ecdbe91cc6773bcbe86be137d2129944.camel@amutable.com>
Subject: Re: [PATCH RFC v3 21/44] nfsd: use fc_init_pseudo()
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
 linux-kselftest@vger.kernel.org, Chuck Lever	 <cel@kernel.org>, Chris Down
 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:28:04 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
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
> Initialize the nfsd filesystem as a pseudo filesystem. This raises
> SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
> executables or device nodes.
>=20
> Acked-by: Chuck Lever <cel@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/nfsd/nfsctl.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index f32311f2d7cf9..ce2666deddbd9 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -9,6 +9,7 @@
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/ctype.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0
> =C2=A0#include <linux/sunrpc/cache.h>
> =C2=A0#include <linux/sunrpc/svcsock.h>
> @@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &nfsd_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
