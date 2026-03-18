Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A08F3D3D13
	for <linux-efi@vger.kernel.org>; Wed, 18 Mar 2026 15:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773846775; cv=none; b=rF0/MoumUpJdqX+XdGmrdyC/xl0Y8DUdaOdiDjz7G630Y0ua/QjO4cKVSJ2OmIKpaI8EIb2PEdvSCm0C88BdT3iUpcw7BdyvOyMIF1q3w1/A7YRf1lS6cEGIrqaHb5WblPPwa14b423jJaYZzopJ0lCJ4TLxuPT+5V+lryJLg8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773846775; c=relaxed/simple;
	bh=1AB665uQu3ZGDCKPAtF0lHKxykcrXaiq4mRGceFg65o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=movnsj0ielwG/FqTDA7qq5Dofe4wFs2mtGiNneTmhDUzpDCwGlf6zRZ/xw40Sa8L3It8qkmLJa0zB/4xIob98xZPRa/gOLiW9fr471o5cpnPktpewNNaWMAbJQuDJslmowCG8RQZ8mTKGcFMhyep/U/93Ah1kI/GEM2HOUKrqW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WI2r0yxu; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WI2r0yxu"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4852f8ac7e9so82116175e9.1
        for <linux-efi@vger.kernel.org>; Wed, 18 Mar 2026 08:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773846773; x=1774451573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=exM1Iff+xUWC3C9H/16DKULzTAM9igYujLmwE9sN/Ws=;
        b=WI2r0yxuVvc4jBlZndmJLrnivwwpA6G8jQq+2/B9NpDSxJBtxBFAqQ3zEuzkGFRzhE
         uy53E5qjgwcJJyBz//edIGAN4MPWUnzoq3Pjl1UY+1OQAFgUhZ5UX81avPqmqpn8f1iE
         N8xpRSKXvY6eKD9VWafY1Qb45cYiSeypePhRbxYrgtGHvUO309dq47gwqpbwF6kh2UeN
         aUBmJCmh+u4+I5JRoPaEA7Gop2CxeimOPwbLCdWihyhrAFWAXIejDW+uSbciGJdDqo5r
         OpamHiiP8NoyKg/j+2fRrC2s3aQ49KqhqSlDT5DdRPoJnbBhMJHePFZSW5k4kM4BP6eZ
         eY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773846773; x=1774451573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=exM1Iff+xUWC3C9H/16DKULzTAM9igYujLmwE9sN/Ws=;
        b=B9J7CpyBlQji/FFph82Zi0clhSTW2I9I1sYKvkGgs/aOSl65L8XOvp1G6JvAC2p5vw
         ev7gm5wsuceVSQF6axQnrOCj39P4jG8XOQ1W6PK6ufG6cxvJlCxBTGOrS88ICScZUqFm
         EKxOpVx/HUQFBpdnCWBEol/NzA0cgKSUOs1u5rO4a5K8LrtcDt/+IeAyPUc+8eQyZgJb
         N6T7/C79eFyTdLfnxrB4IaKRSqWJRX04n2B5cxWMXCcl9b4c9OZDLaKyJu25992/PR1K
         DwJrmTARbzuMFIGxFOankts45ZMLIdst/z9jwJGH+Hy2Iif2QY3csQw72U7N1Ab+XCNZ
         avNw==
X-Forwarded-Encrypted: i=1; AJvYcCVMFbwsVLIfKj8JLykX0cm183nsvGBWyusvUZ5KZsS+68GDEcjTKPR5dK9Dop6DoTbQASSSB+HB92k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRh1xBf39DL2uFq2NmdXdWofd3GqU4BYI0RrrVG8oxRY1H3y7I
	5f7rodP7mP6SVW6MFNI7HNmENDsQIgIOP5eSRjFjw1AJlp5zXDuHe7Fu
