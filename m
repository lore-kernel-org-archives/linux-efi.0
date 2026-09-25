Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D119E49B454;
	Fri, 25 Sep 2026 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790336691; cv=none; b=pJfByBwr6yn430VX8hEuvOeRUFngmnE/00kD8zLZqvZkrm6GrgbkdmxV0u6WcqL/xiWDWIsOjkpZQXnWorQNSk4Ul2jxBeVPIQ29MXU8e1O249dukvDORDgKaEqq4BNglWVn4L18yhGf82FCbTOoCUhJWGXh1ehHUMzx+39hj2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790336691; c=relaxed/simple;
	bh=e95i+Rr+8qXvLy8j1a75if96U35mkoHbs3lvy5NuIF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SKlBZ1gYAGlDK0FRo/VMGyv2el8AnDs+UPAGB/+6DlEI5XtB0bWSEZpyXDGTUmty0pLvlL23DO3EFYbx6M6mobiN3HsoqVE/zub6VrOnUuxFnhcG1iSJU5o4xd/xhgrxdd08EkvzeCXGv/NgRY37ecdy33f7gC9ItxpZwrwgmIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzmzqkpP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzmzqkpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAD81F00899;
	Fri, 25 Sep 2026 11:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790336689;
	bh=fQR5galY+vHF8DwHfIpBqByGI2QoQ55xP6PAhdlQD8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bzmzqkpPHBos0Gm0BQs46ekYRclLwIQeJku2jMz/mh7vK9CfCLVrTAhlJgYmVtdC7
	 uO/tnnrfTjlhjGRSxNX/f5V0PHgZ2Qe4fjZpZNCX78okcxWcV3enMF9GSl95b+qOWC
	 YXAZjxznCUX158C4E+98g0LKc2xJL2dWqjsyPCzuK8gcbCamNxEVBrorpX+ZjcdX84
	 wBvQMQAyFDkDJKLXtz3zCvGRnXXAPlaMAXGbfZ0goFD05ixevn4LKk43+RyoLRCQcZ
	 QISgc0x8j/vfPJ7Of1rFyphNCY1B3xQz7Kh+ut6Dxz/+XqaHfSQHPnKli2WXjDXrG/
	 qf8BYwlqk6zAg==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.ams.internal (Postfix) with ESMTP id 83F92198003A;
	Fri, 25 Sep 2026 07:44:46 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Fri, 25 Sep 2026 07:44:47 -0400
X-ME-Sender: <xms:rV62agr-Aqve671wgJRqEo6a0hMBDzL-l9cGGdBpJVicoL7zlpLU0Q>
    <xme:rV62atCkJbAWCSvqhxR3MR08QesFr_M4NIRQ9QdIUKkQ0P9JAEa5yKHHDQk7ZKB78
    t69xWZ2HWwFWsWmryUEEnhCDcEjQDsDmwfu7mEleh4BVfikc_DiK6Pw>
X-ME-Received: <xmr:rV62ahcuyp5IJW-bNOKaOuoarDOw9pBn_cfjJ4cn3dBRMq0QlKgslZMpo8s>
X-ME-Proxy-Cause: dmFkZTGeblOzfkEOSlJzwLa0Km46KNhQRCaTtHujd0dgGAACUtraaFtLKqkYZlr8mtqnKX
    YOEE5vR2jUaQWbj0UEcxorUuH/nHiBQ80x9Vd33o1vh3HivC80L9bOTnDr36YF53OxMMyT
    fbrov1Y0F77SSn9ieo47egq/0S2Us+OaoeBdmA4ZCrux0EQ3jMFnMyipZG5FpBUrH+A2F9
    8G3f+4D8oLafC+vekBdSZgDgaFvubMQlBB7Pabr+LF5FRD0k6iEIHmzcreZlBtWudtzLyE
    KZUwfHmE5uzog4xemlDeBRnz+Dw8ul76N0a7CmjuvCbyWrQeIiApw+ey0huO3BUniB6dHD
    OqIQU3qzwtZyC4fc5HikQX8E0QYGoS6Ddm+XiBNy7sRZllT6ndvqLLJdTJZbhAYjwgMHxH
    Pj1dEi/U025lErPTmmgMuCNjqTb2wL7KYwWxqo1dIpqd5C/Xylz2IwoB4a3oTmHfsi0Rvt
    QGn6UIJe0KPJJ7gIhn9cOW1WHE8jXLLJuuCmnC04ul494k1mi2ONWVTJ7IEMogNRUwVT2s
    lgJg8NIAuehy8OrsxbnlsZyLtBRlEwpqNrDq3Wja6i5HP+o76h95Wzw7NO0Jye4PNo/41+
    zCp5SMvFGfPBISBEiDPWuKVJTKiy6m5dqow6dOu/zeTq6dX6yJ1w85/5UFbQ
X-ME-Proxy: <xmx:rl62alvpHxajDY2SKPC_J-Fq29NXNWUUa53QPYbh-mxIWrbaT8l7yg>
    <xmx:rl62aogoDLoJcyA3DCNlsT_fAZkI2-FJTZCkQL_x44WR-krV9SMy2Q>
    <xmx:rl62atu9oX76dBLTfn5juXBfKN29rNDYkZBxHbYItHoj15ZFy0yq1g>
    <xmx:rl62aj97QqVQ8yelYlv2ZAOiGU9N5CdhWzwUmR4f8MjRXOXBPfGW6w>
    <xmx:rl62ajYH4_Xb1Tsmy2kpOuAsNPxIMarcwHAC0kI-GzfU4zmsQ728l1ae>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Sep 2026 07:44:45 -0400 (EDT)
Date: Fri, 25 Sep 2026 12:44:44 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Borislav Petkov <bp@alien8.de>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 1/3] x86/tdx: Share tdx_panic() with the EFI stub
Message-ID: <arZeOczqtAPGqjnH@thinkstation>
References: <20260925075137.44298-5-ardb@kernel.org>
 <20260925075137.44298-6-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925075137.44298-6-ardb@kernel.org>

On Fri, Sep 25, 2026 at 09:51:39AM +0200, Ard Biesheuvel wrote:
> Move the implementation of tdx_panic() into the source file that is
> shared with the decompressor and the EFI stub.
> 
> Use memcpy() and strnlen() instead of strtomem_pad(), as the latter does
> not exist in the early boot code. Avoid fortify instrumentation in the
> decompressor/EFI stub by #define'ing __NO_FORTIFY before including
> tdx-shared.c
> 
> Note that __tdx_hypercall() may call __tdx_hypercall_failed() if the
> hypercall returns with an error (while it should never return to begin
> with). __tdx_hypercall_failed() calls the decompressor's error()
> routine, which prints a message and then loops forever.
> 
> When called from the EFI stub, this error() call may attempt to use port
> I/O to the default serial port rather than the TDX hypercalls which the
> decompressor uses normally to print diagnostics to the console, but this
> is fine: given that this situation only occurs after a catastrophic
> error, and a subsequent spurious return from tdx_panic(), whether
> error() uses port I/O or not is rather moot at that point, as long as it
> never returns.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
