Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4225416869;
	Mon, 12 Oct 2026 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791824875; cv=none; b=ZtKB+p26VgDlP/USOFA7m59X13Y62ke0r2VAHPuibNGT7ucDGKCP9CPNJ7lNfIf9ENxRYvjQJfN/dSo+ZFg0nI7gwQai42MHJTb9F+zXMR6Q4ABN1u8vE4aXNX59YP1070iGsL+MO5nmic5/dZQMAbT1tGqn5oDxamLyt3d1RRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791824875; c=relaxed/simple;
	bh=4CZobYzp6p58ZmSEz14TpT41+xpZQWCvBjoiH9LisdA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=ZVOYhldh9Ckz0VxzCjJAfpmFQC4tFTZb64dBH7kI1OJu5eTQq0GP3YalUR7BWZ/RV+OdT7YXE/jwAGBOfd3qaSeSO71CMTzQhPvI4F1zed1fLuRq+UsNiJUNmTwIyBUq9r3xdS/Yf+JIT94SZIHS9D/6iF/Xbd3Jy/GhsC0dZso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CSL9sZ2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSL9sZ2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06FB1F0089B;
	Mon, 12 Oct 2026 17:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791824874;
	bh=XpTBJEUI4L0IO9d084F3iXRKv8WqZ+vCrsDhqb+T6p8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References;
	b=CSL9sZ2hNNfXtkWPPyhDC31wyL8DcxixHieuYNskojmp2nhk2S8yzXr87xzNpQBAu
	 +pBqH+tVmwgRkNyPcnHVwQI0ylFt2jPcAWAyD+G9Dz2d5e0kSJCHkpyNvgKsEAH3aq
	 X73kZowvgm1ts8uYg+oYT2EHWZMgO0HPt+2zsA/FR4q3VOr2EZNoDa8ILmn5ubJ6P2
	 uJngk1/wSOjYopKgQ2+rrzYc15BaHjzgS29+EtNNyAichU0Rjp8C9CgkZMC3cYQR1K
	 yYgBVs2WdubNIwi+CrD8i5CbDKzKwurHFHeaA6lVSE7exw8jBukxQk2487/0TLqwLX
	 eC3iv/kneDYVA==
Date: Mon, 12 Oct 2026 10:07:53 -0700
From: Kees Cook <kees@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lkdtm: Add more EFI runtime tests
User-Agent: K-9 Mail for Android
In-Reply-To: <20261011114013.1130-2-ardb@kernel.org>
References: <20261011114013.1130-2-ardb@kernel.org>
Message-ID: <90ACF5FB-44A7-4869-A770-E7A30FEAFBC2@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



On October 11, 2026 4:40:14 AM PDT, Ard Biesheuvel <ardb@kernel=2Eorg> wro=
te:
>+static void efi_rt_test(enum efi_rts_ids id, const char *desc)
>+{
>+	efi_status_t status =3D efi=2Elkdtm_rt_test(id);
>+
>+	if (status =3D=3D EFI_UNSUPPORTED)
>+		pr_err("XFAIL: Test not supported on this configuration\n");

I've tried to have more specific rationale for XFAIL reports=2E Like, I tr=
y to say what someone needs to do to make it not an XFAIL=2E Here that's ru=
nning under EFI?

Otherwise looks good! If that message is made a little more "actionable", =
feel free to take via EFI:

Reviewed-by: Kees Cook <kees@kernel=2Eorg>

-Kees


--=20
Kees Cook
