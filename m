Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794405401;
	b=qJaGvRVGn2FRRG8E2nNrGBy8Vz6Z4mYUabAp7PASUgYp4pr3EfGzIT05GAautbcTc3DY
	 PkCiu8/8cSWQhuj3OIp1knopWkZR7LBEuANzHZBSUV2CS2QrPmH8y3zKkfxHBJUiAPMPE
	 uaWqRTDZ2Em7Q09mI9Y30izHfgF9aAujp7ZzUT3yjKWKGxq2nlFJaQOjnL3tMV4R6Q9Gf
	 UpATwQYPHC9TK7VyIQtHwjRg/RP05ZjvrAGLJNR3ShwUcwT4kTzv3epCIN1rk7k+G3VSl
	 wtTKHFdMPJTw30htkcEcIKf/DFM94I4JOk1eGRcDtpRsFkPsqoCIJMRjqT5uIHKWCrQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794405401;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=oRF2guphEyqLr1O9h9fq+s+FW78qBgZ0/k6wviHnruU=;
	b=GOAHzu2faL3QlD4PwPcHt6qUxaPH7XiK0oTLuoIK5xc8n5B0n5E4lVBz63WWNUn8imBd
	 HtufIYFhUnoP8ROrGogx3kw1z8izoE4PzHekweZUqFCBKbrROj0dk8GbC1HmsnoEb37WA
	 HAS+HRxOTy7bZa/00gWGsQPEkFWk+GU9MM658od3pH9bISGziX20ZEsSIEbXYojyev6B8
	 1Gjh64WMViCpESbKjl20G/4lHLDTh+s5WtSVK/TRTt3Rv57dbgpvdJGYvplUGj4wCxjEC
	 mHdqA+lhfQQ5W2bI//PbdBKHVNCkx/b92QYhuIx0iXxyBmx3fkP2Knp57W4HOo7w5IQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jpjn3736;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FBF606A880
	for <linux-efi@vger.kernel.org>; Wed, 11 Nov 2026 13:56:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1FBF606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jpjn3736
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso22146955e9.1
        for <linux-efi@vger.kernel.org>; Wed, 11 Nov 2026 05:56:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794405399; cv=none;
        d=google.com; s=arc-20260327;
        b=GvD4UWuiuhqFA+ovrdz9/OlZeBaWqFuX1dogJ2bo26Hmgfvcei/9YlPqp1NbyU/mYB
         5x3XUcuE+ouZDl4rugZvSXvGt/2H0p4iF9iSbN9QnTOoSQiDht69ciPUpNRO428oLeJz
         6skZBWLMbSuSnnSg/i2ZprX67hElaZNXKW1tMRCf9JK4OckR93CISLeptrhECKJreGxA
         mwZ/e4Rv5TzndwLKuudItWWtlf7sJkZDkOFZVqFd8vZ9PaCDGdpuX64qZbSOnM5hwApC
         taRNxaK44Rjku5yXpdxdfmKmRthKoXVp0rCZICLz9/fe6CR0UUM0UklBijms4wkbfgZD
         lN/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oRF2guphEyqLr1O9h9fq+s+FW78qBgZ0/k6wviHnruU=;
        fh=iWMAFx8Jxn6Be+Zj7aGfhMjkNxcoYZ3rzA54mVwpLRI=;
        b=SpJwP4kW6QxFrEIFQR6aVJdP9PCu8D+tuzc7jUDra5FrU2cvKJ5zj/S6exqgpKdWjd
         h1RdTWx7Wlo0HvJtHHSRa3K38ZHo2RP11EPy8RhXS18tyaPuPI65qHhB3TWTw9gtg+Ab
         3NgZ5Tcy6roXqQEKHr94K3mAWnekZPyMPjBNtmIopGOlSNH4ZWykBwb8WAp94YMDLaaA
         YVyTnk5UnAwkJmNhUXmsrhN+gNtHeM8TA0GdLK53HRtI2rSsIEdu5fvCFlGg0SjFnIgI
         Ohq4yTcSYtGHJ/IwoebgSvyASePPF3nQ1QK+0rS8vy7hBx50bNMykLuQw1Osizooermi
         GHwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794405399; x=1795010199; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oRF2guphEyqLr1O9h9fq+s+FW78qBgZ0/k6wviHnruU=;
        b=Jpjn3736+17VV3j8BY9HdEIk8rTF/SZsQTWCIIW7MCwGXacnTX9L9vLzL/yYMO2j+T
         /Tg8YarJp3KO+2kkZAtuCnyWFm6xfuCzu6xYKxq5A4LV8ZD7cejyZFDLGg3CNc2cW7qV
         78B7pJY3UjM7ZvDEDLEFLG9OoCiyETKx1LgjlIXgeh+oupn/V2v5k8kZkU/SAgbI9nfA
         vRcOi4TfjWFkhmeQsIZH3L6/BiFbwG6Oivumdk8otPWw5ZbNJcunNe4vnVvq9nfRxubF
         mC5bB4fQ7a4dpTCTfgEmrP7maH+TKrhpL9Kl1UA+ftxPHKFKc5kwnu0lbw3+IzTtTw4E
         asyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794405399; x=1795010199;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oRF2guphEyqLr1O9h9fq+s+FW78qBgZ0/k6wviHnruU=;
        b=XCOgHmSUDFiLFKpVDWHklw50yAxw5BWQ6OnFjfAJYJk23c1S9m1uROyicRwRFMvGFs
         cno3ccRnFLjcRFQAteld+0xuVcEa7RIaDvzYlvUTcrDfSogYhm+8wcs6uLOn/d2uTqRf
         f+WGZME7NUIqe/3BQW6gRtfais06zy7o6+IY4Jte22i2VN0BCfOz2W4LkHf4LixRx0WT
         zkD9y2bQnlHlUdkCuxEm0YXSwO9v72uU9CVy8toTTysFqOvYxtkHJs9Xd/LM6hJ8p7I6
         qEk8SZ/dhSCd7ipi5LIkTZNPjqcb2sRTymPTFVVJ00D7gjJi4mwGdpmHX8clGSRuZkH8
         TTZg==
