Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794305680;
	b=jcTHFbsxHBIgxN7n6x+xQgKaMGNnCMtu4vTnCtSPhKYmEhtuaW6cxxOLxMQ7C/xvXfwD
	 GBxZ5epUccoLgHxK0ztX4g3EWarRnRDtRgB/PKYXSz6s4k9NQ+YSb9ma5kY9MBQkjy5bV
	 6HF/mUoAjtkgTwg7Z0TO5jfYIBrjEEEq7TLEZB7vzBIoWXnDOsbWrU7f37i0gUxfaxpgZ
	 p6xlKg/ifg5V99YGlPfZzl4uoHyWA3DEOjHSU9CbrLqcg8sC9mCqPT1wwAVWBFky33DPa
	 ZC1UY4Vyn66iEc5m3KMcIFswFQ1d3p3QsP1kEdy7a80KxAcpki3Xv3A0qa+uMbvI4XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794305680;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
	b=BKQtuSfguNvyi+hKivR2dxSaR5wEr4Nnmq4YEN9vk1hlL/BC8vET1W9sTd/33lGw3014
	 80lkWkug3y7c2YFSiCxwD4ND0oRDnywjVQuUHDGWesae2GH7FuBzmEIjb1Q+Q/oTUAduP
	 fwuh8do/SfEpg+lCB5c9N/vXaTAKD2JxvGy5NpanP1okGEa6FQZfK3KaDSdz9YOYSmVg6
	 OVpVth5jE59b8y6EZBvqzwb1mGxm7hVm3DeLJWh/zvGL8DvA9iX+g+nCllwpK2znRy3MR
	 g5ujEUu/s5E4xPsLTHPWBd0XCqXzpJ1mjdNCVZ5AyL/wR/MyvteZeg42uK02tGBqF4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DrlQYRb4;
	arc=none smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA4A606AA43
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 10:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BA4A606AA43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DrlQYRb4
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso3959803a12.0
        for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 02:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794305678; x=1794910478; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
        b=DrlQYRb4d+FJBQLFk4gip1vdMb9pZcbFm0QRoW/O9nsnnIGk5B/dcI7komCKzkv/uM
         Uz0TTkL3EB0XOLA2v0TTxwYvqDOvah1wiwbB4uUsiRRXfj1OcdvtnHWnMQS6yfKTNN5Y
         2S+sbZpFj/oUd6OIfB1K+t4luOgmpm8MRta8dNUBz+XdEb16ui6jztHrAySR2QYDDBtW
         UcH7ksMk3kyTCuhLg24n4RSbgP43bR1MD63YWBBHbNHKba+s6Adtgd3r0iiTavTYgvkx
         vCBmyxhjfzRfUpjuhY0K7x1CK/3uUIf/0FzbTbFW5bHu/k5G1xko0Cr6O3LrrObY61iA
         y+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794305678; x=1794910478;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
        b=wF6V1LysjKyjkF0HEXOClzr37u4xYfcvTvVqwOHCTuhfrIlqeRR4ffkj6FruYoYz0L
         Hb4WmpZj4nuMmMoFcOukXD5Mh2hAr7YhpAfdPH+Jdh8mDUySOTDwJ6nfjNje7YrvAPwS
         Omer4i8Nn9nsFynZ8VYJy+Et+E+jHMhD5XW1iG8q8FHg1iJbDgfm4l2FweYaCAFuN19+
         NEm4JudCJMVlZDiZ/f/rgKQZbyXxoBOfy8Y1jJT5J2eS8NJWbN0KnSM6qNtn7xhguRUW
         RpqvjEEM5nwFVTZGrVJUDuoIq2+T+2NOWwZTwKcPh4ivKur2PttWrwMz8UOTOxue3Pfr
         frzA==
X-Forwarded-Encrypted: i=1; AL+hErFjsfTpz6R8/KVZeOjzdgnvCFaSmZRETjGDTnfI1DujEfdnc7lRY0SybBwzbasdEeKbdEtL5tkn94I=@vger.kernel.org
X-Gm-Message-State: APuU4Z/nHX8AbfT2leDqGSd0o9aofwz17i7KK7aa3T691XEsTcGepijk
	VVoowrzUtjKJhmxy37eYFecRTcx2J7BYPozgNs4MUZ0ibtGFSJLxzbkM
X-Gm-Gg: AYBFou2HCND490ZX2ZM+hlm6mTunp94gvSTGXy+6TsOrOBg+tux3AYPpspXCnLIlKfb
	/thEKRNMXEmDhRdiI10pWgW4ixiBwA5XxfJ4Jk4rCYBEfmAX8Ojf/fZdiJNE+wII1f4dCGLGldb
	SMBzziHPZz0XzMMhIeznSKY+C21VATFtCTaUMM7/7ceNI4+jLhgq5GqkvddalRrBMs8pZLa7SGQ
	zEzDCxE9v+BqM1HO2htTMrUagIWV96iAKIVyz//Oll6kSRzVlOECp6VnKIVkFW2VKyUk31sJZg+
	EuCrFMRkHd8Qk73YhKoxDVgu1EruJYn45DpPW6gahRyAnmAfe3COaLNKd/GjzbSbZlM0o9+yEHf
	SB+fnHMlKKyBUEsxmvc5pjqQt+TpAkmL62Az7sM0LnZlJAQNkRQWkKNJrqxLso7Miq879LkInYj
	aYt0J4ai3RlZ4MxTLnmJIzVgRCdXkGBDYQZMTjazIzAQ0Tiwr7skA5bRNVAJlB9iysbdcaoHmDx
	vTAs+AF/tEaGMJNQqzAft5OdQSS1slI5JUgzYJf1SzHbrXgwqIMt498KTUY5ngL3oLhhTgKXRum
	vUKjBK4pQS08iPpeq7SXmB+pDuExULXG0VfNXFoDv5gcGcCX/U+04rhrZ819mk49yken0n8JrHN
	lyeMsGJkRaRkK
X-Received: by 2002:a17:907:944d:b0:c41:4c20:5a80 with SMTP id a640c23a62f3a-c504963ce05mr189793966b.44.1794305677695;
        Tue, 10 Nov 2026 02:14:37 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a593eacsm90433466b.36.2026.11.10.02.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 02:14:36 -0800 (PST)
Date: Tue, 10 Nov 2026 11:14:35 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <avLui6Mpf8GbKbtc@amir-ThinkPad-T480>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>

On Tue, Nov 10, 2026 at 10:14:54AM +0100, Christian Brauner wrote:
> The fuse server can register any regular file as a backing file. procfs
> and binfmt_misc files are already refused by the stacking depth check as
> both set s_stack_depth to FILESYSTEM_MAX_STACK_DEPTH. sysfs and the
> other pseudo filesystems aren't. Reads and writes of the fuse file would
> then be done on the pseudo file with the fuse server's credentials.
> Refuse files on pseudo filesystems just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/fuse/backing.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 8c21a8a74efb..4e4fb810ddaa 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -147,6 +147,9 @@ static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb,
>  		if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
>  			return -ELOOP;
>  
> +		if (file_is_pseudo(file))
> +			return -EINVAL;
> +
>  		fb->type = FUSE_BACKING_PATH;
>  		fb->path = file->f_path;
>  		path_get(&fb->path);
> 
> -- 
> 2.53.0
> 

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

