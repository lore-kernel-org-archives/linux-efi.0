Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794453209;
	b=jsHTL1moX6KKRsMV/pmR38AAtF04O6eASksC3o8jpNzV6eYKY7PHYuk3RpduTTJOl8RY
	 0Qe/ocCMetpy40sIXC233OuP7iIzwt0APjb+J0LBOqKrVoFm+oIbfzLT1PEwbZ1KOtgxS
	 6wxU/l46QqtTFmzmBNppR5mKfvUHfAeoGxD1PkwNrzG0ndtPMuO/8DjVZtc/5RRg9F08T
	 jbofry04yRcSrW23UO0kfL1mXhtAfNk7sEv3WMNSrSm5xXna28E7TDEZATbb/KvksscMg
	 +YYjRIQqhHafdw3pi6Eo8sZrvx1rF21WefXkQeXkJypmVHTjeMDDmvgsyGjU9baPapQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794453209;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:Content-Language:To:Cc:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=f8mmUDpXbdelWthFJmC6h2O4KuH79ZCjDuO+eZML6XE=;
	b=G+nMhM4Q5OumkJVezGTmEhdiQTEf3r8uXCaZ2MdOUKSOfajqxqKWnPd+3Sv+/8RWhuKQ
	 +b5BB8jBVFeeBNNmXRv5lkyb0gl9lX6a0aHCsdI9e1frtWNGcYBHEpGUmk7coaNZEWyX0
	 BcJ8NGwdLWOpJ4/A+0hh25r6PKf7SYJa/J9kpiIE4vFsKwUmFFfydizjN43+ytxbngpSA
	 BhGoYv4LTsVyFmtDqAxIRV0V4cpLC007u7YhOwieD0n4n+e+DtEBsmwB75m6lUmFv651A
	 vNGKH4meoD8Aa8B/s0QNcfTG0e5fAuDiYsGdx4cjErFl7TI4+195MCGuuLEtpV/TnsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=XCX0QDL5;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6FA606A31C
	for <linux-efi@vger.kernel.org>; Thu, 12 Nov 2026 03:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB6FA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=XCX0QDL5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:From:Cc:To:Subject:
	MIME-Version:Date:Message-ID:From:Reply-To;
	bh=f8mmUDpXbdelWthFJmC6h2O4KuH79ZCjDuO+eZML6XE=; t=1794453208; x=2109813208; 
	b=XCX0QDL5oVSv/aIPeStvvQTrl3WY9BGY64xwHzDN97H6Z6xJR7EbJWNeyuaauNOBhOmM4CrFrRI
	f1BH1KdHkLd43Mtf9TAeYL+FWkjSPi0CfbfvZEKo3MndOytoqxkbu2OP6ktHQY6pCxW+EdVs/VAfD
	B8VuyIIrX+ZZO1tTfK1pS6AYod4iFd4MkUZU3ll5hMW1atVWbVbClLFjiu7vDcegguzo7bBS7HFr+
	kHaGY4nAoY3Gtpvk3N1CHa12BehqTFWbTSPfPIzexKSoDohLNLs2xiKo1MM/l7ueR7X9Xtjv+PAY8
	cuIadTKhAQo1SA5VG9WA60X08t6upSWiP7Pw==;
Received: from [189.110.51.50] (helo=[192.168.15.3])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1xRLFW-009Gwm-22; Thu, 12 Nov 2026 04:13:18 +0100
Message-ID: <4a29a98e-92b0-7271-e2e5-10d159ee4a4f@igalia.com>
Date: Thu, 12 Nov 2026 00:13:12 -0300
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] efi: efibc: Optionally report panic as a reboot reason
Content-Language: en-US
To: Dave Young <hidave@163.com>
Cc: ardb@kernel.org, linux-efi@vger.kernel.org, ilias.apalodimas@linaro.org,
 jeremy.compostella@intel.com, matthew.k.gumbel@intel.com,
 kernel-dev@igalia.com, kernel@gpiccoli.net, kexec@lists.infradead.org
References: <20261108003549.745697-1-gpiccoli@igalia.com>
 <63d0fb19-b1cb-4729-839a-b9e1f1379473@163.com>
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <63d0fb19-b1cb-4729-839a-b9e1f1379473@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/11/2026 23:57, Dave Young wrote:
> Cc kexec list
> 

Thanks a lot - a very good idea. I forgot doing it, my apologies.
Cheers,


Guilherme
