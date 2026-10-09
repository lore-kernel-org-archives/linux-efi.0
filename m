Received: from mail-qk1-f227.google.com (mail-qk1-f227.google.com [209.85.222.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74E83D75C7
	for <linux-efi@vger.kernel.org>; Fri,  9 Oct 2026 08:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534594; cv=none; b=LvbzZejN4VEt8pBfif/Sx1oJIpXJSv9O0gYJ2fqkOnBWoa3aATApw/lf0O2ha5GjES45HXAGsR7IvfCQIEbLZUZpvXZioLyq8L0MosZDaACfYbgZZpAvg0QiOfgLzCbMg3DEjqBnx5AtyTn+WHF9svnlrTFBD5zuzJojxT9YxV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534594; c=relaxed/simple;
	bh=KdOxe03RJFJSOXfBnXYN+A603ShkIe/cWcsUKZ0d0NU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vBePPzYiA9qpLzqangNWCvWcpLF2AXUffa58jfmSgp4PRROUMhgc9I/vCeEk/pmoFtgpMQRxWibLi27uOuC2a3X0iAeASvhV5nkmgwVT7xYQDHRHzPEGuBjG3aJo/JGeCbMxv3OQE3DdVkXOTBoWatpzdI7lJcENeAH3AtfEHis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org; spf=pass smtp.mailfrom=cavan.codon.org.uk; arc=none smtp.client-ip=209.85.222.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cavan.codon.org.uk
Received: by mail-qk1-f227.google.com with SMTP id af79cd13be357-93e56c287b3so495843485a.0
        for <linux-efi@vger.kernel.org>; Fri, 09 Oct 2026 01:29:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791534592; x=1792139392;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cq8gQSDpD+5YFxqUsScItWyxOjZQR+1g4Dz/3bcOwAM=;
        b=FujHFcGQkRrqq+MO1fInjtnPXOfaxcv2RII0/NdUBNT1bdIILjV5pMB/Oc+MOcsG9s
         ZxgEGOziU0wwDMkGT1NZqpGYlYSh/R98dIo8uI6J4pn5+nQ/kP+UjTEOvpEmlX1JDb2G
         zKKAAeC/KzT/F4gfRKJ3t351dX4x17LwbTCr66TpR8lLhMWLyRq5S2Q6baOHuk1J1lJP
         cNgrQdnd7BFX/6FR0lym9LMVz9f34CXX/PxKcE1ACFJk7BkUS1fvTtREU6IR33pO0pPP
         lq4SqxrOTTxoZ9CjQxb9SQQX/t8CKtOaFmcaq12IKJZNEHC0y2FR8cdI8mhWdzypm7rA
         XU9Q==
X-Forwarded-Encrypted: i=1; AKwUvByr0xIczv/4RtrbdK4e236vIlG53hvgpx90AaapUHV5dhy4dbIZvOWb555/1oMycEo9g/dmGAtNEdo=@vger.kernel.org
X-Gm-Message-State: AFuF++m4FX6651OJhIfOCVfhOArefEvI/FbkR1st9JnDKEHe75TqL8Tt
	3czAhjAskme2zm6eIiZrvoxUOt2qhwUwfqwImGmYgSIfJ+IATn1HWSz5o0GeV8r6zfRnJFkjICC
	xyMa4eUShlrjSWVIaXi/qfSFHLzSMowGB+zme
X-Gm-Gg: AYBFou3ZlBiZA7p30XWIUiME6COn/JdcD/wg/ciG+EL3msVprBgImrNGuUi56YMKzu7
	fpE7Un+gOnD+eVImt80DNd4mb3vR41OgdD2ktWwDBHjXnINliuX6IDZPLZhwuWkIuprCWuK8W9y
	RzBC2Vc/aeeJQCVPsCAUHfLkpYakP28dqpNJ2ZFzKakSXLuEYX0RGho8GtfdDsS6w2YGiC8zNo3
	n2l04+ytXLZMzxM+YYkjgd30ZzuMAdtAkdcZ35xNXs71HSh8/rqWXke5PMucUymSKGgU6CxQ1bs
	Z9wv0/04UKJRVtZ0GDdbXumpqj2+IDBT9TwOetjAVPysiogMBX4ss+hhE2MW+YaVxwYtbRmdA0G
	et/czaaDzVywhvw1lbEGQgW9mcLVsQg3YE9RQzPtI
X-Received: by 2002:a05:620a:471f:b0:93c:2c15:e510 with SMTP id af79cd13be357-93ebd2085ddmr144845685a.37.1791534592672;
        Fri, 09 Oct 2026 01:29:52 -0700 (PDT)
Received: from cavan.codon.org.uk (207-53-253-74.PUBLIC.monkeybrains.net. [207.53.253.74])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93eb9811a3csm31984285a.3.2026.10.09.01.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 01:29:52 -0700 (PDT)
X-Relaying-Domain: codon.org.uk
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
	id 72C7C12862CC; Fri, 09 Oct 2026 01:29:51 -0700 (PDT)
Date: Fri, 9 Oct 2026 01:29:51 -0700
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 05/17] tpm: Add a kernel attestation key and signed audit
 digest retrieval
Message-ID: <asil_22hdNKBXH2p@srcf.ucam.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-6-matthewg@nvidia.com>
 <c5d1b69763362db8a681d00d3325dd673c4db08b.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5d1b69763362db8a681d00d3325dd673c4db08b.camel@HansenPartnership.com>

On Thu, Oct 08, 2026 at 06:45:15PM +0200, James Bottomley wrote:

> Oof, there's a lot of duplication in here.  Basically you're creating a
> signing primary key (technically it's not an attestation key because
> they're supposed to be non-primary; this isn't a criticism because the
> only consumer is the machine owner who doesn't need to use privacy
> preserving AKs because they know all about the TPM in their own
> machine).  The primary generation routines that exist in tpm2-
> sessions.c:tpm2_create_primary() et al. already does most of this.  The
> only real current difference is that it creates an encryption key not a
> signing key, but that could have an additional bool argument
> (signing=true/encryption=false) rather than duplicating the entire
> routine set.

ACK, that's fair. I'll respin with that in mind.
