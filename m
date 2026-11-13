Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565562;
	b=3RpgIdoPq8r4ezNiNCGeNN6cZVBnP0Wc8pnYWmFL782deO1BLSslqZKGI5dgQqw0wK7q
	 tpRfdsq8iCtkBjzTTA1CNivdLfyAq5gubwCJb2G5hmYtvVWLS9DRFhwC4Ushry5m+vbea
	 qnO+M7YHG/u2HOxHWmKi5J0Y7maaAytfPfB/3nOlnDnrJbKJ0aGyi1Tt1Rv/3o9lpGMHl
	 sG5CMgW7qRLO4gOV+mYvd9wn2gb54RRFvx43ShG4iGll7dHyDcFFdiAeZG/xjC8VFyPJV
	 LFDOgHH7epc0fpU7N4mD0OvmSSjme62BuzyMKW1p44I6bPMutHkXtk6u71GMKm/cyIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565562;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
	b=xjZe6Gjc11ZfUYEhQfeeeNiANhzgSD3Qix6iKPnJsDMRN1hQEfn3h9jpfsOn58HvsKNJ
	 fqOBN/uSyLrUiw+LmCP5jkuSRGQFztA3v3pvJ/e0q6yA2Z8VrcnrjNNGJfTSOihxAJ7nh
	 dK1JlVjlZu2mGPMZqfYTkQvSze5oEMiaZN/j8YdBauOpiovHU+vaJPH7nmptbijZxnm4D
	 Tm2ezqeIqX8iiS22VNoCPGnF6683WWKbLWY+UYCVwjgfkUftbJeXzToiSzhoGNJ853rox
	 1H0nmWWvUefSjvzwXmBNb0fkqETuB0wmO2JvkYaOh/3QBDt6kaaphQeW7l/UoC8tLAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EhCy1rjV;
	arc=none smtp.remote-ip=74.125.225.138
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B71606A895
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1B71606A895
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EhCy1rjV
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-4b80834ce1aso1170635e9.1
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565560; x=1795170360; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
        b=EhCy1rjVxVdFrlqlBXdnWdhZOgju6UqPO7MHP0T5eDQlLH3bu4fGnJjBmSeu+X4e2W
         fqknndYp9WUsPcSw+hMOJQKeOCVQ26f4CApHOuaHiz0ZnrEcpw06GAGjRX2e/v0KskXR
         kPbczhlJA2JL/E3RYwJYZ55bjMsTqV1bcwrFG/iNBMGzSlTlhWz25UxyOw6nI4axYZSB
         u0krz81cE8qJBpZN+Gj0XIkGJFuZa0vCttP7+3dXPKfvLd7fzcQdMwTNK/JaleYs6P1m
         dJAReh6EvrYwFB4nFlJdvgjX0mrHV5c8k7KozarvFnbaOIXtcKdLHY5nOcL1YTJjLQtf
         x2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565560; x=1795170360;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
        b=aAXho44wXHxlImYnMRt9oF/Jxa0A9wtCE5C2jgtmOGZAp6uNwvGr/rys0KIfybtq++
         AA4sl/UHiegZrmNT498z18hRd3nr4PYzfJW3oh6prImBFy9FkLoXGauPT0211UetQO4X
         J4WRVanygn1uJSi9IY2H2gzgxRYqo/uCAqW4/fYsBYkRLhfsy4m+/ZbsEUPsLmGksPyd
         9Oz8D3ao9qLnYeJoCCIJCxm6yKe/vcs0C3j8QaAMhEdjF48wb/VP8Cz3yyUS15Ssv1yL
         gS3N1dUztWKO38JfAzO5GduhKnnMD1MbsKo4KpDZWGtepdV91G+ugYBFzAuQBaiW8L/y
         XEcA==
X-Forwarded-Encrypted: i=1; AL+hErGaDFJYQOSC+37/saLAckS8BRNbPIfeYMrS3bjwLY37cdWc+5SGg5MaK3ILfKdllJrUifkq59nC4CM=@vger.kernel.org
X-Gm-Message-State: APuU4Z8vYPF5KvsUFPtj+Gj5j730IrpKLYd4phRhWsKq8Ci3YUkEb8qf
	9ORBC0Aa+ekHB4CePxJW2oTah6l4Gk9UnYUTNgF4pF0qHihKXQS11VOrUvxyW+GZOMKL
X-Gm-Gg: AYBFou0f8+yvMgrfMdAqug2tXy+Rz9m2twb1iBH57t1qEZcxMUfP49O1bLA2k2SNukx
	tNaC645kMN5SZW0ex9sv8wFx4Hyr/Cxl4QJ08Pts/eWmXlI+eZdtjAbK+ZPMWB2LHg9XGMaMr1/
	ma58oKXvD+imvDPMYvXe82uENNKPwnLd3pFoAv3iYPLqy/iCYCCsPOhlkMtWaDhQA+bif2CmCpd
	HI7duVwVMJcw0BL7IaImrOaT5sTAe6E/FSmWrPSsCfzUQJo8e5UVytakEaoi2W4mbblMW5NwOEw
	Mgn1Iubd2Vh8FXnV1Jq9LvvqVZMY8hErfnq74hA+/TTA4RWsYZsI+sqSepLUj7c0ovFrKau6MIv
	1vZdX1LTVPAZE1j/+xZyqLVBEeYiTiVswLp+QqCgqdUQSy/BiNYGAv6FU1rlPozXfOje95+DX4J
	dF/qnfGE+M8YPwh9RsiOXqAgru9zRT8thqOslg2hGRYjXwQPrGt6FBAjTDoDhj3swSUGvzELHkz
	j3zVcc6PUvreTj6/EwkR6vp6N/bbYQv9kpIyz6z4fKA5pUPp8PwAPi06Y0Z1txa47NvXsQMXwxF
	j6Omd6aLJjEcu+kHfyZoiT64L6YXqa8AWUk5liKu+gkWBpH68q+DCs2b0ATRHMY=
X-Received: by 2002:a05:600c:4e49:b0:4a1:78c5:79f5 with SMTP id 5b1f17b1804b1-4bb55aa999dmr38995625e9.33.1794565560090;
        Fri, 13 Nov 2026 02:26:00 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2538b9sm244439965e9.1.2026.11.13.02.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:25:59 -0800 (PST)
Message-ID: <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, Chris Mason
	 <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
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
Date: Fri, 13 Nov 2026 11:25:57 +0100
In-Reply-To: <20261111151202.GA11391@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
	 <20261111151202.GA11391@lst.de>
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

Hi Christoph,

On Wed, 2026-11-11 at 16:12 +0100, Christoph Hellwig wrote:
> I've seen setups where people use fuse to mediate access to sysfs
> sysfs in odd ways.=C2=A0 No idea if that's still around, but if so, this
> patch will break it.


Oh, that's painful. Do they use backing files for that?
It's a relatively new feature in FUSE...

Kind regards,
Alex
