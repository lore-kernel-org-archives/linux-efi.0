Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152254AEBCA
	for <linux-efi@vger.kernel.org>; Thu, 17 Sep 2026 09:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637897; cv=none; b=UpSIJSo1ATdYBz8nQIhZHMGVwG3rwDWNDdmnSSfzPTZYaf8KEcIHKhrsPXAVtSCFYDkKIgcO07PmP0g5DtjtBX6tqPWsubsrMqL985qps4nRSwCPyHYYFkClQ+bqNCWASqGzYlm6OrMEnsX97Wtr0xmo8oYYeEqflpqBO74sexg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637897; c=relaxed/simple;
	bh=k9iy9AJdW8wLxZL5ESd1C2sYrjeHcZKryGJ+0Y5s9hM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=mIrAt51AtHqdpsgbYNDffFjIlvTpleUcB5YsFNBFZinGmoV3L/lG8XIu0nhELvzBNXtkaVatRzcbIQStK40tNGITp/C0YikchhyCd/VZfPghLYbn0SKDLxX9GGxyzsYnay8+nzgqQAxeT0mPJdw0v2ET5893cavpYiC19lJUcyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RNxYDaNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RNxYDaNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E691F00893;
	Thu, 17 Sep 2026 09:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637888;
	bh=2rSF53ZY4pk3y6lA4BpXgH5Qd2QOlkJhpUxGn+AImfw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=RNxYDaNqOcntlf++6Gzcp8azIj6a1+NP5cwBvWoXLnK6NnIB+qEqEYk+TMBrK4GXB
	 LHY3Y54gnFWIDSk5OHMxUIcVLedwHb/e7Nz/AJG15WKzSebehnqWJGmf/fsfx+3O5m
	 t0RC8yaIezWobKh+JatM36EdOmyyc3DZaQop8kxlhioxUgcQwAMCT+oDlf9l3jKGOn
	 JwoRzw6bChek6g8Fm02uwRN9GqQtiUw8yvH1Tps0oODiM2tM3LAY/y0tEBEgJY8/Dp
	 t+IJQyUxTeARGy6YQOLh9Mar2iOPt0SRwB9fFVCz8z0b2sYz+YLXaEv/wBljxaEGgT
	 v/2up5VCfrKAg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9A4821980074;
	Thu, 17 Sep 2026 05:38:06 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 17 Sep 2026 05:38:06 -0400
X-ME-Sender: <xms:_bSravXTHP8oWAhhoNm2inP06XPvxIL8w08Uf21_3un7Q5o4ZJkwLg>
    <xme:_bSraiYxHz02LS9UwLcrpZB501n7rIXLSL8ogVyZGP05yz_Apqdrw50cwfNVRNaeP
    NDwOmM7qhQHyAU7FIcXN071zXoM4n_tGvWYSZ5-O4iyhBFNuvPvi6CBUQ>
X-ME-Proxy-Cause: dmFkZTEXd2h0o4lG1b+Y5NWTcjCbMHLFEL0ltW+yBpGuTNwPxnu6HZiwkO7TqUQ1L02Kac
    ReG/bMGBU0bvYMzDliKa0O2QhEYAhhwf6wSOhVR3uLuSHgCWTY8s9LkMtFiM5mq1DYshrz
    J1MiUMMwKHalFIYr4dxzgnUWIw7qZuvtxUDfcqpP+uXd/sazidg5kM7R+ngF4FoggYX+JT
    tpbHDAuiNp5KyGQCJa+1zmGkNVRfJEb4U8QuV273ImWVP0tlXabVzwAcgc2qcGE3xFNK2q
    naa9dmemW1LDLk7Y71ClmwFPyvMKyBCopcOcPGfWVIgLDcklNUt/xLdu6IYRn5zxP4bKdW
    d7+iCQL9RZ0Eokewq0SVs4XdxHaEg94yzcakOQNH+7PpTCGHhijzUBPFC/Y6RsBhGyms5L
    Izg7wNn1eyolV3jdvK1bbl6RJ/uYLr6ta16rszPsMxXD+K8tOoK/1SCfbQS1Qln3SPAw4W
    aIbrM77sEOY0WQ9tUjQsTED6SCzeLg1oSFhGU+NGwCbV0s1UdXVZS4HpBT3KC1ByMY3V1X
    uKLF8Gm2wkTpD8DbA16dVQCHDsRZ5CiR5kGGl3BUF8pZ0sozWBbb9G+s+8Edx0NLWK2nth
    SRHy7WDkEuUWjkE+kSB+dDpSGfDP9xlzPpQlxz17ddpUGxbPNQdnTDTsn2pQ
X-ME-Proxy: <xmx:_rSrasdgc45UV0EZ8KeBa0v4oRSECm7--m92X8ESFKrbms_R3WpL7Q>
    <xmx:_rSrappMHWg18OiOg8FO1aYPgLJY4qDnG-H3SxsPu5UcphGxdRgwXQ>
    <xmx:_rSrahANL1lT3JDwfDy7yix3QI4rfgsXYcw94gz483tXpM0tLtOq9w>
    <xmx:_rSrambWsUT0kKtGfNBXXTNNuKI6NliLnZLD3fkHsV4r-2SeWkG3og>
    <xmx:_rSrak6AcsMv_wmAW2uHZaPuMliANzt-tK_OexURrFHOs3oBQcXDYNlg>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 529B3F80081; Thu, 17 Sep 2026 05:38:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 17 Sep 2026 11:37:44 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Vincent Mailhol" <mailhol@kernel.org>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-Id: <eef95da0-5d7e-4d19-b416-7f64ff2297d0@app.fastmail.com>
In-Reply-To: <c55f8ca6-3b67-45da-b309-b1793407fc04@kernel.org>
References: <20260916144647.2651379-11-ardb+git@google.com>
 <c55f8ca6-3b67-45da-b309-b1793407fc04@kernel.org>
Subject: Re: [PATCH v3 0/9] efi/libstub: Avoid UTF-16 conversion busywork
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 17 Sep 2026, at 08:21, Vincent Mailhol wrote:
> On 16/09/2026 at 16:46, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>> 
>> The EFI libstub performs some redundant conversions between UTF-16 and
>> UTF-8 and back again, which includes dealing with surrogate pairs, which
>> UEFI implementations themselves simply ignore.
>> 
>> So drop all the homegrown code, and use the existing UCS-2 (== UTF-16
>> without surrogate pairs) library code where conversion to UTF-8 is
>> actually needed (the kernel command line).
>> 
>> The remaining handling involves the EFI console, which supports wide
>> characters natively, so just use those directly.
>
> This v3 looks good to me and runs fine.
>
> Patch 8 still uses spaces instead of tabulation for indentations. But,
> notwithstanding of that and for the full series:
>
> Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
>

Thanks. I've fixed patch #8 and pushed the set (minus the x86 boot)
to the bootloader-info topic branch. I'll merge that into efi/next
once the x86 changes land in tip.

