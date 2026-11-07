Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794090869;
	b=pqfKb2Ew+AgmanxpnY/V6mixC5Brs7kvmZDZo/miHhNdVN4qL2NcwkJGHTr7a3JQ0eA3
	 gJkrNq7n894NVRs2RzBXdIlvszREv27pG7EWdFpUveeYUHxWgWJMHQDXPmEoF/x+wMVBq
	 6lDiHmxceFyfO8Dk/YuKmHUhdvRjdKSvLYqi8g672vwnoxYO+UXQXHHBqHbj7uAOTcUEt
	 Rt0VpqdIaR1ITtHkSyXAGWLmAn/AoP1Eq/b0uEkk2eGXCqvR58AD9T9W6s56vECBIqbi+
	 16y2bqXUYGvkkJtww9cXfed4f6vXxp7sjrOe1Lw9a8d+ZGaSmlp+o6/gy3ks1SGzVnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794090869;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	bh=wR5HXTh16ddUXMlLaMHcCDUi43szIAAM9f7TTgkHzr4=;
	b=PMdoLodFvYbUQE2NWYDSt7Ue++MZLPfRqzivNsX1atF7PmDbjsQVh60oGBxP55O6d9JZ
	 rS8EhL4EHbsW03AZDKAzRr6ACz5UpJIqG1roY1v82OwQmK+g6SCMkr+oCzvueJcz3ytZH
	 3wBWBOvUneIW3ncC6NN9jHSwOXaNPYOqSVwEIm2WRnpbi+si4hXkStjOqaBA3y8j/8Ff7
	 7t8hXdUySpIOH6MgiyF7O8HhTMGgQ199OAjVA8Gw4aiHXMPC5mQZoYeOFCi6Wc2C17dNc
	 muKnUdH2SZ70s4aLVP8VSExr6UaQMPzkihcDImljySsvThNxV6QLwAB+1ijxugbting==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gompa.dev;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA56606A32C
	for <linux-efi@vger.kernel.org>; Sat,  7 Nov 2026 22:34:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DA56606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5364648ae07so833001cf.1
        for <linux-efi@vger.kernel.org>; Sat, 07 Nov 2026 14:34:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794090867; x=1794695667;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wR5HXTh16ddUXMlLaMHcCDUi43szIAAM9f7TTgkHzr4=;
        b=HKEKXQTwZlSQlM4GtAS7aDStLGLONe1cXOmCcM+khoZZAOrRe6Lk7MbxGqE/P3zjVD
         jXPDw+vS1ai8+DN1XjZ7eVqVXA/khStjJa5SJnm4k54iTbjkFeAU3wJJUvIt9jdHWyv1
         V+zz6ZKqclL0XubytQ02eKhnAiASykfC3dqC+3LUZ5vxxQtAfI2ShimfVOq4W8VNLs6V
         EGKxIHiBG+/CQ9G+PSLQiYz/JpwSUfk038W45HJlYJHZDri/MHG9mFvEWP1MGAx6BOSa
         nPreahSUPBlELaa/n9fzCUzBNBgCF7RU9e9vw81wZdGEFJVgRmJ6DEoKhDNvWBs7fpdC
         RXtg==
X-Forwarded-Encrypted: i=1; AKwUvBzUGxnpQbOAM3VR78eQU+S2jHTITNhA0RSKY3Eb85UWajud2FTYGco98NObGGo8u+YbgDBAO0W4MR0=@vger.kernel.org
X-Gm-Message-State: APuU4Z+yXep1aM1nmMh3Q2fuCFjbMPn0VL1irZs6nmPqYPpUN/vtwT8Y
	WFrbEGJ1ax6yl/CZhdEMjXTuR8tD7WH6fdGyANWqHQM/fC6ffBS/qzc/
X-Gm-Gg: AYBFou12L7NsB9brHdS65EE3c7wkw8gZtHjHJbVfTnyqS4GrDiFo1lX0fcRz5ySouET
	ZsrGQeHgnGNFKFl3v/jQZK4/4fE45Sr5YZ8Q9vzyG9Tuax8tLnMwFrPZWk2vKjfGIYFXNfMELQ1
	zH6uPrWwAHKXG/ddLE7OHIp46UNeqmd0Mx3l43Z61N9CxK5EF4OZigEmPngYz/2QHu4+Tds2qxF
	4SakXpIojMP+i8mCr6nLTAnjKOiHd0Z00af6I3igUHg5Nu7YQJ+EWAlfcYwlY5gdlVNwQgum1iv
	smeJQS6UTrUFTH6OCob9WnJiVtdmOcTruWZ5m65Ggmv9ZWim6FWKXhOQCVe/LndCAJyTMouo2Is
	/w2gWCY1jYDl3RF1xRMU1MTbuqcfeI2F7NbLyZxFapWx4Jx9bvhF1m/P/2s4v17euLQch+7OH5M
	Mw+VXz36rc1uOfBQXrzUPZaZfx72JDsqZ1Z3UUdnGPJFCVFdB4AZbufBPFhreZsZyRw96W7NB8I
	i7DVeGF8brnuckMN3f717vOxDw/mTqBopptOlu3inYrFfomTW784uXFaEQiiOLuXiOgbpfzU4tU
	ul8VnkSW+q0KXpk3agZbX94J26JU4FAUxCi2JJo4bf5SxSlzgn1PTtL50krrk2ltQK/SR3Tzxgc
	AI1JSVWRFLdOaO+UyrAqywX+O9ZvWURQ1pGbeMf5VsXyPGW1N5TUnv4fP+Ogx2wtJmSQAQD6kgI
	us
