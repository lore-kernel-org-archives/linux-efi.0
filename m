Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=185.56.87.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794434206;
	b=coZ3WKBCeZI/nb/x8lSlhsA8qPEvNey6B9qpQWDoseqsoaxTLnDasjGQ1YwLzN61ZVd9
	 1pFIk8dzatJRJtd9O4olNIEkYDsrBS2lbldSHBnHzgMbEmK62tU7Bj0NdcGQZTYWStzz6
	 YCQBlYhpstq8aDIfqUOf8FzJTUqz5cXNehfWm2o6JEfFdDhl/c+6w7awtiPN7xkdERKZs
	 CiGRhMWDElKKvq8EIdyKt9QkIyCzeMB37NUbyrqH4mIprtAqkc6BYmpAS5LU5r9qn3aFc
	 1q052+OvIbkEaeclYJyz12Kfg5NwUY+Rz0YVdUYFd0Oa//QFtOk5JXtPbobyQyF8R7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794434206;
	h=DMARC-Filter:DKIM-Signature:Received:DKIM-Signature:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:X-Source:
	 X-Source-Args:X-Source-Dir:X-SGantispam-id:X-AntiAbuse:AntiSpam-DLS:
	 AntiSpam-DLSP:AntiSpam-DLSRS:AntiSpam-TS:CFBL-Address:
	 CFBL-Feedback-ID;
	bh=dJgiLhwnxl07OmJUhfJ5CpoeivoNNwCPag679Wtgjv0=;
	b=vu1LBd+VTTKQS2sk0OHZwxcBLEZPvE5yvFT7n458jJfKRaXoC/icIbACSohJ/3GW3Ff8
	 coPaZ7Tlh4dRL7cc24dX/LtGfcu/gGOGakmTCb/CPOtjNTryZtxl53iqrblJmkRCT/ivb
	 RfOma/En5aOd3F+epqXMFXubNIKQlj9yX9ZhKV+DAUCLWMtyX4cdoXB8Vf86D9yUax9FR
	 nUbadyHzTamnLtObPAlU4SUcMJIRQltLjrF7vEQiPGPcXcI1N24d2/STzo6Nf2z/5JDU8
	 7aJLddjkY83/bcMr9I+t7tIm/ByeBZ1gBBXuFVgB2/SGeyqJjYfXj3wmg7N+RiYGELw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=valla.it;
	spf=pass smtp.mailfrom=valla.it;
	dkim=pass header.d=antispam.mailspamprotection.com header.i=@antispam.mailspamprotection.com header.a=rsa-sha256 header.s=default header.b=1GpxIO77;
	dkim=pass header.d=valla.it header.i=@valla.it header.a=rsa-sha256 header.s=default header.b=df24bgxE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=185.56.87.1