X-Gm-Gg: ATEYQzwOqs5yHqyN5StySJtAmdgzbfk78XPdwRjgROKNi/KgQKU8vgkp5g9JmkXCL4B
	vcKfg67NXPFhWhtBlr+NvtWArVPiSXIVFrw5+xGWIz6Q/7fdZ+Ehk3Xk/vd65GrTZynRREhZhm7
	MSY5Rwo03bcpaMEidOxsBBbK7L3cw4SpC3u8FTVBXFJCZRsifZM4JVQgxcXdoeByPHHYIw/FEwZ
	emylB4O1pHeJhmikY2K5nOY3KislG3ab3664aVBsvioyYfY6RHl4YY5EG8lFwmpJ/PECw3Z6Ozl
	Ycce2Wqi364c5lrbYXHzWj2NSk//T01wNrCiTCHkqMKsdxN0rtJDRuZGHY4ZO+mkPKdAEs5VTq4
	+mG306GSl8MeY5U89rYUFDTVI+nL3BKxqxPR+OWowORfe/ChId1yBaeNjEnNwn4Am16AgdpizYn
	b6yMJKVGkwwsrSSMWpOrIy6Pkx+go3t8uSVhOrz4HGkftzZ4j0niNfUtISsCE921/09gYwS4BE6
	t8=
X-Received: by 2002:a05:600c:630f:b0:485:531d:28b9 with SMTP id 5b1f17b1804b1-486f443841amr64877395e9.14.1773846772381;
        Wed, 18 Mar 2026 08:12:52 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f421a617sm81548895e9.7.2026.03.18.08.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 08:12:52 -0700 (PDT)
Date: Wed, 18 Mar 2026 15:12:50 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Ard Biesheuvel
 <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Josh Law
 <objecting@objecting.org>, Andrew Morton <akpm@linux-foundation.org>,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] lib/vsprintf: Limit the returning size to
 INT_MAX
Message-ID: <20260318151250.40fef0ab@pumpkin>
In-Reply-To: <20260318094733.1ada0513@gandalf.local.home>
References: <177379678638.535490.18200744206158553364.stgit@devnote2>
	<177379679625.535490.15253547806594621828.stgit@devnote2>
	<20260318094733.1ada0513@gandalf.local.home>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 18 Mar 2026 09:47:33 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 18 Mar 2026 10:19:56 +0900
> "Masami Hiramatsu (Google)" <mhiramat@kernel.org> wrote:
> 
> > From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> > 
> > There seems a design flaw of vsnprintf() whose return value can
> > overflow the INT_MAX even on 32bit arch, because the buffer size is
> > passed by 'size_t' but it returns the printed or required size in 'int'.
> > 
> > The size_t is unsigned long, thus the caller can pass bigger than INT_MAX
> > as the size of buffer (that is OK). But even the vsnprintf calculates
> > the required/printed length correctly, if it overflows the INT_MAX,
> > it can not return the size correctly by int.
> > 
> > This should never happen but it should be checked and limited.
> > 
> > Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> > ---
> >  drivers/firmware/efi/libstub/vsprintf.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
> > index 71c71c222346..1713cacecc25 100644
> > --- a/drivers/firmware/efi/libstub/vsprintf.c
> > +++ b/drivers/firmware/efi/libstub/vsprintf.c
> > @@ -549,7 +549,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap)
> >  	if (size)
> >  		buf[min(pos, size-1)] = '\0';
> >  
> > -	return pos;
> > +	return (pos > INT_MAX) ? INT_MAX : pos;
> >  }
> >  
> >  int snprintf(char *buf, size_t size, const char *fmt, ...)  
> 
> Since this would require a buffer of size greater than 2G to be passed in,
> I highly doubt this would happen anywhere in the kernel.
> 
> If anything, it would be for "correctness" only, but I don't see this ever
> being an issue within this century.

What about the return value (on 32bit) from:
	snprintf(NULL, 0, " %*s %*s ", INT_MAX, "", INT_MAX, "");

This is more of a problem for libc.

In reality there are easier ways to crash the kernel....

	David


> 
> -- Steve
> 

