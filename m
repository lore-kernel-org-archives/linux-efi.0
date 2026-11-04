Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753392;
	b=MDHk4uVSuQJz0yrbc0vvkLeZlK+Jy23zv8Om6A3APVsvPaoo88bV6+UUDWzVPMYbzQ2S
	 m2cjtr2jhv4DiCPyI5YIKZZUkBnYLM4UU9b4Yc00zCTOZGAhTLgCm7aSbenUqH9wPBFcO
	 t8VWlGnSoJG7WGWHFg7ZbdnJE72T0I7uVxKd5dFAecqecSNBaax9PSDBNNDJ6ctpHUK4t
	 66Ib1clPf2nWxtoZON4hSPkdqCx1mu2tMY+twZ6HIdVfndlWBGUPwgINsIs0RVy77ajo+
	 /LviXeClxMm1b0LcPZidSQ7cU90287+ZisSMbo6Eg+TuupTWOmlElw6TdSHnAV+mQig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
	b=pKZiXMKXyF3PhqWpvcrRWOmPAvRbbhlBSkT+GmvptoGCujDqfPJWeeRTfcG5RfdTC/7K
	 uQWWc0gXdCAxaJAlR8juz1uQxXxbGMCLn5/bmxyvDO/ZjOkZh51dPnTI+pK3vevenyfmz
	 z0Tupeq79fZPUQjP+iLQCEnxHbIsnHOiAQMnSV+pwmWfIz4nqenSBBcSflXjj9QiUqokR
	 LwtrgAuyrCvYKYhvTNHkfRag8+ILzB/PP78V4Qo4zzIXSB9+kyl7LWy60BCg9xvQ/7uAP
	 FeRnl6NsjvRMdOb/MdkfHigSACM4PlVz8SlhI6OlxCeL++zTvXk6+IUgqe3/5EZLzQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VT+pUP2N;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29086606A32F
	for <linux-efi@vger.kernel.org>; Wed,  4 Nov 2026 00:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29086606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VT+pUP2N
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc4aa0246b7so80466a12.3
        for <linux-efi@vger.kernel.org>; Tue, 03 Nov 2026 16:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753391; x=1794358191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=VT+pUP2NwuZcLnfpE6RBehWP9rj7p+v+tKoR/WVHOzz1v7CJgJGu6gqjY1V/YGEdmw
         igNrVOnPTFLv9xvYK2tnZhcPD4jqAzwLjDlQ2iFsJIT0vgZOsXkUB60qRSrv68Heg2+2
         k5XkKmMrKWtBUKDoGvgF6CjyKJx7mmzehyXgiMW8Z51NtcdDEa4LvP5GkI/GPk/JWdX0
         E0pyc83t8pyqA1wDQ4YMhv4IP3UIHbsnnJtT4+s3TyxuI9ePzpN8dD0BzwPhXNBIUBNN
         GS4KAdHBqzLrJ9upnMsWdUfiG2GuZuR+cDGx90+hJalABWpp8S3bPmquj5j2mZuikn7l
         6bxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753391; x=1794358191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=YqLaC9UV/rSBa/iyXRqSyyJRu1OL/K8XO0Zv0rkUUOopaHewykxErRQF0NkeQqpvRi
         MplkmvPcHILrCsxupKaXwX9tPucT6a19u8h3dRW70kw6gBvP54Aj1NlnOAJqYA89Jy06
         yFxnys+0sK+L+ExMsLbbjonCyt2UtIq2zfORU4yrP9ioDUNiFsX+7g2k7YN28kYYJibw
         IwBxbxPWM2mm6oBo6v4CcS9MvT4sYF0k+d3qI7GmYm8IOMUX7rHk1CjPj6EkmUR53/zf
         JAJa9gFLFOvv8460xRLnlskFVJLVQ1pMlQKPQtw5dZ7B7u+KKbQ/SqeVCWgsdRCfqXva
         qyww==
