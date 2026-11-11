Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794403122;
	b=P+i0stHJmeS9ICN0KlKzBOHRf6TAcXKW4d4P2Y+f1sANLVcjCMLqY6worwCey8sxrL7Y
	 Yc4BVc7/QfcMNtuRLwVgC3VCFYXZaNHhLRtiPxFN9gRogER4FivDjF5AGCh7zdreH8aT/
	 hc+7vH4Gq37H+peqAE/8/uE8PKS6QL/dgS/6f3yP4vvQnvFF4XgM27QMH0472WIW/1fyS
	 eXWWc5Z14FbsVMLCO0qCUy3pj4p/BHWjTwPp+ZUW6RwpfjiBw3aUCHcgBfVAqE0bYkALt
	 qq8u+LlPJatK1ZWobbdQYoLFj8F87CtA5NnnoXWtrqtBdGmily84wNtM89QgC3tHQeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794403122;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:From:To:Cc:Subject:In-Reply-To:References:Date:
	 Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=esQaj4i0rxBBJRvkYI6ptnCogyr3YrhY79nTBzkIGog=;
	b=44VHdbh+5xbv5KVyzYPdgz4HsDGIM9pimNJ8P1x1PocoDOuG8bXBrvpvFFRqAJdidp24
	 3jziQGvdrCy/hiGSeN1eIsz/zuzbwOX38JH8qZ+6nlFYZBGHcc3dwYUvoHGzrzNiZA9HE
	 FZJR9stK8h8h5A3s5aoXTgzDoRiThpvwVMHR8wOnYpUg+hw90y1fXarde0dxKHYnQOuo9
	 JnVYXZz578ax9V3BdvikD9J17MFw5H4NdVCxuCDrXBnTpoab21vik+sPv1y0b0S7F4fxg
	 yGi6SK7R3lf3bX8Pf/IRGbusI95yDjdCEUskbrJRMVT4JjWywLobKl6t5erP3hxJYMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eYoyBHQr;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=RqC7PlOQ;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E7E606A31C
	for <linux-efi@vger.kernel.org>; Wed, 11 Nov 2026 13:18:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2E7E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eYoyBHQr;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=RqC7PlOQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794403120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=esQaj4i0rxBBJRvkYI6ptnCogyr3YrhY79nTBzkIGog=;
	b=eYoyBHQrKS1HqLiMj1YQ/WVExftuYOJCdFbVU/rHAR0ZqNZTJj1oBqmtGKBxVi4I61GxxV
	7CCq7dH5C8ybQOfcakPQHWW5AlIH4Hf2qWZSVggZ+ewSS3Q0S65ZYmsBvPybQbKxKeW1Vx
	BGhb8RhBMFrnxvDBEcFPmXT5xh/WwpI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-PQRNKbFZNt65PK6oJ01gug-1; Wed, 11 Nov 2026 08:18:39 -0500
X-MC-Unique: PQRNKbFZNt65PK6oJ01gug-1
X-Mimecast-MFC-AGG-ID: PQRNKbFZNt65PK6oJ01gug_1794403118
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a359c7f47bso27309665e9.2
        for <linux-efi@vger.kernel.org>; Wed, 11 Nov 2026 05:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794403118; x=1795007918; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=esQaj4i0rxBBJRvkYI6ptnCogyr3YrhY79nTBzkIGog=;
        b=RqC7PlOQLpcRLVRN7+MIGQGYiMWNxZug8Tju31tvogWMzrAd4tQOCCnLYEDdGQmB1a
         yIU6J7qsALFakOeCg3rFjyozZXyY1ZY94vDoAH3zrYpWMWqsW3rzMAnOcfjV/MD/Ce5a
         3f99wOl4BA2vgj6J0+xX6JkVMkaI8VW2NQwwEtIGyuKrux76g4GlnDaBC8w6s7sAkLTX
         CbyPtn1OpCdhcy/up/0BM2RXl6gZXXBTuguwH77sMuZ1vEM2VZaG1zS2XaIhSTZfFi4g
         T87PD7H2j7sgEXpZpzr/Wf2M8EuE3/qGvVuSuZ5CP4DWg3BOX2f1Bcv2x7cLi70juUtk
         CoFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794403118; x=1795007918;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=esQaj4i0rxBBJRvkYI6ptnCogyr3YrhY79nTBzkIGog=;
        b=meeM1Prpv43gkcAQF19hoH8lFsEzrLz612FiA9ZS5sgwHaNGr2rBkANlEFPMbLFoKR
         tSJOzCIO+5zO5bNEjDVa8GfHf3GB3xWagpTtE19DUhkXY+wOJ9NV+5ujg6XvTG8euaw6
         e1wOh875xD0U08b1VGf1BdKOeutGH4MG0UfSatLJOr8KKZUbfHGgmSPmJLrA28fxIg8p
         YNgxUt/BEcchcpVxqiZf9ebECKlxmB7hh38rVxOEECe3yHuTyH1PAswf8pmkdRYAVUDi
         cCt0LY2GaBsGCaf3BTRqVIXtS3cZp7hI/0SyGXUaiuGR1FKgBQ0C7i2eGiQaP7ZlbLan
         tKxg==
