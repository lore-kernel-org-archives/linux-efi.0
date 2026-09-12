Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDFF33F385;
	Sat, 12 Sep 2026 06:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789193430; cv=none; b=VQ6Lw5wbQ/EhGoEH2Lo2y5DFe9mNDeyUpMRh3lb5a4pVDAIG0ygQtuwvHuGOlCjzaQl5sX4U915YnHvb9JTURqDUYMHtnKECSRlpyrOx9coDecM/JtHG4CuF9lxz7iodPgBXCpxQluDwiuLjjA78oBA7cr2zOwXi/nogKU82MTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789193430; c=relaxed/simple;
	bh=MPX74QGdyjwiPXxzlrmj5PHbSotLq9oVP8TW7+53Kqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MyH+Zd8Z5nmya1+fk1r0gNyd8X8NQn7z/T4Jr/JejmQoCVxTXlYdXaUgludx+MhN4NhNPOK+Il9aWB2gA9ZwW8y6jMJPwG3ANuFC3W+a6D71IOgh1CyKitlRKnFgTnFofTX6OrcQqcMNRE7ZkguZ/pxp9fMGRw9goZzyZ6b7krM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jIr2ow2v; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jIr2ow2v"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E070940E00E8;
	Sat, 12 Sep 2026 06:10:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MxW4pgKm1bbP; Sat, 12 Sep 2026 06:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789193416; bh=7rO/IGkeP9vagXS7FbRz3LcCruCUqBIigtT2595VZC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jIr2ow2vu1XkYC/oHCKnLHHgRWWFKnJkETNreRN91sIKEENsinJKIrztfHoaAMX1u
	 hFtzESTbr+2HbUoiUWU0/hSoDxsdgAMjKlzkWwGcwaGqdKqalY3D5C7e1jW073ZAlg
	 i1fvINDD4pQJ0Oo2r2uU+Xs+IlafG8ezUPWwbC6f0BThqm5+kiyXFUL451UjgreWjF
	 m1m+lIZdEBDDXPG+SEXWfDFYypAZchg4VYYIRpHBYP/PNC3wJ3wXT/8noLYZYM217g
	 BQnxFa8AokoA5T0KMyWpEGOesRSiPncSpXlL5fcywJtSl044E4qV3KFbG1Mv12o86L
	 T1l2OlcRQ2TSQIx3Qaf2F3seKKKZefUyFhmrx0dOgLuJrb8Ys4wd4BDatLSEb2cCdE
	 Qo0nG7rVKDyzx0NeIzHAY8J6OAma8aeBag0ap+5hEgsbKkIZmbMZGXwsB17KYXy/b9
	 v3Ci+irFaEFzhI77rpdOp9Ekoe4d7cEoQFjy9zux+Kwd//xKOuhXah7lOMTDSvKtYv
	 K0utmrKYzlKP+x2gTvZOwcWHMuB37hnFDa/Sj4jHZd2s2mbfds2s0nn3uU944LfaX3
	 CAcE5rs876AarYk4i93x9pNSEBdoZIK9NB/I3Xith3yFUX+zT1p3I18MY2r86BYico
	 KLw2YdcMrTOWWHNCUM9x+iEk=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6AC3740E016C;
	Sat, 12 Sep 2026 06:10:08 +0000 (UTC)
Date: Fri, 11 Sep 2026 23:10:05 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vincent Mailhol <mailhol@kernel.org>,
	x86@kernel.org
Subject: Re: [PATCH v2 01/10] x86/boot: Drop pointless re-implementation of
 panic()
Message-ID: <20260912061005.GDaqTsveevVkzxRJoI@fat_crate.local>
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-13-ardb+git@google.com>
 <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
 <cee2e02b-3817-44cf-857f-62a148290367@app.fastmail.com>
 <aqKrhNQ3mZMs5-Dy@thinkstation>
 <b24b9785-b790-476d-985d-e8c5405d192b@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b24b9785-b790-476d-985d-e8c5405d192b@app.fastmail.com>

On Fri, Sep 11, 2026 at 09:32:26AM +0200, Ard Biesheuvel wrote:
> Thanks. Can this be applied as a fix please? I need it to base efi/next
> on it for the next cycle.

You mean I stick it into tip and give you an immutable tag to merge?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
