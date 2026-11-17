Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904594;
	b=xH2f8LDHQFUDlScO6dkmNEM4JQuSOk0mJs7qHWq0IMawN0EJzy3qfQSEavOXj61bB0+E
	 axjIIV9/1s+Tax6i74rspauQB9D2vhyid02OKSJoHbXQhYGbBrnGx4GBiqM2HjfsSprag
	 knxcnKF/ALzTssoJAHOXkLJQT6qYVol/+NOtd43Afawd1F8JiJUtTQtKGwMy1J2cciDW9
	 //lxUbKDJNSpB7rYlO/DIhsXw5l9kiHeuwjRcXeZoGAgIvxJ2owIq5vtlFC4ysoQWBi6p
	 ICL5GAERJzMZRY/Fyb0SCrXbpkCrCaSV3d/3jl4Jr2qpRjnzYUv9rySI90EYU0XHsBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904594;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
	b=MCLbNlJB5ADFy//RP7URg+O2Sg0PRNm0ycU91y20slC0yvwScEg+qwlsiuB3eq/AZIEm
	 GTF/P7eJwrMCVdwm9H8IHXb0jyh1wvyLEQr6rqEGEdp+6YLqDOpTM1VOj5+3e9fX/a1ZS
	 TpnqDUdF7cmmaj00L5g69XjdL8VWQyeAnEUxYmgcwYfseXPUbPMROIpD78qxM+BI8De0b
	 zKKRzOw47T+mt/kwiSeZUtPVYRAOUhPJoW4p4sOpX3d8Rh/op7tbVCCpNNAjDoD68T4zO
	 6xjV9R6kORYSJ88Xm0gWINESGhHSHku86WNW0CFh9ummM5AkXVQsxcqaacxw7QFlH+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VB84C1sh;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08FE606A8A1
	for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 08:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D08FE606A8A1
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VB84C1sh
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a210470b49so35813435e9.2
        for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 00:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904592; x=1795509392; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
        b=VB84C1shjSG034pSk2oK3egXlQwWjuu3VjrdbAKPawk/Twv4Yif6yhPlbROFWtMgPQ
         3tz2NQZOgPBk3fq0QRZC/paJXFCSb8aJt/mhh+A0iXMTZvR4a2C4xo37cxqDT+bS5wyK
         cFfqQ64HX4H+WtOYlqmaNWk53bLD4rVzH3Dam/22N7EldMgTIeT60YiznWNjIzN+eEJD
         Zc6kl9xoD3REW2KAU35dfm9/7zuNgWUL6hteTTxoqyJmYKiacM/NYuvwNSKHsMwzezat
         1L4qftGlpMPZouPAaee8sA2dATEpRVvU+RzrgkUS2mvSj/+KFRi5Npjbd19v9tUdsF88
         Zbrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904592; x=1795509392;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
        b=I958jHNUYQWDkGa1ryQc2GiAq0ZLg9wMdz9n4oJU8Q2iRAqt8uZ+YtDGiH3NSB3QYF
         mKqTB4EaK3rrO7enzYUzGz9flxYk1YmPJK1VuBGEzITGQoClHj8P4nOs6g2TOmGRB4WR
         zJujnWx0wXF8VwCmPppoB5IgUmTk2+oe5FVcqCSWpYVWsjntl0zH5vYou7MEM9rfj4dc
         D1MYmaQJt4ovSJioD4p0vOObQpc+cQVICiswpQ24y74hXeJZokkQ64qR/QF2ldsK5Rok
         cMJ5XPf5HO4gxwJSBKv34JsniRXvwq2vMxg7WwH4IuT37JhEY9HA8ztBHAr6Yw7ElxEg
         NQWQ==
X-Forwarded-Encrypted: i=1; AL+hErEudHAUyNbPdF8VkmsslixmbLpagZL40gB7EFSzjsdEj+uj50fi9T8cGS1l407F2S6N+hcqtKJT344=@vger.kernel.org
X-Gm-Message-State: APuU4Z9qHKTzyFIvu7MadkD761CNFH1EpNrMEP8lz5AxRg43AUlsWkb3
	jHikvJcM3HeYRbrjrf1YQrwHhek6MHDAsLkG/fRf+58XRfJKoiA5ecp4+4UVD46sHLQV
X-Gm-Gg: AYBFou1ik6SISlE8oQuSKF7O6zUtNoiQXF4Ob2E949+bmgl4QgCyQDmo9+iGJPY4js0
	gVjIVjr/3I8wTlYYhO8HFzCqQgoP68h5qPn/ku5fECYQvylbe05OjKB58nE/oeFtCHR6qPSutqO
	xn1oaYnxHlAeFEWl3ew6FU53hl6zlPdXp1NaYzH0aHkVL286Aa4zdXQflPlTbpkXlaR3rn9eXpq
	E/XhUjCNX5/MQedfIMvClTz4LTp6KFszftfRgPJyHaCa44n5KwcK5jVbfC9egEZL6jz3+ksx+Wb
	IDGow3hmiqKeQuFM1WDLdrzQw2pL5w02jElk5EIZVe6RGhjlKTz03RzEWEnhKoaUIWwHdvD2uWn
	lYmHAFwFtuH5t/KBFDNcGZbKsgfn5op7HQTv2J5qsrIEOBvI1aIO6Z+NrJkshWUs6ie3ruwWwiL
	6dVypZ6lWVcneefxy1kDCn7H21LmVJqMMEr5dbiG1ogcciGNpxECSUR9olwsAJFmvCm8T8xobjy
	jLKHtfne4ieLnEFe70cJuGNdVxivKPfkU6VFLqc6V3jdYN7wvOqIfHT6aXuzEG38+HEfKFd9Pc9
	RY00hhqDSdxIibsy+Y7CW/KDMV8gTLX2cKHYaNl8aZ5LyfFOLCM7XvPkxzj1DDEh4WjeLBh1gwJ
	1zWTcT4kHuDFvQFea3pUHbJeYtMbgevj10YAjhXO2f/cbKLyfbCjg5ysM
X-Received: by 2002:a05:600c:1f90:b0:4a7:76fa:87e9 with SMTP id 5b1f17b1804b1-4bb55ab281bmr266345525e9.21.1794904592167;
        Tue, 17 Nov 2026 00:36:32 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78430752sm52548565e9.12.2026.11.17.00.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:36:31 -0800 (PST)
Message-ID: <411502f9a4f940c223b2b88d7e19fafdce63172e.camel@amutable.com>
Subject: Re: [PATCH RFC v3 29/44] s390/hypfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:36:30 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-29-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-29-8cbbea1cf34f@kernel.org>
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
> Initialize hypfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. hypfs never holds executables or
> device nodes.
>=20

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0arch/s390/hypfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
> index 559b011e68800..8662169de477a 100644
> --- a/arch/s390/hypfs/inode.c
> +++ b/arch/s390/hypfs/inode.c
> @@ -12,6 +12,7 @@
> =C2=A0#include <linux/errno.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/vfs.h>
> @@ -301,6 +302,7 @@ static int hypfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	sbi->gid =3D current_gid();
> =C2=A0
> =C2=A0	fc->s_fs_info =3D sbi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &hypfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