X-Forwarded-Encrypted: i=1; AL+hErEFnzZ9PQBWrHfK7jnl9tHNtmQBXgPomiGRNm8rjPY5PetqbcFJ9E71VpsyqtjyweT2g8SvUqtiwUI=@vger.kernel.org
X-Gm-Message-State: APuU4Z+4UgFVDN3I94NYv/QhB430PtJ1ODeOLf399nvjAwhwKsbHhmbD
	dKxzGyyfZldxsoFGkAmafAe0yhu/YZwN9SHTiJWhvWBmBwg+Pzt5WmJo506b2LMrAMlXP+TGwWe
	0WpHJJfODL/aF33J0yjL/qcYydUpq4yqm00G+
X-Gm-Gg: AYBFou1Pe2DLsYnGcSIjYkBdrUS/1IgRfOJz7MmyFCoGYr7NhEvdzBzmbfjdbzZKclO
	5Khs5d/wi7ZqADKgtptSi4oX+vobdiesoOCmvBDpvYOut191q2HzXorpSVNQYGD4h7Gqx6PzzWF
	GWn7YyqdDfgWm6C8C7iTK6TIuUDNzvCJJKMaGsTOgt52bblQIteGMqDTHCPJi25alOLA+V7sNz6
	LJ60UgcKTg8NENpFWUhZSMlxUXh39m+tgodqEi54wiOzCA5+4lqAFdadMw+n7ErxB4c6OvmlYfW
	6LndjWd+Tw2wbCwfmOe2WMQuN98gREcWRQQHbeJB5ilgZZ+EhJIuSWbKxKpoKV4wYiFYKSLdQyv
	uu0nBknlHJGq4FTsN0bkv3LpYK1Ga2wW3U3+SvL1XUfMUeYltcc8mfgpvAU0=
