Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793225391;
	b=tglGzYRFJTwiPaGE7z/zTWPpY3Tfmsnu7EPMxJ2iyWbLQR6VOChIJ1zBsr3aliJ1WmgG
	 OMsacu6CJXNopGEfABSoa34Mtm7/PKpaHRcUePknBo4CFvfUZgJ9N4sdlNeLSRu0SWQ4G
	 K2WstYP8dahGmkY80MXIM5mZsOJWQTZiw927fPlutBE1d7ykf3SQzLkpRyWaYfdGxd9aC
	 D3rvfuqoJvTceiKcbwm/h+eZdjcqgbUBgQe3gCoWrqxhbsSTWKL0LrCHdpIY8inwHdXR6
	 BSyj2VspGHHSHXagWmf65gurltqkUbnU3ZfV1SASnU1EZ/9q5myypg79/u5wh05Aecw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225391;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
	b=GN70L7hXHROMf2YPhUVnJzKHo9xVd91SZj1H7OBnmB6SH6duVZgJK6U17nEPiUl2HsWN
	 GCsFr3EZNzYQHS+2nvHQk96HzZlZdSxjyfHuvEd+vrfTug1fRduSgFyoSaKn3iP5KFInQ
	 U3rBDxdia0uADec7lOE6kgQ7ro5Pw096d3TX/H78GG5gbHLGjEeXMkvmSykaiJmbsqoSg
	 JT2S3zVmOJmtq1+rR2vWxPKwUxBsxsf9tpa0huRepVz0Q/tEHkFtx+Cr6xpkZ4NDguRn/
	 ZWCwrNor7PsbowmM9weTpYRkJj5nz1yK7/tSRTzTEplJt2rFQiPOuiSuitN49ZtyaGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=A3bm0Rl0;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dMvVeWef;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3758F606A31A
	for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 22:09:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3758F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=A3bm0Rl0;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dMvVeWef
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793225390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
	b=A3bm0Rl0L2KduLS9N6kB2dKgaYdtONMvBvt1P3XLNh76A3x2xGqPB7TkmV7Er+QN5Y5qUw
	3B1dSo/GsMvmKMg23QEXMlEeFomWCuWJxBvIfP9jxMDdD7ej7LgtWLRtUlumo7/JZW0OYB
	3shh/V6sSxCJzAi/Ju+1lHi/e98NJTM=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-R-Q6qiHoO6Gu-UBwySVVcw-1; Wed, 28 Oct 2026 18:09:43 -0400
X-MC-Unique: R-Q6qiHoO6Gu-UBwySVVcw-1
X-Mimecast-MFC-AGG-ID: R-Q6qiHoO6Gu-UBwySVVcw_1793225383
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-67906c453b8so313554d50.1
        for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 15:09:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793225383; cv=none;
        d=google.com; s=arc-20260327;
        b=bGuQa23R53YfyfKec7qKginWRWl3jtBfog3uNkO87f96b0r1b9mCRK85Bh1ERr7Tyk
         3kXYirUU79TC63x7BUSGPXPM2ktRU8pjFz+lW+8f9Itobb7WpQexWyGTQfDRzNSqN8Wd
         EN/Oc5X1ae6J59hxQZXBfLzuIWpdoerc7tFBskZzYqGmpS4nM+ZaQRmAOq855dMSwozU
         FUgm/EqSRmG5mddTwEHqSmx7fvRlRmjDmgJxE/9LWFmfVLtLaXBprHUypJyu5zfT6tqD
         bOpuxosq6eq5lwfT5hl6VMmL31e+cKGrPGMDKcfVzzTnA+0BadPpHXB4aoATl0Ffu8oF
         vqAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        fh=fBl2g+iBb+wtfm98D3eVRZOiBUKmfXHHpsEUdcGuhIM=;
        b=DHd4cR7So4nJk/ly0mcBJcE/gz/VevBMzgx9u9kYl9cQLa9hqN+Vwmop4KV9Wu4Rgh
         v+hEtDp9RtTzDv6IFxb71I09XZ7g66AJv1NM6b/Rfyr6aek5JMfFCVZe5mNfForJQWhh
         bNfYbFBi/lmE8gtjX7IYpAdbAVh6iJgafPV4mO/5jAEW9AfEcmzCAjwjIwcQfMApYeQ7
         KceNiPtJX8QAlLIO1Isz1/udm0+R/Fe6kRXFMsLl5M2VbzfWy1PiJUvdU4NHEUQJIGEd
         XpP370uluYsNKhx8ZNGnXpZ3xB0XW/G0+2GJQDXniUYgYpRLUldvKgz4F2RNXRUm4Raz
         FLgw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793225383; x=1793830183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        b=dMvVeWefC8P+UdQKNVCTRzDnhWHngZQGob2rSgzwsZSnRN8SAHr7CL96OPYJXufFq7
         zSTFFPllhPr/w76wrseeWsykFIT3XNeylizZvRvScikFw2Vx8ZBVf5aKYuJSSTUPuuch
         XBaTxNgE5Gyy25Odb94BXqgaNMMlvyhAsHvl+cohQ1ckCaDBDm4+NkPEdFeD/j45D4SX
         9JdubWa1Rkola0sqbNiDrUuR0ynjj8Js5euvpFf83x/dOZOzpzImQtYe9Q9exxMiq/qr
         mXS/pEC6VjG6Gc4ktJQ1wDheP9WEZsIfL+MfkoZBHHuqMX4NfKOOS6gRPfYVsrX4HqWa
         L7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225383; x=1793830183;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        b=XwRhkbKcT5RPiQ9+DP/B8Ud87W4izYZb72ooI1J3k95Er0pttRFf5v3ifsCJ37qH3I
         +p2HzJz6oTqDDSp25DfAXmpv9d7ISQrOAVYITtmKpVPAnlaQG/sfLhCTrNrOmxvS7fvi
         I54zwLuqe4eFaXr99ovQIIYS5GxdZsI8txiJGo0jWVe1bmdbljN22Wh62TPzhcxXjUso
         SU0175aeCjrYr7eWuXRbRNq3jT4/MrWhuhVC8EJ1oB42oa6coCMPzwgFmx59ZsHWAuAz
         eTvCt9G966ajV5HzNPYWl0t54s3MlQC5pMjsk+mBZZmwTL47OEgd7ZIkdMTDR1WI3h1Q
         zyZg==
