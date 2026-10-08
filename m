Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD30381EB4;
	Thu,  8 Oct 2026 16:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791476701; cv=none; b=dNb5TOUg9OApr9UDX8wxukLYNOJmDzRz6EKzFXd8VxvgNKmumdlpxKICS4fUaVt+eE/s1prLbW+yinupXEFI7JOrYwFKIK+UJxU23JezbrKVmIFsms7fje5su8Mi+bBLEanQWhQRNknTP2xtZceMb/QaDiUA4w5GR421TgyaQjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791476701; c=relaxed/simple;
	bh=2dx43UJficry21HH+GkWY8Ror9EBcFm6ZvuJ2EWS0aI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhlymNkcwsnYsBJCTVcWqc65BTNq+GJW2sNywZfIR6/ikl+XqpdGUYCTQDI5oU764PYNEIO2ewt3olz7jppJKobYqjBRBodZK9nrDhbPf9gQS2zz4gZlAt7gWyks8KCrbZajj48IjagbZeBgk5kunH3uvuEb9I2iqoJFz7TJkwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBhVX6r/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBhVX6r/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AAB5B1F000FF;
	Thu,  8 Oct 2026 16:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791476700;
	bh=hK/V4IMydhsEh8nY+sX+TPUfSmFZWjWLyWcSraYYj70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CBhVX6r/ZjssvSG43VD8goptzG95S8n+pqrpZeHEwO2e4+sSKKUPY5Gwq/RXxAJIW
	 2Qegi5MrZVIEbASwq+PQddm98EjDcConApR8vogv4VJ4c9At4ZYez/TFeBThihG1gS
	 OQ+e3YClgZuIRnHf86ZtDpMHuuvG1A5VAs/zcVubWXwUpBQYy8XoztkPvrS8klmxG3
	 auMLJe7CfxfgyLNLMkNP++QFda+sp6gf3CcFUYsZjD2Qwko9oHiOSKGJpmCLacwGOY
	 SylBvanjjD1PgNN+tg9EWxz8s7JmX/rDswrNNyD3cgbx/OmMxuvrfTeYJCBkTTA+6G
	 0v5mNs9UaW2lw==
Date: Thu, 8 Oct 2026 19:24:56 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <asfD2HmdSeCt00_b@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-2-matthewg@nvidia.com>
 <asedg6XdGkOaQJ_E@srcf.ucam.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asedg6XdGkOaQJ_E@srcf.ucam.org>

On Thu, Oct 08, 2026 at 06:41:23AM -0700, Matthew Garrett wrote:
> On Thu, Oct 08, 2026 at 06:20:17AM -0700, Matthew Garrett wrote:
> 
> > Reserve NV index 0x014c4853 for use by the kernel, and filter commands
> 
> I should emphasise that this value is very much a placeholder - please 
> don't deploy this patchset anywhere until we've decided whether this is 
> something that should live inside the Linux UAPI group range or whether 
> the kernel should own an independent range.

Ya, I grabbed this from the cover letter. We keep this in mind.

Br, Jarkko