X-Forwarded-Encrypted: i=1; AKwUvBwOLmGzxAzRzEHHnKMtKLvTFEKyL8EnXuVquYU9NUL+J5otjFSMN04k/rVJ+6BX8t8EmV5eM8C70iY=@vger.kernel.org
X-Gm-Message-State: APuU4Z/LA6+xnvQr7HAxaGlN5Z62KDGKDR3X2QWjSdzJs4v0wS4dZWrn
	A/8vqif4Od/UcLfUGeRLq9twQrN1TDkJXh6AZIVfxI2NWpEMJk0wpSWr
X-Gm-Gg: AYBFou2tcF/SMiD5W8ynQSUYXa7i/HbHMIW9LNySPPHLKgDcAAltQgLC0jHCHU3ziwl
	efEssQAgHRzjVfby9dvqd5PAD+EDzLAROVlMwskCI4gk6x6mCV17LlWxko9Bw09Rvu1X8f7PRZP
	GqpscHU3TljpEe4vD1RV+Y9o1yd/RSF0vVpdF1vA604+iNVOMpfHsEyhzPNsus8u1qF/Aj4pt+j
	ULVKjtTAkWkPqz0iEghc94zaaTBwK2gyt5NtfwGqDruPUdkTmD7vs92IAmZtjSAH4vhG/1gAtq9
	unqGpXZFAEh+CsQzeOb6A0GXqTXz8zvAJdqKbG5Lg3qlJlBtj+UnlhS9SaZWeB1jmVeI4SAY458
	7/IELQv6n6jgecj8pqIHXDm2YiOr4EZiev3Pi+Zqfwt8aDf201NEn4/mNwJINs8VFC9EMx4hc52
	iEH97A+78pxjfytV8KLLyhmz14z0xtKG1ZkV5dD41cKHKHejL+rhXpbTRY+QorWTIcY0diWv4Z3
	nQ8TffgAbroTs3Bqr8qWJ5sGk9wmzPkZ+/JXNSkhM0nIAlnrH1eVWFFN99HxVuc0GtMSneT9qD4
	JIfZbZ9E7t0vG9lQS4FKXJR4ZkJ3w3rYZO5mUQg=
X-Received: by 2002:a05:6a20:914b:b0:3e2:9470:5303 with SMTP id adf61e73a8af0-3e928953948mr11828504637.15.1793753391239;
        Tue, 03 Nov 2026 16:49:51 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb46440cc7sm329325a12.3.2026.11.03.16.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:49:50 -0800 (PST)
Date: Wed, 4 Nov 2026 09:49:48 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 17/34] ntfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <auqBLEvcurRZfGj6@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>

On Thu, Oct 29, 2026 at 05:07:08PM +0100, Christian Brauner wrote:
> With errors=remount-ro every ntfs_error() ends up in ntfs_handle_error()
> which sets SB_RDONLY without holding s_umount. If that happens while the
> volume is frozen through bdev_freeze() thaw_super() sees a read-only
> superblock and leaves the s_writers rwsems locked so every writer hangs.
> 
> So set NV_Errors and a new NV_EmergencyRO flag instead like ext4 does.
> ntfs_emergency_state() returns EIO after a shutdown and EROFS after an
> error and the write side shutdown checks use it now. fallocate,
> ->set_acl(), FS_IOC_SETFSLABEL, FITRIM and ntfs_mft_record_free() get a
> check as well. Errors while mounting still set SB_RDONLY, nothing can
> freeze the superblock before SB_BORN.
> 
> NV_Errors already refuses a remount to read-write and since
> commit 521978c4f444 ("ntfs: sync the volume dirty bit with the recorded
> error state") the volume stays marked dirty once errors were recorded.
> But the dirty bit may not be on disk yet when the error hits and
> writeback is refused from then on. So a work item writes it right away
> because ntfs_error() can be called with mft records locked, and umount
> lets a pending one run first.
> 
> Unlinked inodes are left to chkdsk in that state. Their mft records are
> freed with direct bios while the index and bitmap updates of the
> deletion can't be written back anymore. And writing to an encrypted file
> only warns now. It called ntfs_error() which let anyone put the volume
> into the emergency state.
> 
> /proc/mounts keeps showing the volume read-write. Writes through file
> descriptors opened before the error fail with EROFS.
> 
> Fixes: 6251f0b0de7d ("ntfs: update super block operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
