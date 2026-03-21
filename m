Received: from sender-of-o53.zoho.eu (sender-of-o53.zoho.eu [136.143.169.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6364E846F;
	Sat, 21 Mar 2026 14:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774103599; cv=pass; b=Y3fKTrWR6hac8oZvhwnRtYkN/oSLhVDDtzu/WoU/UAjUtkax9eZLCovj6lJCfu1alvLRhfi/xVvKpm/wTd5SZ7r22uuykWcwymaA6IrmokGe16MSI3eFdTD4/HzmwxHxPLVsoyI+aHTlnfzec6Rfwhzvm/DhcaOMMeSlc7xTd40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774103599; c=relaxed/simple;
	bh=dcrAvz0hRsDq2StWs+jNhj3odjYPbG6/ZSiGn9oNQ5g=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=f8EP/RHh3kHWVHhvkYlUODBxaVyjBLGputlIKLj8rmmFaOGmkAzZCPfHSn2HQA3s9gP6TIQDZOUslrtdpGCKr/+2ffJytqwvuLfiF2y2cifZ13PxmBgq92s09U1JBRi5acPs2Splazioppkq6WBn9SRYMd/BbjmXY2MzNWRPJEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=objecting.org; spf=pass smtp.mailfrom=objecting.org; dkim=pass (1024-bit key) header.d=objecting.org header.i=objecting@objecting.org header.b=XavQIa0v; arc=pass smtp.client-ip=136.143.169.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=objecting.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=objecting.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=objecting.org header.i=objecting@objecting.org header.b="XavQIa0v"
ARC-Seal: i=1; a=rsa-sha256; t=1774103555; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=GiQ51/HbcrupiNAo02iAymczCNrBV7sczjqPw3u3cGtcjxh9UzQO/VOW7ypEwc/etOamBOxc75FgMHTaVcq3VSA31KUA0MkI6Jpu1guIhTPwzpl/e5WOkkdv/PZl0rTqKKjP6wquu+pcMEJ0b82q9/T28tU1KGsVgcR6ZyGxIRU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774103555; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=dcrAvz0hRsDq2StWs+jNhj3odjYPbG6/ZSiGn9oNQ5g=; 
	b=e267sQPZwA8enY1tzbQyE6e5KI0KTrlrxVmRW+B+z/NniJ8YN0ovo4BG2/W1u00WKh3JrufXL81hwghQHTbrzZ98slSUvqZ7xN0kwj9fNiHGBsaYw3YKY0oMPXbmqYaIkV9mW0XoWWrIHrHNokc6nkpIS6CDw5j0jDvXeErPejM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774103555;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=dcrAvz0hRsDq2StWs+jNhj3odjYPbG6/ZSiGn9oNQ5g=;
	b=XavQIa0vo01VsC161u3aPBhh9aKDyzhB30iZLLk/+Y8GoRHB0nIc63JchDNzalsZ
	KfYQ9rEEp0dn7ydZSVsZexf/UTU2GAZnZhRkJI+lpRt7lNQQG9wC3q9vbBqwdpVyBzR
	nTEuT+gh2uIZABPYvWaVuRpKH91QoL67GxvMpV7w=
Received: by mx.zoho.eu with SMTPS id 177410355288425.08217320596168;
	Sat, 21 Mar 2026 15:32:32 +0100 (CET)
Date: Sat, 21 Mar 2026 14:32:33 +0000
From: Josh Law <objecting@objecting.org>
To: Jens Axboe <axboe@kernel.dk>, Kees Cook <kees@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Davidlohr Bueso <dave@stgolabs.net>, Stefan Haberland <sth@linux.ibm.com>,
 Jan Hoeppner <hoeppner@linux.ibm.com>,
 "Richard Russon (FlatCap)" <ldm@flatcap.org>,
 Thorsten Blum <thorsten.blum@linux.dev>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
 linux-hardening@vger.kernel.org
Subject: Re: [PATCH] block: partitions: Replace pp_buf with struct seq_buf
User-Agent: Thunderbird for Android
In-Reply-To: <12bb0db8-e8a3-4e08-89e9-db9a1348bea3@kernel.dk>
References: <20260321004840.work.670-kees@kernel.org> <D47F8215-FD08-45ED-AB01-0A5C48CD41DD@objecting.org> <12bb0db8-e8a3-4e08-89e9-db9a1348bea3@kernel.dk>
Message-ID: <AC193B05-A9FD-4037-8243-DB210BA4A7B5@objecting.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External



On 21 March 2026 14:28:21 GMT, Jens Axboe <axboe@kernel=2Edk> wrote:
>On 3/21/26 6:08 AM, Josh Law wrote:
>> Reviewed-by: Josh Law <objecting@objecting=2Eorg>
>
>Please don't quote 1000 lines just to add that, that's somewhat annoying
>in terms of scrolling to find wtf was said, and it's hugely wasteful=2E
>Prune your replies=2E
>

My bad, I was testing a new email client out=2E

Next time I'll just add the tag with the commit description

V/R

Josh Law
