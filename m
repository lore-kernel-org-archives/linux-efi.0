Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECAD2475CB
	for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 20:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789073729; cv=none; b=sAMDAjaq76wDywYF6HFzRJP2KQzJLhIm3La6prwlqhrgJqSv9SsSfEo0FXR9IQ2n/dqfA7ZTFANIl7bPdWMjtCsI55ruw0LsbtuTFwBEeo7fw1OpRksTYlaUmAJ+Ry1n4dIGMfu9Gxo1+NSDct1cRdj4flL0UF3BvgLvkhaE5Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789073729; c=relaxed/simple;
	bh=/A2Fwd+9+3agfDel93uvmLAzyFdulq2jHx373bRNuP8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mo51Ii5ZJZmFkXQ6TwwaL9Bx5FSb/Em4yCEFdntVuzU0nj1hvV8HWhTTcxhyU4Mrbi3JfsVa3hKuoHynsGdFlclfcyzs5UzFIrIOHj7F4J/iEjIwLZZ+bd0uAoND8N4Zrpghd0OTRVqKSnx4GN4MD7ejf5y7O+d9shkNTmoN99M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=q3MR69iH; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="q3MR69iH"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7f5934ba2a5so133023a34.3
        for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 13:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789073726; x=1789678526; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1WJxP3qg6bq1oKid3neP8OLauam4Io159DZHymfuNtU=;
        b=q3MR69iHn0RY8dFStvfBYLlIS711TnZP6i2obkEa4Tv+UcqUhErfE32yGVLx7KsNPZ
         byOPuN6dCUuUqe3/2ke0voaOgHQ15J3/TxvcWWR4CxSJOEpK2lr1SMfGnOaInGirOPoi
         U9+d3LfXKFyhZDll6x3PHgbEjT+cwcQHuy5x0TX6NRwWCTVQU3beZRDRVuAh0HA2/aBm
         hRUZMjdqg173YDLJS2lNLwhlVe6CdCPQXcqhDquiXxweFjiNGZq+83YorruH9lJIDIpy
         Loj4/drY7cGjraj7X3wfak0K7BuP8+V9NIoQl+OU3sqOd/vflIr+mbJ3Moss3e3ZrWoR
         5L6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789073726; x=1789678526;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1WJxP3qg6bq1oKid3neP8OLauam4Io159DZHymfuNtU=;
        b=nOINf25DbNtXq3bgzTNvPSBYZzsrXBFVPoIljR0EZIQEcPag7SV67phsrTvATBkx3M
         9vwPwTlHRVcsmTCHfu4MYt/uR/vnmytf19Ova0plC4M3HKJazi9ANpYyjRBw+lzD+fVx
         sHBHtTFjSbGomjVOH2y9iJlbgcXUYt5Det2cPy11vhUAjNi1u7Z0QMM6Oqv7KNCSTMAj
         MMNyZxvMAoBmO+NMCfeqNS3t3pd2GWJakQRHziTuRU9ziNjaoPk+epht2N+RZrZvStnR
         WgRmLHGQoncCaIyL+bqRU0l/18tuV5GclADbe19V64DvFERH1rZgP4AQKsJ0Md4hIozV
         OkiA==
X-Gm-Message-State: AFuF++mCVTljbbtchucHv5yMs2arpppkJ/88fvJjKclFAhUQerI3YOGi
	5kfW7WshF49PkNFpST1kBThaUU6YP7PX4YgaXhswlChaF+fXkReEHYgi0Ey+chlB1bU=
X-Gm-Gg: AYBFou2dSAb5OJ9aAGfisEtvYw973A0Ky9AiPZHk2ccLmsE02EaaOSZG9Dytlt4OTA7
	A9QritYvsG/DKPVHK7OzobNi7wFL77cAHur9toIBavp0XeGcTr+czN0LI7eLKTCPZ27DencoeHD
	NranyKaLeVnBQ6pCMuQPkxvsOOunVKIzJW/TqNN+/zr23hycGncJzec41MUc7yxznvrI/99Hhq/
	V6us6MTvv5ehh0AAvyUuVZE7JOVFrALfq4yUX2pOWYAFrSCAj5GremBuB+GO1B5FfOaEvX+PBQz
	Kv0+krT2lt0//P+UIp9RbCOk5Gftrs7M8YfVyxRGnwBNQFIyUIWvH7s+Wg7Q98FpeBid5cpnG0Y
	HapWr/NG5ov8YO6pnyrtAeOx0oRW7iHm0sVSCCGUPplj4KGVJjYEPZj1DeWjd0qBvPd+QXsMexL
	uokVBy7dskjo3y3oedVMkQtmR/WUdf2a1t7QyyBs/rg/fJTy94qK2C7hRExQ+40NoABuRQ84HyU
	KLwhekvwmTjkT3OEoOsVSPrO+7ySJwMYn8byZDMai3+AV79m9M=
X-Received: by 2002:a05:6830:6abc:b0:7fa:ab72:9dfa with SMTP id 46e09a7af769-803ff447bcdmr479781a34.18.1789073725724;
        Thu, 10 Sep 2026 13:55:25 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-803f60fe54asm635779a34.15.2026.09.10.13.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 13:55:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Davidlohr Bueso <dave@stgolabs.net>, 
 Vincent Mailhol <mailhol@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260908-fix_gpt_entry_attributes-v1-1-a4dcb417e8fc@kernel.org>
References: <20260908-fix_gpt_entry_attributes-v1-1-a4dcb417e8fc@kernel.org>
Subject: Re: [PATCH RESEND] block: store GPT attributes as a raw value
Message-Id: <178907372482.484803.13802362688033738030.b4-ty@b4>
Date: Thu, 10 Sep 2026 14:55:24 -0600
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Tue, 08 Sep 2026 20:58:26 +0200, Vincent Mailhol wrote:
> struct _gpt_entry_attributes currently models the GPT partition entry
> attributes field with bitfields. This is broken on machines using the
> __BIG_ENDIAN_BITFIELD ABI because GPT always stores the attributes on
> disk as a 64-bit little-endian.
> 
> No current code consumes individual fields from that structure. So just
> remove struct _gpt_entry_attributes entirely and replace it by an __le64
> value in struct _gpt_entry instead. This lets users apply endian-aware
> masks explicitly when inspecting attribute bits.
> 
> [...]

Applied, thanks!

[1/1] block: store GPT attributes as a raw value
      commit: 74ea55a6ecb3fd69b47b2b8a6f6979a6c79c7ce7

Best regards,
-- 
Jens Axboe



