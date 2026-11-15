Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794771330;
	b=lBsuHeMN5W6yG1zsuxD3tgPn7Ep8qNimSUQ+NG2RMba7g2/4eUDViVMZhi7M8SZ5uqWj
	 2HrTsI90nx0Xl8QMktVmH7O8MEJFqQ+qfcX4OEs2luSdZ81RZBT1x4ZkJnEKb7oH7GFW9
	 fjwG2a5xVGeo/WDpxzOywbc/L38su2gbzqlhLJ32knMiFVpCKv7n2qCbXBL6gu9EIlo5j
	 YKUa0m3hDZZB0YUS55uwpVUIBmj1EGpL32o/RH5Ub0Ns3T7Ibx4lVIpD5cFPGsuYLgZHC
	 bQNlyw9BplX0gpy4lML+wgywm9xceDzFngkxQBadoDmSUsBK13pIn0DPYzsLJia266w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794771330;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xQuRIeL9gb9FIRpCT0DiwI69sSOufjQ4E0irVGNePzk=;
	b=z8Biiwb6cDynXzNy0hJhE1VVyLDqcSJk5SZov1qu37SEmk3fGukXC9WaY+2ryn4GU03+
	 +FYcdFKrEwAvb+R2QH+/g5umA/ZCc19z9dTkennfha9rStGPe9dZ6wteaFhIXczg6kaKX
	 6P1Wmfq2vRxll2yuGSAoK9B/65V4UYVIp7W3g3IFdELkibVE61oRf2zs8cl+xIpVm+cMa
	 SfSc1wgf3y22R8fOy+BMZyJ35KL22zmKT+0S+65U6UKg63vMPLsMBWvNrLIVM3uOiGxgy
	 pKymjUte0SxjRqRu+f28dU2vBuMH8QCDCXREnUmV09zHem8lSy6Uus/0oIvlLry9sbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KhcUoYah;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id ADC4C606A336;
	Sun, 15 Nov 2026 19:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KhcUoYah
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7F9A21F000C4;
	Sun, 15 Nov 2026 19:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794771330;
	bh=xQuRIeL9gb9FIRpCT0DiwI69sSOufjQ4E0irVGNePzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KhcUoYahnGgL7ypfAVubv4Jk/C28QFb2tArkRCpl3P6/SPIfQtL9XsSNRefW/bgRi
	 ii8h3J2PnS6WPcOV1GUAin9bh/S6kMdIsMt7J3AwkeKl8yhL0hOORp4qB0v66kHSdm
	 3OndwObC/08wzBBAdvxfJBHqYknDBYlnkXxXMmsfegFLCUjHs1ASmRfWk1ndG8NtPu
	 aaBHpzd7sVDS/MHtRg4AFo5SRpY+8+TOhRXx9M+cWWF9Vykx/PviWbqmNYH7QFs0J0
	 pDYjgNf676edToqyhVkiINkstGi/17ti73MvqgG4IrvRb1OXyRxwKdDPVKenKnl/BX
	 h1qh0YTcHbDTQ==
Date: Sun, 15 Nov 2026 21:35:25 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 04/17] tpm: Log commands executed in an audit session
Message-ID: <avoJfTBuUXisiX9_@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-5-matthewg@nvidia.com>
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
In-Reply-To: <20261008132532.1155166-5-matthewg@nvidia.com>

On Thu, Oct 08, 2026 at 06:20:20AM -0700, Matthew Garrett wrote:
> +	struct tpm2_audit_entry *audit_log;
> +	unsigned int audit_log_len;
> +	unsigned int audit_log_size;

We don't want to increase complexity of tpm2_auth with nested structs
and fallible allocations.

It'd be better to just declare audit_{cp,rp}hash arrays here.

Br, Jarkko

