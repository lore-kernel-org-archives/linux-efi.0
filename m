Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794859451;
	b=OQdsPshP/hrMiTc6FEfXTN2HHWToXyqrBO+YbNFN9ikqsA0wclHlhwi8qcFJtdV6BMPB
	 j/oZkbCLN9+kG6wtq/XfrTHoCSm4Fp+GbnQYIKGYuGQhZHay7zXx5uQVLVq7qw4+zDQQ9
	 CNd0MNcz7m1Laxxq3OfR/HZ2At/soXyHz5g+KxQQAKH8eykNAx8Y3IKSBzY1LRDGUvTct
	 BtVYxZw9XI9NU2chj4GjG1J5InnqVGgnhFTcnYS3OdH2I0ceNbkyF+fsjHUAEnsw2RUC2
	 qoIrLilA7A2+MFYd97JA9LLPbiiBxTZc3A+zw6AaAgvLTPg8QQCKlZDp8McnWvZxVVQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859451;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
	b=GQJvC8Hh6ttbliofQvov48iDYi6mSYSx67vxRIdZFhU7UwMDcWpNZ2fDjYQtbr7fFgQN
	 cP3b288nfF1eXGpyjGFywHAnuHG/KAGxu8LtdgluPIf/23C3gzTQBR8PnyL2I1UpV8wED
	 QrSfL7oql0zPiPLKEWOiHQezTzFqoficPQVCckGpXUamC0u6fZisEZy0xH3WJ1YkNQhUv
	 2E0DGZkp515GYayA3bNXwiVjcWcFqByFQgz3g7nE0Qhf6j6mz1+0kWIClJuQJq0eupXQC
	 AsAWMdDi2jaihgv+xcIZoXO56VbRQmIdmQdpem92RvxrJdAT3EfV9S+ugYog+ju48Jg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hnqDx80H;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D21A606A339
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 20:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D21A606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hnqDx80H
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-498f5fa5103so1736450f8f.2
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 12:04:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794859448; cv=none;
        d=google.com; s=arc-20260327;
        b=o/kn4zPYlYqRXDhbMuQ66eJjce9EOJcs2VezSOT1CGW+U+iWncj/A1R8dRd2OLDG3l
         /iJluGg5s5LdQo0v46G+R7A3UxfDO8rZGvD60xZg/Kd2O6pPMsRFiEPf3Vz7Oqumf+xf
         ne0IYV4/VEaipe89kBXw2fiwkV6Dkp/tbkuQdhvS1q0SbXRgbGL1JqPAoWcKaz0JkK53
         T03nsYZjtUABJAuy7pYgxYgiwnTNxabTUbSANSkOvvvkLGpKJqnhMIOSSSXE9WSK+otI
         Q65OFeXbIdu1tXEZOe/zmcSPe//vZf0BhXugqkFXaA7Bhw2Zk8zSoWP5usL3Q/XBzbjg
         kNgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        fh=DbzEQRD5co2jZYE1ljmbezBiBQdTLNeJ0R7pZkvxycw=;
        b=RzuV/oyrzwUUSyJNDC9Y4HcP6oB6frK+AlJ+l43iV30L+45M4X9LaDSpBmX/IsXDk5
         fVGa1Fk7NxDTzHbUulJ2dZRA7YaFrDYCEcBeTXtlPkL8e/X/UIrlzKLuCTb92c6fdb8U
         AQI5N4GZ/lBuvSdijV2fPLccwJgwXxHj6O0VlYoy7YMM8a8oDhl+bl5wQLpmVp4zwVoL
         DsDf+F/HNuOx4Wdkh6JXBu9QtKkIG6CE/ycdJp6+/Kly9lbEO5p7JUNRgFwBBk5WsmRF
         utN8AStYri5MGeYrgOU7IpdKXQb5B9gBfrLs2Qz2KijnqrGP3u4smj8xbq/zxKDXrKmG
         ALPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794859448; x=1795464248; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        b=hnqDx80H1BHGMZ+jCw863LQE2wm4hG6wTw//ziQNWkZpZIjdyNNCtFJNcbykSvuJWZ
         RrqgQGru9l+9Rlw9NCoAO7RXSeH6CHzRwb+h6TsbT77V+vTLtC7o5AslWzWJ8+7yhciq
         sbJxN7Yoz6y6VYO91QUyEDVlXVHt5e/uzOZriYhKEljZIduQH6pNfhdOY5sHlJFueOxf
         bN/uTLfuNBjnHaTZ+WukZQS/Wa30tWyiKsfqEPmOKtkcPCgN1gGIeLsa9pfco/3ZvP3P
         koo3Bb9/+esUnHdHS2hTd5qtXE/k/xctadMJUuU/zchcL0VDKvTRNofZgdIQ6mLOou9W
         X5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859448; x=1795464248;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        b=0h+LIOxeKPjURG4ytxUTaBjtU3MRhvG0X1xdKKQXQDyDEQYIBU78hMxquPnaFo8Axz
         8PBQmZzhvYx9+dykqj9f9ysmmvjZ3xB9YjmemTRTbKAFrrdUBRQnczOn/1+XD4qrqo7h
         6MJOpQ5y8ZN/fDr2796/CEW0KBfCVGN0kWU0zEoB98BnZLYs6aDpnnpH4oeXP+8WgUvT
         Z1oc6uq4TSM/ewj8XZEd5wGLjGEqnziobcWv+JA9Qp88dY+vSZ1uX2jrpRjRz1SAp3VA
         JHlLw/abVmFWpaUy5Ti6owaab8yRmkBmLTFSLo09MLaMue5XQhXWoDKj4eLZda/5tdC0
         ysnA==
