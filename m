Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657338;
	b=a7/n58XDnhlSYgZnRC3Wkr7oXHTNWpCzSnDuOGvneGOObAzeK6v08gDh1jVDRj9Q2LMb
	 EtFlPdebIpkiUcPoIJa9b1rv4tgIZLirfGUoeAoe8vcLUbWLvFA5aAHA9v0hub2X+voBb
	 9tfDl9tqGwlao0bJmkwgFqLHcOcg82mqTOchwBnAG4w3Bki6Wf+3ghlpqjPe/2apAfhT3
	 HFYmEvxcOK36evx/ZkfAcRDPY4HfwcOrokLsXFHhJFjTud1K9KH1INfy7Pb2yl6p4t7wW
	 94/HeC75weVpE5PUyuLuR9QujlimDCkVFNwH+DGgnwGuHOO76EXSiHp/xGGOfmqPXsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657338;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
	b=l4Ljl5JCbdUm+i9cXdkWOOvrQMoD6j2BI89CIegnhRYwarybslA52qblqJ1VeP9qSo+X
	 MlbL0cYdITc72g44o+8HO2paekYlsRiw4D6PKTvUXV1IQEVmn/ksdoLNFWwoUgIzUD31L
	 6CDNWf60X8oaxNXgg4HnWiqNSVFCXb/YHXClQy6mGdlnULIOoYLrB9zPasNvCPHcne42t
	 /uQgKG/8Rh+0IGQh0jhlZIMZqv7WQndhMEwsXF7F1sao9bdeG46lRaNYM75wD6A/Ipiom
	 1zxoEjtVPHwWIrF6LxucsFjJD1B6gtpFe8spy4q3lBH2Bh4OGOF8rLuzkuNdl5TWgZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MrTBjpIE;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F07606A334
	for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 11:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69F07606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MrTBjpIE
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so338682466b.2
        for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 03:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794657337; x=1795262137; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
        b=MrTBjpIEXzsSZaANjc7oExJhwGnF+j3pBQoJGLV3AozjECewWnT/dOn8PoCfUIeYGI
         mRgldWBhVoyoY4kjpOu/TkcCPMpetn8bMN74Irqnk0JnK5MAQS777TE3iVfENO0qNvUE
         8qb82pxhdLikkA/6tATGUpByZMee1vHTbdl6A6vtosorr3+hE9wD/mpuH76lS1WAZqyn
         nUdTyabyG8UAyWqGnpYJGfY62DgpvBldD5kNADP5MARyaYxmHHJYDsQkr6qVKrnaldzF
         KHIyaxdpU8Pcl80WjVwUUXXw+yU81KD0D8RdN7wE6Dhf//BzElFXAKq/AgQBu3vGzFII
         7JmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794657337; x=1795262137;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
        b=lMVGy9DIWeSF1mDwVTP3T6taKE/jvzCJ1qxur6l5kJeg79n4a5JcpYTRNf6raBO6pq
         8vv+A3VlBnchGN7mNgGFgJDfJQzcQw1gKy+GHVu5rE2eT5U+vYwbQPQ15yYDmDGg4yyD
         jcv3fmpNI///R4PALpyIXJBujrc85R3TADeBvA+CMlnxOimCqR1NqQJb8Tg18JKdghJE
         8a/xZz6w43ZKnKDqTV8PWjTV2tKlZ499D0GuvThKH11XJjf+6u1qdhbRXKkepeljQfjE
         df0OKIbhr49YbbntLSvjbcoFXZ/oR8JRI9LOH4jYXk6NUCIgChAPkU2d2uJPvWGZPYME
         yrcA==
X-Forwarded-Encrypted: i=1; AL+hErEeKEVkFe2YIMkmFX9oBlG9/Z6HXVmQICmJjSZ7UGk+m1WLnDCw1X5EZQq1SLbXqO7AzhKOAg1TTrg=@vger.kernel.org
X-Gm-Message-State: APuU4Z+bTJpzj5MZIPnOU8nH5g/J8Mpl/xtZLlc9aSOCP9rMPTSW2qbe
	QaIEt3gV9oNwvRhakbIbhcSB3hQBC+GSV6uEmrsj6obOASr/3S6iKjuh
X-Gm-Gg: AYBFou2jthLZFE+z+LDptlhoWtBwx26HADvSy/v2nHU+qEXGiupfShWG8D5lx4/dxKJ
	55gjPiWHFAM2IsppzpjLeJBbkDZnD6zJczVSOvwC6Ij4hO3P9PK4dcpYlhR7rbiqY/ud6oJ/7X3
	lwfDXkc0IHPff4bknZmiALLUlpYTlX6QhDCWZB4Oe1P9XZ+DnSK4fSWtxANd+41Dw9LthhnT2o9
	wFY+Tdk2oqQJCW7nTpvc779Vqx1aK7XVOZU6X/toqlTPrGtyeZsW6gu/3ai9pYvXGdRSs86i1Jy
	9+ZIBZ6WslBElJAL9FoOhHT/ot1bVB7juC7Gk1SBM6O4TiHEEiB/i9g8VR1PeanXJWNDLfXrVJv
	uVC5dCktLJFLOFqugWF3L5Nr7Kym7QTuxZWGt5NVKYNolfdUSoYebO/31IXV4iU34802C3tLzXd
	6kKHFN5mim1QnSFzqBH6tmnb8nWKDcEr7UeftiwuFsUSWadm4IHiSamru3lG/tTWMjGNH7dzUcp
	xl+yjtIgvTde0zuxWwHDXmPjMs32yskLbpgrcZBcmzd0yfHZ9lgw5XaDxkGIjI//augqT5oIUyp
	bm+q43CZp4zaJcl1ztRT//Bs8Skj0XJn0z9LDTzGZJ8GCdkQRGpurpnv4aWYOA/3W4/Mz8rRrhB
	oCmp5duwdoKU=
X-Received: by 2002:a17:907:3e10:b0:c40:231:6eab with SMTP id a640c23a62f3a-c5096370c31mr441592966b.16.1794657336589;
        Sat, 14 Nov 2026 03:55:36 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b41f44sm206223866b.31.2026.11.14.03.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 03:55:36 -0800 (PST)
Date: Sat, 14 Nov 2026 12:55:35 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Alexander Mikhalitsyn <alex@amutable.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
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
Message-ID: <avhMN39TECaur0sS@amir-ThinkPad-T480>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
 <20261111151202.GA11391@lst.de>
 <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>

On Fri, Nov 13, 2026 at 11:25:57AM +0100, Alexander Mikhalitsyn wrote:
> Hi Christoph,
> 
> On Wed, 2026-11-11 at 16:12 +0100, Christoph Hellwig wrote:
> > I've seen setups where people use fuse to mediate access to sysfs
> > sysfs in odd ways.  No idea if that's still around, but if so, this
> > patch will break it.
> 
> 
> Oh, that's painful. Do they use backing files for that?
> It's a relatively new feature in FUSE...
> 

Very unlikely that they use FUSE passthrough and if they did
very unlikely that it would break their filesystem.

The API for fuse passthrough is that the server requests to setup a
backing file before open via ioctl and if ioctl fails (as this patch
does) then server falls back to non-passthrough open.

The ioctl can already fail for many reasons such as MAX_STACK_DEPTH on
procfs as the commit message says, so server needs to cope with the
fall back.

Thanks,
Amir.
