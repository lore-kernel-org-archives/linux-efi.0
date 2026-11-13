Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564363;
	b=Nw8ZjDE9Y4IywQ+yLiom5Wv43GrpSPMMoVkicoNrrqx6wBmdAtNQBhyO6q7WbAoLey0n
	 yKKvbDv9Qp0S+J3UGFZsdZLh3dSjG2tLJvAqJ268HK21KQ3XuTIbkhDLZMyYi2nCgRJ3i
	 mmJVkar9rbwJmu8OI+PVZA4PcN5ej2RMb6jcHsWqldvURAIeQwGf2vZyhKbbOt/NZk9L0
	 ziIFq17fx4fIEZhPOBYSDwjTZ0/FYak6bIgIQMpIK6cW2t8ovm55Lk7GA8lx6+PHjkuI0
	 WRNU4DyGaBbZ2sqActhc1cbuDRLk00MZbBIEwjcFvbgaqVxZnh7F8d0G2WzWRIOwxeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564363;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=TjkCmA8zoLhZK8u7U4HhR7QcElVzore/o+jClE5BdRs=;
	b=HyFtxJLHEyce2L9LfSSNnSH909iS+yTSSTof/GcwCGd6aqhHoLXE/NmyRqnhNEfaVwI2
	 s0l5CIjPStx6kXDB5fizftVtnSSH8xRlOdrYCkwTs8a6mRFUjhkp+TIj/s1B9S8tHjuf6
	 UkF7jBSXr6Tgt1voACQ40Gg85GtTBEw3ilU532HpO9t5YXWSWc5cRIMhufy7Kx+6caD0+
	 R5t+XaDYNrrbZT+Eh7x2MOu9MWw/Bu8HYAS5zsATOwOeQb6DQU/TChpPXLqG1f0FMdkaO
	 uGlA63bFHp66QJN0dfpYCDEzi6S44rEYxUPa0ZH+uctcOh0oo0M6oWrq/gFmJmWSzKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cjEYfKb2;
	arc=none smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E8760A3801
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:06:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05E8760A3801
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cjEYfKb2
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4d427836e9so121960266b.1
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564361; x=1795169161; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TjkCmA8zoLhZK8u7U4HhR7QcElVzore/o+jClE5BdRs=;
        b=cjEYfKb2ti/xguKoQF5XePY0eNOezud7K33Duf47S0g3JkHBuObkd06WZKSsE2j4TE
         DEwnxkXlTao4933EWT51qAqcKFQZzBDYUWq7IdS+RrJUrXD2u7QTXDm9Wr29l+nlsY2h
         ba2aoEFnt/fnBZ4TqG8AlHBTx7MlaAOM8MSBIpLqFecTqJgM42mukp171NeFhmx0Zx4N
         EfXY8c4e2NVT5eQpV/Fv1f87MHIzBgzN889RZpIYFKMs83t0n9Q8bpafRw7OfeQ9pMp+
         KOGhNvmnj7I3xZktgYLxquasfZAW0tMnNpo/9hpnK424qA58Vs+J+ftPxNsRzOLYAEav
         G1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564361; x=1795169161;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TjkCmA8zoLhZK8u7U4HhR7QcElVzore/o+jClE5BdRs=;
        b=hSw5K/KcvnrIZ+mJeLLqwu7OPeltVVGpj/YcWZ5lULlJP3yyDVayo7fypdSruR986p
         gNI2MtsA1VmudeQUowLUW51kUNQJDWrTbeQ9x2iQjbcFqvOiZdqkT3LeiouqB1gvbkPQ
         7jlHspFtcNXos5jD0mI5X6ltRU/5mIfYDW0Kj6fU0JhoeY0gbCU0ojRPmNXuypEtk81T
         bV+3Vcd+w2ZcpJx6tsP42/+Smyvdtx20jUyPB4V1Xqi1PqtIs9W+787EfTDgBKtnqgT6
         Jqd6fmJr0FOMLwNQ2+LgdjBy9jd0abvkOQpSm6t/EmU2pZgMCQOGpODmPG0GCSGpXeKR
         WBTQ==
X-Forwarded-Encrypted: i=1; AL+hErEM3eXNU5FFi+gmXmG0vbvTWD6h8CVf3PrVwxZJ0pGQ3XXbUAivtc6K6ZO1ZHtmeJOIodQx2y5fRRg=@vger.kernel.org
X-Gm-Message-State: APuU4Z9S6cwsWnqdhfVfb/BHCehhqgf3VGuq6QjDaeJx8OgIWlDL+hFS
	V9OCkmD9cF5GbeXWnzZlTuLKJQNIdeIOkC9ITbE7z4ZIvTiRC8ZEAH3SbMrarT/XnBIr
X-Gm-Gg: AYBFou29pS5aD2l4/9eF2H33z0gOubd0gnQW7wnKLQqwcThbXH8Nt5x3B2GDmljzDfu
	zkkxD/lxAlh/H/qGuBFeNOMmEJihhdaBSx9dT/rSDBW/dZWeMEk3IHfM36uzguel/0Mq1Blz8nd
	JXDFOBNIC8E/6djy8Y2FS7lWdnaJ3KE/ZIzWykq2U++E2RHEWvlqtRpZF1JpPWFQngrohUHSFbs
	fZv18DrZfSbTQmiAZRl9+muZvWv6cBPi7izVXtmNri4Qf3dL/It7qml3My9JR4SJJuuB4rz8zHT
	EjjaW2Lb3phj+jGjqOjxuExKEW29oDF3qTu3w4wyyHeqcMRd8dcNIN5flD1aPKi3k/fHnrr9ImZ
	M61erWu6s/IOVaS5Bva6Pv6XiEe2hMcbzsYdgz0p7CZ32Ex7Is1hKkmM8oeTTHZnjpp3IAPaOIE
	rwKCaADcMThlogPuexZ8O3PzHwW2Tq4epyJxpO11zqXw92TYQhaqShIjdwX4x98pQsXIiStUkqa
	1fbHOr4jvighgtjfY/yArqOaFFmofK9A9SIimIFREKJBABDe1DiqO+bYKVdigHvCpEhLGV98REe
	ASCzKDoaMLB16JnDJBElJ0A2cRYO5dC2JQlVA2EiWYgGIq29CXMHQxP0npe5dw8=
X-Received: by 2002:a17:906:ef07:b0:c4d:5820:325a with SMTP id a640c23a62f3a-c50963dc627mr169588066b.39.1794564361325;
        Fri, 13 Nov 2026 02:06:01 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b8651bsm73693366b.78.2026.11.13.02.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:06:01 -0800 (PST)
Message-ID: <e8b71a2778d7d7797d433e7bac1a37ee64aaa30c.camel@amutable.com>
Subject: Re: [PATCH RFC 15/41] tracefs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:05:59 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-15-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-15-4c998976c6c7@kernel.org>
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
> Initialize tracefs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. tracefs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. The only tracefs files
> that can be mapped are the ring buffers and __rb_map_vma() refuses
> VM_EXEC already.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/tracefs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
> index 5020365ca704..e04febd868eb 100644
> --- a/fs/tracefs/inode.c
> +++ b/fs/tracefs/inode.c
> @@ -12,6 +12,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/kobject.h>
> =C2=A0#include <linux/namei.h>
> @@ -510,6 +511,7 @@ static int tracefs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fsi->mode =3D TRACEFS_DEFAULT_MODE;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &tracefs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
