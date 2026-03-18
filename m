Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CEF3D6CA3;
	Wed, 18 Mar 2026 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773841630; cv=none; b=DirVFWieOq/ZTa1HknbDSDe8TyVFSc3UFNmP3ler5pimXDIZ+OhOyewwWIw3vRUqocs1yS5iOy4WNfppFiIQQnJNLNvN9pytWNDfvfh4QFykuLGyzu1vbBBTPZ299IjINwQ9Zzf6p4HCp5aa1la+WBofwwLBgN8J9WqzzIfMemc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773841630; c=relaxed/simple;
	bh=xuPLjKIHNiTtcBnFtoxrmTRk6AV8zkiX4YeMFqAN2YA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LDh6zHFlGcaESclGEeTFr7pAkNI/npbqud2hBFHrIZBzwKAOW0DbSYqWgCuMwfX9r1N7iit/+AoyoIQh9EA4o0xyrpUVD4c/jjgrIWQtJyI2/Xg/w/ixxr8ktlV9TiOs9zhXKv5No9YHF61/QriFh3N86gblmOaxVLWXso8vEJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B20AC1D7F4;
	Wed, 18 Mar 2026 13:47:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id C070B20030;
	Wed, 18 Mar 2026 13:47:05 +0000 (UTC)
Date: Wed, 18 Mar 2026 09:47:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Josh Law <objecting@objecting.org>, Andrew
 Morton <akpm@linux-foundation.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] lib/vsprintf: Limit the returning size to
 INT_MAX
Message-ID: <20260318094733.1ada0513@gandalf.local.home>
In-Reply-To: <177379679625.535490.15253547806594621828.stgit@devnote2>
References: <177379678638.535490.18200744206158553364.stgit@devnote2>
	<177379679625.535490.15253547806594621828.stgit@devnote2>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C070B20030
X-Stat-Signature: a5d3tmqrrbo43u5o4scbgtc8paub93c9
X-Rspamd-Server: rspamout03
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+JVQdjTETLXEjlDbLcBRotCcKy1j2TE6g=
X-HE-Tag: 1773841625-35077
X-HE-Meta: U2FsdGVkX1+SHgzY3IYUBpBXRdgLRAl4l1l+aUIoRWxSWGq4D4ItI5yrKkiRMT4mIAlIqq+Rweq9k18FWQOJjpfySaE67IBKPOjWSUQABGFqVvJpOvHRZHiFsD76p+MVPJWRUBtWycUzZJkMsBhnWbKAxfhWrFJE6K1/n7wkg/9IgllJgZIdA1ShgK5ZRXfvNYdMuCWDORX3dEoUmNVF0/OX9v0qT/L5BtjC3QcNuSrCLG2LJm3D6i5g+jHFCnECvv06CLazCJMPnbEPiXjH31tQ2lXAdMdKPzHcva9kAfbZbcesvNf64AvuEQZawUqf4uRtT2FoAXjy5a2Y7tTRlPJrPheQUSQH

On Wed, 18 Mar 2026 10:19:56 +0900
"Masami Hiramatsu (Google)" <mhiramat@kernel.org> wrote:

> From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> 
> There seems a design flaw of vsnprintf() whose return value can
> overflow the INT_MAX even on 32bit arch, because the buffer size is
> passed by 'size_t' but it returns the printed or required size in 'int'.
> 
> The size_t is unsigned long, thus the caller can pass bigger than INT_MAX
> as the size of buffer (that is OK). But even the vsnprintf calculates
> the required/printed length correctly, if it overflows the INT_MAX,
> it can not return the size correctly by int.
> 
> This should never happen but it should be checked and limited.
> 
> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> ---
>  drivers/firmware/efi/libstub/vsprintf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
> index 71c71c222346..1713cacecc25 100644
> --- a/drivers/firmware/efi/libstub/vsprintf.c
> +++ b/drivers/firmware/efi/libstub/vsprintf.c
> @@ -549,7 +549,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap)
>  	if (size)
>  		buf[min(pos, size-1)] = '\0';
>  
> -	return pos;
> +	return (pos > INT_MAX) ? INT_MAX : pos;
>  }
>  
>  int snprintf(char *buf, size_t size, const char *fmt, ...)

Since this would require a buffer of size greater than 2G to be passed in,
I highly doubt this would happen anywhere in the kernel.

If anything, it would be for "correctness" only, but I don't see this ever
being an issue within this century.

-- Steve
