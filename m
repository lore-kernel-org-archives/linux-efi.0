Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF22845A288;
	Thu,  8 Oct 2026 13:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791464686; cv=none; b=nInO4tXGJ9odlySgC/fPVEzM8FvILu9pKo8bW+zDXv6UYgdRZnwv3jZdf0/DimfL+NXkfvqPCAzlUSipSJwMLJIuTOl5SVm66ZwgTu7Q2RgKUDy8+wIbSbgCO8TG3xqqukEe83qIj2EUokrCen6OE2Cr4Qe60myYt4sfXKuvbS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791464686; c=relaxed/simple;
	bh=Rh4hXJLKyAcuCe8NCjmCKEHqY5gcCNMva4h1Ro/Fnxg=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=mT7xlYcFrK6CJHPQ4JWy/wZyDYgVDNKaVEKPvc3rkTZDh8ePnm3TUFlX81VzcNtGnFp5twrxE7rADYyK2opTMKndha1XZ5fM9FA4t5Ztrj6UWhZYtuBRnK/75oVK+Zi2ZBLrpD8OI4RvshijiB49MvkiBuNcEJ09npWGJKY9nj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=sCp3rm++; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="sCp3rm++"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1791464674;
	bh=Rh4hXJLKyAcuCe8NCjmCKEHqY5gcCNMva4h1Ro/Fnxg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=sCp3rm++HWSf4DnTrV8vUKBRubwoelJVKY9zJsMNeSiwTpqImye91XwODndVH3zIr
	 RjVh1X16zGBfBRbyHpFzX1N4ZHpXs0kDEC3rUAuRhj0UjWGY9aMCmNr/gYMAyu9KYs
	 qDGuKw4MJVTCrreu/S4TAuR5YPdf+STGNy6M1uKM=
Date: Thu, 8 Oct 2026 15:04:20 +0200
From: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Message-ID: <91f74adb-e1ff-4687-8ccf-66ff2583d680@weissschuh.net>
In-Reply-To: <20261008081317.2602565-4-ardb+git@google.com>
References: <20261008081317.2602565-4-ardb+git@google.com>
Subject: Re: [PATCH v2 0/2] EFI sysfs constification
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <91f74adb-e1ff-4687-8ccf-66ff2583d680@weissschuh.net>

Oct 8, 2026 10:13:25 Ard Biesheuvel <ardb+git@google.com>:

> From: Ard Biesheuvel <ardb@kernel.org>
>
> Constify static sysfs node accessors in the EFI core code. While at it,
> switch to sysfs_emit() where appropriate.
>
> Changes since v1:
> - constify efi_runtime_show() prototype and use __KOBJ_ATTR
> - add sysfs_emit() patch

Reviewed-by: Thomas Wei=C3=9Fschuh <linux@weissschuh.net>

> Ard Biesheuvel (2):
> =C2=A0 efi: Constify sysfs attributes
> =C2=A0 efi: Use sysfs_emit() not sprintf() to generate sysfs file content=
s
>
> arch/x86/platform/efi/efi.c | 13 ++---
> drivers/firmware/efi/efi.c=C2=A0 | 52 +++++++++++---------
> include/linux/efi.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 3 +-
> 3 files changed, 37 insertions(+), 31 deletions(-)
>
> --
> 2.56.0.360.g66cac248cb-goog

