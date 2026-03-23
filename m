Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC02329B216;
	Mon, 23 Mar 2026 22:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774304949; cv=none; b=XpiFic8P/2YT+Ib9p0Q5NqlWvnJxMF6/+/ZLN7sg3B3Q2dzYPlzgM5FfYNNkN7SdSIze18vdror6xqkjl3N3d8FsJ5Rswk4cW1e4cA72siQHl1rRxhcNeTYY+0Eemcfue46gFXSb8TbuHDY4J1f/Wjo9fV0b1wZgeii1l+JaSlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774304949; c=relaxed/simple;
	bh=b4z8RgLa9KqoZ38u5S4ocRd0tOm+QXwxO4X2MfnCi7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IAmNmaFlYxHaMGKtNCmWwUK8N2qVsrzB4SFQaIyilVxgn8g4SQBqE2ykybtGrd4SPlOTtVVqN+BoSyOIcEcpxsVuKjObrudr94sLe98q4hpGaa7TmqgBq9nCUk6N2B1yyx2JHSl6xxNOPO7qD/jx63JcX23YGKI+CsKG82Gw5Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBipcaOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBipcaOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44742C4CEF7;
	Mon, 23 Mar 2026 22:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774304949;
	bh=b4z8RgLa9KqoZ38u5S4ocRd0tOm+QXwxO4X2MfnCi7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dBipcaOJ+VHy+PWYPWbTp/nW0J4Eq+iG9DKF1PTYjy0Pr+a99n9AUaZccVbq/ElqB
	 526h0R5Q3MF3vyTZOmj6il4Kcz4Y1qasG1mVTwDznLFGNvAntA+qMzh/ujNIxMXGE+
	 FjxRQzYRKIY1bjuTi6og3JE97XGm9gTilj0Z8Myw2MPSi7fQBZSAiUCCP6WNHR3P0N
	 BSUTA//MonKdOmM4zIgeCmbEGMDZn5igm2wCvdYdZSNMS3OSNbpSTwqUfAn2uEdf/n
	 RpI4QxzLCoEST40o1kayMlWU5aucwJikC+95VsvNSCQrEethpdkjWQTF8o7p8oYCIf
	 eKta88neJs9sw==
Date: Mon, 23 Mar 2026 15:29:08 -0700
From: Kees Cook <kees@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Josh Law <objecting@objecting.org>, Jens Axboe <axboe@kernel.dk>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	"Richard Russon (FlatCap)" <ldm@flatcap.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-efi@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] block: partitions: Replace pp_buf with struct seq_buf
Message-ID: <202603231528.26AA606EA8@keescook>
References: <20260321004840.work.670-kees@kernel.org>
 <acD_IIEXmhnVlO0C@ashevche-desk.local>
 <20260323200807.71535b6c@pumpkin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323200807.71535b6c@pumpkin>

On Mon, Mar 23, 2026 at 08:08:07PM +0000, David Laight wrote:
> On Mon, 23 Mar 2026 10:51:44 +0200
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > On Fri, Mar 20, 2026 at 05:48:44PM -0700, Kees Cook wrote:
> > > In preparation for removing the strlcat API[1], replace the char *pp_buf
> > > with a struct seq_buf, which tracks the current write position and
> > > remaining space internally. This allows for:
> > > 
> > > - Direct use of seq_buf_printf() in place of snprintf()+strlcat()
> > >   pairs, eliminating local tmp buffers throughout.
> > > - Adjacent strlcat() calls that build strings piece-by-piece
> > >   (e.g., strlcat("["); strlcat(name); strlcat("]")) to be collapsed
> > >   into single seq_buf_printf() calls.
> > > - Simpler call sites: seq_buf_puts() takes only the buffer and string,
> > >   with no need to pass PAGE_SIZE at every call.
> > > 
> > > The backing buffer allocation is unchanged (__get_free_page), and the
> > > output path uses seq_buf_str() to NUL-terminate before passing to
> > > printk().  
> > 
> > Thanks a lot! A few comments below.
> > Personally I'm in favour of this patch as it also removes a lot of ugly code
> > (which is scoped string manipulations), FWIW,
> > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > 
> > > Link: https://github.com/KSPP/linux/issues/370 [1]  
> > 
> > > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Cc: Josh Law <objecting@objecting.org>  
> > 
> > While not long, this still can be placed...
> > 
> > > Signed-off-by: Kees Cook <kees@kernel.org>
> > > ---  
> > 
> > ...somewhere here to reduce unneeded noise in the commit message.
> > 
> > > I couldn't help myself. Here's the full patch, as I suggested in
> > > https://lore.kernel.org/lkml/202603201230.74BBFFABAD@keescook/
> > > There are plenty more like this to do...  
> > 
> > Indeed, but thanks for the example on how to do that!
> > 
> ...
> > But probably okay as in the previous branch it needs more work to follow,
> > something like
> > 
> > 			char dostype[8];
> > 			...
> > 			if (dostype[3] < ' ') {
> > 				/* Escape control character */
> > 				dostype[4] = dostype[3] + '@';
> > 				dostype[3] = '^';
> > 				seq_buf_printf(&state->pp_buf, " (%.5s)", dostype);
> 
> Or just:
> 				seq_buf_printf(&state->pp_buf, " (%.3s^%c)", dostype, dostype[3] + '@');
> 
> 	David
> 
> > 			} else {
> > 				seq_buf_printf(&state->pp_buf, " (%.4s)", dostype);
> > 			}
> > 
> > Taking how invasive is this, it might be better to done separately.

I tried to make this as 1-to-1 replacement as possible. The logic here
was "complex" enough that I just left it as-is.


-- 
Kees Cook
