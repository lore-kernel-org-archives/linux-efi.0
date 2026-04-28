Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D6F3F54B2
	for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 10:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372952; cv=none; b=u3WBjBCWTCsLOx+FatvuWrF6V+cxkHtM6N7cwKzuAP0tAclQWqA98iBnaV2uaVvssFpg8+w4APeWZI5U5mjFqj8BX4mlV80jrk+25woEM8MEnI7UUKBHYYlcv442Y450kjp1pnZedDDeOrzaiomApt1Vl+St0j9PTn3cBNg2Y68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372952; c=relaxed/simple;
	bh=o3tKSq+sRHGDLqJnKIUYGbF7/3kP6BVfs4l6sBjhjUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XBs8FwNPuCXcn9gpHYxoRR8nkRqW8E2tCunPxtDDXlHdn8J5P7h8ks6IvGtAuonGUhQnWv+RUlc5XJULaL+s3MaURAtCcwGrrwr9Jdb87GgQofuVgQlMGRYFi0zth1n/lNAXR1aHzGnc5I/hJlHbf8rkTaSnBGjvgkQ5esQyJNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=jcDyqtGg; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="jcDyqtGg"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so192030675e9.2
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 03:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777372949; x=1777977749; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsbHvXqwusfplEoszztZBXz8B7efcTJ/84frjlGa8Pk=;
        b=jcDyqtGgrHqBIAoOTgixEOZZqscW3Yc7ccspQI3/mLLMLZEf3N1XYIlkZC4FHx/GDM
         +w4mJfYsPJyHWVf6KsonV1vsq1hv52lULeHY24UB0XDayh17zmZzgtr06qF14cSwhHj1
         WiqiuEbfM9acTQ3xa0JpaxE7k1Pk/Ya8kbMkt1g+LC3xljdCxqsVZxkwwpGtEOFobP0Y
         GN8z/A0M0wL87ZJbeCcGzbffQBchoK/1Y1psnVkUiQpqWbLBhaHtRiVN22VbLRX8InSt
         A4ax/YuhlGAY4fijkgmGnYGW9Hs/yKJpDFZ9HLFzU7V8000lPvcjeu/vKDgoordOFJ6+
         3+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777372949; x=1777977749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZsbHvXqwusfplEoszztZBXz8B7efcTJ/84frjlGa8Pk=;
        b=fiaXKfaOFDxud/mxGYZsyydsZxxz44SW9VtJfRJm4xYUV9rlYlPj0/TjGZqAgLHqWO
         wAXocDk++riqRdBJI6KIMMHBZXSb48lqTFluTmuL2257Xv/OxWzztjHjemlRXQhSntPS
         DQiFMuQfuQVkA9LJ8Np1nIYz51zNmhawfalNFNgUHoTlqRoryldo9d0bKku+wWU9PuSn
         rR611pykrPgdihttDzKgd+7TUTYBdZqY0oTMTOVr72F9Co/mk9ywcUE0NRTUqADQFwG4
         d2SzqiVP0WpXXskKytv6am0UDlO0CZ8ToUjoCtVfb7/+d0rl6vh79FgTVB4BRuB47RtS
         Bm+Q==
X-Forwarded-Encrypted: i=1; AFNElJ+N6ZpolXCl3/6DZEN5F/PfBJByrXT54CM36zExMwkwTmT2N+FboMgtR3QHPTdDL16THEdTujY3AN4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzE/X/Z94Tnx2osecGbKgxxBca1leT05NpRThuYLd0bkqqQBoEu
	1UvCIR+70A6BdUQxUW0yz/qMSJM3BHR6T5STudLs97h3AI9xJsgxcxMRNW/u1O0+ayQ=
X-Gm-Gg: AeBDieuPXhRTxUJveOqlQ+tI8i+1xLAtboGIAYgdeKxoqoKSz8bNrfGmH6gvjHOXLBr
	txJTWEj2GP4xrqqQjmh6MN7B1YpByaas606BTfy4iZ3YhaNW8kokkVNAPHmfubSSJo/WiJsJ35S
	ePQqOl59qTqCqj2M1qP4GugxuxWoy8y5cs+jkd06BKa0CP/Q2IpYQY16V9DWRY331UOi6PA9jru
	xw0Zh6xKeAEpkqQ628kq7Qx29Lx+jvM+GQpMhh9BAv+3xO5XRojk6eXE22F7wR1WcGyDlfjfdOo
	7/Hvq8fbWfinek/zjMH4AG7kjL7+2vkxx5u7iuWNZ6TD0fzWf3sxQMRAeqLMyv012ynxYRkmsgH
	xiDI3JdDW75q2hXYMZGcWzIcKGpZX8vMKCalP6HCu8i7a3beyNpECXZlfzxz9t0X2IJb75AF8bK
	+/uJVmGpQR4VwY63mx9Kw8bfwuOHTyv0+5rAUyk7M6LeN+8w==
X-Received: by 2002:a05:600c:b93:b0:488:a2ac:a34c with SMTP id 5b1f17b1804b1-48a77af5e11mr39400725e9.12.1777372948759;
        Tue, 28 Apr 2026 03:42:28 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([185.194.184.52])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4463fb7e39fsm4992767f8f.29.2026.04.28.03.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 03:42:28 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:42:25 +0100
From: Gregory Price <gourry@gourry.net>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dave Young <ruirui.yang@linux.dev>
Subject: Re: [PATCH v3 02/17] x86/efi: Drop redundant EFI_PARAVIRT check
Message-ID: <afCPEUv1KQmQJ4UM@gourry-fedora-PF4VCD3F>
References: <20260423152024.1098465-19-ardb+git@google.com>
 <20260423152024.1098465-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423152024.1098465-21-ardb+git@google.com>

On Thu, Apr 23, 2026 at 05:20:27PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> efi_memblock_x86_reserve_range() exits early if EFI_PARAVIRT is set, so
> there is no point in checking it a second time further down.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

