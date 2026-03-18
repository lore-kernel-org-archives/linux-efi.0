Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6C4392C5A;
	Wed, 18 Mar 2026 23:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773877822; cv=none; b=MxoksA4NWoT3UJmuhbMJscGLDv/rsDUbuDVjz1bV5LolS9rawMfAGF5OWrapQMBZ13EjmRiqqfmsSLFIDT+95al17g1WU4344ThcwQUTbsMQ+kdaFPdrT5ACZZh4i4tj8+y4mdS+91GyrVB0uhKOUBXKqB7qW4vgmrevAAskBfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773877822; c=relaxed/simple;
	bh=6IWzCQaHerAAvhD/9gGP9tDIay/QPLUaKA6cLOAZF60=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=FJnkR3rhVIDhEzBDcSNNjRz+P+Q6FtJuFaNTdFgkZrGG7n5m1rhko6RSvJpxD6oeIa8yKrW/KIEdQMv04u1HZg3HIdD1doQK0ePjUUx8XB9fGCn4yaKkm5JxoBAbtULrdwiUSV6RfwTW2rA1mXcW42ddN+RkePIOyemHjn7eip4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/wgGU3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/wgGU3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABA7C19421;
	Wed, 18 Mar 2026 23:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773877822;
	bh=6IWzCQaHerAAvhD/9gGP9tDIay/QPLUaKA6cLOAZF60=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=O/wgGU3N7Tvc2nhLZ3qg0Y82l1XO2cSiirCMPhF4+QUX6/lQvBeFSkfL/oSf6KEg7
	 xhnUBAvlAxLeeY2sdgRd3tv5ALPAhjlTMo5lEVf1JdtAp0goepa3FBcAzRldrZ0P8N
	 XldUZOOhr7l81nOZjLkbddr1pUHOzA7UpEouEwk1DY2U68ZdpmSEtkbAq5gtED3lGx
	 HrMHuIq9sHP8ieQVUlCnvvpFq+twwg1RbzqZZcjz4ASUHR7Ex3o/UfFHlUysw7ulHy
	 G/mZD+p1TO/CIgqQYbGrhNGO7srohL6XeOG22uz8q79GVY6rdcemdv0o7Lyorc0KYa
	 DifUqmhee9zQg==
Date: Thu, 19 Mar 2026 08:50:17 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, Josh
 Law <objecting@objecting.org>, Andrew Morton <akpm@linux-foundation.org>,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] lib/vsprintf: Limit the returning size to
 INT_MAX
Message-Id: <20260319085017.f636870059cf37f59b346f5d@kernel.org>
In-Reply-To: <177379679625.535490.15253547806594621828.stgit@devnote2>
References: <177379678638.535490.18200744206158553364.stgit@devnote2>
	<177379679625.535490.15253547806594621828.stgit@devnote2>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

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

Ooops, I saw a wrong code. Nevermind.

> @@ -549,7 +549,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap)
>  	if (size)
>  		buf[min(pos, size-1)] = '\0';
>  
> -	return pos;
> +	return (pos > INT_MAX) ? INT_MAX : pos;
>  }
>  
>  int snprintf(char *buf, size_t size, const char *fmt, ...)
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
