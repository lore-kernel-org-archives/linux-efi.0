Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=93.77.172.85
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795699033;
	b=QUUMbA7MHO6z7umTjSqBNX3EiwNAgYaWLf1c5dTeKih6pV+upXU9VlBxAq3E3Uyi3bpv
	 j+sF/feTNuiQLAfUixWEl8qUHSgSUNZBQXiD67ZidGqVkEJEm3+WQNb4lhoGkstJHe+Dq
	 uQKUaKpjAjizq9cpVNwLTWZWdutFrqB/Mxgd/eKlHJiD4oI6RUyqhmT7VfWSrJfnwGiZX
	 ISWvwYS9srkDKSpmYTDUgrXh1u2/H6/RLz08fwM2xyWXd4FS0eoBiQ1VmWSM73WzEVOcS
	 dyZasustwErRttTdclufY53SJxt65n3KmXnd5iiyUjCouOuOzcCkUr/kpUVzAtQToJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795699033;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Gbe2KbK4Qj2jebSXDSbpr3h8bicLa7Ak4paMri5bBHk=;
	b=DiMsWQIpGTakE2h6GoIg05UoWu5Xpsx5/Ys32tNgnxFkH0hWve37zHRBgCYo+UVRCuuR
	 n0CS4uNj5/Pnq1h7QvByzRcS9ujoI6oG+QhlzbA+qfHkLgSROaExR6lREo4+Hzedz/vid
	 qQGmZoLqe56QtljV4ZLuj4in7hf+Z1qI6hP52JxIrpE3zgK7o+PZWZ7d4LwJbeCQX7Kf3
	 eIKwwiEUuH40r9Wyp7a1ef1UBgOuuNdIG2sAaq66/0Npp6ZR264R8wlEr8Hps1dpyhV7o
	 NXUC6j89bTkH94Po+uIzjR15ErP5SrV0quctDwBHVFV9/3g8BpbJCVmegycnidfxhUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex.ru;
	spf=pass smtp.mailfrom=yandex.ru;
	dkim=pass header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=Rycq63m4;
	arc=none smtp.remote-ip=93.77.172.85
Received: from forward500e.mail.yandex.net (forward500e.mail.yandex.net [93.77.172.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0C1606A31C
	for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 13:17:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D0C1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=Rycq63m4
Received: from mail-nwsmtp-smtp-production-main-59 (mail-nwsmtp-smtp-production-main-59.yp-c.yandex.net)
	by forward500e.mail.yandex.net (postfix) with ESMTPS id E602BC0214;
	Thu, 26 Nov 2026 16:17:02 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-59 with ESMTPSA id wGiDCbPc5mI0-KxKLWE9s;
	Thu, 26 Nov 2026 16:17:02 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1795699022; bh=Gbe2KbK4Qj2jebSXDSbpr3h8bicLa7Ak4paMri5bBHk=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=Rycq63m4L9J4p2YXN5mQ5Mf4vBFXGdTUUckMM0B4hcPXUgHikR9c4gOlOjZWIHuJR
	 nuDMp9+++r4WFIZ4Gac9+5GnYdvGi/uBOQHW38oeVAwUp9YYWTEiA8I+LRz4IR4+J3
	 7ivxS3fgau5Z/tje6dqGk0u0J9hrmoUjSaFTIKNc=
Authentication-Results: mail-nwsmtp-smtp-production-main-59; dkim=pass header.i=@yandex.ru
Message-ID: <1ae25bcf-0d13-4aa3-aaf0-b367444f6719@yandex.ru>
Date: Thu, 26 Nov 2026 16:16:57 +0300
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] efi/libstub: fix building loongarch32 without zboot
 enabled
To: Ard Biesheuvel <ardb@kernel.org>, Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, linux-efi@vger.kernel.org,
 loongarch@lists.linux.dev, kernel test robot <lkp@intel.com>
References: <20261126124145.876953-1-dmantipov@yandex.ru>
 <534a9786-8594-4f0b-8ce8-ea1844581c0b@app.fastmail.com>
Content-Language: en-US
From: Dmitry Antipov <dmantipov@yandex.ru>
In-Reply-To: <534a9786-8594-4f0b-8ce8-ea1844581c0b@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/26 3:53 PM, Ard Biesheuvel wrote:

> NAK to the changes below, they break zboot and need to be dropped.

Hm... I've tried a few configurations with/without CONFIG_EFI_ZBOOT
and found no linking issues. Do you have a configuration to test?

Dmitry
