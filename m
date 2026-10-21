Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792536621;
	b=FcJpxhUJzfB886AjC3FORdXCjxXa0Mx84IVZJv8JeNzBVU0tyDQKaMALfGCzFf67fdBY
	 JuuUrSm/ocXqgDagb/5m+rJ4rmJ6VaDdHS7QICjePfoJX5mmP46WKHtH1h2WIPmQ+2P+y
	 b85jkBYkzgDW2VWYooRfQDRo1aaUHKj4hP/v9FRsTvS5ss975s5Yfr8MKP4MiSwqNeGgS
	 Kbu9HC4ZMpCHKqAB7PE3wJrZshKNYfabAhZfPmM1EjMofkChnDwL3qviMaVPsOwV8EuY+
	 C64aQeMkxIiNb99rN34S2h1OrEQU3J0FiAm4hztHhEGGo13x/HyDmT4GFXX0m1bnkLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792536621;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=RGix8b+4rEGPx1vlWyRM//jxrhYNPw7VId0i+fn4vP0=;
	b=iWiK/rqJlFLlaoYs/Az7KLMUm6Q0N5H2UBuSP3tBCwdFAoh6QAgFahXPLvxZ0apSHnyc
	 taZpGQmWwWAuzC6sID4eq0XNGfQjDSE0BB/puUvee4ys+evx+t4LWjnx9UagA/Jq+wesK
	 5J8t50pv/5CmUaLTjk01QL9681gaZtY4o7r2uqbGq95iLkRzuAB6ff6F6I+UWsynfEbW9
	 Dg2N6xACSTm5DqwiDC1wLzsYoPtMA2SLRakDXld0NS7zhFqGSR5q6pAubyrStwjHECP5y
	 uq95WNKHW9zIjTNas6YGbYNEPJmKQ1/zgQZR4TMZWVCltnUEz4psQX6i9WurS+BIIbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XSWdVIml;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A8860A2611
	for <linux-efi@vger.kernel.org>; Tue, 20 Oct 2026 22:50:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79A8860A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XSWdVIml
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso106291f8f.2
        for <linux-efi@vger.kernel.org>; Tue, 20 Oct 2026 15:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792536620; x=1793141420; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RGix8b+4rEGPx1vlWyRM//jxrhYNPw7VId0i+fn4vP0=;
        b=XSWdVImlnN+o8KKG+n8FdqZKnJyuYzxymErOsSI8I+mbWj1WKZ6nzidsmjFU9HSrR+
         vqgDumIJaVanwgvDvCQZpDc1+Q+1Yu/ZQdO1TGAiSn7zcJ/EIXO9TapoqBvCQUeYh55v
         WMTSIU2/6hQWr/tKz6eoFUaAalDBOhpk+YSsWqwpACa/+ZoegBs50VCzkKidvsFNvIFA
         8b8xC9l3L0kISRpEfSfybZGw+SDyya9x5tRhhllwkNu3mXQxPtTTTCyYvUWq8HNKxR4k
         1BIjXTFJWfVyxgol7fAchZytRgSIxAlcYIjRkPsePysYOFssUU9c1tnMeQqsBVaXZh7F
         zevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792536620; x=1793141420;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RGix8b+4rEGPx1vlWyRM//jxrhYNPw7VId0i+fn4vP0=;
        b=p3bgfE4F6RdjnqtgLsUfn4achNq0XMvbubig5gA3iUPKLMukeGVBUtpDLoMLxwfmwW
         rfCEWeeJDYUXrvBiPIvxyyMocf8Rqnk9FxtrEIvTxG64LKL064WVFHKZ1eVdAcitjbom
         DtwU9nH7KPi13D5HIcR0AYdx8iEYWq8woYalMvxccPP/SVUC0D/vj6jyC3V0SJm/CGaw
         GI/frQeiiUM7I9TPfTOHB2Bl6UfX3pw7SWtQ/G43g95W6hw8QNgdjss9WXJ86XCUy8LK
         XEENJ9Mk1AT9YWFuvUFpbdBpxP5SSW0ZYp7YbDwFh6zchkUMRaWVyB4k3n/4js0eNyGp
         RLDw==
X-Forwarded-Encrypted: i=1; AKwUvBwcC6KD3nqxNiOx9lIY1nG1Cbk5RMH7J/LUU819BerdRUCDPLQCEdAPHr5sjZ0LWa5SOLc6tQl7ZH0=@vger.kernel.org
X-Gm-Message-State: AFq9FYLHN5XQDC922RXp7bfI1NmGzspa3O8xQ44UPUdDTettCAx8Mra5
	otK59qzMOWJCoHNdihyx4ZSP8UCrFBpG4k2rvKXZDD+OyA0/zmoOnzya
X-Gm-Gg: AYBFou3dJKa+oMpcg7vh2ZmZWz0QRWMJLA5E/9XWlRH1TxIlXZCY6QzThLkTIaf+5QH
	TCZtpURpLGFRvlAYR31ALTkMubYi0lFQzp+YJiE+0DqerJkaQEkWfyu+r2NoarRnagneiMe7hQZ
	TRqgGJwoHIV6w8jg+6epeGY07gWXcWErM99t58eJGJBSYVt6gGJtstcL2gd1MOLgS5Ymxph4/fV
	iysooqbbb+bPeMF7MT+eyFQtFDSQWCJXTt2vLxL1Yc2QAaDe6gV0OZPqXXjce49USO+N3BIz/+V
	iCyr7gI3pj1RHqumPTLC9/8ld6j0mq3Hvmz9vNiuGCk4VHQtPzxw6FtdhiEUh6BIYksPjP74K9r
	+P7REODQq03wV2TPtlQSNPNpYHanPKeM3WYQrmEcWVGRJPsCKnh0gJ+IwHWVkAq7eGcJiob+Ag/
	gF45odC2kj5bzB9rO3QflaB5h2Ff1wIaIJEWshMp8mxLXVPOnaa4nuXL+AIX69jrVHehfbKq7P7
	GBpamuvJaNrT7KmdD/qNTx/cQ==
X-Received: by 2002:a05:600c:3b01:b0:4a1:7c7d:8881 with SMTP id 5b1f17b1804b1-4a1fdb04f88mr2783945e9.13.1792536619814;
        Tue, 20 Oct 2026 15:50:19 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fc0b42bdsm17511805e9.0.2026.10.20.15.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:50:19 -0700 (PDT)
From: =?UTF-8?q?M=C3=A0xim=20Pedraza=20Padilla?= <maximpedraza@gmail.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Francesco Valla <francesco@valla.it>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-embedded@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 10/13] drm/client: splash: take the background colour from the image source
Date: Wed, 21 Oct 2026 02:50:05 +0200
Message-Id: <20261021005006.2341200-6-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <ad6a04b7-cf57-4b22-9c22-85a61af29f1f@suse.de>
References: <20261013093243.505776-1-maximpedraza@gmail.com> <20261013093243.505776-11-maximpedraza@gmail.com> <ad6a04b7-cf57-4b22-9c22-85a61af29f1f@suse.de>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Thomas,

Am 20.10.26 um 13:19 schrieb Thomas Zimmermann:
> Please see my earlier comment in module parameters.

I answered on patch 3: I would like to keep splash_color as an override
for one boot, for a bootloader that wants to show a boot state, with
the default from Kconfig or the device tree. If you still prefer none,
v6 takes the colour from the node or from Kconfig only.

Best regards,
Màxim
