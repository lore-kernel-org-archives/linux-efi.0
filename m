Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBBC2C234E
	for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 08:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027877; cv=none; b=u6UXu9PQEjTfBxw1tMXa6NPlgeCVr9KnhRhOzsgU6TShrIKve2n9eiTDzU4VfEBl56Fkh/fRsNO/GHSbzsm7aM5mKvwOHl9l/66MVGJgZPP4Htv+tEkkt87GCuqScdJnsT0zkYtoyZ4ofzDy3cx/m6Ffkdlu+ptQkQiuiQVYLUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027877; c=relaxed/simple;
	bh=vgTt1CKugXmTVCyKAK1V5bcR84Bpza5H6R9rp5ITitg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mtPrvTRuenhEB5S0F5GeTb6v7Lw3yjNxOemJjEP44hgPo8awrZK7I5AUluCZ/WhRlr6ixN1W6oZizSVX094vKt4NiFLw6lMpLjb2RV4pjNQE/qMTICbpuZX+tQ0Nnnu2rlep/kzxfJLbyTDPGoAHU8lm2M6LEGqcLmfyDVlwu30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IG8/mI3j; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CW+WST9t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IG8/mI3j";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CW+WST9t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789027874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DHVsvo6RwXVpI3O0qorfwMCGL9oJM3VblhLkUEiQrLE=;
	b=IG8/mI3jUmKq59CE+EOS0OknKjl7nvZ1X+aMoYbZKqCMBsFl+7fiPhO4tQaA0Izz6ryM3i
	luZkrNUHSacSEtd8AlICBo/k9qKS4Q922HsjURROHgwWTvkrZ9D2AX1BuqXHGQxpcy/rn1
	vxz7uC/RMydmqkQ1MfjolDwO0BBOvhM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-vzqcuC83P12ezL9xscllYw-1; Thu, 10 Sep 2026 04:11:13 -0400
X-MC-Unique: vzqcuC83P12ezL9xscllYw-1
X-Mimecast-MFC-AGG-ID: vzqcuC83P12ezL9xscllYw_1789027872
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48584d903ddso2102449f8f.3
        for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 01:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789027872; x=1789632672; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DHVsvo6RwXVpI3O0qorfwMCGL9oJM3VblhLkUEiQrLE=;
        b=CW+WST9tF8gAuzeJCcUxnWBG/Bz9DijYOE1a1MiJBA2bFdCUJuDT4FJW7WATWL1BfY
         SVZXDFKrZaXhM1xCgCzHboDceMBXrtVbuZim1ZsCLruQxzwtxk8Tq47FFWl3tP8asdS3
         RCJ/SVn8auYLL9WtmDIe7nKIxO0su5x0WcWLqDjCsOcb/HE4iP1MrfpTnHkaXkvuELWS
         wLhwFt5QvFNXUDTbltTRNAOUgt9OR0VblvFApa192Zc9dB1u7b23QdSBgxuGQRKvX+2P
         xltKND23A88xvYD9jrdvZ4tUEUKWdQKyuwaoNt4NCvLY3P5v0WMme3MxIZ8rbUY/xXvW
         sQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027872; x=1789632672;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DHVsvo6RwXVpI3O0qorfwMCGL9oJM3VblhLkUEiQrLE=;
        b=HEmicTyHJ44K0gSZ5aRj2nBHLQvMIZxF/aO1ANEy6mdwh+w81yC6attt8hPQinTo/w
         PWy0NvhwxgT5ufRS90gUIrGTvqVixUBMD7y7nd14QFOckZ1L/yh24y6oNNBqOF/lgJyc
         72JgCgwFy71YzIns8C7raTN8TkMsyZnW20frZ6QLG3aWL9sNDYW/q0SvFeGbFIhxwXHI
         0uBBy/K/QvatPTcW/1vDwDvuvlUw16yJwspRyOms3A8GM+fPGArk8hvV6PXZPHxHw/OJ
         9m9mDZnXWrrp0rtUeFjIuUvhabzAWzBl8k2MWjJRSJv2Y8f7Uw+OELZ5jkw1Qs+Y+5Oc
         8vjg==
X-Forwarded-Encrypted: i=1; AKwUvBxYqoyU97T8TFzCsw1i15vAUlUDbHTgQogcSQ7E8f4zmOxCHpVyLBbwNmCoM7A9uIT4WhrIyiIPV3M=@vger.kernel.org
X-Gm-Message-State: AFuF++laPxVDEDoEPLsFcqH1xSfrMa6h25FYVwaSuudlD5V5C7aQAqyx
	72JI+8LVFFeyvr28nC4B+0XDkdmltEp1L4Hy13VpEYl1ICg0RDWx4GkBSdkCJ4AlQe+2MkQZ2oC
	VyOQu897thfkHbqQtyD5y791lD9QOCt4fdsRqPapXw8ID2jD9TwK1akHQkDJeKQ==
X-Gm-Gg: AYBFou04+devTNdDaNIyEbOn69gBezNQbwI3MmaPiy6kpjltBocnUl6LMKsVKYSoWD5
	sy9oTfUvq1OrMuwvgo0Y+AorGuRSl6KAsx7DSjz49HCWYMBL5LrsVemLrNGyFO+IWoPr4noD2Kw
	bzc8e07Jo0vLwQ8TU5HRZs4Na6Ywbj/w8F54oDTp2U+EIyhQDdojBppbEMvBik4Kw7yFcjHcs/R
	5XaHj+GfS/q1alHInO8xUtRj7lDqDRFF3PO1jKObVQhNBZBKXcjoWqwz5wtrEBFCihKImdLQ5kD
	QQ47sN8K2CUYoOHuCiai8EDiTToKuHlJZYx3EqaUOo8YPJm7xIUfa3LUfzfB2Gut0tHJHGErnH+
	1DCAct7XIW2Ns3McRKa5pLzcs+IScFQeWqavoWWdqoZ22HgF7x2CNivtVNQ==
X-Received: by 2002:a05:6000:4694:b0:482:fb97:2ae0 with SMTP id ffacd0b85a97d-485872ade60mr34287602f8f.14.1789027872201;
        Thu, 10 Sep 2026 01:11:12 -0700 (PDT)
X-Received: by 2002:a05:6000:4694:b0:482:fb97:2ae0 with SMTP id ffacd0b85a97d-485872ade60mr34287569f8f.14.1789027871872;
        Thu, 10 Sep 2026 01:11:11 -0700 (PDT)
Received: from localhost (62-151-111-63.jazzfree.ya.com. [62.151.111.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883c5bc5sm52649193f8f.24.2026.09.10.01.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:11:11 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, ardb@kernel.org,
 ilias.apalodimas@linaro.org, jani.nikula@linux.intel.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH v4 3/3] drm/sysfb: Use preferred panel size for panel
 orientation quirks
In-Reply-To: <20260904090850.43060-4-tzimmermann@suse.de>
References: <20260904090850.43060-1-tzimmermann@suse.de>
 <20260904090850.43060-4-tzimmermann@suse.de>
Date: Thu, 10 Sep 2026 10:11:10 +0200
Message-ID: <87v78dcyqp.fsf@ocarina.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Thomas Zimmermann <tzimmermann@suse.de> writes:

> Sysfb drivers currently use the given display mode for looking up the
> panel orientation. But the look-up table stores the native geometry of
> the panels, so the lookup fails if the current mode sizes differs.
>
> Get the panel's native geometry with drm_edid_detect_panel_size() from
> the EDID and use it for looking up the panel orientation.
>
> v2:
> - ofdrm: validate EDID header before using it (Sashiko)
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> ---

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat

