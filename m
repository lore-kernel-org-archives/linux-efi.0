Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC1638C2DA
	for <linux-efi@vger.kernel.org>; Sat, 21 Mar 2026 14:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774103306; cv=none; b=rk4ovGgLNFU9IFsU4f34SZ0rNZPQx9Mdy4PX3hRZU9tYXzrZmjCExAUuXYozXc7XK8xQ6QKvvwoXSOiCrDf5q4v8qzO6cHGIOPrrqJDLzWzEZmsjhdDdX/UsCIcKUZPv52smvWWr1wqqq4pE0WZ5FTTJ2aRLEezH9XAhSqLZMF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774103306; c=relaxed/simple;
	bh=Ljm9lHSWHJuvEOaPyKMhOHXf0fTCsJ/D9lwyKKoju7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lTKYRDS9IyQ4M3wdDXuJQcnOTZ4nUPtP743hd4GlaLXtG2Dc1ISAMlg6IXzxRLeYoN5NModuaXkD7syfix3Wekiws3VE6jo3jUkT7XdoHicm9s5TWkbS0/5ySVNeynJ65huIuW8csbOftwLKIY9/4e2WNrp93MTXKp/NL+vVgZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=D/3B61aJ; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="D/3B61aJ"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-46701f2077cso2867970b6e.0
        for <linux-efi@vger.kernel.org>; Sat, 21 Mar 2026 07:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774103304; x=1774708104; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aGeFtEcePrRuGM6CVPtSo2iuVcZXXricGsZQ7tQ5chQ=;
        b=D/3B61aJ8a8WPzCw5ztDzz0FSJUiv/Qr9mA2lG235GydGFjAmzb1xZQeGuOxmxFYxx
         9g/O2OMTTMLLOaKS+Kkl7Mxi4zlKIngC2tIdx3fTsn56oaaaUMAFWhVEse+CmNAoWJWE
         n7rDD3EUYIA0GnTI+duQdSCQ06hHgD4Fdy+ptJC7B6EXwcDPmeS16DnBsXzBiewmKmkq
         RXCcD9a9Z1fvapboemM+kMRBzjQ3uikJbGtTP1jVe+LvytJSy9Z4QxfJ2DBOYzmkyUP4
         vcOYFMkkxoA5qQhsKyiK/HutQhxhEhM1LFAEqTtQCY3/6mJb4T+wRZNryQ/Yg/A6ytIL
         yjCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774103304; x=1774708104;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aGeFtEcePrRuGM6CVPtSo2iuVcZXXricGsZQ7tQ5chQ=;
        b=NY10Qg3SD+0DXFPOJpkeBykqmBpQgQCffFizrvrKtLylTuh1NJd3rZO1Y92iDnq+jU
         b+AMZbMwEXmpBpZukIL3m2Eo1Ygkzp/HaemnxCNqjtdlULA5w93Y82GZRBzoeacurOY4
         1tSltOsKgFp6lC4E64gNBmQ1w13eNfc5kVM+uxKUQwv9OaZKUYdOFEjuUcEQ7zhahB8D
         Qk3hv+f1WK3nYl2SN2MzRmdfQkqf/lDWlGHHpDOHrpR9w/Kfiot7YvoRNBfOSoPvgCze
         OlfdqZ+w3iASQwf8T3tTCe/dWLcNB/LUGQdG7crAIwpf+ZzgToTNeO8ypbah8hlnKFrI
         GfOA==
X-Forwarded-Encrypted: i=1; AJvYcCUicR5PRQjJOT4H5VpRk6L5qm2I3mAu2jQO/Pk3N37G0UPNXtJHVFr+C7VrIfopFuDuSdMkahLfhwI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEi2BTk9X097raUpm3MNRJJWbyQPqm/bgTQGB5j0+EbJInwgkR
	yKzWjB9tb+W5yBWg0UWmzRaHWMU60CMzHSAjRVqzrtQ9NN5Pd1H13pkhhFth2mGTlg8=
X-Gm-Gg: ATEYQzyD+QKbRrdJ50Nc93ophKbRN4drAMhCKDLVnBykbmErq0QJC62rlJnaWGbNHom
	yvWGKtz3lpMy4W+gzm0PdfKoUvmyMYfHV5SbTitaAwhxnMk1libZH7mFhy85hz+RbmV8DfuGJR+
	+J6gEnOId0IZIO1lGG+486Kz0dowc20NWBgpLEHIXoP44Qw8taV6BIpcCvZ0C5AvX7r/dKBPLzV
	tS/PECKBv7qrjsAyfBNz6lMnREO4rVm3E8WBAmNDIUlqYbKfWUihqiYprsQ6O2RDzUwIdpXexQh
	QaLkAirnTFu3qAmlncK+WLhsimTlwlImdZODGOVUIAXYGXpe1jlX1TFbyWTt1PFjLfUSzPT6Eb0
	Q6r3isgtzy3Lf2WvzLyDCEGWhGItKYwj0Mag2dtYF1Kj/P8higzivsoEQpo1cn8vMmas2vw6UAD
	QvTiN6KQ1P72YlTmj1548vfu/o+tKpC+9+GFQd5Ul99XBwEBgH3HHmBdJ2Rj0vLP5cKWLihFgrz
	R30lSgj/g==
X-Received: by 2002:a05:6808:a607:10b0:467:f56b:5267 with SMTP id 5614622812f47-467f56b6c30mr1978974b6e.10.1774103304390;
        Sat, 21 Mar 2026 07:28:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14ddf9d4sm4797944fac.16.2026.03.21.07.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Mar 2026 07:28:23 -0700 (PDT)
Message-ID: <12bb0db8-e8a3-4e08-89e9-db9a1348bea3@kernel.dk>
Date: Sat, 21 Mar 2026 08:28:21 -0600
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: partitions: Replace pp_buf with struct seq_buf
To: Josh Law <objecting@objecting.org>, Kees Cook <kees@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Stefan Haberland
 <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>,
 "Richard Russon (FlatCap)" <ldm@flatcap.org>,
 Thorsten Blum <thorsten.blum@linux.dev>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
 linux-hardening@vger.kernel.org
References: <20260321004840.work.670-kees@kernel.org>
 <D47F8215-FD08-45ED-AB01-0A5C48CD41DD@objecting.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <D47F8215-FD08-45ED-AB01-0A5C48CD41DD@objecting.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/26 6:08 AM, Josh Law wrote:
> Reviewed-by: Josh Law <objecting@objecting.org>

Please don't quote 1000 lines just to add that, that's somewhat annoying
in terms of scrolling to find wtf was said, and it's hugely wasteful.
Prune your replies.

-- 
Jens Axboe
