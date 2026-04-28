Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CC937BE70
	for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 10:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777373253; cv=none; b=j4+L5V2AXZtDQSel9ZOndsrvVIhKG7fFmx9uGO/qzgPVh84KaCWCQRgBuOxnBaCS6gUe3NgEUJeRK1x8TDDcM7o0YSptzeWt/q+g9si5Ax/zyjcJVjJoIamlh6gYO35GhzvnhRZ+iioQ9RWyl8uapDpbMVSv4zMMW1RKaZYtoCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777373253; c=relaxed/simple;
	bh=R29TYibaNrPxbtXzoGqyKBqqz762YHGAFVY4QzIkEo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GRcRpGh0+EoLaEYaiGUQSED12ytRvBLwqqU1pwpgidDiKJpbLw0ee44TQM638oHVCmyJrG2xSpnyGIhjd3dccaKcO81yXPY764UUA82k9hwL5OKwWKKzJ9iWpVTxBg/i4nOSROs3Knf/zMhV6/LWS6Tgw082U1cc1/4yW+Er6zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ITCPGhQV; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="ITCPGhQV"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43cfce3a195so6404176f8f.2
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 03:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777373250; x=1777978050; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VBl4vrHqsWi74zANNfXZD9NFSvoyl74waXulnZdsouQ=;
        b=ITCPGhQVJz0DugFPzB/dpnP3t7YYuQmtnKBrMb4IZ9iPCjz73FTMt8pWwEiBF7YfVQ
         cj6v2WconPX+ImPXWgWFYInQ0SKUDVtdY2SGZmIqMNKd4uuNozNccBS5eH8uafWmvRbD
         NEAmIB3EUL6ZRsTMo4WiBVgU1BzYxicPBCzoXMyUurv+RHmGlMICJLOBnW36HZFKz7Ff
         BkimZ5Q/bOs765X4NI/t8OzTae+QKlDmmXSCDzqqiXB4ElehE+IGVtBMvYv/Q5sab9eX
         Vz4yDyn5RKCpEAeI8MUwL+SLxASxFJuGDpScQa90PKhusacK5S1uW/yATQ8eyze8ms+V
         3UIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777373250; x=1777978050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VBl4vrHqsWi74zANNfXZD9NFSvoyl74waXulnZdsouQ=;
        b=XMe/8Us0w9Yz4aoTqK3VWdHa1fvx6zxbtttp7DQKGBK9/YVurcgWsgnDhfEUwegy7j
         WMAqKrt4RUDqISGK1YYW8Daz/oFYx6P9DwqPpq66yRnX+f90Ns2W+Zrs94Ok2d0OYOOa
         qiisIfefBkxQpqGWvlCxpLvqtnk1/xGKlzpyytrENPkeGFZI+pnBR0/uyyvYOvilq1P9
         xfP+vWhz9uumVZ4+/I8A9d5PLzpuU8tUBr+zlEFRv8uYMVUBjkAM/V+UAib2VtdBAtpL
         I897et9ILU4tHfe8R1sL5uKSw7Q9y3jmPD7VN6e0xslzvVRLC+PUL1Ms14zkDDt/iraA
         G//w==
X-Forwarded-Encrypted: i=1; AFNElJ+y82VOjOFOSyr1JZou1TUIV387MpzMer3QYV3uCordphE+csRn40HRJQIuvkc2bd8FMMyQU57PR3k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcBPOumdGoumCmWIrU/kzdWByNeVcxAKDfb1NCwQDWl6csTNmW
	QiIWbzCySY4YYX260DrHgLWqxVL0Yr4yMptTdVhZnctABKP+ZKa9RG+a7ZzjmcLBPaTzPbYAkMj
	Du5SzhmY=
X-Gm-Gg: AeBDieu2cxWbqY+KUzSWwEHKWuSKWRuBxsagTxtJqNvn/FwIId0knAh42QAbola2pDc
	U3jhPNA1MtOD6JWSZ//+K07+v7QfhSrZh7R4GTX40c/sqdNVmX3jUc2+twOS12XZxb1wvhjEtgM
	zwGwQ2wugiqfiIAnDCSiG0ELWwcAgd2CJ3lXIJroHUQhatdK7+ofs207iR48g03uKs8wrc7N52p
	L9d3vTsUPnCTcq9vx3YvLrJmxlMKCP2sA2WrXNCqBLWEawIIqnsUjkyoDYbM6/EYdpTBC2QZo0l
	9lloQahoz3OYDbxUrbXI8K8YpSrwXEJ8esxyz7PZe9W2UBB4dC1Vuy2SL5/6EbCpPIoZez/04VD
	wWzpUoX9zi+ohxQLFaHsv1Cx+3rfC9r5Rs8a4JVzI6Sls6laNcjP+v73hd17y+IMUT16Ysn3dnL
	k6eepqXvKburJ7aGln5KJoEacqFaSh7UiQ9rHc92EwaWoJ7g==
X-Received: by 2002:a05:6000:438a:b0:43c:f52b:8003 with SMTP id ffacd0b85a97d-44649ba199dmr4772896f8f.36.1777373249636;
        Tue, 28 Apr 2026 03:47:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([185.194.184.52])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4463fa89140sm5346060f8f.27.2026.04.28.03.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 03:47:29 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:47:26 +0100
From: Gregory Price <gourry@gourry.net>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dave Young <ruirui.yang@linux.dev>
Subject: Re: [PATCH v3 03/17] x86/efi: Only merge EFI memory map entries on
 32-bit systems
Message-ID: <afCQPpQfOfn3J0Lc@gourry-fedora-PF4VCD3F>
References: <20260423152024.1098465-19-ardb+git@google.com>
 <20260423152024.1098465-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423152024.1098465-22-ardb+git@google.com>

On Thu, Apr 23, 2026 at 05:20:28PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
... snip ...
> 
> This means that merging regions is no longer needed on 64-bit, given
> that the relative placement of adjacent regions is guaranteed to be
> preserved in the virtual space. So make this hack 32-bit only.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Will try to set some time aside to test this, but this may actually
resolve some numa/efi quirks i've observed in some KVM/QEMU configs
when trying out different memory layouts - so thank you for this.

In the meantime, diff seems reasonable as-is, will try to come by with a
test tag.

Reviewed-by: Gregory Price <gourry@gourry.net>

~Gregory
