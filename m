Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA2642DFF1;
	Mon,  6 Jul 2026 12:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783341493; cv=none; b=Mf16/trnG6Ko1AE01BMriYhHOlh4CUJT0IFn2nGXcvr8kFfrVAR1SscQTx7LIKeamC9/p5ky5i850/uxGPY9lFvXe3cOJYYLX0x3dDgjePidtA9qRk1SUrEDYxFm/m4VURnt9wmL9gleQadj5/xD9kjF2gvO9q0KgHnRtizlyI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783341493; c=relaxed/simple;
	bh=nJoBXu6vApHB1qtfFrNQe0S1ayCCBtGY4e5g38FuToY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ox1dIT2aneUQpE6y6eIjKFC70tGh6HiYcOdTZ4fouSICirFbOCdmowDLCz3W7Zd3LEPKNE7/ODOusX2e2Ehe+NZwnjNOVxyAYzk3pxe2WLhpfBypaMJCdKnDSA9GgRiusxkbDyLTEMmoTDU8Kw6Y+8/Cj7BsyVoCZQFC2wZmBrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id 9698E1DF0;
	Mon, 06 Jul 2026 14:29:06 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 77605600E552; Mon,  6 Jul 2026 14:29:06 +0200 (CEST)
Date: Mon, 6 Jul 2026 14:29:06 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi: apple-properties: validate setup data header length
Message-ID: <akufkl7EVZUa0tlY@wunner.de>
References: <20260706091813.77792-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706091813.77792-1-pengpeng@iscas.ac.cn>

On Mon, Jul 06, 2026 at 05:18:13PM +0800, Pengpeng Hou wrote:
> map_properties() remaps the Apple properties setup_data payload
> and then reads the properties header fields.
> 
> Reject a truncated payload before checking the header version and length
> fields.
> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>

Reviewed-by: Lukas Wunner <lukas@wunner.de>
