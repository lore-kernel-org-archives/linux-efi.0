Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3537E54B;
	Thu, 19 Mar 2026 00:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773878831; cv=none; b=nAPL41TETr7iWC4RkMNX3iHjG+35E3bwwUPKF1ZU7qUFk9YqY6f7MfkiSJwBWjxFohA7bWEset4R3zLKqyVoewvhKMNEmHSv7TTySOQyalSKtF6Q+9ylHsKuzl3ltOWO7baBhjekI6GKaa1yMLCEBbLAmIx58s6mzran0i3GIAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773878831; c=relaxed/simple;
	bh=QLqSvP0FhwGkNF1lUURbKaXvOWYhMfVrXp9IZq9ijWE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=cu9VJIH2j0LeHplO/KG2dRRQh4I50HVzKb9zsfgSqF8qu7tlt+niLyu+oFWAV3nHwog6PYNXtPYg1SMa/Lyvv69EpMOidsCkQjR9HK0PJ02TdhxMqLwjLpyeR2ZSn2ylQcyUYDMZwhS507XvaEBM7quHSNJuTuJ6amOyqiJ1EVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaQzIcbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaQzIcbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFA0C19421;
	Thu, 19 Mar 2026 00:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773878830;
	bh=QLqSvP0FhwGkNF1lUURbKaXvOWYhMfVrXp9IZq9ijWE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GaQzIcbjeAzFL6/7e2UgzIHLYXizYYZ+5WaHL2nSZG2mqhuqVERSTxp/t8XgycMfi
	 DI8/EW00/cuGF0PC59Cyd9Aj2kPURh8iWo4LTHatJ8qm+LfF4nIEiYUlmuM4qiQd0i
	 w3dVqm9cfUro+4hakU2MgSNzTk2lyYYPbYyj3SqdjQ79bdye+iuFeR9hpvKTFOx+tk
	 HkmAf4ibFRXF4cGWSRnQuf0HDNUHUBFskWRD41e7sHOenpCYcRrbWxoFT+LiWlQY4v
	 KELhCgwkC64IVyeWJh/fZMZhdBnDtjp9gR+vNb4VUUd+eAEm5Tdvu3xzcIYQ3jY393
	 zZCLJBJCzhggA==
Date: Thu, 19 Mar 2026 09:07:05 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Masami Hiramatsu (Google)"
 <mhiramat@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Josh Law <objecting@objecting.org>, Andrew
 Morton <akpm@linux-foundation.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] lib/vsprintf: Limit the returning size to
 INT_MAX
Message-Id: <20260319090705.5e8e9b01c00558d4af512356@kernel.org>
In-Reply-To: <20260318151250.40fef0ab@pumpkin>
References: <177379678638.535490.18200744206158553364.stgit@devnote2>
	<177379679625.535490.15253547806594621828.stgit@devnote2>
	<20260318094733.1ada0513@gandalf.local.home>
	<20260318151250.40fef0ab@pumpkin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 18 Mar 2026 15:12:50 +0000
David Laight <david.laight.linux@gmail.com> wrote:

> On Wed, 18 Mar 2026 09:47:33 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed, 18 Mar 2026 10:19:56 +0900
> > "Masami Hiramatsu (Google)" <mhiramat@kernel.org> wrote:
> > 
> > > From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> > > 
> > > There seems a design flaw of vsnprintf() whose return value can
> > > overflow the INT_MAX even on 32bit arch, because the buffer size is
> > > passed by 'size_t' but it returns the printed or required size in 'int'.
> > > 
> > > The size_t is unsigned long, thus the caller can pass bigger than INT_MAX
> > > as the size of buffer (that is OK). But even the vsnprintf calculates
> > > the required/printed length correctly, if it overflows the INT_MAX,
> > > it can not return the size correctly by int.
> > > 
> > > This should never happen but it should be checked and limited.
> > > 
> > > Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> > > ---
> > >  drivers/firmware/efi/libstub/vsprintf.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
> > > index 71c71c222346..1713cacecc25 100644
> > > --- a/drivers/firmware/efi/libstub/vsprintf.c
> > > +++ b/drivers/firmware/efi/libstub/vsprintf.c
> > > @@ -549,7 +549,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap)
> > >  	if (size)
> > >  		buf[min(pos, size-1)] = '\0';
> > >  
> > > -	return pos;
> > > +	return (pos > INT_MAX) ? INT_MAX : pos;
> > >  }
> > >  
> > >  int snprintf(char *buf, size_t size, const char *fmt, ...)  
> > 
> > Since this would require a buffer of size greater than 2G to be passed in,
> > I highly doubt this would happen anywhere in the kernel.
> > 
> > If anything, it would be for "correctness" only, but I don't see this ever
> > being an issue within this century.
> 
> What about the return value (on 32bit) from:
> 	snprintf(NULL, 0, " %*s %*s ", INT_MAX, "", INT_MAX, "");
> 
> This is more of a problem for libc.
> 
> In reality there are easier ways to crash the kernel....

Good catch! I found that size >= INT_MAX has been handled correctly,
(see lib/vsprintf.c:2875) but width check has been removed by
commit 938df695e98d ("vsprintf: associate the format state with the
 format pointer") accidentally.

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 800b8ac49f53..054c9758118e 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2803,7 +2803,8 @@ static void
 set_field_width(struct printf_spec *spec, int width)
 {
 	spec->field_width = width;
-	if (WARN_ONCE(spec->field_width != width, "field width %d too large", width)) {
+	if (WARN_ONCE(spec->field_width > FIELD_WIDTH_MAX ||
+		      spec->field_width < -FIELD_WIDTH_MAX, "field width %d too large", width)) {
 		spec->field_width = clamp(width, -FIELD_WIDTH_MAX, FIELD_WIDTH_MAX);
 	}
 }
@@ -2812,7 +2813,8 @@ static void
 set_precision(struct printf_spec *spec, int prec)
 {
 	spec->precision = prec;
-	if (WARN_ONCE(spec->precision != prec, "precision %d too large", prec)) {
+	if (WARN_ONCE(spec->precision > PRECISION_MAX || spec->precision < 0,
+		      "precision %d too large", prec)) {
 		spec->precision = clamp(prec, 0, PRECISION_MAX);
 	}
 }

> 
> 	David
> 
> 
> > 
> > -- Steve
> > 
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
