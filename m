Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686759;
	b=qm0KQRSeUkFTx9K96EgTjpz5MFSWyckyASL5gFDvd5pP/kO9/Jkw+xPxEz0on5R1aeYr
	 KlyVeFaFdZEvkKvG3FPYZGkCrW4uCrJTRHQknjQ8dQkP5w6pNCx8ZYOfid9S5glvcJ4nP
	 YsWR3CxrKBdEJcu7y28D3vYkbBhIKYfRPTcrgUin81A7jyp9fY7eNH00k0kRqpNQ29w9r
	 2vI8DCtb6GjTMN2a68u3Ec//TrbSXZ7NMv6J8zaP8Hlhr4MPhC9cnO+0gGtuyBAcVvT5N
	 wQFq7Vfk9TSPjrmaYMN1TO+pkZ7Du20fhavWac8tIosWGcx7Ldf/BoqXrDmFDtQf1Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686759;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
	b=uBLxlBn3BIAV44EFn368Rxy9CvZXUCGsJlgTdBtvK4KVVEnKUwf+yWEdb+DrB8OMQi30
	 lTbL6QE76uQRtxuC6OrQ94feUILBW9cQSrAyvTN5ceVIEC/Ed1WcTNqmnQgSY/MtWB5H+
	 4flJIeT4ZQz9BRBHA+LGtBnHYEizy/dPlK8R/Iz3v1PyAFhv1F8qJ8A3X57MXwkBl6ZRZ
	 GWC92s5aRYfuzWXxf2KCwgel/vUCuXqo1ocE5uIx7Ckexj/ghu3DuYY2r4XgU9LlxmmCT
	 DuNKEEl5BL02vEsn7OHssPhh8fmrxbQs2+S54z1GQ7Jtgsfi96ehlIRUjc2ddYlVU3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=t4xxtvlP;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28743606A8B8
	for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 20:05:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28743606A8B8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=t4xxtvlP
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ae7626d14aso1127817a91.2
        for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 12:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686758; x=1795291558; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
        b=t4xxtvlP4RAICjpBIWPIkESb6EJJVOcRd9+LEytv251d1ZQsfD2pYblwETMOf/zroc
         BDzAo5elUgpAiRA0oYEfExHYSjjGywxztBxThvGs665InMbo4S8LytfXKr2B4Cw2IX6x
         hCl30XcWjOl3zGKKK0Vny1KN9lt2zjyLiPz3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686758; x=1795291558;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
        b=LWDiJo8q7+dWRjPTWRj6juh+8puHu4JPRu6SIOjt1mQ4NvSq25kVWIC0FpxwClJmRx
         CbTK9zyUwiYovJy4EjXrf8I2KGOjMpzizmm33aBBz22s6ts65RWd9MY1CwIKcYjsQzZs
         auOjiAloAiWYi7IMoGv4KaWVqLwdoNKMw7Bc+ItpPY+YVHrLcHmiQsNURFz29h7YdFt+
         SQ97T+qck0H9CMdRnnE16wnL4bQbH+JKMNMQRfMIDA3PSFykc6HDJ3jzIAOKFm7N/4GD
         ceK8BLODK/llKkZKqSb9FKZ8ZFQr5+yC4mWXabnMS1V20x+AAyzhrsuqJelXTc5599Xl
         tXDg==
X-Forwarded-Encrypted: i=1; AL+hErFFmbMPMcTeKBHbcgpDfseSpWrNgn5Wu6k+dczSAU+qId/8esg1I/LGjwktXExH0u/1VlYFquqHeDQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z/h4di+R/hG7ktr9dMrF1AkaW8xa/E/yC/1X9cGSzFG5PxUKd/U
	e9SdCiYJnDZqbmv2L3/dai8EJ3szSk9cPk1p410GWXCTN0FvF/3wSkbM4Bmcq8+o5a0=
X-Gm-Gg: AYBFou12tiGgaztSWxGRRK+cJCAnJbPUV5rS988qLO9a7y2EtAXPvY2aBZmaS80zH4T
	SWPT8QOXh7UNNFSkXWDowLrIXFzJxfX2jcxcKOobl9BaQeplZwZLaiJhfRLmEMv1JC1Ouiwyrcq
	n3Ww3vvouv+/MvrNjS22EhLY7GsJJ0P1JpAzL77xPQE7uOc4JYJzhYAjTrJrd4httUx7f1EJysK
	Wt32gjD94rsgUJtXQiGd+VJ4356aKvVfrhRCtp5pS+sKrVUAvsohbrtC+B9yqbY7Hslr2DlIQVG
	c/2F9ChDGwQSs3m9QIId7CzhVIFGZDMlnkPzOfpVGzNmEDU2phfO4U84GOlrcaPzxevcOdjtHWu
	+H2KRRNFr/bXZyjEpqxBLsmks0vxi/zmzKFyLS3lmJ/72N7iYjzThZc8Sp64KBu0eJs+x5w7EII
	RynDM0k+XE1Vf81K0rXf5DroBa7Cv3D2iXD40w1rx8/kuXEDwXQnRc5R07RzDapDnxgzhh4QLmf
	vlvMWqUT0MbwgGSkXyB1haxxxjY0NcEP5nJKrylmOnHKutct1optb4hNOLum5Z+Iiyn3sJRGSwj
	O3NdldrxQy50vn/vQVUPcrJ61YTkvEnuWAm6fuNbcnOva4ZNj1QqU5QiIgj5igEdLmLXmFB/ytX
	TZRP1x3IaYicvT4MFFBMOCBkW3uguuBZg2w7/1xlll8qYhM42AGXvq+1ZO6WP4Mt67abAMsgH/Y
	dlqZFruDQsRaDplZsRIkbvYGXvQYMceacTw65ud56cq0wWd4qa9O2EztPk
X-Received: by 2002:a17:90b:3b8a:b0:3b0:9f53:e8a8 with SMTP id 98e67ed59e1d1-3b1b0b5f2c1mr6192503a91.52.1794686758572;
        Sat, 14 Nov 2026 12:05:58 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b266d873sm4654869a91.1.2026.11.14.12.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:05:57 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:55 -0800
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
	Alexander Mikhalitsyn <alex@amutable.com>
Subject: Re: [PATCH RFC v2 17/42] securityfs: use fc_init_pseudo()
In-Reply-To: <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
	<20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
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
Message-ID: <20261114120555.cbfaf8ab8a92fb25@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christian,

Christian Brauner writes:
>AppArmor puts a .null device node into securityfs but only ever opens
>it via dentry_open() which doesn't care about SB_I_NODEV.

Not a big deal, but userspace can see that node too, as
/sys/kernel/security/apparmor/.null. Opening it by path works in current
kernels and fails with EACCES after this patch. Now, I don't know of
anything that does that, but selinuxfs gets SB_I_NODEV cleared again in
the next patch for the same kind of node, so I think we should do the
same thing here. If not, it would be good to have a line in the
changelog saying that opening it by path is meant to stop working.

Once that's fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>
