Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794323278;
	b=GdpwsUgWkyBcVSa89ftaosJsA7wkUCHTm70aFoa69Zg2RqDjityqaVWh5b4JTX1HR/Hk
	 N76lBEkXo+tEfrdYLOTMGtWHy+pT/mhW1U6iTrPxS24aLoHqqEyicK/yOj3AMAj+QytR5
	 hRgkug0lRTCbvMsmNpWeDRHmiICoj27ctynzswXinS/G7fUrgyu3Q7rxABaoG7yEa1KOR
	 JZDAxtxvnA8qLznqlmuk2h1ZCNna1+aqVP4HcgB6xf4mkpSA9mnbSkSJu7d3YYSy+vafL
	 yzB15uFp6b5ucP+vODQpzd1U3f43cIA7cm55rCqiTBFc7GB90PCwKZoD7fX8U5rMyuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794323278;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
	b=VK/n83Y7le+8+PN0EVpiafdVr67hklACWztROVfodDKRH1lqcYLf50yM/xihxG9rwZJC
	 TbKzQt2WUORh6pZ1PFrhVdd2XdnHL2jcU1Q85WfrMCNme5jJ15ii/7+z+UzpEiGe70p9P
	 qiya6Y2ujnr4U18cX3VUHHF5Jw2hgb9MK7gJJKlk5ps6h4CJ2vcGdaCZTorViTK2OSQxS
	 rjq8p0T9AFX4t9wZ4SSl6Y1sua56XsiIn5k35iF2oUSnjfaad99tLHrcw5GY9x0zbb9cz
	 PgqnWPcMzjO+8bgecirIZ62QiGRWzhzQ/HEk5oHIQR0fy3d4y/bvzYFH9UXfm9EVxCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LHozpx7Z;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214E760A2623
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 15:07:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 214E760A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LHozpx7Z
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e8da6ef7ddso12775835ad.3
        for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 07:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323277; x=1794928077; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
        b=LHozpx7ZkQyIUBsAkv4C311vzxfheFN2pzrL9Y/FTHkEXQzaVUkMAz9U9wFUejAOr8
         YATASi40x9WcOvyF4dkS6SJQ2bBJHO0yE68WsOT8oewufPXMhMYT6O7d4/5H33a+EMHR
         jjCu1KqktdAA/9c8ZIpbjFjA/3BLyNbgEZc3fS3F9+PTZ5y3jCgkJQ9rhGft5ONP+cJO
         aTEF5vn9sQP8UWqDXO8UszNcV0yZFTKvtrsUk25y1Sz/3h5njQt9uj1PBQLO+FuWPgpB
         LsGoLTWDE/iFYFuKD+GJLya2PXFipxPXM8zYDthkWkjgd0549O004Xgoom3qc/ylK84T
         vykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323277; x=1794928077;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
        b=Y1S8eXvsoiWorVU6FQJJD/q+D4RXAE9fwWqGZorB/1q/Nye6AQIFQ5pUgdCLBRmN4L
         Nl4+psOMhQY1HW/TYuHndBzZVm6wvpYlB3/wYFG0RwnbhcV6R9CrOuGzQXbwuffIWV/V
         /etMxhp/WwDWBx/bhjrsmCEeHZywl+u42OEbcQWEAv1NXO/vMjAEKZtS3FIe3glSJ3be
         4/Kk5sVledIAXsSo7Ir7O+BRbsaCr5FAuWMluuTvGfw7PrSP0Phl7FzSn//3Ni9PIuZp
         V85pwps6MMOgHe49n1H1HZcNRN3c4nXwQzkJ8xDyeng4jzVMLZ/YqJZKFQgq6dR+HNKw
         X98A==
X-Forwarded-Encrypted: i=1; AL+hErF7eAhgC/6Yz7gY54q1/CRMl3k4aEwsT/TtrQC/huwpv+7EME8Y8LIsv2gPeJDvlVIU78+TF5VjDXQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z/5bfeaBBFZop3OXpYvijqAgjXkjbMs2u/bgvJh/I3aMH9b+CKf
	g8KwJdMwzr5jnBs3n4XGwsSM9LYsSO79uaIJDhvRK3KOF2WvCWNuKzAJ
X-Gm-Gg: AYBFou0vBwXKjA1/92K/ICLX2lg2fOr25GFx59txlFkgweoJSJhmM+LgjcEI/KB7Nil
	+8WCKvcIyg1iivPejEnIAYYvoXY+ao72DgSCEYLs5+eHFfkyKa3kRG1AbKRTtAshybH16yRDR5L
	oxAmDjPqlBHWZjM0hkN3ZuLcwyr2csq2vTjTIG9ZqJnK2eatJxcsgpDZ3CvVHMpWIF5YwaaxEcc
	LHUkv6SVlUD5wEO7fSqVw1+kT5b0dfuYpkkRtFKakebOhwnPm1wtwKiQ+wL18ycvlszIGs7ORPR
	TjRu1/7EEn00uo6X5jJ7aYdL2D9rgXS4YRishkBi5jS8n2hBuE65CzICkS1n+xkITv8eqrhH4/x
	pcIF4gpyWvlHusJyE59/aVcxSyEpDyYRvSzfWFuHWTKQ6BiYLW2ArTQPXNRezmzRNVobzi4y6PQ
	0llCyUhxs0ftlYNqfNzEydHrpCWcdKRrQkbTCOn2b5g0Yyj1ZgLsrLyWYz39rpjLZ4RSsC3DB9t
	6cc0S1ADxuwP6qw6yONL+T55/k5wbDFJKrLUSHVOH4wrVduc7hmI5XV7P7ivJHdb1icSxEvNp3p
	5gdKpr0c4AfGUU5b5z2RYyb7QDLIDvGo/d5VwtF7U7AG9pt16BFmeP+TYSmBX1WkxMWevdf3uSZ
	FyI9vi03tf3o=
X-Received: by 2002:a17:902:d481:b0:2ed:1ef3:9ec with SMTP id d9443c01a7336-2edb9172a2dmr26826345ad.14.1794323276968;
        Tue, 10 Nov 2026 07:07:56 -0800 (PST)
Received: from [192.168.2.6] ([27.75.101.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d78dbcsm10397575ad.27.2026.11.10.07.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 07:07:56 -0800 (PST)
Message-ID: <71f76e5e-ce24-4a71-863a-169ad262c510@gmail.com>
Date: Tue, 10 Nov 2026 22:07:46 +0700
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 36/41] nvmet: refuse files on pseudo filesystems as
 namespace backing files
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org,
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org,
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
Content-Language: en-US
From: Bui Nguyen Nhu Quynh <kaylovefoss@gmail.com>
In-Reply-To: <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/10/2026 4:14 PM, Christian Brauner wrote:
> The file backend takes any path that isn't a block device. With
> buffered_io=1 that includes files on procfs or sysfs which then get read
> and written by a kernel worker on behalf of the host. Refuse files on
> pseudo filesystems just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  drivers/nvme/target/io-cmd-file.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
> index dfa8aa46188c..71c69bac5394 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -52,6 +52,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
>  		goto err;
>  	}
>  
> +	if (file_is_pseudo(ns->file)) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
>  	nvmet_file_ns_revalidate(ns);
>  
>  	/*
> 

I noticed patch 41/41 doesn't include a test for nvmet. Would it make
sense to add one with buffered_io=1? The test would need a pseudo file
that can be opened with O_RDWR and supports both read_iter and
write_iter. Otherwise, it could pass without ever reaching the new
file_is_pseudo() check.

Thanks.
