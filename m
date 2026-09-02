Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D94143F0B0;
	Wed,  2 Sep 2026 22:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788389926; cv=none; b=rX7MqKm5fmAl+DIpMve6QDK48Rh2B8kDnsYpnplTwgfVm4UezE7fY+sQXNT/EfIRlzs+7hXU+p+q4H25oc2q5Vxsy0Xw3oKPV/i/SefYtB1YjUhSD7nPCBhRkkH6exT3NlXCL+RYAMgncY9FtNkXpYMtcuBKHDyxLAkSlpFT3HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788389926; c=relaxed/simple;
	bh=NGROKAGJRcPSkbTlZMu6Ec3q9VqyOJY69b9PTEkaVgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iercNTvZS7Uwnjw8Qk7Hr8Fwt+gkFd6ghcnKibwym+yn1jvULFBp70GzbBXKu1jB/cZM3b5hG02vWVpmaFRbROk0ByACqL/0GZV9VsSbdAa0uFlAsy5rsNukNBniKPv/VkzvRRjw5v8p8et72ib8UmglD3rnCLWYYJ68jECj/dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ot0qqSw/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ot0qqSw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAB21F00A3A;
	Wed,  2 Sep 2026 22:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788389917;
	bh=aHfkXpE6IZqb/J2m9EKFTMgu8Bwmhk+NyTMlMZHfuZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ot0qqSw/9dHcLGTsrnMh0VD1VOJwhuy6KRdhSb4GZojS5Ky+r6X9feMjk2OT/JVns
	 yoeGuvp0ooqgdqkO4kxcrArRhNi5NV8Z2qN3NA2neoOWex5T3/Q1o/TFVEgO6a6AAW
	 zFt79XbqOLKpSRs/4LlH7k+QqxVhD7oPvxYyd2cAt+q0ONoKD62sxcbzUISnwSmQ/7
	 t+k2y2qdZ1cB0qJy3WZBPczHb3n+cwF8NvTC2vWIID0c1U0vADE1dhV2Zyl1oqheFk
	 kdDxMs5R4+UJGEbk6JEkb3z4d6RQr5seHMqBtwlEFJDV247OTQfESuqd3/yM4cUWit
	 JWpF4km0oF5ig==
Date: Wed, 2 Sep 2026 15:58:35 -0700
From: Wei Liu <wei.liu@kernel.org>
To: Thara Gopinath <tgopinath@linux.microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>, kys@microsoft.com, haiyangz@microsoft.com,
	decui@microsoft.com, tglx@kernel.org, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	ardb@kernel.org, ilias.apalodimas@linaro.org,
	James.Bottomley@hansenpartnership.com, javierm@redhat.com,
	lszubowi@redhat.com, francescopompo2@gmail.com,
	tgopinath@microsoft.com, x86@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Subject: Re: [RFC PATCH 07/12] drivers: hv: hv_vsm_boot: load secure kernel
 image from firmware
Message-ID: <20260902225835.GA2896046@liuwe-devbox-debian-v2.local>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
 <20260901165647.3160413-8-tgopinath@linux.microsoft.com>
 <20260902043732.GF2583463@liuwe-devbox-debian-v2.local>
 <4d876bd8-3885-4d65-a272-d846ae0d7d3d@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d876bd8-3885-4d65-a272-d846ae0d7d3d@linux.microsoft.com>

On Wed, Sep 02, 2026 at 12:22:37PM -0400, Thara Gopinath wrote:
> 
> 
> On 9/2/2026 12:37 AM, Wei Liu wrote:
> > On Tue, Sep 01, 2026 at 09:55:21AM -0700, Thara Gopinath wrote:
> >> LVBS bring-up requires loading a secure kernel image into VTL1 before
> >> starting it. Add the VTL0-side loader that stages the image in the
> >> memory region reserved by hv_vsm_securekernel, in preparation for the
> >> VTL1 bring-up.
> >>
> >> The image is a 64-bit ELF fetched via request_firmware("vsm_sk"). It
> >> is expected to ship inside the signed UKI/initramfs so it is
> >> authenticated end-to-end via Secure Boot before the loader consumes
> >> it; sourcing it from an unauthenticated location would break the LVBS
> >> trust model.
> >>
> >> The loader validates the ELF header, stages the PT_LOAD segments into
> >> the reserved region and records the entry point as a physical address
> >> for use at VTL1 start time.
> >>
> >> If VSM support has been advertised to the hypervisor but no secure
> >> kernel region was reserved on the command line, panic: LVBS bring-up
> >> is committed at this point and there is no safe way to continue.
> > 
> > This conflicts with the memory reservation patch, in which there is an
> > automatic allocation when no kernel command line is specified.
> 
> Ah no.. So securekernel= has to be specified in the command line for
> __setup() to be invoked . It can be left blank without parameters like
> securekernel= or with parameters like securekernel=256M@0x80000000. The
> reservation logic will take care of reserving the correct memory if there
> are no parameters but if there is no command line specified __setup will
> not be  called. The other way of solving this and invoking the reservations
> unconditionally will be to call it from setup_arch like how reserve_crashkernel
> is invoked. I am not sure if we want to do that now ?? What do you think ?
> 

I see. No need to do that now. Let's see if others have opinions.

Wei

> But I will reword this and state that the panic happens if there is no
> securekernel memory allocated (either because securekernel= was not
> specified or because memory reservation itself failed)
> 
> > 
> >>
> >> Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
> >> Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
> >> ---
> >>  drivers/hv/hv_vsm.h      |  17 ++++
> >>  drivers/hv/hv_vsm_boot.c | 201 ++++++++++++++++++++++++++++++++++++++-
> >>  include/hyperv/vsm.h     |  21 ++++
> >>  3 files changed, 238 insertions(+), 1 deletion(-)
> >>  create mode 100644 drivers/hv/hv_vsm.h
> >>  create mode 100644 include/hyperv/vsm.h
> > [...]
> >> +
> >> +static void __init hv_vsm_get_sk_mem(void)
> >> +{
> >> +	/*
> >> +	 * The reserved secure kernel region is mandatory once VSM support has
> >> +	 * been advertised. Without it we cannot load the secure kernel and
> >> +	 * bringing up VTL1 is impossible, so fail hard rather than continuing
> >> +	 * in an unusable state.
> >> +	 */
> >> +	if (!sk_res.start)
> >> +		panic("No memory reserved in cmdline for secure kernel");
> >> +
> > 
> > This log line is wrong.
> 
> I will fix this 
> 
> Warm Regards
> Thara
> > 
> > Wei
> 
