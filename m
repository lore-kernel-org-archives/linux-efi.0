Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C0F1FCFFC;
	Wed,  2 Sep 2026 00:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788310745; cv=none; b=LJ8p7XP62omTlbOM87RvzEyFSYNVcCANaXDnrbz/S8PHj/n1gPM0ZteUwNznNBmbzpHWhXOymKFz8dlrtxCsFNk0Qf6kK4vkOaDIwOGms5x9mzgFn7pCaYGaIwI5U8L0tA8s4m1OS3l8LjP+oFJKvk2xnMUdM6IskL5s7xbmrEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788310745; c=relaxed/simple;
	bh=v2E9tCsiCdcPeLCXL+a3HGoBgxSJWpidJRPXqBTEz80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8M3j0aw+UoFeiE1vVIP6oB2P6xeqsnPTb1kKkXIjUsOTh9qd5daGCA8VmIwNxLEY95xLryaRCb87Gf8Ra65A7uG3FPVLbQbJ82t125rqBQ5I0UEGyKA1zOc3dBFQZq6uyStT9pruEZIpnQ410SzMghQXukshXy3qHrP25KYhmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byyqW8ly; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byyqW8ly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F348E1F000E9;
	Wed,  2 Sep 2026 00:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788310744;
	bh=MhIs69j/kWPkPA0A6YZxiIT0JY3qgkOwd00Pjyy+9t4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=byyqW8lyGJWIF0zrNxIXw2aC94BLG4eYb441PJ0wn93kzKfXrDO5L6RQwi8rHE8H5
	 HmJ3bJUCxFNjThFi0scQKKWrMktrnBYMjFbGeAJ33UbfXnpsDqNQOpBZqHE7r2Z/L4
	 eoQMImhoA9u95FiUcHkN++IV8X++9/0PbIaWcKKLn/vH9Htk7+3Z5eawDm1SgMDJnT
	 xbkzEc2SoUk2GnXFbOFaGagUCdBp1V9mAQchx8KPsnbqQpTH+Nh0iC5tGLmBGhPoq3
	 rB0Pl9FmiVB5zAirQsw56TecO4CUa6FFU3t4J/O959TrFHNiLnPxZ71N5xhCJGnLEu
	 qoIdh98HcVzmQ==
Date: Tue, 1 Sep 2026 17:59:02 -0700
From: Wei Liu <wei.liu@kernel.org>
To: Thara Gopinath <tgopinath@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, tglx@kernel.org, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	ardb@kernel.org, ilias.apalodimas@linaro.org,
	James.Bottomley@hansenpartnership.com, javierm@redhat.com,
	lszubowi@redhat.com, francescopompo2@gmail.com,
	tgopinath@microsoft.com, x86@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Anna Trikalinou <atrikalinou@microsoft.com>
Subject: Re: [RFC PATCH 03/12] drivers: hv: Reserve memory for VSM secure
 kernel during early boot
Message-ID: <20260902005902.GC2583463@liuwe-devbox-debian-v2.local>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
 <20260901165647.3160413-4-tgopinath@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260901165647.3160413-4-tgopinath@linux.microsoft.com>

On Tue, Sep 01, 2026 at 09:55:17AM -0700, Thara Gopinath wrote:
> The VSM secure kernel runs in VTL1 and cannot use the normal Linux
> kernel memory allocators — its memory must be reserved before the
> general-purpose allocator takes ownership of the physical address space.
> 
> Add hv_vsm_securekernel.c to handle this early boot reservation. The
> driver parses a new "securekernel=<size>[K|M|G][@<addr>]" kernel command

We should add a prefix to it, unless you tell me there is a plan to
extend this to other virtualization solutions.

Wei
