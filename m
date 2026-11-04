Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753735;
	b=RnteOJP+HZqMEnR14xGrOWl0hdgtosxKq0Hg9ETNAJ4qPHqdy737rNCrxmCJvvraZJOd
	 h8S17PX5PBsGrX1sY+o+SznGEO0icAHKVUWILkCe8swhDAtUh7SfRYTPtxDelqEJpqI9X
	 onzkH8d8armunpN3djQjjW3DCMDkxYSwupEIraZxRWHo8aiCcrUSxeibqvS+6YWa6rK80
	 HoxFUdW2gzqhpSuTfQw75gqov3EvUXGtTOqRfuqSoQqgcFm3AWUxTYVJweddKuEuNZt/w
	 jFm6xLfZ6eZBM/wF7T8ePJDAHx/622ayLtMSWi+Ee79kU8vvA9HoiBHYbPsDvWphMNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753735;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
	b=kHMN0S5hOePI58szzuPSc3rucGPEW4DsL380fA1QtyqtMIy+oQqU25C/kCWgJJQIA3OE
	 YajAmhJyUztiEcVRnNtbyJkZNfPuTyhr2QFV0HGhB5VkQHJlRTj+Sy0LEZ1PQXyQC6g2W
	 nl+SB5tnUbSN4Piocgm7fUMKzHXjFHpNIzuWZ16nVPy7hCD6M+A1Iaj3Dbnha5mjZtY8d
	 H4ycUkMxIqX/6nQTtNYDb/f8HiElbPyPjzqrr5c80TTmNA5AWnQLpqpZEulR83V+jfnzv
	 xcZvkRhUPocfa5RcV6pCD+w/L2AkWEVAlcs6x4sdRvbgXa/lYhjLetm+g2BlThYHmhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sudo5wuz;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D58606A331
	for <linux-efi@vger.kernel.org>; Wed,  4 Nov 2026 00:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71D58606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sudo5wuz
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ac7842c17dso153317a91.3
        for <linux-efi@vger.kernel.org>; Tue, 03 Nov 2026 16:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753734; x=1794358534; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=sudo5wuzf8me28sIhbntLBwUiKNWuwSV6wtIncQpUBbsN4Zu1yMj1uOdtNMULS+qse
         p10GSTbsQZQej+RmcaRVIPfYXpiJc7DVP332tBPCeYi6iIxYHtw/pCGnwu6pUZaiYkuu
         1jzqj0fIApJI24vXlIZRW+4LFyo/2rv7mV5cIr8Gch74DjfIbhBYVLv8/dyYnqAxTrWw
         7/Kxsv4asQfbrP6PWPBOlk/xWVzyI0hLDQrJy+RjayW+oFANYAqhfVZpq60HUf6srI5f
         LvFF0LRAtEUesVRTlzKq8hIDxyh050q8ogJnunYhdFI0Mss29VGLQmid0PHrrP/vhgJw
         FudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753734; x=1794358534;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=MXFjwtIxihVtq0gM3xNOuRMlFJDawKFsr2sq+FKu9KyPLsdYjNM1ErrIin7lBTk3yQ
         GQX81OtxOvzDO0yXbqxZRKLyAq3furcuco/u+GlvLAdO2TR8w6tFLcSmpTwyYwdjwE2a
         i3GlpRC1qXyH+TfYv771Xk1UmUkKhAwxl+p0gOGq73ttcy6L/kBBAkXCPecVHKbW57yl
         0y5FE14yIwuLhc9omoQIBq0Za8cFAD4fnHYZcAWCaNKze5cJ8Bk1+mvJ2iY0Xhpxcpxr
         LDB3QV03AQXkZ+r5ptEn5hAxFEXp2jV4OjVM8AkpFeCFZUFHMtiA1NJfXWRv9sJ8vUKn
         pxBQ==
X-Forwarded-Encrypted: i=1; AKwUvBxdRSznVBpPVHsZpsmR5om9af/8LFLO093uqSquf/Znf+rcSfN7SDky9VGQftg9gm31MCxfCNW7+Kg=@vger.kernel.org
X-Gm-Message-State: APuU4Z90KrVsCmY0Q5riAhmbZURnWP4HtcHtHM25IT58v99sc1KfgrG6
	9kJlWliLyQ9lKEo+JUqf1YoMSwdPvcqYP/1pP2MILPJL9B0I1Iv7kdk3
X-Gm-Gg: AYBFou2FOTwMHFJ8Vn6iXMaBILETlYaRcFcbW5O+0ZzRb/7/VMHyPUQW5HA8kQMWPsX
	vonKXHS7/ZWTzjebto4E/2MI7ry6Bfy4I6r4u1HrDosHcVCjJa1rUY3cyd4Fq2GHEo2ZA6UUkSJ
	mYyIs/M2x2YM4bFfS1B1aB+J0IRhtVj5vIcu25gs3Eg+O48tdUDM2uQn/6+QvCcLayqVPaWrJRc
	GEcnjGp1D8jv9heNvu04mjmYZlgB0axv73S/POAty+HH1Marqf8hwMB2X5GGow77X7cChFxM2QS
	sxObN25fifzmloGRWTFuwbIz23DJ94e7iTnFSIZUsNFJXNW6tEK/cbOd675VBC+OFBpbSXCoNxz
	NVsSXnPbXnXlHSU9klCH16JFPhLufN6DbV4uW8FC7i/s8CySfg7spUULNB/u+dU7yYzRSYchbW1
	EImHJ9swjNiGw7jK74sh409i96U9HJEyXFzW4DiFo75a+3UF0cOCaqEdWLfV/FySkJVU9E732n1
	T1mYozKRJ5JEbnLYY/zV8ur3j5y/Og9axom8tPUZiIYkONcuhnA9NrM0ZsMn6ch4H+YQIOWqPGz
	XgSDf94TUJ4Z98TpEQ==
X-Received: by 2002:a17:90b:184f:b0:3ac:83c1:2c0 with SMTP id 98e67ed59e1d1-3ae897e06efmr11479861a91.64.1793753733906;
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09445f7b3sm1222403a91.5.2026.11.03.16.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Date: Wed, 4 Nov 2026 09:55:30 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 18/34] ntfs: use the generic emergency read-only state
Message-ID: <auqCgguXEsKCq9p2@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>
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
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>

On Thu, Oct 29, 2026 at 05:07:09PM +0100, Christian Brauner wrote:
> Set SB_STATE_EMERGENCY_RO instead of the NV_EmergencyRO volume flag when
> an error makes the volume read-only. ntfs_emergency_state() keeps
> telling a shutdown (EIO) and the emergency state (EROFS) apart so all of
> its callers stay as they are. /proc/mounts shows the volume read-only
> again.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
