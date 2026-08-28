Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC6C3C1D6A;
	Fri, 28 Aug 2026 12:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787921328; cv=none; b=Lr8Wf+lQQbP3JjzBheqnIMpyOON81Nh1jIkoGWVQJ1/wRrdZGaJH18uwJ8VMPXmVWXaWTJFDa5QzwYZacKbwJx90V6dJP9OJdG0ZtEKRJZHQqSDne6nQsk3oX17o61/M+xopIADkL2O1fJSvx5ssoeNVCpIYCjw5KwDWxg38A/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787921328; c=relaxed/simple;
	bh=EVGzS04FnYNDpEdfPtxzk+aqLuXej0sZ/rUGua+x9yU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o8vbqVo5HFDdtp17F4AjrANSJnArmPVZD/wU3hPqiylTuqZI8HR6fbi2a6FxiPh5qT6Gqvk2nP2NQsliDM8vft62k/MGB7OOmDq3GMIfq8+zh2RJwpXTKLThgkZtRuGhiXAODR9X+fRBqRCQxkEoNensEJZWIZZpEohWKoGup7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=rbc4c+vX; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="rbc4c+vX"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 1571A4E413FF;
	Fri, 28 Aug 2026 12:48:40 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id C7DB660537;
	Fri, 28 Aug 2026 12:48:39 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7978D11C7810C;
	Fri, 28 Aug 2026 14:48:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1787921314; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=scK/I2cjqVO0vAjV26ZyyTKaHsFuHcj/vb04vGRyhvc=;
	b=rbc4c+vXpW+zJUQPRtSaghanGQ5BU2T++ZCNiSeeQcySif1qD9bGOODSq5UoTt5fTD7q6U
	cwIA1Kq+KfDkkL3XyyVfc3W15S6oZsNDK1Ijcqi4hL9HMUE9Qkbd8GpE5tF4YhpY9jvz4S
	wncNvg/MPB8AqEcGixoBDCZ8O2WJ6mqcrTciwA8gLcBqoObWekGu62ZfnsYDl5ciV4SmA/
	TpMer7v36/pduI/rPGUo9SgSLnBJB/QsEVjdEBOrEm+00ZdZAKYljaPG69WjRnvgX/cvwd
	ujcFlT/n6pqDeMMytwzpuEXj0t3edRhMPLhcERb2+wYR8u+97SKbbg5hXZwHsw==
Date: Fri, 28 Aug 2026 14:48:32 +0200
From: Alexandre Belloni <alexandre.belloni@bootlin.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: "Johnny.Fan" <johnny.fan@cixtech.com>, linux-rtc@vger.kernel.org,
	Feng Tang <feng.tang@linux.alibaba.com>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, cix-kernel-upstream@cixtech.com,
	bob.zhang@cixtech.com, jie.fu@cixtech.com
Subject: Re: [PATCH] rtc: efi: restore alarm support with runtime capability
 probe
Message-ID: <202608281248326784a354@mail.local>
References: <20260828031519.2749354-1-johnny.fan@cixtech.com>
 <549999fa-4b1a-4f53-872a-9036a377f8cf@app.fastmail.com>
 <apFHoVVdhJsmBXDR@JohnnyFan>
 <6adfa384-d232-4e80-a6f1-fa51780107d3@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6adfa384-d232-4e80-a6f1-fa51780107d3@app.fastmail.com>
X-Last-TLS-Session-Version: TLSv1.3

Hello Ard,

On 28/08/2026 12:13:10+0200, Ard Biesheuvel wrote:
> 
> On Fri, 28 Aug 2026, at 10:32, Johnny Fan wrote:
> > On Fri, Aug 28, 2026 at 09:26:42AM +0200, Ard Biesheuvel wrote:
> > Hi Ard,
> >
> > One additional data point: this is not a hypothetical requirement
> > -- multiple CIX customers have explicitly requested RTC wakeup
> > support (both suspend-to-RAM and power-off wakeup) on these
> > platforms, which is part of why we are motivated to restore the
> > alarm functionality rather than work around it.
> >
> 
> Fair enough - I'll queue this as a fix.

I can take care of this if you are happy with the patch.

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
