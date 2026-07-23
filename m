Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4323033E345;
	Thu, 23 Jul 2026 06:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789115; cv=none; b=CfG4mIFcY01Q8Qsm29dmzUdG9zawaCpyRFIqFts8XBevgeMoVzOK0y0dtv+R/gwEPMLUVnQAemd+oqTBuGFYFcVHmTs1JUvkbpti8543Fzrm5MDRSVddw/xbbFehROG8et6TxfP5yAR0yl4xDYeBjCDK6dIOuqcYNThERVaCiP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789115; c=relaxed/simple;
	bh=ImwVGU9nSg+OHqDwSkDQ/uaULUdOYzaNECTX2aTymVc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=qID9wW9AjPr+XD/GLgBa/66cG5nlrPXZzO1zqZSqeByRz0g4jOMsKob8kt+1gIijm6QZUlXaRwR2zBMWnYzhcpyuSHSQe6KlvcygXzCX2/ao6ahPnIto75nOASgsWX/D1tlJMhs9lg5qU2BEawsFwVNa7mt4u/VwFljuImIb2As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iG8LrPgW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iG8LrPgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C2A1F000E9;
	Thu, 23 Jul 2026 06:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784789113;
	bh=4xQTy4eSVpTtYPrei1wNXYNurYKnTqTxWF1OcjOoWRE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=iG8LrPgWXIA/R1VPUdUigj5u6npSj14MPFQX4XJbec2JyBoSyHGF2GAlL85pLtNy6
	 YieXBEc4ju0hW/26CIYiTCmcadQ/SEgXOvVbs0v5F+hY8++sPC7pHCQF7wnSwD5bRf
	 dT4O9so8p/oLDNg4nrGKakcXMHz6bnCAM5wQKI8oa1oyNNH0TFmvDf6KXHKnP9cvbc
	 3F52xvj6VWaw3UbTTC4pNKpWYjvLzNI5UG6J9VhWNItEfMBTLcEDGJup6cX9P1y0V2
	 2d2XxuOCzZ+xVl+2ZeCAO6kUszHklg9IUeXc1xogoDPo3MU8HFGg9ncVDLqc6nJARM
	 NCYt/7/mK99HA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8D7D5F4007A;
	Thu, 23 Jul 2026 02:45:12 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Thu, 23 Jul 2026 02:45:12 -0400
X-ME-Sender: <xms:eLhhavfi0jpkHty_MDJoST9X4tgvrac-DdI_kWHdJ1mgbVtUCkslXw>
    <xme:eLhhagBh98yQ0WqIJbEdyWB1bQ2SUGvVEiDaSbksfNy6C70aDyCOQ3j5YYox_piQn
    be_c5BeIUOwtY4CRUzu4a8ZjN5snBs4RStT2-d5rc46XClnO3l8nkE>
X-ME-Proxy-Cause: dmFkZTFMLAuCUJ86r51UVZPMu/ee9B12uP1/sLjg7iraD7WqqlD11sY0lMbKcdF/cboh7w
    bbSxN3tlkJbxVKLnjApaVBzyxoJtmi00UZamlWnqqnvn+fHGo7crmEI+QjVK9Hh+BHc96Y
    EzBpd/SwTGAAae4fQwEMfcxLUMEntCBL+2CkZw7oiPpl9N9RhZRTlSk8rbWWWFKlKP/ZKj
    CXHpsLDGKA/L4egtmPdf2ZnR2lgjEeLDexK4krDRVZAJ6aPtHCU9ytB8CADjQUMxLFYlmE
    Vuca1IfJ7BvKVUPgBIsx+rD0682dGjamhZTZvMXRZXke4NvPJE4HgSgMjYyXxqNhbXfUKK
    7mKs/Wh1xeo2JheuVJQ8LqMRcALfLhjxO02TERxT19RPStSbHLjlqNfClxgaKMAxMElhXj
    4PfYmh7vDpd7g7aAUECHqknCyOoZjf5kzVIW90bSlSaQHutbHGsvPp5SeK2V92y/ZRWaVW
    EwzokZp4PcP1b8HyyuPoi/S9LQ8Hs+chkF1GAsB5ZcOZ/eT6LOQgvNPHAiV6nmO7lPKf/M
    hqOXlwT1jdXpfBhqIUqc8QfACjgPrHd0/kqDZUUItW3dew8tC+cShlY3GhZLQPaXfYweQl
    C2vckPn4BN39PqJG3O5miaCeXI3cYFhOBphDGXrbMgkgAiUFcxNBZlgJLPQw
X-ME-Proxy: <xmx:eLhhanmkPnnwhZ20NvKGe9wGs1Ig7UYeaq-qMGp78kADskrB-5C7pQ>
    <xmx:eLhhamQLk8MRin67lAjoiUfrh92DS3xnyyA1ibvvjXnINvPZWXyNdg>
    <xmx:eLhhahLF8iERJVhHnHQ-MTztOPAtHafSzP9QjrsWNtg7hlxo1VrgOg>
    <xmx:eLhhakD7MPUQ5BUgpzf-aidY8f06VSma9L7rW_p14tWcDfMordgIGA>
    <xmx:eLhhaiANqSkUWMhe_dbcAwtJdRTTPKeM4PKdL3d22HoagpPIZml1CqM7>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7790E182007E; Thu, 23 Jul 2026 02:45:12 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 23 Jul 2026 08:44:48 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Vincent Mailhol" <mailhol@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <4ab2fe3a-f828-4f79-b13b-217c48d76ceb@app.fastmail.com>
In-Reply-To: 
 <20260722-efi_guid_to_str-const-guid-v1-1-c12a105da2ee@kernel.org>
References: 
 <20260722-efi_guid_to_str-const-guid-v1-1-c12a105da2ee@kernel.org>
Subject: Re: [PATCH] efi: make efi_guid_to_str() take a const GUID pointer
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 22 Jul 2026, at 23:22, Vincent Mailhol wrote:
> efi_guid_to_str() only formats the GUID through the byte array passed to
> the UUID printf formatter. It does not modify the GUID contents.
>
> Make the input pointer const so callers can stringify GUIDs from const
> data without a cast.
>
> Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
> ---
>  include/linux/efi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Applied, thanks.

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index ccbc35479684..cf5cc85e3fc8 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -705,7 +705,7 @@ efi_guidcmp (efi_guid_t left, efi_guid_t right)
>  }
> 
>  static inline char *
> -efi_guid_to_str(efi_guid_t *guid, char *out)
> +efi_guid_to_str(const efi_guid_t *guid, char *out)
>  {
>  	sprintf(out, "%pUl", guid->b);
>          return out;
>
> ---
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
> change-id: 20260722-efi_guid_to_str-const-guid-a5b2accc7f0a
>
> Best regards,
> -- 
> Vincent Mailhol <mailhol@kernel.org>
