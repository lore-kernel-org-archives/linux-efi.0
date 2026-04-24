Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE63F3DC4D4
	for <linux-efi@vger.kernel.org>; Fri, 24 Apr 2026 16:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777047870; cv=none; b=KmSRFqutiJ8rRZj+2XuJclv54Tt3+P0hJAj4qEJ1fMMgvyS0CvAqEIW4EUSmMZ0Vk4N3yp7uPSIQxbmbw/9DwO5DSIRL1e1dpUBcl1M6n5jaslLiCwQrjvvLaEnOc6VaR5i1M8gQNmherMds2hBzGEBu9lavl049Oq09GqRStQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777047870; c=relaxed/simple;
	bh=WGeiHUHtLNR3bIDnkcA7YuMVHwYC8v+r8hhmRXVRhBU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LEl5/Jzc8hWxiRJqbEmkEycJOtSNNMEELAW+BAoYYax1W/ODXXgohQO9XdGznX0uewm5+YcGQ109/pXkmAwgw41NuHpI+SAuzwG7DTgFEe9ob2AUlYT7YG8hjTQLbrWh8eoPFoFqssHNFFJcsDE+raaHn24CUzejm1utJIxqQYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fj7y5y3z; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iOvv6AWT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fj7y5y3z";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iOvv6AWT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777047868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bkHBfOVa4bz/wCbZfmwZYYdZCO/tCYPxae+JQxak4Yg=;
	b=Fj7y5y3zUfCGiyELYAQdT2Tus4lHHg+DwuBce4lcljP1RRvE8Bhpaq2BpO9K6MplVpmjXV
	1+FzH9Ool/+0mWkkYKj0AestQlSGWVOEfMmQNFSCeK1iOuNURX91IAdDYGEl98Y9Aco9pO
	v+V+AEqwVwKQzt1GtaWH8ABAr8ZB8Ho=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-8ewRxWgQMaWqgG6Uw3bNwQ-1; Fri, 24 Apr 2026 12:24:16 -0400
X-MC-Unique: 8ewRxWgQMaWqgG6Uw3bNwQ-1
X-Mimecast-MFC-AGG-ID: 8ewRxWgQMaWqgG6Uw3bNwQ_1777047856
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48906aa28cbso46684285e9.0
        for <linux-efi@vger.kernel.org>; Fri, 24 Apr 2026 09:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777047856; x=1777652656; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=bkHBfOVa4bz/wCbZfmwZYYdZCO/tCYPxae+JQxak4Yg=;
        b=iOvv6AWTq0H/c2m2rbaqEFM5jPUzXLM4P+qbNLd0MIuNUGu1XWaG7Vl8B0TmTjKR6V
         RzPHmYK94D8a3fptzJxnM1hLLsiAehvIxROuvJnIK/IrM8X9C8WG83roVs0L3N6B6L2m
         /zGVINwVrcb7k76naUV7pTh7Rq8oHMW5i0yqb/3a7+u4/L6KEeQu0Y9eK5zrg09smA7L
         Qf8Q/gvCGGcrIgxHJqwWXo2CJPxUINee5SBv5U+ViUetNOzsq2MDLXsElrfVOmVW4Ug2
         iAKIBCiRqOmZjfCjXSM/pe9Z67o4TET9PayQyq/tS9lrvZ22FPmxqe6QXQJa+4yvWxzT
         L86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777047856; x=1777652656;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bkHBfOVa4bz/wCbZfmwZYYdZCO/tCYPxae+JQxak4Yg=;
        b=C5v4nlMEBITOldxtWoZpXl/Kn8pcaKXt8XhAF+enjkeyLEIqxjgGhodYf3qhsSZPcj
         M/nnlBdcnhRUTrcViAJbQylXx0nTYxC/JPqYqMsPWQ1EKDVDv4yPGr5rR8WE2Tp0s1qc
         Ez3ALsea6DBS0KBmVVniY2WfoI6rbrFwfWBPJWiO4BOdpBiSFZcJ6oRCWBDI6YrSUkxx
         xTsol77Adw+lu+4ssqHuz2iXoJh6uJ2QA7dehlic2tyjiGm4j6xUUgkYjA2FN7TN3zwZ
         YF+MHUWUEf2a2utKkImi1SfMyyfCaj90lwQQz2ZgKT+/WpjVonIteOEEkEI9m0zCfhey
         fkEg==
X-Forwarded-Encrypted: i=1; AFNElJ88gvUKUyuvcWuqYxxrxZkFO7cWlrkviVt/I+jjRYczvXyoSXVxZ7xEq16i3jfw7cJYeZxBZPNyfTA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1MXWmc13hJ7PGDdJX4Gwi7rTFCakaZ+PMldHvqVl9WtJM/XEi
	Opg38PhJlHIXNMM0Q1rlr7PSQIBEfSzFtPvuDbcAITgbZQvkdoM6Qt3M/RLzEsj/urGyy8f3V3b
	Wx04ReKMMRmz0xp5hacz9hJTzwtKepia2bya72whXKeyYavxHkOJ13l3hBzYyCQ==
