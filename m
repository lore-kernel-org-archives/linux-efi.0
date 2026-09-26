Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A43C280A56
	for <linux-efi@vger.kernel.org>; Sat, 26 Sep 2026 12:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790426799; cv=pass; b=ZNGQhkDYIfwAYuYIgejrsUdp41G5uGEW7HY8EAa9BoxRm7avl0djfqe0aJZ/TEPJ8JJSIEDIp4Qox+gjNLT4NtL+Ny1SuApANHJHFCXMeTkzuCsbTesiTvMI1pgmiiMQ8PSXKEQIOJG0eY/qR28GzC00GmjnnJRrsxX73XayJwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790426799; c=relaxed/simple;
	bh=Q/M0zAfCMSWd/uxVr21+FZg60PEdHKRNk2wvwX2jaWc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=uY5VODThG/npZnP+t6qu5EeUoYAGSaNy20Fci8+4JxM1dbYo4dusS+UfGq7jx+1H/zvg/yiR/rekp0A0l95LMmbCwWLdSkJHON32uhgw9ZiSvTRmKx+hlBKiz1wpq+j9EjHPQy3ne4ZQDkuDjzZQt2hOzZOpCmlXkDkcvkBOvbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QETit0Na; arc=pass smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QETit0Na"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c112aaaf04so1060701b6e.1
        for <linux-efi@vger.kernel.org>; Sat, 26 Sep 2026 05:46:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790426797; cv=none;
        d=google.com; s=arc-20260327;
        b=bgzPwgk/ZWBO0Cn33rw7pSYB0RqGQU5Ig4Qc3WgWRc4XJ+VJY5iokbJ7yEID7MigmZ
         X8MFW0DYLrCeLE/28uZqwDUa9AYxxhU+m055L6XOeM+ak3Yk7WPNVtn6/lBHyWhidfNg
         dYJzB/d67HbEjRWVu+veo+ilcBC9pZhu+XJarhmHhy53Rqz8SWAcZPhjUHqSNZNxhYHq
         4/TArEn4bZqffkqV1BwEOxjExRTombCB4f/aTeWj84463vorOi8GtKwwNePe+OLUHgSM
         Wcu4GYXsRllkblkUihicBEOJU4Wqp+kjE1To2UrnQ+yM+GhfZ+MZNh/IWKZMIXUaEXZJ
         BikQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=Q/M0zAfCMSWd/uxVr21+FZg60PEdHKRNk2wvwX2jaWc=;
        fh=HiT+Tw3NUeDXLyxUjpPQhIZv7DeshVrPD5FcU9aQong=;
        b=Pw9UPo1mp+wysZTQ0dRCg/d0Gp8KWbIPWFYGKYOAFlFhsIN1izVGh0xDXxLHNTW9Jc
         wB0tZiw0pgdHNap6ciw9ZkeCWbt36m+Wqt8SyR902nF25VEg6z+HQ7mwEK1mzyIMG4kc
         pieBUZXAl2xhC6+dF1SKXFw7IvehIhIi8koXnXA0TC7HzDhPz1X9ZmBK6eEZmyDV0yre
         X41uskX1BMDZt/CkUo5i1A6ZRPVIUu8ykczmvamQIc8pWD0G/IoTjCbHJfGvcmogvEeb
         XCFiny5Z5j+Wuvjmc/LQFtvhgdrodzdlSgj2fveRTzGyUYV8bH1vw0JmgxjGGsgz4X6J
         qA0w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790426797; x=1791031597; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q/M0zAfCMSWd/uxVr21+FZg60PEdHKRNk2wvwX2jaWc=;
        b=QETit0NaIuOrEAChCBV51ZxhflJX60cc3HPb8QX1LiWP1u7GEFLPLAcP4TpvhW/oZR
         ai9053OkDzjadyJuFLd9HjmsCQlkUGppmTfSPImFtLzxlum9OVpHO+bmOo7AXTCQNxl+
         0m0hEyUlbkdPlQBoMaNqBNxl35XnVyBFh8vO+Ruvr/39Q9wy+AkQYDLsj1aoXQ4MOjQ1
         l55j7yV97gf1jfpjdDCQNevpMjyt7NXH3kMnKQZ3PtaHbsdh8ASp6fcNDV0XK8Vpzhku
         LDyn+Ifeq429EDZb0fEYOyTGB205HVlVioqtzvg0cYJtrHE4imyudH0Y859lyMWF5Olw
         eG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790426797; x=1791031597;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q/M0zAfCMSWd/uxVr21+FZg60PEdHKRNk2wvwX2jaWc=;
        b=YppUX/V1MJCfH1RdyipsJMVsbwsVYCTITDlyU4CuV5v4+VHiVzEVvMf2PNSHPDeCHE
         0wRo9pP6p1v8KSVR0REXvyQhoYnu/ich3cUlVGNl1rvkRoV+NcMEp4fG1cM0OrXvfPNL
         Cp6VuKjsiGq71dr7uUhGHRFLP+LI+afYJUu8IT+gaRetnHDpsI8iEcFLa+v8K345kCRL
         TKZqif8xdolDN06qvUs9r4O6lSdM9E08f4WVp7D+/R+Tct0aLu4OJYvl/8nhtiU24l9N
         sbuabbNW/eVGUcAxiYrL+R5TZMiH2nnEeTIZjrufgi73WNDx246/cDL0J/yVdIwCXCBa
         xmQw==
X-Forwarded-Encrypted: i=1; AKwUvBzGEmWmVoMgQNPoGa5675cUH2tH+mKxP1scl7qGXg96msJm1c2ygHbpNph9/fPu8d92+icRD9XYXwg=@vger.kernel.org
X-Gm-Message-State: AFuF++k9XtlBshmqpm9H/I5RqznQLbBxWNZIFr9KgYcvwkkBP5UMXcp9
	3sVfGvnb8JDxt6BZxuuampohK3bspYialoGQW/mn4s5im6tlYHO5/L9wgdlHpIcBVKjK8+b+YLF
	9nGtsBV9+c2rrRYsW+3V8f/5rB4itHoo=
X-Gm-Gg: AYBFou1h7nMF6+fpkcZwECxkabN0wXkYs4niE/9ivriGKpk9SO1niGXH3j0bTi8FoDB
	8pFsu6qq51L1cgR9r2gYL/AgEOsuXn0gsQYW76XmItdiqGxxhU28XI6HXWuly3Bb6TMbvNwX5dr
	mjg3ja48ic8/b3sM4T2JbPiouyyeQzmS67sfdWq86DXHovi4ud23aoiZYdiSg6ItvekymgAqtHk
	Bl9XZlhODS77TRbt43BsSzROfnJ9o4Ql8Q1g7X/fNqrqqpkEGuTE9hEmHSf2A+ArvBQeFLn2f6r
	NdL8BfhUyHMLcOaYjxq3n2VDCFB2l24GaPY9JQ4v54T/icQsfd2CQ1Un
X-Received: by 2002:a05:6808:3a09:b0:4cb:818f:d572 with SMTP id
 5614622812f47-4d72962202dmr9717048b6e.26.1790426797222; Sat, 26 Sep 2026
 05:46:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: MaeeFilho FL <joaoanandalima@gmail.com>
Date: Sat, 26 Sep 2026 09:46:26 -0300
X-Gm-Features: AclHuK91iSpp7C6tIzpIIc0jwuxDMR2F_jRk4TAgdThXM_keAj6Bt0yVqavesWM
Message-ID: <CAFA5sMfFW6ua+RTsFyPif_02=3anRia-07Zep6+7DpDSfsTdAw@mail.gmail.com>
Subject: Re: [PATCH 00/16] arm64: DRTM, boot portion
To: jgunthorpe@nvidia.com, linux-efi@vger.kernel.org, ardb@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The entire architecture of this series looks incredibly solid.
Isolating mutable values out of the measured range via unique sections
and implementing the DEN0113 launch protocol cleanly inside the EFI
stub is a massive improvement for early-boot defense against
adversarial firmware.

Reviewed-by: Jo=C3=A3o Guilherme da Silva Freitas Lima <joaoanandalima@gmai=
l.com>
Acked-by: Jo=C3=A3o Guilherme da Silva Freitas Lima <joaoanandalima!gmail.c=
om>