Received: from delivery.antispam.mailspamprotection.com (delivery.antispam.mailspamprotection.com [185.56.87.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607A3606A321;
	Wed, 11 Nov 2026 21:56:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 607A3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=valla.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valla.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=antispam.mailspamprotection.com header.i=@antispam.mailspamprotection.com header.a=rsa-sha256 header.s=default header.b=1GpxIO77;
	dkim=pass (1024-bit key, unprotected) header.d=valla.it header.i=@valla.it header.a=rsa-sha256 header.s=default header.b=df24bgxE
ARC-Seal: i=1; cv=none; a=rsa-sha256; d=outgoing.instance-europe-west4-qv6g.prod.antispam.mailspamprotection.com; s=arckey; t=1794434205;
	 b=NZMQzMdi1AT2LEr4lRcZW7rd0hLeUdrmSa2N5cIII/3+/1aPWIwisQU/+n1L5XW0O40Qi3BcjC
	  xe3Uo8dPvBXRZ3V2qbI+CkmmjDFmB0HpvKTUcq/v7b3v0YPZxvbPdcVwBWNJpJ46vLhE3koDC5
	  bGjT7PKUinhnQPY7JLRgd2sy0rljWPdfACtc78Uz+AvZzEs5w8GIkh8cqf9cKM1iimu1CRiK8y
	  sEA0aJA4mwMOkhjwsTmUNYRuGfuyvDBypjb7gRa5jjwmBqNzCzxvDWFoCBC44MBuT3jPGunmyT
	  NI2PgGpGa6Fx7gTN7Lu/cs6Wx9P7AwhpldhsytUmAFvdVg==;
ARC-Authentication-Results: i=1; outgoing.instance-europe-west4-qv6g.prod.antispam.mailspamprotection.com; smtp.remote-ip=35.214.173.214;
	iprev=pass (214.173.214.35.bc.googleusercontent.com) smtp.remote-ip=35.214.173.214;
	auth=pass (LOGIN) smtp.auth=esm19.siteground.biz;
	dkim=pass header.d=valla.it header.s=default header.a=rsa-sha256;
	arc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed; d=outgoing.instance-europe-west4-qv6g.prod.antispam.mailspamprotection.com; s=arckey; t=1794434205;
	bh=ZWHYAXJh8M23GgTHS9F/68nHKMuIi5pIeMMp0ENqHgI=;
	h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	  Message-ID:Subject:Cc:To:From:Date:DKIM-Signature:DKIM-Signature;
	b=UKc3a9BHkS7SzDCYd/Zk16HBFPzJT16vK47exNMCPUjsGrKAtvkeKYTHTKCzEeF2I7T6esNq67
	  ru2Buu8e9RReiuBIwwtGoEuKsMgbSE2Wm1JhIHL9oIw89iKkZwtRdlbGZ8thvi/82cK7nY8vy2
	  8d0Hx/RXu1KgE+n/e9DkrOD5URa8VtAgLsnMNbGbDAS5oB4vFZ5bVREyYJ8H7fETrgfQGpwHWy
	  s+48AKaidemed4W+MuyH7oH55cqcTGBajnlz1Uyf3k4RtrFW/lUTzagIUIBH7tMBeaBYvMtcya
	  CyztzREt5j6kuRIS4M6BgGcTIYM1Ja2kpFmRVzAjOA6OEA==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=antispam.mailspamprotection.com; s=default; h=CFBL-Feedback-ID:CFBL-Address
	:Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Subject:Cc:To
	:From:Date:Reply-To:List-Unsubscribe;
	bh=dJgiLhwnxl07OmJUhfJ5CpoeivoNNwCPag679Wtgjv0=; b=1GpxIO77H+pCebtcOry2W7wEMN
	N6o1Z6ypcRnNwhq3YdLr3vc2TcMLzRxd0twNOm3tu8Sz6QucYIiAWNOYwS6nAwR+hnDaJLYgYoQIg
	k2UoOvY+lGFBmpZZAUghe6F909QcjcRmAEJfy+R4QcrGKdJV5P6x4SkZmyMU48WhBAr4=;
Received: from 214.173.214.35.bc.googleusercontent.com ([35.214.173.214] helo=esm19.siteground.biz)
	by instance-europe-west4-qv6g.prod.antispam.mailspamprotection.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <francesco@valla.it>)
	id 1xRGJ3-0000000HACC-376R;
	Wed, 11 Nov 2026 21:56:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=valla.it;
	s=default; h=Subject:Cc:To:From:Date:list-help:list-unsubscribe:
	list-subscribe:list-post:list-owner:list-archive;
	bh=dJgiLhwnxl07OmJUhfJ5CpoeivoNNwCPag679Wtgjv0=; b=df24bgxEnOqCeuhgE5/Vkt7aYo
	NqMMrcKi2X0+MPYvvdEA0l97DuzRosc+bZCoNUxVo+/HXKbeAjRI+DthEMN0VJGE9pJu2Bf5zBWHf
	3b1JA1B2t61gBHNDk6N2At/yfb9+GePnBCmJTdpKBhvEqfCSddqPd/rtIfIgv14ZgF8k=;
Received: from [79.17.15.196] (port=60109 helo=bywater)
	by esm19.siteground.biz with essmtpa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <francesco@valla.it>)
	id 1xRGIe-00000000J0c-38Lm;
	Wed, 11 Nov 2026 21:56:12 +0000
Date: Wed, 11 Nov 2026 22:56:10 +0100
From: Francesco Valla <francesco@valla.it>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: =?utf-8?B?TcOgeGlt?= Pedraza Padilla <maximpedraza@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Helge Deller <deller@gmx.de>, 
	Peter Jones <pjones@redhat.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, Javier Martinez Canillas <javierm@redhat.com>, 
	Jocelyn Falempe <jfalempe@redhat.com>, Sam Ravnborg <sam@ravnborg.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 05/15] MAINTAINERS: add entry for DRM splash client
Message-ID: <avTjrfIEPgyvPDti@bywater>
References: <20261027135342.2003632-1-maximpedraza@gmail.com>
 <20261027135342.2003632-6-maximpedraza@gmail.com>
 <ed28619d-6ca7-46aa-82c0-c83f30a836e3@suse.de>
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
In-Reply-To: <ed28619d-6ca7-46aa-82c0-c83f30a836e3@suse.de>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - esm19.siteground.biz
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - valla.it
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-SGantispam-id: 409e35b0fa1265cbd8659dabe4aea8a7
X-AntiAbuse: ID - 409e35b0fa1265cbd8659dabe4aea8a7
AntiSpam-DLS: false
AntiSpam-DLSP: 
AntiSpam-DLSRS: 
AntiSpam-TS: 1.0
CFBL-Address: feedback@antispam.mailspamprotection.com; report=arf
CFBL-Feedback-ID: 1xRGJ3-0000000HACC-376R-feedback@antispam.mailspamprotection.com
Authentication-Results: outgoing.instance-europe-west4-qv6g.prod.antispam.mailspamprotection.com;
	iprev=pass (214.173.214.35.bc.googleusercontent.com) smtp.remote-ip=35.214.173.214;
	auth=pass (LOGIN) smtp.auth=esm19.siteground.biz;
	dkim=pass header.d=valla.it header.s=default header.a=rsa-sha256;
	arc=none

Hi,

On Wed, Nov 11, 2026 at 02:31:51PM +0100, Thomas Zimmermann wrote:
> Hi
> 
> Am 27.10.26 um 14:53 schrieb Màxim Pedraza Padilla:
> > From: Francesco Valla <francesco@valla.it>
> > 
> > Add myself as maintainer for the DRM splash client.
> > 
> > Signed-off-by: Francesco Valla <francesco@valla.it>
> > [Màxim: add myself as co-maintainer]
> > Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
> > ---
> >   MAINTAINERS | 8 ++++++++
> >   1 file changed, 8 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a08087fb6e67..321ecb9f5b5b 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9168,6 +9168,14 @@ F:	Documentation/gpu/drm-ras.rst
> >   F:	drivers/gpu/drm/drm_ras*
> >   F:	include/drm/drm_ras*
> > +DRM SPLASH
> > +M:	Francesco Valla <francesco@valla.it>
> > +M:	Màxim Pedraza Padilla <maximpedraza@gmail.com>
> 
> I don't think Francesco should be listed here. Although he wrote the initial
> implementation, it's yours now.  Maybe list him as R: if you want to.
> 

I agree with Thomas here, you definitely did most of the work and
deserve to be the maintainer. Feel free to keep me as a reviewer though,
I'll be happy to help!

> 
> > +L:	dri-devel@lists.freedesktop.org
> > +S:	Maintained
> > +T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
> > +F:	drivers/gpu/drm/clients/drm_splash.c
> 
> This patch should be merged with the one that added drm_splash.c.
> 
> Best regards
> Thomas
>

Regards,
Francesco