X-Forwarded-Encrypted: i=1; AL+hErGTHX2ymgm5RAZm6Gk7RrjChe6zJAduIIxMDVGV+RytdOl5dDKTtVxlVyk/Kw6zURxXlfgbPqNhQqk=@vger.kernel.org
X-Gm-Message-State: APuU4Z88XYVJwiZ4mOq48yLJqOKroFtGSgIAFiHZEiCF9S9gLxPF7meB
	hzK553+tFu8t9y4DP80vggq69QY7E4fgGxu8yS4cSxWuyYE9C1HbBiHzZfSmSjHDbXOcP1CAL5p
	t5iUaSwcxZxGkebRZywEtmZltrRnanLg=
X-Gm-Gg: AZFdTZddZbvHHZ517TDKkZykyB1y0HjycNZdxhbAck9627dUUVPYV3cFRTXOnFUJOLm
	/TxoUQRvpjHeV1T98iABm/ogv0P2Wynl3ob7LcvBwc781du21qMveu4DBoMDk4NM2/gKLXyVAWE
	qw1A8r77rr9BKMVxGhtH7M8aZ5V8GN0bhKUhmsE6wp69dIGdvUsTrCvhGdZRqQsnS6ViK7qOtXo
	mT2r8JiUJo6/gBIIg53jBYt+h8jlkFbW4rnDGt2FergVt3E7FLKh+ikxkbOoeOAa+A8PRONiNPw
	+KaZtwizjKdXJ5Ecc2mNx4P/xoMdzEdu4MJ9ZPFe67KnTQwq3lQv7SEI9r2XBQel/aEUF87frTt
	WkYpOdobKsRKZO/m+URdKwtVDHzLPbwHAb/G/yxV6sT8nrDxcKOuhOHIIUdkDK4QmUwyOyRtNoS
	eOjTUr7fMODEMijehKL1w=
X-Received: by 2002:a05:6000:4692:b0:491:3fdd:af34 with SMTP id
 ffacd0b85a97d-49d61c80db3mr13343868f8f.36.1794859448335; Mon, 16 Nov 2026
 12:04:08 -0800 (PST)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 16 Nov 2026 12:03:57 -0800
X-Gm-Features: Aa3M54q6P4M0RFDCKQ8HHGNCWJafItTSPdWR1qNwVGtToDAv2VOv8vDfWHzYR6A
Message-ID: <CAEf4BzbLFVawibuX0wk=8uzy0WZSYHbkgK55d7rqLab2qAM1Fg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 09/44] bpf: use fc_init_pseudo() for bpffs
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org, 
	Alexander Mikhalitsyn <alex@amutable.com>, Chris Down <chris@chrisdown.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 3:21=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Initialize bpffs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  kernel/bpf/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index c6f328e4752e1..57cf3775c0766 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -15,6 +15,7 @@
>  #include <linux/namei.h>
>  #include <linux/fs.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/fs_parser.h>
>  #include <linux/kdev_t.h>
>  #include <linux/filter.h>
> @@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block *sb, s=
truct fs_context *fc)
>         sb->s_magic =3D BPF_FS_MAGIC;
>         sb->s_op =3D &bpf_super_ops;
>         sb->s_xattr =3D bpf_fs_xattr_handlers;
> -       sb->s_iflags |=3D SB_I_NOEXEC;
> -       sb->s_iflags |=3D SB_I_NODEV;
>         sb->s_time_gran =3D 1;
>
>         inode =3D bpf_get_inode(sb, NULL, S_IFDIR | 0777);
> @@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct fs_context *f=
c)
>         opts->delegate_attachs =3D 0;
>
>         fc->s_fs_info =3D opts;
> +       fc_init_pseudo(fc);
>         fc->ops =3D &bpf_context_ops;
>         return 0;
>  }
>
> --
> 2.53.0
>
>