X-Forwarded-Encrypted: i=1; AL+hErFHy/OPbi0TVnLcK87g2G2Vd7Lptqer96jG2yKqzTUtTqIe47tV58k09TN6jVL67YxjzRJ+yIiO5T4=@vger.kernel.org
X-Gm-Message-State: APuU4Z+OvPhG5Hh5xI38Q5RM8/4Rb2z2U5FJ/qIgPpuxG9Xkke4f1/1B
	o5UFOuFFkKOAcSa0f2KeAu14pOteVK9VVu2jBvSITRdGqJMQ3bIk30ZZQi3ASQQQ6+Vuu/YQafq
	Em5Mk3YkSo8pmTwGrrkchxkIn/vwJXlSpieIAjvuSvTvzVJXF6vz0BtPE0nGdQg==
X-Gm-Gg: AYBFou1n/e47crqbp6pk1myFYZqcamIQSmE2MEMMRjzM5HsZrKpMIwv8ZLgzMunmIpb
	qIxxon9EcQ9vX72lid+pEJq5LxxWcs/5lWtCO2MlaCp0kTi0BJ+wkfUBnvkYAX6Prd0rwH0vwI9
	W11/DQM6Fbb5bxFkW+7hQfp1RE3Lbhu4iNh/5j9Tv0jo7yQ+5FPjVWYQqdV7MzaoA0fWTeStQok
	YnsxopdUqYR3vX6dODJf8EcTv2OVIwTmC1MKxbpVxG27PJ9uZZGMsXUiAVm8gnjvs8ArT0nV40B
	A5ngLKJSn1HpLUtihsOhjbREhyia59eUxURVPs0ogwIDc6t4qRNpy282v9XoV7nAo394pDzTyZx
	3UrJtQ7wm3PYTqB67qVcghJjMz+bF95ly66kbq7rhfAutrpqEEZ1laMP7ylr3Xe6DfBofbdxYXd
	yryqAJtwhA0RS5Opvn2B+XVUOUnuUbkRgRJGH8Oqo=
X-Received: by 2002:a05:600c:870f:b0:4a1:7c56:d4e2 with SMTP id 5b1f17b1804b1-4ba093817d0mr40825545e9.16.1794403117586;
        Wed, 11 Nov 2026 05:18:37 -0800 (PST)
X-Received: by 2002:a05:600c:870f:b0:4a1:7c56:d4e2 with SMTP id 5b1f17b1804b1-4ba093817d0mr40824875e9.16.1794403117057;
        Wed, 11 Nov 2026 05:18:37 -0800 (PST)
Received: from localhost (62-151-111-63.jazzfree.ya.com. [62.151.111.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498811fa70esm9733692f8f.19.2026.11.11.05.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 05:18:36 -0800 (PST)
From: Javier Martinez Canillas <javierm@redhat.com>
To: =?utf-8?Q?M=C3=A0xim?= Pedraza Padilla <maximpedraza@gmail.com>, Maarten
 Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Ard
 Biesheuvel <ardb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Helge
 Deller <deller@gmx.de>, Peter Jones <pjones@redhat.com>
Cc: Francesco Valla <francesco@valla.it>, Jani Nikula
 <jani.nikula@linux.intel.com>, Mario Limonciello
 <mario.limonciello@amd.com>, Jocelyn Falempe <jfalempe@redhat.com>, Sam
 Ravnborg <sam@ravnborg.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org,
 devicetree@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/15] fbdev: efifb: move the BMP headers to
 <video/bmp.h>
In-Reply-To: <20261027135342.2003632-4-maximpedraza@gmail.com>
References: <20261027135342.2003632-1-maximpedraza@gmail.com>
 <20261027135342.2003632-4-maximpedraza@gmail.com>
Date: Wed, 11 Nov 2026 14:18:35 +0100
Message-ID: <xlv1cxsba4lw.fsf@fmartine-thinkpadx1carbongen12.rmtes.csb>
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
Content-Transfer-Encoding: quoted-printable

M=C3=A0xim Pedraza Padilla <maximpedraza@gmail.com> writes:

Hello M=C3=A0xim,

> The DRM splash client parses the same BMP headers as efifb. Rather than
> keep a second copy of the structures, move them to include/video/bmp.h
> with the magic number.
>
> BMP is little endian whatever the CPU, so the header gives the fields
> as __le16 and __le32, and efifb now reads them with
> get_unaligned_le16() and get_unaligned_le32(). Width and height are
> read signed, as the format has them. No change on the little endian
> systems EFI runs on.
>
> Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
> Assisted-by: Claude:claude-opus-5-5

Please drop this tag. Has been obsoleted by commit 1e035297ffda ("docs:
remove Assisted-by references").

> Signed-off-by: M=C3=A0xim Pedraza Padilla <maximpedraza@gmail.com>
> ---
>

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

--=20
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat

