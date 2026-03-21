Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E919238C2DA
	for <linux-efi@vger.kernel.org>; Sat, 21 Mar 2026 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774103267; cv=none; b=iF6oHzFEsm1Rnl+G+FsovkjuQ8wB3YnJqpg0tK6VST236MyuDGC+Y0JilBtwQQTuOVzHA6PZhwfkVnKY6wwr/ZuD6HSyt6/FVnDLnk+jYq30Lc8YQ3KvqG/FpiRwynIIeFYcZ2otiJq6AK1DmfCYV5ghEVeaw6cB/HImal3NzE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774103267; c=relaxed/simple;
	bh=XbJvTOd1ukwPGu2B9QSbSkII0ybcEyvvDNPe4pFXwFw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=F32zrugBVKxTuMY2DDFYTH9zDfO7C2tZFooo7U/V5PJ0O0HO1/jZ5PLDm23t/+AJx2kdtIcDqm/wMUdprO4ljDzLm5Epc5MlE2dw0AJ3JDjlc4pMQTOtwZ7P2+NvYowvvla8lp/wu2K/VYAoNMGlgk4tDCEaHyZ7ZPEnDdhbS2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mGBersy6; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mGBersy6"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4670676ba03so951860b6e.1
        for <linux-efi@vger.kernel.org>; Sat, 21 Mar 2026 07:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774103265; x=1774708065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=By+r1Fe/YcOBcCg/TUP/Rfl3T3jnspwWgDUfbTqj4k4=;
        b=mGBersy6NNuVGCzzex1I7u3IC6ckORW3S5x3pPRjUsQgq2WNIPS1fUUxi7klBu309v
         LuFeUd4PEbb0fnTBDEoPwTB4pacYiXus2ZdD4Lr1lh2EhRqfHkwi/CqYnDTRxAkt1YvO
         +fHEGoE07oTYSeZxZxxqZD62Lgz5PbJb6NSQN4R0OOkZWLNuP8IgpBx2VHjO+Uppy6fp
         Np2aLa/9fUgEhHQ69KbRK0TabRl2oeu5QnBYQ57RgKQRd0/pnDuzDaKwDqDkVTrMgSiV
         GpNZzXpxFwgkD7gkifWSSKFVUkDKDkC4zh08w6uerFTjhdjdklJnKU6CI+eTl0ua1ln/
         wu9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774103265; x=1774708065;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=By+r1Fe/YcOBcCg/TUP/Rfl3T3jnspwWgDUfbTqj4k4=;
        b=lmV3KRozqyXmurkrLUGJpmXXUhaBY31PlnL0fRdaHG6EjF7+27bAN4moeNFJIcMeKy
         LYFYecTPI64Hpg+X8xFeVoa61WkvT8lwIB478wMAJzqKLsCK6fpksjbzhY2WAnZPDS0/
         +3hpLWAm3p5Jl9rUly1092N1y8dzZxiBd63wtkC+phWCITA0icCRNlohQw3dQkabiaCA
         JvJF6UbbK00r85TEt6uakGIf6qpWuKBvkmkGplUmb1zaOtjkyQl81NilvvsIJChMttAn
         i6ACenajKqrF8JgtCyjeSkujLFH0a8CsU5M+L6mRVuS+YEfEBFHJ0xbAAyeSu7uHwv6K
         W34g==
X-Forwarded-Encrypted: i=1; AJvYcCUKfDgxfe6MHPUeuNUOQsKq+61odR4TINoij2Or7eMmYMVRqKJLNN4JPW+a9JoId/O6hszm5x8Qr1w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyoMUMQ4EXGVJqNAWS2XIIFkImQROiH0ZZfvTJqe65DzFIbyaR
	YWDOTM/7cE9xoZD26KHNcROkd3g38L3NHmvUGYh+rvNELikzTBWCksXao5kit31kak8=
X-Gm-Gg: ATEYQzyMSNOku4FkLJjsVO4vLKo5B5AqV85gK4tgxzj2VndAxOPmJw9aEQzFXSxPuCP
	AFgMIcfADlQvZXeKc7rZOXhdVQ2SItzGvXSDYl587ecKbjU0UE0M6m3A7whm6HHLSPyBKX6clyh
	pw2F+okb+CBzqYwxABdmF0sP/vYDneZKFFvxLHC3VHR3YC0WuwlbVLfpwx+JS86hS7HtLdZJTVi
	pOhW3MoWb7SEGCi84x+fwzMxTp25+44QiAJ9OYm3blzwUHMzVeHMCkNdUw1fc85eKsZwnZnEBj0
	CzOr5tc6E1seDsJqp9GJYIHUeo+l+vEGV5jI9b5wmVrRejQOzSidSSZFP1LShbroh0QlzyeRl+y
	/YSzDw1DNcSKkIZftlmE1VjjMeTAqBX6+n5M8a9fryq2pUDKQ5aei4x+mFs7nWHSBWHZ/8+aaqq
	IGrU/6UfSXEE9cgVSe9rS6bzbwRj9h5eNcw/z5g9AN6OoH3S4LOl81dOS6u1wV6xOU+DFuoCUOE
	7Th
X-Received: by 2002:a05:6808:1392:b0:467:255a:7453 with SMTP id 5614622812f47-467e5d9638fmr3487371b6e.14.1774103264871;
        Sat, 21 Mar 2026 07:27:44 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467e7f131b2sm3215075b6e.15.2026.03.21.07.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 07:27:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
 Kees Cook <kees@kernel.org>
Cc: Josh Law <objecting@objecting.org>, Davidlohr Bueso <dave@stgolabs.net>, 
 Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, 
 "Richard Russon (FlatCap)" <ldm@flatcap.org>, 
 Thorsten Blum <thorsten.blum@linux.dev>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-efi@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, 
 linux-hardening@vger.kernel.org
In-Reply-To: <20260321004840.work.670-kees@kernel.org>
References: <20260321004840.work.670-kees@kernel.org>
Subject: Re: [PATCH] block: partitions: Replace pp_buf with struct seq_buf
Message-Id: <177410326319.185838.7918397412644396915.b4-ty@b4>
Date: Sat, 21 Mar 2026 08:27:43 -0600
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.0


On Fri, 20 Mar 2026 17:48:44 -0700, Kees Cook wrote:
> In preparation for removing the strlcat API[1], replace the char *pp_buf
> with a struct seq_buf, which tracks the current write position and
> remaining space internally. This allows for:
> 
> - Direct use of seq_buf_printf() in place of snprintf()+strlcat()
>   pairs, eliminating local tmp buffers throughout.
> - Adjacent strlcat() calls that build strings piece-by-piece
>   (e.g., strlcat("["); strlcat(name); strlcat("]")) to be collapsed
>   into single seq_buf_printf() calls.
> - Simpler call sites: seq_buf_puts() takes only the buffer and string,
>   with no need to pass PAGE_SIZE at every call.
> 
> [...]

Applied, thanks!

[1/1] block: partitions: Replace pp_buf with struct seq_buf
      commit: c2d466b9fe1913f8dbe2701156c38719c94188f7

Best regards,
-- 
Jens Axboe



