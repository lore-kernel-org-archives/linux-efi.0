Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904513;
	b=an4XI3RjNd29p/a2r8JNJEOz7R3Bn2ipZM/1fwc1gd1H172LRc7wI3nUasQScCQPMbXR
	 E2lTonXRxvzUUuYX7+po9i3Y+17LI+M4DgWqsDeyM6siG6YRic2ZG2NYsaACbim7LopoP
	 crjmrSTqbhFvJ4q+06zoYmeSrVfPQ8W2qVRVMIb0k/Y94NUAmFuKohCS8i6o6wA+l4nNK
	 8Ck7e4wZNK1+wSW0MrXcjHwFVt1zGxZjdAvUZXkiXgoVb+YoU8RirLkFF+r98SyyKrVl8
	 wNKylhBpezuxTUw4dyuqWQoMdooxILWR9ZUVQ6lSz3EcoMza2YzlABtWJOnouDi8HlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904513;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
	b=V8JQfYd1/vVyi0LWCkl7VzXw9AOhgICRDjKtycp8GEOcKW+jDJxsaCyX6AMAbYwlifZe
	 020A7Q2uM9fOo9IHWNbMq/6XKrI6yCzGsRz5WCHkImsNgnHTc8zpe5KYU54wArI46/CK9
	 X5YO8ROaxxQXPn/1GdheCi2+io5rXzYi67QbX6dvuws6LkUY/2uCLwfNlTG8NtnIE6Idh
	 8wCiJ3+qA8dckxSySCuYHBBLpktanR9l9a02kJjy0Ygo0prXWLWq3GqEDVdi3pElnW07l
	 T0uZEoN9J3kpDGPil4lBpgMW8btRjiAFiEbshG7ECFeMv/Pg43y5zD/sfLhvPwfuPSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=asHWLUHh;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BB7606A8A8
	for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 08:35:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99BB7606A8A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=asHWLUHh
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4a33359c1b3so506524f8f.3
        for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 00:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904510; x=1795509310; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
        b=asHWLUHh9Osx9c7ISjHVvBK+jrwM+bEKiKQ5ZLUG8jHeL8cbDrdmay7aq+azwtlrvN
         q7YkHw224WJQO7TnM1AyMygFYXrlY29jKpq3C9XROr0oTqsA+UK4p+WS5GMy+xx9DTRb
         nuDA+OEO8+ykjkDq/RDjAwEfWgenycj+snq2KkG6mulygb6NKchr6plM71+t8W0/+aGL
         LigMC+giRqQ92TsunABClmE52NWQSdRqhQeez7lH76lemvGh63Ic8nud3Qte/9KpQmbQ
         YrdviXjfG5hlS64KIE7Iq0kMRVYmtZMNK2hkMRb6Cz1tihRk5N+J71aJKPK+K5E0SOED
         KbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904510; x=1795509310;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
        b=GGX5J182wvNdryaGUbQCQnOPS6PUOImKJqxMQRLI8Sch4NFpIYXRfscE391YVntHBC
         Nxfjyzk8P5RzU5jDP88jP71WqNU/U9BwTrJbjVh5fc35eXrSaEfwG1wCN9r6bZav7p9n
         RYh0jCAH8L1zGG7YV2XL6MWm0HlzI0DbU/qVRArsIuLWdvK0PByJ6Zru3Y21qRjkWwaL
         OMpIqqIktWYV2js6Bi/WPYY1bs7a3WqkKelr1aTnEmXh4Fz6U3clq+aL5mpxDmTZI3qJ
         rm06KUIx4+/q9ztqHPMD/0bc9e6wLwaL2YnlgToEQDkZ9MB3mQuHpa6y8gxRveC/FlsL
         bnRA==
X-Forwarded-Encrypted: i=1; AL+hErFmxS2Ric1yuUECQRrWkCz0tdH0ZTG5yrMwa2mv+egOpom1aG2CvF6zx74lhfVDhSAg8ATPhXW1kWw=@vger.kernel.org
X-Gm-Message-State: APuU4Z+qxTAUT3fnLlo1xui/p9IqylfyCzpA8CrSBBw5EYdA4nsHnJKA
	oE7uMJkNzYCOHLA0G/yAu0K3gGTYJaxdMjvkKI5E4FVZDaP86IZo7kEEFgHrhXL580E3
X-Gm-Gg: AZFdTZdbmcQu4X3Xso/lvdvHPGtDWjWZYSXu585qt50k3TAvNKZkQeu5Nuk+je5oc/9
	3/rvj4IoFoa+J/iMxDBFnRt1tobhYu0LQxg+I7f9HCgYuXQk2Y/jIBkkDhcIk8cp24CbSvnQzLb
	yUZdgTFC4jwMMi63v93LADXPd+oms0m7fVN1QcZdjssr/a+B0OeUMOllLPfED9ernbDM9ntMnPM
	Ag8VoyLhQMb5kUcv7BdW+mGSBhDCQK588RsxZkPHs4jE8u7nhfsdep+QLGhBnzutrWHie7HlEDK
	RGhKWe6vF6xCVSPRH7/9JetWNoHTnAEsOqgZXGqCjh+4KSts3ABWPb2sLzOzE/CtWopvo919w5a
	Nqqy3ZRMAAkHMHw1QnNk3bRez15KZagJUOvxTVAbYwoga2XqripYTRvzGxlP8b/DJd9CIW7Ngg5
	kw0H2O6qeP+zItNekEgKdYp9YNttVo5FPoGYTUGzVImv3RIPXsDVAmNE7XxLZL8le3b38HCNAqU
	1MstAkPzF/2OiTEHiDx1Rz0DS4ZKTO1rdWGJSiTVulWBcjHxHG1XbH0vVP70ED/4M4gI5CKwIKz
	F+kNRGIZsQPtlrTXDfLeHbnb0m3kLRXY5GcPkz9LmuYwamSD59lMy4IE7YkAARRdx4RCy9yo+rW
	LURMLWvoTz8Ei6qDA+gL6nxKYwFz7mUKsaaogKkt0zKpMkoZpMtBczawu
X-Received: by 2002:adf:e193:0:b0:48c:7306:18e9 with SMTP id ffacd0b85a97d-49c728c6e6amr26569239f8f.43.1794904509932;
        Tue, 17 Nov 2026 00:35:09 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4e2esm26338505f8f.36.2026.11.17.00.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:35:09 -0800 (PST)
Message-ID: <b0ec2cd8f9b7a6a2e4a54c6df2fa897bce068cbd.camel@amutable.com>
Subject: Re: [PATCH RFC v3 28/44] ocfs2: use fc_init_pseudo() for dlmfs
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
Date: Tue, 17 Nov 2026 09:35:07 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-28-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-28-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Initialize dlmfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. dlmfs never holds executables or
> device nodes.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/ocfs2/dlmfs/dlmfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index d3bfcada3e3bf..1789ec96dc130 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -21,6 +21,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/types.h>
> =C2=A0#include <linux/slab.h>
> @@ -563,6 +564,7 @@ static const struct fs_context_operations
> dlmfs_context_ops =3D {
> =C2=A0
> =C2=A0static int dlmfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &dlmfs_context_ops;
> =C2=A0
> =C2=A0	return 0;
