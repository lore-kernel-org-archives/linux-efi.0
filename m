Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564337;
	b=vEPIUWhLC6W+k2GOqG51p7a8hKkdRK+VJdaexhN0qj6LfVm/j/HyM8yogIVpa6M3wuWv
	 8w/jOcwkSN6K2rhT5BNsqGWhUqXXO3OcCiHz3c4IXVNErFbsBjM4buoobh7z+Clx1ajNz
	 jYQ2LorwV7XU0RqqlvK/a0ms35wBR2VGsBskAKfBDjuTz2XtLPLf5uemjifB4EVB/epQW
	 EP5k61oKfR93jEp9KGn3hP/P+ZW5gTXnN4sbWYNZvW7zTaDMy3YduN0GYAbp9S0crFn1o
	 vV0a7TP8H5uYjQQTtxOZd2wJicewushrBMWI4tFpEINE8UaMAVu/AzSeL7aK+9GH6Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564337;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
	b=sOEnqSu/lf49jwG2s09yQmJPIM+W4+35LM/EzWL6LTeKDiebUjENpBGPtPw7PbHZR7Gu
	 5xOdIitDyvs9fmO/Z/H5dIIbsSl33D10iKxvToDqHueudDkPIMJyba8Q1Qwagd7DgKB3x
	 kZgyQrvP3j40XZKaaaaEImk9O8dD+4t4n/QFjFlt2jSdmm7XskoJQLMP+jiWXXu9yTREL
	 A5EoGGxgO4G+CFSTYykA1/kwC/JEBKf9D+5T7eVqY05mfYKSDFhhbBWEhOmBMoPZKiDhS
	 Lx6aBihqAn7REsEcc1je1yItMS8ZUtm33qQfUhhW7/RbqUj/kWsopsa+Ap/G/CVU5xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nUCLd8f0;
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4CA606A8BE
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:05:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD4CA606A8BE
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nUCLd8f0
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c40f29667e6so164614366b.0
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564335; x=1795169135; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
        b=nUCLd8f0G/K2fMNIytq9u2LWpw8l5XbCSUxsIs6+S5nVG1T3fI5ErIjnpvRMTRJ1g3
         66+hupjWTQxex7ntfQ08B69tN3G7DYFzu+MIzI3GxWcQnqgZu7yay01l+4mpEhy0Ef02
         xbNHIv/PH0KitW7ZH+pZK/qyW26JriIVV4HRgFAXvls3DDajVpT9R5cy9rfpfJ9qOhH/
         quuiU6KaH+bd+1MNp1oe0tS5lHpOu5FifqraRZhGcQQrLcBdrSt8hi6RHYJpJDDneT+2
         609Jb+e8BW/fqMWXfEgOdGZ8nZZS6I2LapQ01HWyupMw/vLrZIn5Q4gffAveGLQARYQM
         rrlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564335; x=1795169135;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
        b=F25PkpyrMuQEhLFUhlZpgjHGel0u+SXE485lMEzT9psBnCJ9TKtlYfhus6jdMQr51M
         LoPrZwR+47S0aTWWlKR7FDrnmp9vfrFZLXzd2AtgOlPCdValJvA/RCVnTQoYLO6N2Qil
         LyirIX/LE3NANuYWLeIGkODXAk7qTBapZiv4q4xlR6CqL6SNZiCPSNVeol94fGyOYcZh
         hbhuARRTR3XhQMK56lNCaI7TyKxLzSSX7x561olT1jmBqVkQn8n/C2bo4hq0oN7wTV89
         JKsQtRYsyp/acNowTu4C0shk0CQCgjWjq9qB80ODNuFSi/ChoVTxiBZVCI3JzuDseJPo
         NF7g==
X-Forwarded-Encrypted: i=1; AL+hErE7YJAjZWrk1BkuNDGMsdrwKORHUVXTC49k3qOwRQUH2h2eGp9VLsHuFuNSAAb39Tke8YioXk/IkWI=@vger.kernel.org
X-Gm-Message-State: APuU4Z9lzVGE2pPRGUGlP+un0UuXOkaesV/6HswUK8VY30xnaYocJ8+r
	TbUlvt1bckELDyYHq/AalEovL/IpUNQuMjn0Nwv1T1GPiPKTQKB63dBA5+JWqOB6yvEowDkGzTk
	/Koo09M/33Mc=
X-Gm-Gg: AYBFou3KhwTOWT9rlhKB088R5IqEGkIAf06AjNoxfnKLCVhVM1pzItd6uVDP27roR7u
	QSRygWhQhMuVVtMsbELqcAO6gViUY6Z5xjSurDXaHMiVPVETwgNS3lldoE+AWMceHdkmdh3ofcS
	c/fV83ocS+GKRO038YcozhIBY8qOxKPaljPhuPY7gGKKLfdmHTTYeoaO9g01bLO0u1vJLPSFrTB
	Cg1v72pecdBKTYo+vxrO9ARXr6n2BzQegAVKs1HyGcNRPyzSGxH1jpFhVTly8oWZfHeKZdXu/zk
	M0c5C+x/s3H60njArPTW9Ws6gTo+pSl21hcCoMWiZ9Gf/IUX72GsYg+r08gfylbzspIP6wss1wl
	5Q/0X2LyBY6/EmMgdTY9+BH/sxysbhqlOkMzTn0Is5IYzfxul6KUFu76NqzJwU2n7Jj4VHHfvca
	9MBpZlTrXB1617Fuey8LKuY1VF8Y3Pzrp/L7k4ym45p8QWKB0MeT/qzqOm45zg1NvPi3LQvan+v
	wi8E7gmZH/sjHlq8bLBTYBpFuT1eDAE8ZOv7UmZA+mKkkb0AXYFRi7r9Ai+74R0oE2kg6FSsPVX
	MvElBaayta7ibu9DOTvdsbEOccK2i5HedSbx0yUhMFxgHSB8yS7QH1pYgh0pzuLCIqeHEqmDmdS
	68v1UnGOv
X-Received: by 2002:a17:907:608f:b0:c43:eae5:ee80 with SMTP id a640c23a62f3a-c5096398b03mr148720566b.17.1794564321873;
        Fri, 13 Nov 2026 02:05:21 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b7b2c9sm75811766b.73.2026.11.13.02.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:05:21 -0800 (PST)
Message-ID: <08fa1be263cf4a3db6b3e5ec2847107fba7acfba.camel@amutable.com>
Subject: Re: [PATCH RFC 13/41] devpts: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:05:19 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
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
> Initialize devpts as a pseudo filesystem. This raises SB_I_PSEUDO and
> SB_I_NOEXEC. devpts never holds executables. devpts_fill_super()
> keeps
> clearing SB_I_NODEV for the pty device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/devpts/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index bd1e8eb26edb..47ef12241d92 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -13,6 +13,7 @@
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/sched.h>
> =C2=A0#include <linux/namei.h>
> @@ -438,6 +439,7 @@ static int devpts_init_fs_context(struct
> fs_context *fc)
> =C2=A0		fsi->mount_opts.reserve =3D true;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &devpts_context_ops;
> =C2=A0	return 0;
> =C2=A0}
