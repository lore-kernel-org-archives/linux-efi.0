Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686762;
	b=RaUlo4xotidJHGGfT/3xfSa5xg62a6k1O3Av+JDSR5PYcVnICbosmOm28qwOnBI5LZEK
	 aOYeKeYXSu7/fKU66+6ummgD6vNcEz/hx88PLKbWPfBU2pKduNEmJJurdkSDatWixMRdi
	 WEL/CIZI6SDRmOWCMocwWJOupHNEk11+LZXj1+CESnbmzUsklArBEesav6JyEHhYBr6HD
	 K4gt6aBCwy+2RYxSANwKSnsm4QpQkHRANe15fDWd5vc6vtWzQCeGT51r6mKWN8pKGKZBV
	 l1ql4rCR7rlJlI6M6yIEaBMa/x1QS/5OqytFDJ35oakhavgqjrdhbJESMt6FbrtQ8pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686762;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
	b=37ta5b1L8C/btpzmJ55+ffJhsfDaElR/H8GT3CK8z9aWi17IQBxS6+P5esdoeOzH+3bV
	 AA/VAhcadvwwMGiCmVhXyOqlfee/xx5FnBEiOSZg/qyhi9W8aUnBKkQePwRHBkr3T6nlY
	 USKR8dEIxFNQbAANTSDh5CZnmY2RfEtoOG0ViOoI9uA+eDyKH+UP323/gFp4vaPz+6ggy
	 pCtWN8UpN+egRhdjn3ZzP0J9/Y2Fo2TdFfKycN9Wadu5NFnbfMdgGdHWiSi1O7sU/yQhI
	 M0zLwjJAgOy16UJzKoeaizEG2ty39d+bzJVhJPBQEKsTA4OhCS339qfyEAsTKdkO2cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=WyNKKpAN;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A330E60A263E
	for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 20:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A330E60A263E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=WyNKKpAN
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b155f50c24so3334983a91.3
        for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 12:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686761; x=1795291561; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
        b=WyNKKpANsG5sdrHWGAt+Y38DvSIGt+WnCUyNYCZoBM4YbSq3wCVAHI95jQ8BFTGgLn
         +vM7af/q0i5zrzjZXXnriwzXN4L/RbeBg/iztvO0eyeIXYNiQp/OYlS5LD9yZqr2gKgm
         1I+5A88e/cV4J0nLZfgp0f7sQwj9jY0Q4quBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686761; x=1795291561;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
        b=FhiAYFMaHC9UNI48mlSambZKJYMphKam2NVVnkbTf1Vdb/Q5ve4RVdZBjShU4BQ1tr
         /9nBTKQ/St5hcnU0K8d5XK8yOMlCDgCmoiFS55Y7k1s2fPBlvc4Ngkp7mNZSngbHZOUo
         Ojd336h9ZkZnTUpf07rPtGyaQivReyarnjMeA3pj4fcf5qvjJkTFbalwQF0nXxdynMHU
         7vX2JTgAfU6TLsblZPD5yFCiwzs5W6yeTWxxgiWbLyao7sd8tHWSV2amAXUv3UwkWqWx
         hFwyjOJ1D2isLosmHjSWKupnaBbzwz2ic9LS90Mm99jM8EAbIVJTdL/XPEm9fSp/Ctpt
         kJpg==
X-Forwarded-Encrypted: i=1; AL+hErGGrp0QREatgodR2YnoBuCCp0/g3dDHGl2dp3zL7UbkwD6WarXYx9rqz16z0h21sXSWtYMcf6/I6ho=@vger.kernel.org
X-Gm-Message-State: APuU4Z+oradIdwkV5TsiKhZdWDwb2FjwgZ3fSgv8ZfcoRDcN7I9Z6rlh
	VkON9aASrTDz0AXBBy7LHRnbtiMf683Vme/Pwy2BmWwmKElqHaDren3M3+xn/Knl5S8=
X-Gm-Gg: AYBFou23IAfUL9t7pinZ9DmpvFgerpSDj0AXT9mgFwJM2y7GbqqLJWUogFTpaHYOlH2
	bLEqStxO84BfKxni927jb0Bi2Rlw/4OOJDNIoF1SVkSd9TfAgiAOv6N7WN7NO1BdCFlK9G784+v
	47fZVnaJvnYfb59aVm0DKi7Oyt+ycCWrfdCC+IOhG12nYLCA5a7+jLd/E7tZ8jA+X0vGRMnykZT
	hBX6ds7NQv7Ju8W3NS6tvD0epaGF12qIHdSKbqEBdGsr+uxyWbX9Cf53ecYVIlcmYBWr1mtQETO
	6o8MqTFQkdEGF3SLlH9k8e7T7k2S1LVhQqmHJFeaExLtFy+EXlrJmghIBnODmc+4sYD2YdIMuWQ
	FklLVf/gRjC7HS9J5ftRVhZBfq4N25nfCBkTDlalL0GoDzAEHOraY7F44JS7Rb2f0vdwOHdF2Z/
	HGbJGoxHLgLsQ1Fha7558qEY+rMB1kafFU4aAPFmledvKEWupT0lArI2+hI5mC7rMcMqfs+R3nf
	lVTZIN9yolGRVwIo6Vk7jtZruDC+uA6Kr02fb3P8/CqwVbBV0T+abJOxzm4m5MtIYdFp3krn5+w
	vCkROXagWSIUR0BjXdwCaN5yz69WHr3Xn44Gpxm/whJrW1kH8sbPoFq5T3aO+DUyZc8Ozq4tJou
	MuGj6RvR5JbqxziQasQ/VYg1S3MpnbfafpyLjkiM3lsJe4mMpsX+x1uqSbNAoQL86Px1PK6P/M4
	RCZ4HztAcqySRsqueZniSca1txwYGPs3Z1MmX+Ql6Cw2PVa/pFzJqGd54V
X-Received: by 2002:a17:90b:2584:b0:3ac:9f00:3bc7 with SMTP id 98e67ed59e1d1-3b1b0ba61famr5629200a91.33.1794686761104;
        Sat, 14 Nov 2026 12:06:01 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b1e9ef15sm5258887a91.0.2026.11.14.12.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:06:00 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:57 -0800
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
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
In-Reply-To: <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
	<20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
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
Message-ID: <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christian,

Christian Brauner writes:
>+	/* Look through stacking filesystems at the inode with the data. */
>+	if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEUDO)
>+		return -EINVAL;

This looks good in general, but what the bots said about O_PATH files
here is real. With FMODE_PATH this is reached for a file that was never
opened, so on overlayfs nothing has been through ovl_open() to look up
the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
itself, and when that fails it hits the WARN(1) at its end and returns
the overlayfs dentry, so the check passes as well.

Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
it's easy to trigger with that. From a quick test with a metacopy file
whose redirect into a data-only layer points at nothing, registering an
O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives

     ovl_d_real(/f, 0): real dentry not found
     WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
     [...]
      file_check_backing+0x308/0x5e0
      fuse_backing_new+0x219/0x4a0
      fuse_backing_open+0xe8/0x390
      fuse_dev_ioctl+0x53a/0x7d0

and the ioctl still succeeds. A normal open of that file fails with
ENOENT, so nothing could have used it as a backing file anyway, but with
panic_on_warn this is now a panic.

Maybe ovl_d_real() should just stop warning when the lookup fails, now
that it has a caller that isn't trace_uprobe? The check would still pass
for an O_PATH file whose lowerdata couldn't be looked up at that point,
though.

Thanks!

Chris