X-Received: by 2002:a05:622a:494:b0:533:8900:4eb2 with SMTP id d75a77b69052e-54e14e77819mr102542781cf.58.1794090867395;
        Sat, 07 Nov 2026 14:34:27 -0800 (PST)
Received: from skuld-framework.localnet ([32.221.37.233])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5526454c1e2sm3581101cf.22.2026.11.07.14.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 14:34:26 -0800 (PST)
From: Neal Gompa <neal@gompa.dev>
To: mjg59@srcf.ucam.org, Matthew Garrett <matthewg@nvidia.com>
Cc: keyrings@vger.kernel.org, James.Bottomley@hansenpartnership.com,
 linux-integrity@vger.kernel.org, rafael@kernel.org, linux-pm@vger.kernel.org,
 linux-efi@vger.kernel.org
Subject: Re: [RFC] Make hibernation work with lockdown
Date: Sat, 07 Nov 2026 17:34:25 -0500
Message-ID: <Qc3eI7EOR8ep1b77lr0gsw@gompa.dev>
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Thursday, October 8, 2026 9:20:16=E2=80=AFAM Eastern Standard Time Matth=
ew Garrett=20
wrote:
> Hibernation writes out the full system state to disk in an unencrypted
> and unauthenticated manner. Resuming from hibernate reads that data and
> throws it directly into RAM, then jumps into it. This is effectively an
> entirely unauthenticated mechanism for putting whatever you want into
> kernel space. This violates the assumptions around lockdown (root can
> write whatever they want to the swap partition and then trigger a
> resume), and as such lockdown blocks hibernate.
>=20
> This has made many people unhappy.
>=20
> This patchset seeks to solve this problem. In order for hibernation to
> be trustworthy we need to be able to prove that the image was generated
> by the kernel and not modified after that. This is not an easy task, and
> requires some infrastructural framework. To that end, this patchset does
> the following:
>=20
> 1) Co-opts a TPM NV index for the kernel's sole use. This is currently a
> placeholder and we should register one explicitly from an appropriate
> range in order to ensure that we don't conflict with userland.
>=20
> 2) Does something horrifying with PCR 5 in order to prove that a given
> kernel supports (1). We need to extend and cap a PCR before userland is
> running in order to prove that the kernel has support for this feature,
> but since we don't currently cap any PCRs there's nothing stopping
> userland from doing the same and so achieving the same state. The way
> around this is to rely on a feature of PCR 5 - it is extended as a
> result of ExitBootServices being called, and since the boot stub can
> execute code before that happens we can perform the proof extension
> there and then have it implicitly capped by the firmware's extension.
>=20
> 3) Adds support for audited TPM sessions in the kernel, allowing us to
> generate signed digests of the commands that were executed in that
> session and their results
>=20
> 4) Adds support for generating a predictable AK that can be used to sign
> digests from those audit sessions
>=20
> 5) Adds support for generating a TPM signing key in such a session, and
> using the signed digest to prove that the session took place in the
> kernel
>=20
> 6) Signs the hibernation image with such a key
>=20
> An old kernel that doesn't implement (1) won't be able to mimic the same
> PCR 5 value. Userland won't be able to mimic the NV index value because
> the kernel will block it. This means that the only way that key could
> have been created is by the kernel, and so we can trust that the image
> was generated by the kernel.
>=20
> QUESTIONS:
>=20
> 1) I haven't tried to make the key management generic, since this isn't
> intended to ever be exposed to userland in any way. Should it be
> integrated into the trusted keys layer anyway?
>=20
> 2) Filtering TPM commands from userland isn't ideal - anyone able to
> poke commands into the TPM directly is in a position to violate the
> assumptions here. Is there any way we can get a secret into the kernel
> that can be used as an auth value? It would need to be impossible to
> obtain from userland and it would need to be consistent over platform
> reboots.

Looking over the patch set, it seems like this should be okay with swap fil=
es=20
being used for hibernation, right? I don't see a reason it wouldn't work, b=
ut=20
I figure it would be worth directly asking.

The reason I am asking is because I am looking at integrating KDE's dynamic-
hibernate[1][2] to allow Fedora Linux to dynamically generate files specifi=
cally=20
for hibernation.

Obviously, this works fine in non-SB environments since lockdown doesn't=20
negatively impact power management there, but if this manages to make it ov=
er=20
the finish line in some form, I would like to be sure the approach is=20
compatible or can be made compatible.

[1]: https://invent.kde.org/tduck/dynamic-hibernate
[2]: https://src.fedoraproject.org/rpms/dynamic-hibernate



=2D-=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!