X-Received: by 2002:a05:600c:3485:b0:4a5:a5ca:de1d with SMTP id
 5b1f17b1804b1-4ba093a9321mr49991515e9.30.1794405398960; Wed, 11 Nov 2026
 05:56:38 -0800 (PST)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-6-2f44f64f0b66@kernel.org> <sashiko-outbox-191225@kernel.org>
 <CAKFNMombDWkJ=m+CjMy7qnd_yy-vZ9c-EE7R95HKKkcy-M0+SQ@mail.gmail.com> <20261110-deformation-knabe-geltung-3bb7600eaead@brauner>
In-Reply-To: <20261110-deformation-knabe-geltung-3bb7600eaead@brauner>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 11 Nov 2026 22:56:21 +0900
X-Gm-Features: AclHuK-kg_k64kD5D3ppXkSngFLDCk2NlJ0a-lNWh9VMpnIyjECtxc1ueGN5wqg
Message-ID: <CAKFNMomUbm3JUBy2GthZwAuFZWh5TSb7i0+g8u1qv1aRviqdaw@mail.gmail.com>
Subject: Re: [PATCH v2 06/34] nilfs2: don't set SB_RDONLY after filesystem errors
To: Christian Brauner <brauner@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
	Karl Mehltretter <kmehltretter@gmail.com>, dsterba@suse.cz, tytso@mit.edu, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 6:56=E2=80=AFAM Christian Brauner wrote:
>
> On Wed, Nov 04, 2026 at 02:32:10AM +0900, Ryusuke Konishi wrote:
> > Sashiko's point here has a valid aspect.
> >
> > This inconsistency can be resolved by inserting the following handling
> > logic if sb_emergency_ro(s) is true:
> >
> >        } else if (!ctx->cno) {
> >                 if (nilfs_tree_is_busy(s->s_root)) {
> >                         if (sb_emergency_ro(s)) {
> >                                 if (!(fc->sb_flags & SB_RDONLY)) {
> >                                         err =3D -EROFS;
> >                                         goto failed_super;
> >                                 } else {
> >                                         s->s_flags |=3D SB_RDONLY;
> >                                 }
>
> Meh, I'd not set SB_RDONLY there. Because it changes the read-only state
> outside of reconfigure_super() which is precisely what this series gets
> rid of.
>
> The superblock can be frozen at that point, e.g., when the error hit
> while it was frozen, and then thaw_super() leaves s_writers locked again:
>
>   mount /dev/sda /mnt
>   fsfreeze -f /mnt
>   <error>                       -> sb_set_emergency_ro()
>   mount -o ro /dev/sda /mnt2    -> SB_RDONLY on the frozen superblock
>   fsfreeze -u /mnt              -> s_writers stay locked
>
> It also turns the superblock read-only underneath the existing
> read-write mount without sb_prepare_remount_readonly().
>
> The busy-tree branch does what get_tree_bdev() does for every other
> block device filesystem. A second read-only mount fails with EBUSY and a
> second read-write mount gets the superblock and every write fails with
> EROFS. That's what ext4 does since commit d3476f3dad4a ("ext4: don't set
> SB_RDONLY after filesystem errors").
>
> If we want the second read-only mount to work I think we should do it
> for get_tree_bdev() and nilfs2 alike and treat the emergency state as
> read-only in the comparison without touching s_flags:
>
>         if ((bool)(fc->sb_flags & SB_RDONLY) !=3D
>             (sb_rdonly(s) || sb_emergency_ro(s))) {
>
> But I'd do that on top.

Thanks for the detailed explanation and the concrete scenario with
fsfreeze; that
makes complete sense.

While the "s->s_flags |=3D SB_RDONLY" assignment in my example could simply=
 be
dropped, your approach of treating it directly in the comparison looks bett=
er
as it is more conservative and natural.

I also agree with aligning this secondary mount behavior across get_tree_bd=
ev()
and nilfs2 alike in a separate follow-up series on top.

So, I am completely fine with keeping the current v2 patch as-is for this p=
art.

Thanks,
Ryusuke Konishi
