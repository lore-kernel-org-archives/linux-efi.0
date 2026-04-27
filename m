Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABC12DF12F
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 09:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280717; cv=pass; b=eHMDCjOaZiTUf84tT3WTcnleZx3AKtCf2NHf+vC1ceatWOSHYznPvQlXtxxZguZ0Srb4D1Rt1mZF3eeWpf+bRNbwDE+v0GXWNSIMUD38WIpEbhWTMotIOX1a/WFMtj/tcoElUJZdaymCJtrzC3RmRRYle/CEwRvkdRfm9Zp5kPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280717; c=relaxed/simple;
	bh=a5WlGur2x+nU1ZXEt1S7Pr3BhzTo07kXxugDtAVEEhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tCghcW+JZkorkpoo5elOxmpwwZ0gd6oNpwWdDF1adA+s+phTbmoNRPKmlFGgo+IHtPBXr0VhcEQT5URsWA9m3pw9+RC7MqU2KNazS+FUupTti8S6Vsrfcq9AQH6I04lZBjVEwbq0MAQPdj+07jUMtY6+gaXs+pFRHIWlUesyQwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FeVsCtH9; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FeVsCtH9"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ba6838e76f2so988718866b.2
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 02:05:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777280714; cv=none;
        d=google.com; s=arc-20240605;
        b=R09ENbaCgq3skxOc3gNxujqZkXIyDOe0SZb8z32dXfIcZzkZjyXypZCD/arcyXHt8u
         McK4fFEqK8+Gy93yoTRK0+Tm8ntKmqfW0IvTAqLxLvoGIqjyHnh7Bcn7vA7Md7Oc6Shi
         3BHBH08QsEwIMPcKlCiYvDKlwD5kWylEdyVkNKil1iCtSvsHHysxuFbkSp+kHcZ5J1DD
         4ZOgSdACEjs1zllzmvp8dxYmP8UWA4Q8EIn57NS6y3EMi2ofiV/8Gs7e858xdq96HH6A
         xXhjWmAk7f+zpvJlk1UAxXP3QS0W27BLcevOirWaRu5bkehrz/YxUZf9Ej0LxMQW41rt
         G5yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BGupVN5az5s8pFT8H0NZ4pHuG9HKT10qjTmw5QNkxIM=;
        fh=XKmfk9xeG2dLwGzHCd3rg6jmY0Z/UjXIPOKCZYq+pA8=;
        b=XwDR33kUowieA4RJwFa5QOgVIJ90uoAeG9rOXbUSDLFsYhvN4FxkIhwt4uikrp80jj
         JNPDbsT5UQxwnNa4Q65vqP8SLh7/hTsmCeXMS2BYo3QVgOafQ8BbsSBwPsWaLPKWmS5f
         tDV9+C5o9z4JvXNC61a0TKZZWEU2QGyWloCa0y31lblYdvpt5WSvH7F3fQjMvLwyFPDN
         o/dXSpbmyzrwQ9GoVd68Jfyy36HPTWnM3a5dOlG3Gu1Jbmsj1V4bwESrtsARpBIYy+2+
         puO9fxgrc52/Nzcso8+1ywihUbdu71orXrxT+/9QnH9lNWSnnVLocUQrMJNKxwxVg2Sg
         osZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777280714; x=1777885514; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGupVN5az5s8pFT8H0NZ4pHuG9HKT10qjTmw5QNkxIM=;
        b=FeVsCtH9PneHPhOEcOJCpacTtqhXnJHPtiJ4+PawigBG+gw6FpulourYIBqe7RbI2E
         QaBFIqQPJ+GtuyXwafgn8USJGEwOpU5XkKvFghsDHa5FV1PlkvFMesDHwbR4rGJzjVKM
         UVb/q2WRcAyFA4NShDXS9Qbcsgm4b8L90wheIVFcTIIt7quepxV5GvYIJUTgXM5s7lAf
         qkKxHJ9RU8YsMvPbFyDpfb6y6x9x6cIcgZ7KSB89hDAbe0ZYluKs/GrQEki46kHwhhNo
         +/oqHS2wFahQO5WlgIaBujyRMgbEaxxanXNdLDWiPfDqVJewL5TxJgE4hdtw5t8ulwQ2
         M04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777280714; x=1777885514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BGupVN5az5s8pFT8H0NZ4pHuG9HKT10qjTmw5QNkxIM=;
        b=qKt1URMioVr2CHFeB5Fvf6y3Yn5sdXRDWW5Nm7admsFye3B+Y/VVL2BdfxMfw4qu5K
         uVjOQMej9gkWdIDpnRZoFcY6Q1OS9L/Vrvq4NA4S83NcavTnv4O3yt/Rm39c2xlbSW6K
         tRLxj0CYPtdGaVmc7MQjluutzyL1+KRSuKGTrUh/19JbAmiECVf1iQiLt/rHUk4S+ptr
         tfv1armb7L8l49DXjEdustl/aZzZUtMqN+05w//kFCop0Sd3VibB0pX8UGsifPqHfDNC
         H30G8g2Rfoq/mT/YKNFWpJfdknnMh5amT43DzgxtJBiLE1X7eIu7b7/OR3nLNIFcMcob
         zdMA==
X-Forwarded-Encrypted: i=1; AFNElJ9jMvgnchXQfNrKzBJqutYLTrp11uyphLlUNfYlR54X/t7EzWoRKhScxNgTTDFELNCKF2QihcBDME8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY356PcHs9Bga2j49jNYlD3AzVIL9C9DuOzFTDPlQCNuHzCdt3
	sSmVqG16/Ncmt8hsja43hNg3TuVSu4SrcMbkFR8Umg1FX7S0QsxgMHwk40rPyecqU3w8luEEgkI
	2gSI0AISJiRPWiNjDWoWTqrW+oBFX25w=
X-Gm-Gg: AeBDies6fyK5gPrtC3K8r57QDBUy/OFGXLonjWXx1b2EYqI1+6tcBp5e832BF5PqzU1
	JjHQVSJaJb/AG1Fke84ANVhcFNmlvyfV2t2RM990TAoZHrKZb5jL63cfFQP5dcTCvu+a1pLIStd
	AOlod0NruF+W6hBN8X+5yb8Hl0y4wQZ0aNt0dbUg6eZrVjbztag+JmFrgWPa2LqvdHfWzo32sM7
	lQrK8YlIfWSJikQJ8MIGqp/U9V+YhsqLdOue2wlD450tPX5tNA7aO7Ho9dxBTuv4B+ksq8DIAdR
	VdYRXhuJtvVNk0c9wyx6X3e2mzpikqxwv0BzlZbXESuHuDMLTPuI29iRODK4IXU=
X-Received: by 2002:a17:907:97cc:b0:bac:75ae:ef3d with SMTP id
 a640c23a62f3a-bac75aefeedmr894007366b.0.1777280713694; Mon, 27 Apr 2026
 02:05:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427040517.828226-1-neilb@ownmail.net> <20260427040517.828226-8-neilb@ownmail.net>
 <CAOQ4uxi8rqkbhK4=8N1ncfU1m6bjdHLbinSf=j3k0oVEaSa-wA@mail.gmail.com> <177727962988.1474915.2841674553452335690@noble.neil.brown.name>
In-Reply-To: <177727962988.1474915.2841674553452335690@noble.neil.brown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Apr 2026 11:05:02 +0200
X-Gm-Features: AVHnY4KY3DGiJbeLpxnNIOueb0cG8ugd69Mb3NfCiVfs_OCISzp2jPWuCU1oOMA
Message-ID: <CAOQ4uxiMUKHuGwpSkD=M4Z_QLxHn7Os9vaaWqAWd36HdfDRYuQ@mail.gmail.com>
Subject: Re: [PATCH v3 07/19] VFS: Add LOOKUP_SHARED flag.
To: NeilBrown <neil@brown.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 10:47=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrot=
e:
>
> On Mon, 27 Apr 2026, Amir Goldstein wrote:
> > On Mon, Apr 27, 2026 at 6:06=E2=80=AFAM NeilBrown <neilb@ownmail.net> w=
rote:
> > >
> > > From: NeilBrown <neil@brown.name>
> > >
> > > Some ->lookup handlers will need to drop and retake the parent lock, =
so
> > > they can safely use d_alloc_parallel().
> > >
> > > ->lookup can be called with the parent lock either exclusive or share=
d.
> > >
> > > A new flag, LOOKUP_SHARED, tells ->lookup how the parent is locked.
> > >
> > > This is rather ugly, but will be gone soon after we move
> > > d_alloc_parallel() out of the directory lock as ->lookup() will *alwa=
ys*
> > > called with a shared lock on the parent.
> >
> > Neil,
> >
> > Forgive me for being skeptical about the *always* part.
>
> Scepticism should always be encouraged.
>
> >
> > How long ago did we add ->iterate_shared()?
> >
> > It's true that Linus eventually got rid of ->iterate(), but we did not
> > get rid of the assumption that iterate_shared() might be upgraded
> > to exclusive lock.
> >
> > The obvious reason is that *someone* needs to do this work for
> > old filesystems, which are also hard to test and nobody wants to
> > touch them.
> >
> > I have nothing against this patch, but I think it is more realistic
> > to state that LOOKUP_SHARED is here to stay, so if you think it
> > is too ugly, maybe there is something to be done about it.
> > Personally, I do not see the ugliness though.
> >
> > Am I misjudging the situation of shared lookup wrt old filesystems?
>
> Yes.
> All filesystems must support ->lookup with a shared lock because it is
> already the case that with a simple lookup only a shared lock is provided=
.
> A filesystem *could* examine the lookup_flags and deduce if the lock is
> actually exclusive (e.g.  if LOOKUP_CREATE is set) and misbehave
> accordingly, but a vanishing small number of filesystems  (NFS and ....
> I can't think of any others) ever look at the lookup_flags and I'm
> certain none do anything so ... creative.
>
> So I'm certain that it is safe from the filesystem's perspective to alway=
s
> call with only a shared lock.  All that is needed is to change the VFS
> to only ever do that.  That means separating the lock for lookup from
> the lock for create/remove/move in directory ops, and one way to view
> the current patch set (the complete one, not just this initial set) is
> that it does exactly that.
>

I see.
I will remain skeptical, because there is always *something* with some
special filesystems - think fuse servers (not under your control) which
have grown to rely on the kernel to serialize atomic_open() on the director=
y -
but the level of skepticism is lower now ;)

I mean it would suck pretty badly if locking order would be fs_type dependa=
pt,
but honestly, I do not think we will be able to avoid that, so we need to
make sure that humans and lockdep are able to understand the different
scopes of vfs locking at least per filesystem type.

Thanks,
Amir.
