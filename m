Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12073ED3C3
	for <linux-efi@vger.kernel.org>; Mon, 20 Jul 2026 14:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557695; cv=none; b=PTu3R9ta4Ov8FSvOH9bl+z+VfuTKqtJQQkuKjHxvjV//E5FKwIpxWTr1ZCwhZcszyxRKXbpksqtwUMo60RtuT7EBxGjJKS93BofnizEFYt0y1OUB9CiiQ05eCvjHyUqCOZ6mAHrZ3jJxURiGesn1haIWDF2VNxnyhUbwqHhZrjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557695; c=relaxed/simple;
	bh=DfQMrLqMXIymwFHIknOLdLAISwN5DuEhDletVIFnvQc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=uibBfYrSTKnWR87FSUmdBMrcGeUExL02OLQ0Es6bVPoUtQQh6BY2whnBoyNXnZ5hr/uKh8s/2ZxMta+XrkDguhiqnN3HPFbAn8gChlYZmTLTbx+I/darzwO/ZugijVz7s7ugpvzwLRW+KBhw4HH96Foco9LxNurXQKYXUV28WsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=bm1QpZJr; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="bm1QpZJr"
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E09083F608
	for <linux-efi@vger.kernel.org>; Mon, 20 Jul 2026 14:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1784557683;
	bh=GVvzHMxnvOnUe3OxM3vQdreEJT7StGP+edlzrOT4kYU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type;
	b=bm1QpZJr0L8PQtqLiheWA5HdmQxuD1ivJCfLFBaCnSIoJIIJKczqr5Znk4d+8N/LH
	 aKycdJ4I6AeVxcr0QtNgIE04ko5UtLXP/JU+ppEsaclDJI5hc3I9L1LUMamFYSSOQz
	 jUEtfc3eQSBd2X6VLTT/x7twl16/jN3T5xiPgVx+i4jget1K+OJPpi7IRiCYcjn54n
	 ZZPSLnm793L9GD2/5jy5k9BBDLBhwaOvlvJRhiHDckxRfZDMmolaUjTmUDKLbWbFNO
	 vh0Otk2JAR1Xxw5FiF06oeSmZHdSots/SGNug/eLi0c5jVCQS0LpkhNHkMZ8VRfphm
	 YltZJS9WVpfH1qQszGoCytTUAjfeABjzK7rhmIkIWudS3tpGm9gjp3Y6oVtBlNyfr7
	 lY29rRpXqL/3pzk1KRD++eIiVykKO2VHAfC7HA6Cj0YsPvUM68C6rv8ZMukYufBKKG
	 ERU/gMRu2BY5d0Zn1YeogXI9Rleuq2ljRx8POaP/Wb7yUmPeVPbq3pLA/InN9OrIBa
	 POJpTmLtB5IKSQnNzArtcDCKT8cblVFta9NJZxbqPsUYRNY6ylJk4vRwUVFLW+f9m1
	 YUy0dJ/BF3Fr4GbTd8i0k5kPU0dNFnwkSpIBh//LKXPScydCRA1k0+2Y5klG0KDi5e
	 tMHiNOvqKDp04OqWHQU1mipU=
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f6e8b5996so1913322f8f.2
        for <linux-efi@vger.kernel.org>; Mon, 20 Jul 2026 07:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784557683; x=1785162483;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GVvzHMxnvOnUe3OxM3vQdreEJT7StGP+edlzrOT4kYU=;
        b=sdk2FvbUd+Wrln4T29WwEf7HIiCw7NoJmmS/vUBdaWVkn3b5+9v9HFW0qGxnmamQEx
         EfitNeKRHq0uFS0sieivW2BzfOwGXyzjJeHo/82aeL5NlQWoSVD1TmhmHJGnaHtYfwAw
         e0MajKcrB244H+fAj8R4jHkrSbf8AjAhj60eTjiVq97UWmBrknvzgzL15f4Koq8aBicX
         mRVLDxYqimmx+k5smPY+uCZ9extyvQTxG9VaK6CV+3ss66CkO4CJ3qGkcuCvVWwFWpy9
         BpXQn6OanFtLL77F6EqrHz64RpNN/kAKafXW/qTnquDfi0v5YMqcgCzarkHcDKYeOyfe
         tncw==
X-Forwarded-Encrypted: i=1; AHgh+RqU0HTgy45tzFs6QxOJIlgUn6NyEnyzMuS+udMavJcbEq9chJ7biacrANqcXtgVs8WMrEpiXFGBLBo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxx+xpiXR/BtJAq+Q0k7TeP87ojwSzoGk2An02EY3di7URfG/4
	zVWU3BwkmEIZe3evQsFqrEBWzOp8WqiG52rXdsx/bmKuYywiwPOegWsFDt4czB5wbBOz4gntDMh
	BEOsYsshOxiYsXIQdh2HB89n4nHv9CJMZH3pXi0LNQBNHovjO/31GgtuXPCvqmHoutfZjP4QPkM
	myww==
X-Gm-Gg: AR+sD11BZeR51EBbA4X0QSl7Ex+WxOGg1gnFOnO4sIh8n0clDYRXuH3G4glgCv+Qh2q
	GORv5svJC7DMqokeM9JWZ2ePVil9A3IK6SAbD1fuXnR0twMlmdqJGTKlZFkqlXgskOKQqQ9+Jgm
	Ar9SZJVLWE/o+ITIHf1SL/oKgBIlDIcVYYC7MeHCT5/wdkWdgLcZ4dFS7BQR69GJDHSAFO2QQL1
	hXn1au6Zb5fvepspe3PIEA+g3kkabkgdv2h4FL1pD/ukhBoBbQaUJT6dfFz0bQYFXGvpFIHEyQc
	NbKv0JQYjAq3e535pvpDvUGeib6WERY2c5Lof+l46jehR29uWy7UD95A4GyuxkOLf5AAjzv/z+k
	ZmoS8dwtecYTUGJwWVI4oGQdtxQN70DN7WFKhFW0yt38OzLwM+akTC2ppE/mlBvkX02Szxjm5V6
	HoZAdYaJ5qSJ0rezjWd8GWviDtCt2Qpe9N
X-Received: by 2002:a05:6000:18af:b0:47e:12d9:a08a with SMTP id ffacd0b85a97d-47f623219camr16164969f8f.46.1784557683436;
        Mon, 20 Jul 2026 07:28:03 -0700 (PDT)
X-Received: by 2002:a05:6000:18af:b0:47e:12d9:a08a with SMTP id ffacd0b85a97d-47f623219camr16164922f8f.46.1784557682960;
        Mon, 20 Jul 2026 07:28:02 -0700 (PDT)
Received: from [192.168.103.134] (ip-084-119-040-110.um24.pools.vodafone-ip.de. [84.119.40.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e51986sm34613277f8f.11.2026.07.20.07.28.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 07:28:02 -0700 (PDT)
Message-ID: <25438675-606c-481e-ad0f-24ab8d8af193@canonical.com>
Date: Mon, 20 Jul 2026 16:28:00 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 linux-efi <linux-efi@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: Reboot via EFI SystemReset()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Ard,

In arch/loongarch/kernel/reset.c code has been added to invoke the EFI 
SystemReset() runtime service. Commit 628c3bb40e9a ("LoongArch: Add boot 
and setup routines").

Using register_restart_handler() could cover all non-x86 architectures. 
Wouldn't that be preferable?

Best regards

Heinrich
