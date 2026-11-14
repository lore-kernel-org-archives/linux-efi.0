Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686757;
	b=hmKmYEcX5vtq2EJNl1bYvS3VseYsXNgcUZH1TWOwm6r3M0hQVXGS80WUvD10C1SG6a7t
	 OK0gg4N/L9HS9O2gnNmS+bx9e3zO4nO9j5Dpk+fal/43q+UFn31EXr8PdW8gyo/wYxT8B
	 p5reOA4UuRlc2FpqhRSuWSkFHpthXVXzE5DQ+1AaIJdfaotMyYcS5/QIGe6bvNlCYytC6
	 HmjiBV9khTZ8ndieuXaiOS8tPR4m9e5WWa6CSckdxgFDba0YR3VVLfAzIW7YzFQLD/9O9
	 djukL0b5IBSAtokIUzOCAvBMef+TEcUTcc4NiXLq7y2P6C9U3lBjivSImdTeauLgQ1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686757;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
	b=1htqqzDAMbCbJpSIpRHhbE8ChYfr+n+lyoeAxAiWUSaf0Oni7s3iwuWdZIckdkAKufVe
	 Ffygzn9fHi51APTtYfrBibaezHbBecwoAeevScfpIj//H3O2/hkilgceG8M3r0bGXVoUc
	 d0uQ+ZHu0eAxpjSoYaTiWPLYzShrbSSaxlGmXfeIh1gQDwB3TXq2naA9LWqPq4Zb/mpqj
	 5hBjT4SOh1KobYr6mFX3OaSjRUQBkRIowXvkp/zExPurRMIPcgMyeJLp8ttw+gyvp/TpA
	 gUkwCWRdyeVkxQeRazQRtzqUkjb1YqOg9g37H0HQ+EPm8DOfbX47cftIdNbywuTjKSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ZNpsvJMi;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDDC606A33B
	for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 20:05:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABDDC606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ZNpsvJMi
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8b5e5e64494so1463746b3a.1
        for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 12:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686756; x=1795291556; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
        b=ZNpsvJMizOoFFuviUq3R3I7xBszXKHR6f+dU2Lhp8+AdJOsuucW/Jpjz4DKxOc01P8
         7Bf2gXYBYorSyL2ypHSps7l13uEx7uOW/BQ3oCjgyM7fn4nszFId/ZhifmOhhkUhMak/
         Krv6vg2ZKrT882kZ97nfZeCj+rR5WiJ1p/wW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686756; x=1795291556;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
        b=z15xgFUlies0OJvzOV6YW/1fqJXLaSK0fJijaNAomKhULqQx6oz8zMdDqza7wFeYpU
         zKn0hDDknqv/H6GBrax3Vgd7XO/nz7BrJEjP6ImEuZSOM965NHjpr6i8eAvvqJSWHfs0
         MQRlzhvODslqp8VV4kiJNoN7rMpiKocjHs+LWozrSYAgnwZVruEyhNTHfXkOiRlN1wT+
         8+XDsyXkQQpSiJ3gPNUkMKAKxEsvwlrDsIrFsCfRrKkAX8hqabPTw85FLnNTXjm2wvCl
         39B5RSk4nDQXeyFhD/ogVKpt9zZE23dTL2PQ+68oK0XZ/xbbsIdk259SjzRuX/VoYsC/
         HDvw==
X-Forwarded-Encrypted: i=1; AL+hErFFNErrKddYOc/N7qUhjOpWUgrR0XLGtkyLKoi112yxho/0bt12yw/C/rD1w50mGIiTdGAi/yJOeUM=@vger.kernel.org
X-Gm-Message-State: APuU4Z9qoYClQJAQZsogZqcIAxhzqm7dWh6p7b5TsNSa+ZcBLcNvtDDr
	7fcuq7F23dp7BmzkcxQMWApFo8z54bd7GHI99pDcPRgOtAlCSI8ApXEpGUcq5iYNjeE=
X-Gm-Gg: AYBFou2nIocFCgic/sxkqe1uHk05fHHc0p6ch6b1EDZcGYXGFhi/du2iHdWJ743ynVl
	EnzAz0VwvNyKUxrbUoNoiohIRpw4g469ih82/UUwCu7qBRBIQ3zhzB9tWJaxlWG37unC0zlvb2l
	gJdqg1yxmNsiwLTa2NC7TeKVHaG1oQbWd655mizyxOzOHs4Be0m+b0fY1sUouYf2nrC+k9VnCjJ
	Ltika3OmO044vptRfzHl8eOKYwgWU7Jcb3s3XMPWY/1EetVajRYOdNxiwmu6pipxi4+ItBBnX9r
	t2CqIFE1PpevCT8CigfQdIWkjZPZhkymidUJXifVKAUMwY8H7UCxOtSNZF3s4bwX2TCXhXAXt6m
	qTlk+0tTs9i3344I7MyY+YEWu0H1KRF5toU8L9yUyhmp8o4XeB3QdI2OBTFzAoXil4t4/wGs6C3
	4Fz8Sz8euOR+jW5Zesm6mwq9HThfJaAT3Az3KeeU9mCwaIXLZX382ny4feZ/Qws1gG95LaWbTIj
	lYWn2ViDCwgecbPIkHhBeECnkh9OY7/4stBH01KJ4fkp+gLjGIUL7LzgTl4BKpHLXrgO9x5PtEB
	/JrrpVEUQNetRYdJx5Sr2mnOgeoVX42a00aZ6+UmkC+FYb/TVUozIKgTFc2yNz2AJjTtfzuIgWT
	gX3YIiEPftY16DisZVDlWmyiKHZd9s6rrfpyeJLKoNaque5psmBtGhlaAJ75LZREIZ9rNd5EMOv
	kgdz9JBiqCa0PFZZwgrekBpht0uP01U5/YhldZDoPZS6ydDsr++MjrFUTs
X-Received: by 2002:a05:6a21:748b:b0:3e3:37ff:3795 with SMTP id adf61e73a8af0-3f7a4dbfbbfmr5517650637.7.1794686756009;
        Sat, 14 Nov 2026 12:05:56 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed12a8172sm2271197b3a.13.2026.11.14.12.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:05:54 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:50 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org, Alexander Mikhalitsyn <alex@amutable.com>,
	Breno Leitao <leitao@debian.org>, Casey Schaufler <casey@schaufler-ca.com>,
	Chuck Lever <cel@kernel.org>, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH RFC v2 00/42] fs: don't use pseudo filesystem files as
	storage
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120550.0c9e73aa12a3072c@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christian,

Patches 1-11, 13-16, 18-26, 28, 31, 32, 34-37 and 39-42 look good to me,
so for those please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>

I've also tested 5, 6, 34-37, 41 and 42. The selftests all pass with the
series applied, and a uid 0 without capabilities can no longer change
/sys/kernel/reboot/mode through a loop device. So for those, please also
feel free to add:

Tested-by: Chris Down <chris@chrisdown.name>

I've replied separately to 17 and 33.

Thanks!

Chris