X-Forwarded-Encrypted: i=1; AKwUvByMgSB1xViHASzOv5mZIBxXGMP7jcqZ2o9cYKFCBqPoyUf8VXVfNlDsnoKmTB5wvdI/z1caqTMpl+Y=@vger.kernel.org
X-Gm-Message-State: AFq9FYJgcv4L2gc1gW/8hd7l3DJL2vAsnoUXy26ft7XtFRqBDCmUNKHj
	dYfo+LCD4dZFNXnYHekfhblY+aJo0C4NDO0DNdNYnfEdPMapJhEhfIQ1hqBQdslDD6Zu34554qP
	hTlxz45iaOFRh0gJuMhxoNdIM4OnDfsgoC/SeJWhZt0iCKwx7GGqtPFjvtRusewSxKC26s498wt
	qPWBhdcXtqzFl6kztDZaB4zexR4BZAe0vSznDR
X-Gm-Gg: AYBFou1oNzNCD6a2Ss/4bmT3HLTHK/AR//OH2mqokyX4PqVP4XRTfvffNuAzCPoua9H
	Nef7lyEVyRzo1/UVjuylI6m6gxDfXOicmgis6928Nu7VcmbF+HU3V4DAInTPbv1txfgP5bRZ7Qw
	3BkqMThJrJeI2HvcRLImZ0rhIbvOWpKznwrguK/W2bo96abpW10N6tFuJfyYs+J0h7RfUlXKp26
	A2UQP/2bKPSltF6yUpgAUDF7yPLyTDiA2nDvhKArBEGTg==
X-Received: by 2002:a05:690e:1918:b0:679:ad2f:3fbf with SMTP id 956f58d0204a3-67a8d0047a5mr704863d50.8.1793225382810;
        Wed, 28 Oct 2026 15:09:42 -0700 (PDT)
X-Received: by 2002:a05:690e:1918:b0:679:ad2f:3fbf with SMTP id
 956f58d0204a3-67a8d0047a5mr704846d50.8.1793225382297; Wed, 28 Oct 2026
 15:09:42 -0700 (PDT)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-21-60743a3dc326@kernel.org>
 <CAHc6FU6z4kX5R3Og8m0dYOHsjFcw+4Btvfe87AGPxy_EWs0E7A@mail.gmail.com> <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
In-Reply-To: <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 28 Oct 2026 23:09:31 +0100
X-Gm-Features: AclHuK9MzobLdiG2EG9M5KT_ibZzYxdrTghiXff6ZlesOE7YSK8Ag_RtXekxyZI
Message-ID: <CAHc6FU6VSAWQ4RJTO_eLnpqN5qvrShbJeT+ADwiA6ohpq8dO4Q@mail.gmail.com>
Subject: Re: [PATCH RFC 21/28] gfs2: don't set SB_RDONLY on withdraw
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 5:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Fri, Oct 16, 2026 at 02:01:00AM +0200, Andreas Gruenbacher wrote:
> > According to commit d564053f0746 ("GFS2: Clean up freeze code"), the
> > idea of the freeze sysfs file was to make it behave like the FIFREEZE
> > / FITHAW ioctls. This isn't what the code is doing at all.
>
> That's a pre-existing and separate from this series. freeze_store() calls
> freeze_super() and thaw_super() directly with FREEZE_HOLDER_USERSPACE and=
 never
> goes through gfs2_freeze_super() and gfs2_thaw_super(). So it never takes=
 the
> freeze glock. I don't think that's for this series to fix.

I mainly wanted to point out that this behavior isn't intentional.

Thanks,
Andreas

