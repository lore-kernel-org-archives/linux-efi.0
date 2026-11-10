Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794274603;
	b=zciO19AxS7q/v1B3n53aQySrskpU3pvHuiWX0N7mRpfcmLK1JJXODQzIgtQwLiKeUa9z
	 AbxFzmeW6mNgDIsekNsuk042NBWLZlLs8RXVO/nIGTmEiGKKla7n5rsdQO9Gp+sbqfWF2
	 +/DbOugTQyDBDiTf0f5KU69tg6I0xv74DR4+aJ7dwvUmLRvV/uBnKl1YzYPwBF5gEZMSB
	 BB0ji/sTUR+tCVm2YdOeI/EFb1+vzYngLt7PtU1Goz2CjcSWaGcDMPyRkgmRXWP/HrGb2
	 m+LXEKhfMdNqG5411MLdYa9WeAcVTrANcIR5VHIh4ogje5PL2/2qcSqonPuUXI+S0/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794274603;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=W9ih9ljPK6y1w9rEm0sqJKx/YKMQ1/8WtMrNwPznZJ8=;
	b=TadC2CCg6X8kxk0VbvsDWkg4q8LDN7FNKEjlep9RKGOrxI9ov5cx6MS45jSZMa3wRxvU
	 2IHJFtwvrJwdtHhb0jfSfKEqjtl2cwxNpEBi3E3USLvuQHA6DNls8fQDm+Iq6+43sZqZD
	 2iLUPCR4PSlG8UU8/Hj2qqFuJ9owdw00j71t8WmP27nff1XwVwPa7mwXbaA/1M9RWSg9f
	 QHSFGxkO5GVZm+y89svMfAnMbV7EqKTiC+hkb26PM6sfjLJy0jURlEJxYMr0xwLyJfNON
	 NpCnNYEzh8+/O9qeRtDNFnkWOub3giKDWetLLTwDlxWOc375HLu1wZ7mmJoDaKsV+IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HtaOlO3y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id AF63B606A31C;
	Tue, 10 Nov 2026 01:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HtaOlO3y
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BDA6E1F0089F;
	Tue, 10 Nov 2026 01:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794274602;
	bh=W9ih9ljPK6y1w9rEm0sqJKx/YKMQ1/8WtMrNwPznZJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HtaOlO3yEfu3PbaUhSbtedRaQuc76/w7JAA8AVcLhLpTPjBnaYJrNhP7Vpqw/9WQB
	 OrhLJls4N2DgDmz3wW76Zj069TK/bwfACqhhq2GB2kwCQ3papadvyLKsPzL5drl7wf
	 Y5hgtZwK0Xe10A9wzwvigrJA2MuL5t5eNBhgxPqBXRirBu+NAqHLt6jhTr+m0oR5Sj
	 51kO2zfNFX1NOvZTC3Qnx0ySLQHSSjv/uY9i9btScCUGBTCo8Q5LD1UZUuiqzrt5+t
	 ShalZOxC+x6VLLgQQZZq3C7UPJpZA4xtNWfQ2SSFxpNqAn9FQ8Hix3dKJz4UOLUawY
	 sLveKrAqxCysA==
Date: Tue, 10 Nov 2026 03:36:38 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Make hibernation work with lockdown
Message-ID: <avJ1JiFQApsgYT_c@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>

I have a rebased branch of these patches with all the merge conflicts
sorted out:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=hibernate

And I'm finishing up refining my test environment:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/

The build recipe is:

	export LINUX_OVERRIDE_SRCDIR=<kernel tree path>
	make build BOARD=tpmdd_amd64

This results build/tpmdd_amd64/images/tpmdd_amd64.iso, which is a live
ISO. Once I get remaining commits pushed (not all of them yet are),
the image can be installed by typing:

	sudo npx @puu/install

The TUI installer duplicates the bootc image of the live ISO  to the
target hard drive. It has a checkbox for hibernate as part of the
installation flow.

I'll report the results later, and at that time my testing harness
should be fully available in public.

I think this is pretty much the lcd for the required testing machinery.
It is neither a feature very popular nor well maintained among popular
Linux distributions.

Br, Jarkko