X-Gm-Gg: AeBDietz/+4lYlfEj7J6v2DUKd8pDJpZ666YqLga6RnnEoU7O4SAXXQ9b7mBMFqKXni
	0UPYOn3DFanRU7pJAN1uL6/WIjq1AoYv8+VTB9gQ6XM7tm6GiYDvjX/sjUiS8UeL5Z2mUaKEtzL
	8jrA8kWK22FVEk9kIGyOnMAps7VkSwizzSFTUusxfj65QPEeh9SdSyx0Si4PN6x5//FkNTCjQ0W
	gldHGPQWzaJxQkJ1kfH3sA+3GC1A/HikvSoPi1jB/5mL1dwEKWFDHrfXX5A+fmHLIleGB/qzeBr
	57xe7xBJk4ymZWEUJwfAGzQdZwfhsRtpmTQCKqVTyJlbRD+9glamBdn36VtqoDrn0+laECCFRmy
	vLUiZzg+wQOS+5wJA27yDhDk6Td/oI0PYH0IKTg2P0tgYQF15cYUyMLIkculqC8kk9Go7GP5FQw
	hZADFMXK1gQ0smhQk=
X-Received: by 2002:a05:600c:8b6b:b0:485:3c2e:60d5 with SMTP id 5b1f17b1804b1-488fb8859ddmr427762145e9.2.1777047855238;
        Fri, 24 Apr 2026 09:24:15 -0700 (PDT)
X-Received: by 2002:a05:600c:8b6b:b0:485:3c2e:60d5 with SMTP id 5b1f17b1804b1-488fb8859ddmr427761525e9.2.1777047854742;
        Fri, 24 Apr 2026 09:24:14 -0700 (PDT)
Received: from localhost (62-151-111-63.jazzfree.ya.com. [62.151.111.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a682588f8sm6272915e9.10.2026.04.24.09.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 09:24:13 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, Arnd Bergmann <arnd@arndb.de>,
 Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Huacai Chen <chenhuacai@kernel.org>, WANG
 Xuerui <kernel@xen0n.name>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Dave Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "K. Y.
 Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 longli@microsoft.com, Helge Deller <deller@gmx.de>
Cc: linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org,
 dri-devel@lists.freedesktop.org, linux-hyperv@vger.kernel.org,
 linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 3/8] firmware: sysfb: Make CONFIG_SYSFB a
 user-selectable option
In-Reply-To: <0156562f-5fcf-47ce-8fea-03345f2c3fe6@suse.de>
References: <20260402092305.208728-1-tzimmermann@suse.de>
 <20260402092305.208728-4-tzimmermann@suse.de>
 <78f76717-8f1e-41d6-92f7-261df96b84b6@app.fastmail.com>
 <3e466158-c2e5-4e23-934f-dcdbb71ad41f@suse.de>
 <d3d7c545-3b07-4881-a16d-45b6f039de19@app.fastmail.com>
 <001efe27-9cbb-4a89-8d2d-a1f3ae15e505@suse.de>
 <295a43ce-92fb-435d-a82f-d1cfa8f4f28d@app.fastmail.com>
 <0156562f-5fcf-47ce-8fea-03345f2c3fe6@suse.de>
Date: Fri, 24 Apr 2026 18:24:07 +0200
Message-ID: <87se8kjpi0.fsf@ocarina.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Thomas Zimmermann <tzimmermann@suse.de> writes:

Hello,

[...]

>>>>>> On Thu, Apr 2, 2026, at 11:09, Thomas Zimmermann wrote:
>>>>>> I don't really like this part of the series and would prefer
>>>>>> to keep CONFIG_SYSFB hidden as much as possible as an x86

I tend to agree with Arnd here, I'm also not seeing that much value on
making this symbol user selectable. For now I would just keep it hidden.

[...]

>> Yes, I saw that as well and don't have an immediate idea for how
>> to best do it. I saw that you already abstracted the access to
>> the screen_info members in drm_sysfb_screen_info.c, which I think
>> is a step in that direction.
>>
>> I also noticed that efidrm is mostly a subset of vesadrm, so
>> in theory they could be merged back into an x86 drm driver
>> along with the drm_sysfb_screen_info helpers, and have a non-x86
>> driver that constructs a drm_sysfb_device directly from the
>> EFI structures.
>
> I would not want to have a unifed driver for all-things-screen_info. The 
> code that can easily be shared is already in the sysfb helpers. But I 
> don't mind adding a separate driver for EFI's Graphics Output Protocol.

I agree. It is much more maintainable if we have dedicated DRM drivers that
use shared helpers, than attempting to have a driver for different platforms.

As Thomas explained, the maintance effort is small on the DRM side and he has
done a lot of work to split simpledrm in efidrm, vesadrm and ofdrm.

-- 
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat

